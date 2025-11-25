import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/tron_goi_base.dart';

class ProductItemCard extends StatelessWidget {
  final TronGoiInfo combo;
  final bool isSelected;

  const ProductItemCard({
    super.key,
    required this.combo,
    this.isSelected = false,
  });

  String _formatPrice(num value) {
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
    return '$reversed đ';
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = combo.duongDan;
    final String typeText = combo.loaiHeThong;
    final String nameText = combo.ten;
    final String priceText = _formatPrice(combo.tongGia);
    final String savingText =
        'Công suất ~ ${combo.congSuatHeThong.toStringAsFixed(1)} kWp';

    return GestureDetector(
      child: Container(
        width: 191.w,
        height: 337.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0x33EFFEF5), // #EFFEF533
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            width: 1,
            color: isSelected
                ? const Color(0xFF0F974A)
                : const Color(0xFFE6E6E6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 167.w,
                          height: 167.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 167.w,
                          height: 167.w,
                          color: const Color(0xFFE0E0E0),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_outlined,
                            size: 32.w,
                            color: const Color(0xFFBDBDBD),
                          ),
                        ),
                ),
                Container(
                  width: 167.w,
                  height: 157.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
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
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      typeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: const Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // TAG SAVING
            Container(
              width: 161.w,
              height: 26.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/new-releases.svg',
                    width: 18.w,
                    height: 18.w,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      savingText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        fontSize: 9.sp,
                        height: 12 / 9,
                        color: const Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // NAME + PRICE + RADIO
            SizedBox(
              width: 167.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      height: 20 / 14,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          priceText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            height: 24 / 16,
                            color: const Color(0xFFEE4037),
                          ),
                        ),
                      ),

                      // RADIO CUSTOM
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0F974A)
                                : const Color(0xFFBDBDBD),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0F974A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
