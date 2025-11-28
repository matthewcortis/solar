import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../widgets/bao_gia_item_card.dart';
import '../widgets/chi_tiet_bao_gia_card.dart';
import '../../model/extension.dart';
import '../../model/tron_goi_models.dart';

class ThongTinBaoGiaScreen extends StatefulWidget {
  const ThongTinBaoGiaScreen({super.key});

  @override
  State<ThongTinBaoGiaScreen> createState() => _ThongTinBaoGiaScreenState();
}

class _ThongTinBaoGiaScreenState extends State<ThongTinBaoGiaScreen> {
  final GlobalKey _captureKey = GlobalKey();
  bool _isCapturing = false;
  Uint8List? _imageBytes;

  // Channel trùng với bên iOS (AppDelegate.swift)
  static const MethodChannel _saveImageChannel = MethodChannel(
    'solarmax/save_image',
  );



  double _scale(BuildContext context, double v) {
    final width = MediaQuery.of(context).size.width;
    return v * width / 430;
  }

  /// Lấy danh sách "Thông tin chi tiết" từ API (vật tư phụ)
  ///
  /// Điều kiện:
  /// - vatTu.nhomVatTu.vatTuChinh == false
  /// - duocXem == false
  List<Map<String, Object>> get _detailItems {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! TronGoiDto) return [];

    final TronGoiDto tronGoi = args;
    final allItems = tronGoi.vatTuTronGois;

     

    final otherMaterials = allItems.where((e) {
      final bool laVatTuPhu = e.vatTu.nhomVatTu.vatTuChinh == false;
      final bool khongDuocXem = e.duocXem == false;
      return laVatTuPhu && khongDuocXem;
    }).toList();

    return List.generate(otherMaterials.length, (index) {
      final item = otherMaterials[index];

      final String name = item.vatTu.ten;
      final String donVi = item.vatTu.donVi;
      final String soLuongText = _formatQuantity(item.soLuong);

      final String qty = [
        soLuongText,
        if (donVi.isNotEmpty) donVi,
      ].join(' ');

      return {
        'index': index + 1, // 1,2,3,...
        'name': name,
        'qty': qty,
      };
    });
  }

  /// Format số lượng bỏ số 0 dư sau dấu phẩy
  String _formatQuantity(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    String s = value.toStringAsFixed(2);
    s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
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

  @override
  Widget build(BuildContext context) {
    final tronGoi = ModalRoute.of(context)!.settings.arguments as TronGoiDto;
    final detailItems = _detailItems;

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
                        _buildDeviceList(context, tronGoi),
                        SizedBox(height: _scale(context, 16)),
                        _buildComboBanner(
                          context,
                          'assets/images/banner-thietbi.png',
                        ),
                        SizedBox(height: _scale(context, 8)),
                        _buildDetailSection(context, detailItems),
                        SizedBox(height: _scale(context, 24)),
                      ],
                    ),
                  ),
                ),

                // Nếu muốn xem preview ảnh chụp thì mở comment đoạn này:
                // if (_imageBytes != null)
                //   SizedBox(
                //     height: _scale(context, 160),
                //     child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                //   ),
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
                    child: _buildCaptureContent(context, detailItems),
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

  Widget _buildDeviceList(BuildContext context, TronGoiDto tronGoi) {
    final scale = _scale;
    final List<VatTuTronGoiDto> filtered = tronGoi.vatTuTronGois.where((e) {
      final vatTu = e.vatTu;

      final bool laVatTuChinh = vatTu.nhomVatTu.vatTuChinh == true;
      final bool duocXem = e.duocXem == true || e.duocXem == null;

      return laVatTuChinh && duocXem;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale(context, 14)),
      child: SizedBox(
        width: scale(context, 402),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final vt in filtered) ...[
              DeviceHorizontalItemCard.fromVatTuTronGoi(vt),
              SizedBox(height: scale(context, 12)),
            ],
          ],
        ),
      ),
    );
  }
//
  Widget _buildComboBanner(BuildContext context, String imageUrl) {
    final scale = _scale;

    return SizedBox(
      width: scale(context, 430),
      height: scale(context, 180),
      child: ClipRRect(
        child: Image.asset(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    List<Map<String, Object>> detailItems,
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
          Column(
            children: detailItems.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: scale(context, 6)),
                child: BaoGiaItemCard(
                  index: item['index'] as int,
                  title: item['name'] as String,
                  qty: item['qty'] as String,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Layout dành riêng cho chụp ảnh (full chiều dài, không scroll)
  Widget _buildCaptureContent(
    BuildContext context,
    List<Map<String, Object>> detailItems,
  ) {
    final width = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        children: [
          _buildTopHeader(context),
          SizedBox(height: _scale(context, 12)),
          _buildBackAndTitle(context),
          SizedBox(height: _scale(context, 8)),
          _buildDeviceList(
            context,
            ModalRoute.of(context)!.settings.arguments as TronGoiDto,
          ),
          SizedBox(height: _scale(context, 16)),
          _buildComboBanner(context, 'assets/images/banner-thietbi.png'),
          SizedBox(height: _scale(context, 8)),
          _buildDetailSection(context, detailItems),
          SizedBox(height: _scale(context, 24)),
        ],
      ),
    );
  }
}
