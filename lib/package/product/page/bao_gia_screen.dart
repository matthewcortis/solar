import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../widgets/bao_gia_item_card.dart';
import '../widgets/chi_tiet_bao_gia_card.dart';
import '../../model/tron_goi_models.dart';
import '../../model/bao_gia_draft.dart';
import '../../model/extension.dart'; // TronGoiUtils
import '../../ads/quang_cao_service.dart';

class ThongTinBaoGiaScreen extends StatefulWidget {
  const ThongTinBaoGiaScreen({super.key});

  @override
  State<ThongTinBaoGiaScreen> createState() => _ThongTinBaoGiaScreenState();
}

class _ThongTinBaoGiaScreenState extends State<ThongTinBaoGiaScreen> {
  final GlobalKey _captureKey = GlobalKey();
  final _bannerService = QuangCaoBannerService.instance;

  bool _isCapturing = false;
  Uint8List? _imageBytes;
  String? _baoGiaBannerUrl;

  // Channel trùng với bên iOS (AppDelegate.swift)
  static const MethodChannel _saveImageChannel = MethodChannel(
    'solarmax/save_image',
  );

  @override
  void initState() {
    super.initState();
    _loadBaoGiaBanner();
  }

  // ===== CẤU HÌNH NHÓM VẬT TƯ PHỤ (TAM_PIN, BIEN_TAN, PIN_LUU_TRU + các HỆ) =====
  static const List<String> _groupCodes = [
    'TAM_PIN',
    'BIEN_TAN',
    'PIN_LUU_TRU',
    'HE_KHUNG_NHOM',
    'HE_DAY_DIEN',
    'TU_DIEN',
    'HE_TIEP_DIA',
    // 'TRON_GOI_LAP_DAT',
  ];

  static const Map<String, String> _groupTitles = {
    'TAM_PIN': 'Tấm pin',
    'BIEN_TAN': 'Biến tần',
    'PIN_LUU_TRU': 'Pin lưu trữ',
    'HE_KHUNG_NHOM': 'Hệ khung nhôm',
    'HE_DAY_DIEN': 'Hệ dây điện',
    'TU_DIEN': 'Tủ điện',
    'HE_TIEP_DIA': 'Hệ tiếp địa',
    // 'TRON_GOI_LAP_DAT': 'Trọn gói lắp đặt',
  };
  static const Map<String, String> _defaultGroupImages = {
    'HE_KHUNG_NHOM': 'assets/images/solarmax.png',
    'HE_DAY_DIEN': 'assets/images/solarmax.png',
    'TU_DIEN': 'assets/images/solarmax.png',
    'HE_TIEP_DIA': 'assets/images/solarmax.png',
  };

  double _scale(BuildContext context, double v) {
    final width = MediaQuery.of(context).size.width;
    return v * width / 430;
  }

  Future<void> _saveToGallery(Uint8List bytes) async {
    try {
      await _saveImageChannel.invokeMethod('saveImage', bytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu ảnh vào Thư viện (Photos)')),
      );
    } on PlatformException catch (e) {
      debugPrint('Lưu ảnh lỗi: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lưu ảnh thất bại')));
    }
  }

  Future<void> _loadBaoGiaBanner() async {
    final url = await _bannerService.getBaoGiaFirstBannerUrl();
    if (!mounted) return;
    setState(() {
      _baoGiaBannerUrl = url;
    });
  }

  Future<void> _captureFullPage() async {
    setState(() => _isCapturing = true);

    // Chờ 1 frame để Offstage layout xong
    await Future.delayed(const Duration(milliseconds: 50));

    final boundary =
        _captureKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;

    if (boundary == null) {
      setState(() => _isCapturing = false);
      return;
    }

    try {
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes == null) {
        setState(() => _isCapturing = false);
        return;
      }

      setState(() {
        _isCapturing = false;
        _imageBytes = pngBytes;
      });

      // Lưu thẳng vào Photos (native iOS)
      await _saveToGallery(pngBytes);
    } catch (e) {
      setState(() => _isCapturing = false);
      debugPrint('Lỗi chụp ảnh: $e');
    }
  }

  // Thứ tự ưu tiên cho thiết bị chính
  static const Map<String, int> _mainDeviceOrder = {
    'TAM_PIN': 0,
    'BIEN_TAN': 1,
    'PIN_LUU_TRU': 2,
  };

  List<VatTuTronGoiDto> _sortMainDevices(List<VatTuTronGoiDto> list) {
    final sorted = [...list];
    sorted.sort((a, b) {
      final maA = a.vatTu.nhomVatTu.ma;
      final maB = b.vatTu.nhomVatTu.ma;

      final orderA = _mainDeviceOrder[maA] ?? 999;
      final orderB = _mainDeviceOrder[maB] ?? 999;

      // Ưu tiên theo thứ tự TAM_PIN -> BIEN_TAN -> PIN_LUU_TRU
      if (orderA != orderB) return orderA.compareTo(orderB);

      // Nếu cùng nhóm thì sort thêm theo tên cho ổn định
      return a.vatTu.ten.compareTo(b.vatTu.ten);
    });
    return sorted;
  }

  // Lấy URL ảnh cho 1 VatTuTronGoiDto
  String? _getVatTuImageUrl(VatTuTronGoiDto item) {
    final vatTu = item.vatTu;

    // 1) Ảnh riêng của vật tư (anhVatTus)
    if (vatTu.anhVatTus.isNotEmpty) {
      final tep = vatTu.anhVatTus.first.tepTin;
      if (tep != null && tep.duongDan.isNotEmpty) {
        return tep.duongDan;
      }
    }

    // 2) Ảnh theo thương hiệu (nếu có)
    final tepTinThuongHieu = vatTu.thuongHieu?.tepTin;
    if (tepTinThuongHieu != null && tepTinThuongHieu.duongDan.isNotEmpty) {
      return tepTinThuongHieu.duongDan;
    }

    // 3) Ảnh mặc định theo nhóm
    final maGroup = vatTu.nhomVatTu.ma;
    if (_defaultGroupImages.containsKey(maGroup)) {
      return _defaultGroupImages[maGroup]; // asset path
    }

    // 4) Không có ảnh
    return null;
  }

  // ================== HELPER BUILD DỮ LIỆU CHI TIẾT ==================

  /// Thiết bị chính:
  /// - mỗi thiết bị = 1 dòng
  /// - name = tên thật thiết bị
  /// - qty = thời gian bảo hành (X năm Y tháng / Không bảo hành)
  /// - imageUrl = link ảnh (nếu có)
  List<QuoteDetailRow> _buildMainDeviceRows(List<VatTuTronGoiDto> mainDevices) {
    final List<QuoteDetailRow> rows = [];

    for (final item in mainDevices) {
      final int bh = item.thoiGianBaoHanh;
      final String warranty = bh > 0
          ? TronGoiUtils.convertMonthToYearAndMonth(bh)
          : 'Không bảo hành';

      final String? imageUrl = _getVatTuImageUrl(item);

      rows.add(
        QuoteDetailRow(
          index: 0, // sẽ được re-index sau
          name: item.vatTu.ten, // tên thật thiết bị
          qty: warranty, // text bảo hành
          imageUrl: imageUrl,
        ),
      );
    }

    return rows;
  }

  /// Vật tư phụ:
  /// - gom theo mã nhóm _groupCodes
  /// - mỗi nhóm = 1 dòng
  /// - name = tên nhóm (Tấm pin, Biến tần, ...)
  /// - qty = thời gian bảo hành đại diện của nhóm
  /// - imageUrl = lấy dari item đầu tiên trong nhóm
  List<QuoteDetailRow> _buildOtherMaterialGroupRows(
    List<VatTuTronGoiDto> materials,
  ) {
    final List<QuoteDetailRow> rows = [];

    for (final code in _groupCodes) {
      final groupItems = materials
          .where((e) => e.vatTu.nhomVatTu.ma == code)
          .toList();

      if (groupItems.isEmpty) continue;

      final first = groupItems.first;
      final String title = _groupTitles[code] ?? code;

      final int bh = first.thoiGianBaoHanh;
      final String warranty = bh > 0
          ? TronGoiUtils.convertMonthToYearAndMonth(bh)
          : 'Không bảo hành';

      final String? imageUrl = _getVatTuImageUrl(first);

      rows.add(
        QuoteDetailRow(
          index: 0, // sẽ được re-index sau
          name: title, // tên nhóm
          qty: warranty, // text bảo hành nhóm
          imageUrl: imageUrl,
        ),
      );
    }

    return rows;
  }

  /// Chuẩn hóa dữ liệu từ BaoGiaDraft sang view-model dùng cho UI
  _QuoteViewModel _buildViewModelFromDraft(BaoGiaDraft draft) {
    final TronGoiDto tronGoi = draft.tronGoi;

    // Thiết bị chính: ưu tiên danh sách mainDevices trong draft, nếu trống thì lọc lại từ tronGoi
    final List<VatTuTronGoiDto> mainDevicesRaw = draft.mainDevices.isNotEmpty
        ? draft.mainDevices
        : tronGoi.vatTuTronGois.where((e) {
            final vatTu = e.vatTu;
            final bool laVatTuChinh = vatTu.nhomVatTu.vatTuChinh == true;
            final bool duocXem = e.duocXem == true || e.duocXem == null;
            return laVatTuChinh && duocXem;
          }).toList();

    final mainDevices = _sortMainDevices(mainDevicesRaw);

    // Vật tư phụ lấy từ draft.extraMaterials,
    // CHỈ giữ lại các item thuộc 8 mã nhóm _groupCodes
    final List<VatTuTronGoiDto> extraMaterials = draft.extraMaterials
        .where((e) => _groupCodes.contains(e.vatTu.nhomVatTu.ma))
        .toList();

    // Dòng thiết bị chính (tên thật + bảo hành)
    final mainRows = _buildMainDeviceRows(mainDevices);

    // Dòng vật tư phụ (tên nhóm + bảo hành)
    final groupRows = _buildOtherMaterialGroupRows(extraMaterials);

    // Ghép lại danh sách chi tiết
    final detailItems = <QuoteDetailRow>[...mainRows, ...groupRows];

    // Re-index lại cho liên tục 1..N
    for (int i = 0; i < detailItems.length; i++) {
      detailItems[i].index = i + 1;
    }

    final num price = draft.tongTien; // giá báo giá đã chỉnh

    return _QuoteViewModel(
      tronGoi: tronGoi,
      tongTien: price,
      mainDevices: mainDevices,
      detailItems: detailItems,
    );
  }

  /// Chuẩn hóa dữ liệu khi chỉ có TronGoiDto (chưa tạo draft)
  _QuoteViewModel _buildViewModelFromTronGoi(TronGoiDto tronGoi) {
    final allItems = tronGoi.vatTuTronGois;

    // Thiết bị chính
    final mainDevicesRaw = allItems.where((e) {
      final vatTu = e.vatTu;
      final bool laVatTuChinh = vatTu.nhomVatTu.vatTuChinh == true;
      final bool duocXem = e.duocXem == true || e.duocXem == null;
      return laVatTuChinh && duocXem;
    }).toList();

    final mainDevices = _sortMainDevices(mainDevicesRaw);

    // Vật tư phụ:
    // - không phải vật tư chính
    // - duocXem == false (giống DetailProduct)
    // - thuộc 8 mã nhóm định nghĩa ở _groupCodes
    final otherMaterials = allItems.where((e) {
      final String ma = e.vatTu.nhomVatTu.ma;
      final bool isGroup = _groupCodes.contains(ma);
      final bool isMain = e.vatTu.nhomVatTu.vatTuChinh == true;
      final bool duocXemPhu = e.duocXem == false;
      return isGroup && !isMain && duocXemPhu;
    }).toList();

    // Dòng thiết bị chính (tên thật + bảo hành)
    final mainRows = _buildMainDeviceRows(mainDevices);

    // Dòng vật tư phụ (tên nhóm + bảo hành)
    final groupRows = _buildOtherMaterialGroupRows(otherMaterials);

    // Ghép lại danh sách chi tiết
    final detailItems = <QuoteDetailRow>[...mainRows, ...groupRows];

    // Re-index lại cho liên tục 1..N
    for (int i = 0; i < detailItems.length; i++) {
      detailItems[i].index = i + 1;
    }

    final num price = tronGoi.tongGia; // giá combo

    return _QuoteViewModel(
      tronGoi: tronGoi,
      tongTien: price,
      mainDevices: mainDevices,
      detailItems: detailItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    late final _QuoteViewModel vm;

    if (args is BaoGiaDraft) {
      vm = _buildViewModelFromDraft(args);
    } else if (args is TronGoiDto) {
      vm = _buildViewModelFromTronGoi(args);
    } else {
      return const Scaffold(
        body: Center(child: Text('Không có dữ liệu báo giá')),
      );
    }

    final detailItems = vm.detailItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureFullPage,
        child: const Icon(Icons.camera_alt),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // ===== BẢN NGƯỜI DÙNG THẤY (CÓ SCROLL) =====
            Column(
              children: [
                _buildTopHeader(context),
                SizedBox(height: _scale(context, 12)),
                _buildBackAndTitle(context),
                SizedBox(height: _scale(context, 8)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDeviceList(context, vm.mainDevices),
                        SizedBox(height: _scale(context, 16)),
                        _buildComboBanner(
                          context,
                          'assets/images/banner-thietbi.png',
                          vm.tronGoi,
                          shownPrice: vm.tongTien,
                          networkImageUrl: _baoGiaBannerUrl,
                        ),
                        SizedBox(height: _scale(context, 8)),
                        _buildDetailSection(context, detailItems),
                        SizedBox(height: _scale(context, 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ===== BẢN ẨN ĐỂ CHỤP FULL (KHÔNG SCROLL, CAO HƠN MÀN HÌNH) =====
            Offstage(
              offstage: !_isCapturing,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: RepaintBoundary(
                  key: _captureKey,
                  child: Container(
                    color: const Color(0xFFF8F8F8),
                    width: MediaQuery.of(context).size.width,
                    child: _buildCaptureContent(context, vm),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== CÁC PHẦN UI DÙNG LẠI ==================

  Widget _buildTopHeader(BuildContext context) {
    final scale = _scale;

    return Container(
      width: double.infinity,
      height: scale(context, 55.78),
      padding: EdgeInsets.symmetric(
        horizontal: scale(context, 16),
        vertical: scale(context, 12),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00B86B), Color(0xFF00A85A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: scale(context, 123.16),
            height: scale(context, 31.78),
            child: Image.asset(
              'assets/images/iconapp.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: scale(context, 12),
              vertical: scale(context, 4),
            ),
            child: Text(
              'BẬT ĐỂ TIẾT KIỆM ĐIỆN',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                fontSize: scale(context, 14),
                height: 20 / 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackAndTitle(BuildContext context) {
    final scale = _scale;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale(context, 14)),
      child: SizedBox(
        width: scale(context, 402),
        height: scale(context, 48),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: scale(context, 40),
                height: scale(context, 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Color(0xFF4F4F4F),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'THÔNG TIN BÁO GIÁ',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(context, 18),
                    height: 24 / 18,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ),
            ),
            SizedBox(width: scale(context, 40)), // cân với nút back
          ],
        ),
      ),
    );
  }

  /// Danh sách thiết bị chính (đã chuẩn hóa từ view-model)
  Widget _buildDeviceList(
    BuildContext context,
    List<VatTuTronGoiDto> mainDevices,
  ) {
    final scale = _scale;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale(context, 14)),
      child: SizedBox(
        width: scale(context, 402),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final vt in mainDevices) ...[
              DeviceHorizontalItemCard.fromVatTuTronGoi(vt),
              SizedBox(height: scale(context, 12)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComboBanner(
    BuildContext context,
    String fallbackAsset, // asset mặc định khi không có ảnh API
    TronGoiDto tronGoi, {
    required num shownPrice,
    String? networkImageUrl,
  }) {
    final scale = _scale;

    // Loại hệ thống
    final String systemType = tronGoi.loaiHeThong ?? '';

    String _formatMoney(num value) {
      if (value <= 0) return '--';
      final s = value.toStringAsFixed(0);
      final buffer = StringBuffer();
      int count = 0;
      for (int i = s.length - 1; i >= 0; i--) {
        buffer.write(s[i]);
        count++;
        if (count == 3 && i != 0) {
          buffer.write('.');
          count = 0;
        }
      }
      final reversed = buffer.toString().split('').reversed.join();
      return '$reversedđ';
    }

    return SizedBox(
      width: scale(context, 430),
      height: scale(context, 180),
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ảnh nền
            if (networkImageUrl != null && networkImageUrl.isNotEmpty)
              Image.network(networkImageUrl, fit: BoxFit.cover)
            else
              Image.asset(fallbackAsset, fit: BoxFit.cover),

            // Chip Hy-Brid / On-Grid
            if (systemType.isNotEmpty)
              Positioned(
                top: scale(context, 12),
                left: scale(context, 16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: scale(context, 12),
                    vertical: scale(context, 4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33000000),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    systemType,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(context, 12),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Ô giá → chỉ một giá duy nhất (draft hoặc combo)
            Positioned(
              left: scale(context, 16),
              bottom: scale(context, 16),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: scale(context, 16),
                  vertical: scale(context, 8),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEE4037),
                  borderRadius: BorderRadius.circular(scale(context, 24)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _formatMoney(shownPrice),
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                    fontSize: scale(context, 14),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    List<QuoteDetailRow> detailItems,
  ) {
    final scale = _scale;

    return Container(
      width: scale(context, 430),
      padding: EdgeInsets.only(
        top: scale(context, 16),
        left: scale(context, 16),
        right: scale(context, 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Title =====
          Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: scale(context, 16),
              height: 24 / 16,
              color: const Color(0xFF4F4F4F),
            ),
          ),

          SizedBox(height: scale(context, 12)),

          Container(
            width: scale(context, 398),
            height: scale(context, 32.44),
            padding: EdgeInsets.only(bottom: scale(context, 12)),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF3F3F3), width: 1),
              ),
            ),
            child: SizedBox(
              height: scale(context, 20.44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Vật tư
                  Expanded(
                    child: Text(
                      'Vật tư',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        fontSize: scale(context, 13),
                        color: const Color(0xFF828282),
                      ),
                    ),
                  ),

                  SizedBox(width: scale(context, 8)),

                  // Thương hiệu (cột icon)
                  SizedBox(
                    width: scale(context, 60),
                    child: Center(
                      child: Text(
                        'Thương hiệu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: scale(context, 13),
                          color: const Color(0xFF828282),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: scale(context, 8)),

                  // Bảo hành (cột qty)
                  SizedBox(
                    width: scale(context, 60),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Bảo hành',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: scale(context, 13),
                          color: const Color(0xFF828282),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: scale(context, 4)),

          // ===== List items =====
          Column(
            children: detailItems.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: scale(context, 6)),
                child: BaoGiaItemCard(
                  index: item.index,
                  title: item.name,
                  qty: item.qty, // bảo hành
                  iconUrl: item.imageUrl, // thương hiệu (logo)
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Layout dành riêng cho chụp ảnh (full chiều dài, không scroll)
  Widget _buildCaptureContent(BuildContext context, _QuoteViewModel vm) {
    final width = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        children: [
          _buildTopHeader(context),
          SizedBox(height: _scale(context, 12)),
          _buildBackAndTitle(context),
          SizedBox(height: _scale(context, 8)),
          _buildDeviceList(context, vm.mainDevices),
          SizedBox(height: _scale(context, 16)),
          _buildComboBanner(
            context,
            'assets/images/banner-thietbi.png', // fallback
            vm.tronGoi,
            shownPrice: vm.tongTien,
            networkImageUrl: _baoGiaBannerUrl, // lấy từ API
          ),
          SizedBox(height: _scale(context, 8)),
          _buildDetailSection(context, vm.detailItems),
          SizedBox(height: _scale(context, 24)),
        ],
      ),
    );
  }
}

/// Một dòng chi tiết trong phần "Thông tin chi tiết"
class QuoteDetailRow {
  int index;
  final String name;
  final String qty;
  final String? imageUrl;

  QuoteDetailRow({
    required this.index,
    required this.name,
    required this.qty,
    this.imageUrl,
  });
}

/// View-model chung cho màn ThongTinBaoGiaScreen
class _QuoteViewModel {
  final TronGoiDto tronGoi;
  final num tongTien;
  final List<VatTuTronGoiDto> mainDevices;
  final List<QuoteDetailRow> detailItems;

  _QuoteViewModel({
    required this.tronGoi,
    required this.tongTien,
    required this.mainDevices,
    required this.detailItems,
  });
}
