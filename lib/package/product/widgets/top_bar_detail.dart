import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../routes.dart';
import '../../model/tron_goi_models.dart';

class ProductImagePreview extends StatelessWidget {
  final String? imageUrl;

  const ProductImagePreview({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget buildImage() {
      Widget child;

      if (imageUrl != null && imageUrl!.isNotEmpty) {
        // URL tuyệt đối
        if (imageUrl!.startsWith('http')) {
          child = Image.network(
            imageUrl!,
            fit: BoxFit.cover, // Ảnh luôn phủ đầy khung, không méo
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) {
              return Image.asset(
                'assets/images/product.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          );
        } else {
          // Asset tương đối
          child = Image.asset(
            imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          );
        }
      } else {
        // Fallback ảnh default
        child = Image.asset(
          'assets/images/product.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        );
      }

      return ClipRRect(
        // Nếu muốn bo góc trên theo Figma, chỉnh ở đây
        borderRadius: BorderRadius.zero,
        child: ColoredBox(
          color: const Color(0xFFEEEEEE), // nền xám nhạt khi ảnh chưa load
          child: child,
        ),
      );
    }

    // Widget dùng trong màn DetailProduct, không dùng Scaffold
    return SizedBox(
      width: width,
      height: 340, // đúng với Figma section ảnh
      child: Stack(
        children: [
          // --- Image full section ---
          Positioned.fill(child: buildImage()),

          // --- Back Glass Button ---
          Positioned(
            top: 86,
            left: 14,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(256),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(256),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26D1D1D1),
                        blurRadius: 34,
                        offset: Offset(0, 15),
                      ),
                      BoxShadow(
                        color: Color(0x21D1D1D1),
                        blurRadius: 61,
                        offset: Offset(0, 61),
                      ),
                      BoxShadow(
                        color: Color(0x14D1D1D1),
                        blurRadius: 82,
                        offset: Offset(0, 137),
                      ),
                      BoxShadow(
                        color: Color(0x0DD1D1D1),
                        blurRadius: 98,
                        offset: Offset(0, 244),
                      ),
                      BoxShadow(
                        color: Color(0x00D1D1D1),
                        blurRadius: 107,
                        offset: Offset(0, 382),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color.fromARGB(221, 255, 0, 0),
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),

          // --- Glass Label “1 ảnh” ---
          Positioned(
            bottom: width * 0.1,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33B5B5B5), // #B5B5B533
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: const Text(
                    '1 ảnh',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================
///  COMBO DETAIL CARD
///  (đổ dữ liệu từ ngoài)
/// ==========================
class ComboDetailCard extends StatelessWidget {
  final String title; // Tên combo
  final String priceText; // Ví dụ: "49.900.000 đ"
  final String description; // Mô tả hệ thống
  TronGoiDto tronGoi;

  ComboDetailCard({
    super.key,
    required this.title,
    required this.priceText,
    required this.description,
    required this.tronGoi,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(430),
      height: scale(358),
      padding: EdgeInsets.all(scale(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x26D1D1D1),
            blurRadius: 34,
            offset: Offset(0, 15),
          ),
          BoxShadow(
            color: Color(0x21D1D1D1),
            blurRadius: 61,
            offset: Offset(0, 61),
          ),
          BoxShadow(
            color: Color(0x14D1D1D1),
            blurRadius: 82,
            offset: Offset(0, 137),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tiết kiệm / tháng ---
          // Row(
          //   children: [
          //     SvgPicture.asset(
          //       'assets/icons/new-releases.svg', // đường dẫn tới file SVG của bạn
          //       width: 16,
          //       height: 16,
          //       colorFilter: const ColorFilter.mode(
          //         Color(0xFF4F4F4F),
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //     SizedBox(width: scale(4)),
          //     Text(
          //       'Tiết kiệm/ tháng: $savingPerMonthText',
          //       style: TextStyle(
          //         fontFamily: 'SFProDisplay',
          //         fontWeight: FontWeight.w400,
          //         fontSize: scale(13),
          //         height: 20 / 13,
          //         color: const Color(0xFF4F4F4F),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: scale(8)),

          // --- Tên combo ---
          Text(
            title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: scale(18),
              height: 22 / 18,
              color: const Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(8)),

          // --- Giá ---
          Text(
            priceText,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w700,
              fontSize: scale(24),
              height: 30 / 24,
              color: const Color(0xFFEE4037),
            ),
          ),
          SizedBox(height: scale(12)),

          // Container(
          //   width: scale(295),
          //   height: scale(36),
          //   padding: EdgeInsets.symmetric(
          //     horizontal: scale(12),
          //     vertical: scale(8),
          //   ),
          //   decoration: BoxDecoration(
          //     color: const Color(0x33E6E6E6),
          //     borderRadius: BorderRadius.circular(scale(12)),
          //   ),
          //   child: Center(
          //     child: Text(
          //       description,
          //       style: TextStyle(
          //         fontFamily: 'SFProDisplay',
          //         fontWeight: FontWeight.w500,
          //         fontSize: scale(13),
          //         height: 20 / 13,
          //         color: const Color(0xFF4F4F4F),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: scale(16)),

          // --- Mô tả ---
          SizedBox(height: scale(24)),

          // --- 2 nút ---
          Row(
            children: [
              // --- Nút "Thông tin báo giá" ---
              Expanded(
                child: Container(
                  height: scale(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6), // var(--Gray-G2)
                    borderRadius: BorderRadius.circular(scale(12)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26D1D1D1),
                        blurRadius: 34,
                        offset: Offset(0, 15),
                      ),
                      BoxShadow(
                        color: Color(0x21D1D1D1),
                        blurRadius: 61,
                        offset: Offset(0, 61),
                      ),
                      BoxShadow(
                        color: Color(0x14D1D1D1),
                        blurRadius: 82,
                        offset: Offset(0, 137),
                      ),
                      BoxShadow(
                        color: Color(0x0DD1D1D1),
                        blurRadius: 98,
                        offset: Offset(0, 244),
                      ),
                      BoxShadow(
                        color: Color(0x00D1D1D1),
                        blurRadius: 107,
                        offset: Offset(0, 382),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.baoGiaScreen,
                        arguments: tronGoi, 
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/document-validation.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFEE4037),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: scale(10)),
                        Text(
                          'Thông tin báo giá',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: scale(14),
                            color: const Color(0xFFEE4037),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: scale(12)), // khoảng cách giữa 2 nút
          // --- Nút "Liên hệ ngay" ---
          Container(
            width: scale(398),
            height: scale(40),
            decoration: BoxDecoration(
              color: const Color(0xFFEE4037), // var(--Primary-P4)
              borderRadius: BorderRadius.circular(scale(12)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26D1D1D1),
                  blurRadius: 34,
                  offset: Offset(0, 15),
                ),
                BoxShadow(
                  color: Color(0x21D1D1D1),
                  blurRadius: 61,
                  offset: Offset(0, 61),
                ),
                BoxShadow(
                  color: Color(0x14D1D1D1),
                  blurRadius: 82,
                  offset: Offset(0, 137),
                ),
                BoxShadow(
                  color: Color(0x0DD1D1D1),
                  blurRadius: 98,
                  offset: Offset(0, 244),
                ),
                BoxShadow(
                  color: Color(0x00D1D1D1),
                  blurRadius: 107,
                  offset: Offset(0, 382),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Liên hệ ngay',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(14),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================
///  COMBO DETAIL INFO
///  (đổ dữ liệu từ ngoài)
/// ==========================
class ComboDetailInfo extends StatelessWidget {
  final String congSuatPV;
  final String bienTan;
  final String luuTru;
  final String sanLuong;
  final String hoanVon;
  final String dienTich;

  const ComboDetailInfo({
    super.key,
    required this.congSuatPV,
    required this.bienTan,
    required this.luuTru,
    required this.sanLuong,
    required this.hoanVon,
    required this.dienTich,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(430),
      height: scale(228),
      padding: EdgeInsets.all(scale(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x26D1D1D1),
            blurRadius: 34,
            offset: Offset(0, 15),
          ),
          BoxShadow(
            color: Color(0x21D1D1D1),
            blurRadius: 61,
            offset: Offset(0, 61),
          ),
          BoxShadow(
            color: Color(0x14D1D1D1),
            blurRadius: 82,
            offset: Offset(0, 137),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tiêu đề ---
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

          // --- Bảng thông tin ---
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRow('Công suất PV:', congSuatPV),
                _buildRow('Biến tần Solis:', bienTan),
                _buildRow('Lưu trữ Dyness:', luuTru),
                _buildRow('Sản lượng:', sanLuong),
                _buildRow('Hoàn vốn:', hoanVon),
                _buildRow('Diện tích lắp đặt:', dienTich),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cột trái
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 20 / 14,
              color: Color(0xFF848484), // var(--Gray-G4)
            ),
          ),
          // Cột phải
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 20 / 14,
              color: Color(0xFF4F4F4F), // var(--Gray-G5)
            ),
          ),
        ],
      ),
    );
  }
}
