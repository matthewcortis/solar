import 'dart:ui';
import 'package:flutter/material.dart';

class WarrantyItemCard extends StatelessWidget {
  final String image;
  final String statusText;
  final String productName;
  final String activeDate; // dạng: dd/MM/yyyy hoặc ISO yyyy-MM-dd
  final String duration;
  final String endDate; // dạng: dd/MM/yyyy hoặc ISO yyyy-MM-dd

  const WarrantyItemCard({
    super.key,
    required this.image,
    required this.statusText,
    required this.productName,
    required this.activeDate,
    required this.duration,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    // Tính progress dựa theo ngày kích hoạt – ngày hết hạn – hôm nay
    final double progress = _calcProgressFromDates(activeDate, endDate);

    return Container(
      width: scale(402),
      padding: EdgeInsets.fromLTRB(scale(16), scale(8), scale(16), scale(8)),
      decoration: BoxDecoration(
        color: const Color(0x33B5B5B5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// IMAGE
              SizedBox(
                width: scale(74),
                height: scale(74),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        image, // đây là link ảnh từ API
                        width: scale(74),
                        height: scale(74),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/product.png', // ảnh fallback trong assets
                            width: scale(74),
                            height: scale(74),
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: scale(24),
                              height: scale(24),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 0.75,
                              colors: [
                                Colors.transparent,
                                Color.fromRGBO(0, 0, 0, 0.25),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: scale(12)),

              /// CONTENT
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(scale(8)),
                  decoration: BoxDecoration(
                    color: const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Status Tag
                      _buildStatusTag(scale, statusText),

                      SizedBox(height: scale(4)),

                      Text(
                        productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: scale(14),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SFProDisplay',
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),

                      SizedBox(height: scale(4)),

                      Text(
                        "Ngày kích hoạt: $activeDate",
                        style: TextStyle(
                          fontSize: scale(12),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SFProDisplay',
                          color: const Color(0xFF7B7B7B),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Thời gian: $duration",
                            style: TextStyle(
                              fontSize: scale(12),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFProDisplay',
                              color: const Color(0xFF7B7B7B),
                            ),
                          ),
                          Text(
                            "Đến hết: $endDate",
                            style: TextStyle(
                              fontSize: scale(12),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFProDisplay',
                              color: const Color(0xFF7B7B7B),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: scale(6)),

                      /// PROGRESS BAR
                      Container(
                        width: double.infinity,
                        height: scale(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress, // 0.0 → 1.0
                          child: Container(
                            decoration: BoxDecoration(
                              color: getProgressGradientColor(progress),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(Function(double) scale, String trangThai) {
    final hetHan = trangThai.toLowerCase().contains("đã hết hạn");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: scale(8), vertical: scale(4)),
      decoration: BoxDecoration(
        color: hetHan ? const Color(0xFFFCEEE6) : const Color(0xFFEFFEF5),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: hetHan
              ? const Color(0xFFF8DECD)
              : Colors.white.withOpacity(0.7),
          width: 1,
        ),
      ),
      child: Text(
        trangThai,
        style: TextStyle(
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
          fontSize: scale(10),
          height: 12 / 10,
          color: hetHan ? const Color(0xFFDC5903) : const Color(0xFF0F974A),
        ),
      ),
    );
  }
}

/// Parse chuỗi ngày về DateTime.
/// Ưu tiên dạng dd/MM/yyyy, fallback sang ISO (yyyy-MM-dd).
DateTime? _parseDate(String value) {
  if (value.isEmpty) return null;

  // Thử dạng dd/MM/yyyy (ví dụ: 01/01/2024)
  final parts = value.split('/');
  if (parts.length == 3) {
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day != null && month != null && year != null) {
      return DateTime(year, month, day);
    }
  }

  // Fallback: ISO 8601 "2024-01-01"
  try {
    return DateTime.parse(value);
  } catch (_) {
    return null;
  }
}

/// Tính progress [0..1] dựa theo ngày kích hoạt – ngày hết hạn – hôm nay.
double _calcProgressFromDates(String activeDate, String endDate) {
  final start = _parseDate(activeDate);
  final end = _parseDate(endDate);
  if (start == null || end == null) return 0.0;

  final now = DateTime.now();

  // Nếu chưa đến ngày kích hoạt → 0%
  if (now.isBefore(start)) return 0.0;

  // Nếu đã qua ngày hết hạn → 100%
  if (now.isAfter(end)) return 1.0;

  final totalDays = end.difference(start).inDays;
  if (totalDays <= 0) return 1.0;

  final passedDays = now.difference(start).inDays;
  final raw = passedDays / totalDays;
  final numClamped = raw.clamp(0.0, 1.0);

  return (numClamped as num).toDouble();
}

Color getProgressGradientColor(double progress) {
  final numClamped = progress.clamp(0.0, 1.0);
  final t = (numClamped as num).toDouble();

  return Color.lerp(
    const Color(0xFF2ECC71), // xanh khi mới kích hoạt
    const Color(0xFFEE4037), // đỏ khi gần/đã hết hạn
    t,
  )!;
}
