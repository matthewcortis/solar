import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DeviceHorizontalItemCard extends StatelessWidget {
  final String image;        // ảnh sản phẩm
  final String tag;          // Hy-Brid
  final String warrantyText; // Bảo hành 12 năm vật lý
  final String name;         // Tấm PV JA SOLAR
  final num price;           // 2150000

  const DeviceHorizontalItemCard({
    super.key,
    required this.image,
    required this.tag,
    required this.warrantyText,
    required this.name,
    required this.price,
  });

  String _formatCurrency(num value) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(value)}đ';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(402),
      height: scale(124),
      padding: EdgeInsets.symmetric(
        horizontal: scale(12),
        vertical: scale(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1FD1D1D1),
            blurRadius: 34,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: SizedBox(
        width: scale(378),
        height: scale(100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== ẢNH SẢN PHẨM =====
            Container(
              width: scale(100),
              height: scale(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: RadialGradient(
                  radius: 0.7356,
                  center: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Tag "Hy-Brid"
                  Positioned(
                    left: scale(8),
                    top: scale(8),
                    child: Container(
                      height: scale(26),
                      padding: EdgeInsets.symmetric(
                        horizontal: scale(8),
                        vertical: scale(4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x33B5B5B5), // #B5B5B533
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600, // ~590
                            fontSize: scale(12),
                            height: 16 / 12,
                            color: const Color(0xFF4F4F4F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: scale(12)),
            // ===== NỘI DUNG BÊN PHẢI =====
            Expanded(
              child: SizedBox(
                height: scale(100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge bảo hành
                    Container(
                      height: scale(26),
                      padding: EdgeInsets.symmetric(
                        horizontal: scale(8),
                        vertical: scale(4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x33B5B5B5), // #B5B5B533
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Thay icon theo asset của bạn
                          SvgPicture.asset(
                            'assets/icons/ic_warranty.svg',
                            width: scale(16),
                            height: scale(16),
                          ),
                          SizedBox(width: scale(4)),
                          Text(
                            warrantyText,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                              fontSize: scale(12),
                              height: 16 / 12,
                              color: const Color(0xFF4F4F4F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: scale(8)),
                    // Tên sản phẩm
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600, // Semibold
                        fontSize: scale(14),
                        height: 20 / 14,
                        color: const Color(0xFF4F4F4F), // Gray-700
                      ),
                    ),
                    SizedBox(height: scale(4)),
                    // Giá
                    Text(
                      _formatCurrency(price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                        fontSize: scale(16),
                        height: 24 / 16,
                        color: const Color(0xFFEE4037), // Primary-P4
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
