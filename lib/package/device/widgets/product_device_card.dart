import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarmaxapp/package/model/tron_goi_models.dart';
import '../../utils/app_utils.dart';
import '../../../routes.dart';
import '../../model/extension.dart';

class ProductDeviceCard extends StatelessWidget {
  final VatTuDto product;
  const ProductDeviceCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Chiều rộng thực tế của card (do parent quyết định)
        final cardWidth = constraints.maxWidth;

        // 280 là width thiết kế ban đầu
        double scale(double v) => v * cardWidth / 280;

        final imageSize = cardWidth - scale(10);

        return GestureDetector(
          onTap: () {
            print("CLICK PRODUCT ID = ${product.id}");

            Navigator.of(
              context,
              rootNavigator: false,
            ).pushNamed(AppRoutes.detailProductDevice, arguments: product.id);
          },
          child: Container(
            // KHÔNG set width/height cứng nữa
            padding: EdgeInsets.all(scale(12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(scale(28)),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------------- ẢNH ----------------
                ClipRRect(
                  borderRadius: BorderRadius.circular(scale(20)),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Image.network(
                        product.mainImageUrl,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/product.png',
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      ),
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(scale(20)),
                          gradient: const RadialGradient(
                            center: Alignment.center,
                            radius: 0.75,
                            colors: [
                              Colors.transparent,
                              Color.fromRGBO(0, 0, 0, 0.2),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: scale(6),
                        left: scale(6),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: scale(8),
                            vertical: scale(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            product.quantityTag,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              fontSize: scale(10),
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: scale(12)),

                // ---------------- THÔNG TIN ----------------
                SizedBox(
                  width: cardWidth - scale(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Tag bảo hành ---
                      Container(
                        height: scale(26),
                        padding: EdgeInsets.symmetric(
                          horizontal: scale(8),
                          vertical: scale(4),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/new-releases.svg',
                              width: scale(14),
                              height: scale(14),
                            ),
                            SizedBox(width: scale(4)),
                            Expanded(
                              child: Text(
                                'Bảo hành ${TronGoiUtils.convertMonthToYearAndMonth(product.thoiGianBaoHanh)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: scale(12),
                                  height: 1.2,
                                  color: const Color(0xFF4F4F4F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: scale(4)),
                      SizedBox(
                        height: scale(16) * 1.4 * 2,
                        child: Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                            fontSize: scale(18),
                            height: 1.4,
                            color: const Color(0xFF4F4F4F),
                          ),
                        ),
                      ),
                      SizedBox(height: scale(4)),
                      Text(
                        AppUtils.formatVNDNUM(product.price),
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w600,
                          fontSize: scale(18),
                          height: 1.4,
                          color: const Color(0xFFEE4037),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: scale(12)),

                // ---------------- NÚT ----------------
                SizedBox(
                  width: double.infinity,
                  height: scale(48),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
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
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Xem chi tiết',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w500,
                              fontSize: scale(16),
                              color: const Color(0xFFEE4037),
                            ),
                          ),
                          SizedBox(width: scale(6)),
                          SvgPicture.asset(
                            'assets/icons/circle-arrow-right-02-round.svg',
                            width: scale(16),
                            height: scale(16),
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFEE4037),
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
