import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repository/chi_tiet_vat_tu_repo.dart';
import '../../model/tron_goi_models.dart';
import '../../model/extension.dart';
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _repo = ProductRepository();
  VatTuDto? _product;
  bool _isLoading = true;
  String? _error;

  bool _didInit = false; // chỉ load 1 lần

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    // 1) Nếu truyền thẳng id (int hoặc String) -> gọi API
    int? productId;
    if (args is int) {
      productId = args;
    } else if (args is String) {
      productId = int.tryParse(args);
    }
    // 2) Nếu truyền thẳng VatTuDto -> dùng luôn, không gọi API nữa
    else if (args is VatTuDto) {
      _product = args;
      _isLoading = false;
      _didInit = true;
      setState(() {});
      return;
    }
    // 3) Nếu truyền VatTuTronGoiDto -> lấy ra vatTu bên trong
    else if (args is VatTuTronGoiDto) {
      _product = args.vatTu;
      _isLoading = false;
      _didInit = true;
      setState(() {});
      return;
    }

    if (productId == null) {
      setState(() {
        _error = "Không nhận được ID / dữ liệu sản phẩm";
        _isLoading = false;
      });
    } else {
      _loadData(productId);
    }

    _didInit = true;
  }

  Future<void> _loadData(int productId) async {
    try {
      final data = await _repo.getProductDetailById(productId);
      if (!mounted) return;

      if (data == null) {
        setState(() {
          _error = "Không tìm thấy dữ liệu sản phẩm";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _product = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Lỗi tải dữ liệu: $e";
        _isLoading = false;
      });
    }
  }

  String? _getSheetLink(VatTuDto p) {
    // 1) Field sheetLink trực tiếp
    if (p.sheetLink.isNotEmpty) {
      return p.sheetLink;
    }

    // 2) Nếu backend để trong duLieuRieng['sheetLink']
    final item = p.duLieuRieng['sheetLink'];
    if (item != null &&
        item.giaTri != null &&
        item.giaTri.toString().isNotEmpty) {
      return item.giaTri.toString();
    }

    return null;
  }

  Future<void> _openSheetLink() async {
    final p = _product;
    if (p == null) return;

    final url = _getSheetLink(p);
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Không có link datasheet")));
      return;
    }

    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không mở được link datasheet")),
      );
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _formatPrice(double? price) {
    if (price == null) return 'Liên hệ';
    final formatter = NumberFormat("#,##0", "vi_VN");
    return "${formatter.format(price)} đ";
  }

  GiaInfo? _getGiaInfo(VatTuDto p) {
    if (p.thongTinGias.isEmpty) return null;

    final group = p.thongTinGias.first; // Thông tin giá đầu tiên
    if (group.dsGia.isEmpty) return null;

    // Cơ sở mặc định là phần tử đầu tiên
    return group.dsGia.first;
  }

  /// Lấy thuộc tính từ duLieuRieng, có thể thêm suffix đơn vị
  /// Lấy thuộc tính từ duLieuRieng, có thể thêm suffix đơn vị
  /// Ưu tiên duLieuRieng, nếu không có thì fallback sang nhomVatTu.thuocTinhRieng
  String _getAttr(VatTuDto vatTu, String key, {String? suffix}) {
    // 1) Ưu tiên dữ liệu theo từng vật tư (duLieuRieng)
    ThuocTinh? tt = vatTu.duLieuRieng[key];

    // Nếu không có hoặc giaTri null/chuỗi rỗng -> thử fallback sang nhóm vật tư
    bool _isEmpty(dynamic v) =>
        v == null ||
        (v is String && v.trim().isEmpty) ||
        v.toString() == '0'; // tuỳ bạn, có thể bỏ check '0' nếu muốn hiển thị 0

    if (tt == null || _isEmpty(tt.giaTri)) {
      tt = vatTu.nhomVatTu.thuocTinhRieng[key];
    }

    if (tt == null || _isEmpty(tt.giaTri)) {
      return 'Đang cập nhật';
    }

    final value = tt.giaTri.toString();

    // Ưu tiên donVi từ backend, nếu rỗng thì dùng suffix (nếu có)
    final unit = tt.donVi.isNotEmpty ? tt.donVi : (suffix ?? '');

    if (unit.isNotEmpty) {
      return '$value $unit';
    }
    return value;
  }

  List<SpecItem> _buildSpecs(VatTuDto p) {
    final groupCode = p.nhomVatTu.ma;
    final rawDungLuong = p.duLieuRieng['dung_luong']?.giaTri;
    final formattedDungLuong = (rawDungLuong is num)
        ? rawDungLuong.toStringAsFixed(1)
        : _getAttr(p, 'dung_luong');
    if (groupCode == 'PIN_LUU_TRU') {
      return [
        SpecItem("1. Dung lượng:", "$formattedDungLuong kWh"),
        SpecItem("2. Thương hiệu:", p.thuongHieu.tenQuocTe),
        SpecItem("3. Khối lượng:", _getAttr(p, 'khoi_luong', suffix: 'kg')),
        SpecItem("4. Kích thước:", _getAttr(p, 'kich_thuoc')),
        SpecItem("5. Cách lắp đặt:", _getAttr(p, 'cach_lap_dat')),
        SpecItem("7. Bảo hành:", TronGoiUtils.convertMonthToYearAndMonth(p.thoiGianBaoHanh)),
      ];
    }

    // ----- CASE BIẾN TẦN -----
    if (groupCode == 'BIEN_TAN') {
      return [
        SpecItem("1. Công suất:", _getAttr(p, 'cong_suat', suffix: 'kW')),
        SpecItem("2. Thương hiệu:", p.thuongHieu.tenQuocTe),
        SpecItem("3. Số pha:", _getAttr(p, 'so_pha')),
        SpecItem("4. Phân loại:", _getAttr(p, 'phan_loai')),
        SpecItem("5. Khối lượng:", _getAttr(p, 'khoi_luong', suffix: 'kg')),
        SpecItem("6. Kích thước:", _getAttr(p, 'kich_thuoc')),
        SpecItem("7. Bảo hành:", TronGoiUtils.convertMonthToYearAndMonth(p.thoiGianBaoHanh)),
      ];
    }

    // ----- DEFAULT (TẤM PIN, v.v...) -----
    return [
      SpecItem("1. Công nghệ:", _getAttr(p, 'cong_nghe')),
      SpecItem("2. Thương hiệu:", p.thuongHieu.tenQuocTe),
      SpecItem("3. Công suất:", _getAttr(p, 'cong_suat', suffix: 'Wp')),
      SpecItem("4. Khối lượng:", _getAttr(p, 'khoi_luong', suffix: 'kg')),
      SpecItem("5. Kích thước:", _getAttr(p, 'kich_thuoc')),
      SpecItem(
        "6. Hiệu suất chuyển đổi:",
        _getAttr(p, 'hieu_suat', suffix: '%'),
      ),
      SpecItem("7. Bảo hành:", TronGoiUtils.convertMonthToYearAndMonth(p.thoiGianBaoHanh)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: Center(child: Text(_error!)),
      );
    }

    final product = _product!;
    final specs = _buildSpecs(product);

    // Ảnh chính
    String? imageUrl;
    if (product.anhVatTus.isNotEmpty) {
      final main = product.anhVatTus.firstWhere(
        (e) => e.anhChinh,
        orElse: () => product.anhVatTus.first,
      );
      imageUrl = main.tepTin.duongDan;
    }

    final giaInfo = _getGiaInfo(product);

    final priceText = giaInfo?.giaBan != null
        ? _formatPrice(giaInfo!.giaBan)
        : "Liên hệ";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          // ---------- HEADER ----------
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: false,
            expandedHeight: scale(355),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : Image.asset(
                            'assets/images/product.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: scale(34),
                    left: scale(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(256),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: scale(48),
                          height: scale(48),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E6E6).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(256),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                              color: Color.fromARGB(221, 255, 0, 0),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: scale(12),
                    right: scale(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: scale(12),
                            vertical: scale(4),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x33B5B5B5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '1/1 ảnh',
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: scale(13),
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- NỘI DUNG CHÍNH ----------
          SliverToBoxAdapter(
            child: Container(
              width: width,
              padding: EdgeInsets.all(scale(16)),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.ten,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(18),
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                  SizedBox(height: scale(8)),
                  Text(
                    priceText,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w700,
                      fontSize: scale(24),
                      color: const Color(0xFFEE4037),
                    ),
                  ),
                  SizedBox(height: scale(24)),

                  // ---------- NÚT DATASHEET ----------
                  GestureDetector(
                    onTap: _openSheetLink,
                    child: Container(
                      width: width,
                      height: scale(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.download_rounded,
                            color: Color(0xFFEE4037),
                            size: 20,
                          ),
                          SizedBox(width: scale(8)),
                          Text(
                            'Datasheet',
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w500,
                              fontSize: scale(16),
                              color: const Color(0xFFEE4037),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: scale(12)),

                  // ---------- NÚT LIÊN HỆ ----------
                  Container(
                    width: width,
                    height: scale(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE4037),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26D1D1D1),
                          blurRadius: 34,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Liên hệ ngay',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                          fontSize: scale(16),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: scale(40)),
                ],
              ),
            ),
          ),

          // ---------- THÔNG TIN CHI TIẾT ----------
          SliverToBoxAdapter(child: ProductSpecsSection(specs: specs)),
        ],
      ),
    );
  }
}

class SpecItem {
  final String title;
  final String value;
  SpecItem(this.title, this.value);
}

class ProductSpecsSection extends StatelessWidget {
  final List<SpecItem> specs;
  const ProductSpecsSection({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: width,
      padding: EdgeInsets.all(scale(16)),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: scale(16),
              height: 24 / 16,
              color: const Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(12)),
          ...specs.map(
            (item) => Container(
              padding: EdgeInsets.symmetric(vertical: scale(12)),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: scale(12),
                        height: 18 / 12,
                        color: const Color(0xFF848484),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.value,
                      textAlign: TextAlign.right,
                      softWrap: true,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: scale(12),
                        height: 18 / 12,
                        color: const Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
