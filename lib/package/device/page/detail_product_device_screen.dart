import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repository/chi_tiet_vat_tu_repo.dart';
import '../model/device_detail_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _repo = ProductRepository();
  ProductDetailModel? _product;
  bool _isLoading = true;
  String? _error;

  bool _didInit = false; // flag để chỉ load 1 lần

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    int? productId;
    if (args is int) {
      productId = args;
    } else if (args is String) {
      productId = int.tryParse(args);
    }

    if (productId == null) {
      setState(() {
        _error = "Không nhận được ID sản phẩm";
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

  Future<void> _openSheetLink() async {
    final url = _product?.sheetLink;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không có link datasheet")),
      );
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
    if (price == null) return '0 đ';
    final formatter = NumberFormat("#,##0", "vi_VN");
    return "${formatter.format(price)} đ";
  }

  List<SpecItem> _buildSpecs(ProductDetailModel p) {
    return [
      SpecItem("1. Công nghệ:", p.tech),
      SpecItem("2. Thương hiệu:", p.brandName),
      SpecItem("3. Công suất:", "${p.power} Wp"),
      SpecItem("4. Khối lượng:", "${p.weight} kg"),
      SpecItem("5. Kích thước:", p.size),
      SpecItem("6. Hiệu suất chuyển đổi:", "${p.efficiency} %"),
      SpecItem("7. Bảo hành:", "12 năm vật lý, 25 năm hiệu suất"),
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
                    child: Image.asset(
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
                            '1/13 ảnh',
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
                    'Thông số kỹ thuật ${product.name}',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(18),
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                  SizedBox(height: scale(8)),
                  Text(
                    _formatPrice(product.price),
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
                        )
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
          SliverToBoxAdapter(
            child: ProductSpecsSection(specs: specs),
          ),
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
