import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/tron_goi_models.dart';
import '../../../../model/extension.dart';

class ProductItemCard extends StatelessWidget {
  final TronGoiDto combo;
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
    final String? imageUrl = combo.tepTin.duongDan;
    final String typeText = combo.loaiHeThong;
    final String nameText = combo.ten;
    final String priceText = _formatPrice(combo.tongGia);
    final savingText =
        'Công suất ${combo.congSuatHeThong?.formatKwpWithUnit() ?? "--"}';

    return GestureDetector(
      child: Container(
        width: 191.w,
        height: 337.h,
        decoration: BoxDecoration(
          color: const Color(0x33EFFEF5), // #EFFEF533
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            width: 1,
            color: isSelected
                ? const Color(0xFF0F974A)
                : const Color(0xFFE6E6E6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE (không dùng ClipRRect)
            Stack(
              children: [
                // Ảnh: ưu tiên URL, lỗi hoặc null thì dùng asset mặc định
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: SizedBox(
                    width: 190.w,
                    height: 190.w,
                    child: (imageUrl != null && imageUrl.isNotEmpty)
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Ảnh lỗi -> dùng ảnh mặc định
                              return Image.asset(
                                'assets/images/product.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            // URL null hoặc rỗng -> dùng ảnh mặc định
                            'assets/images/product.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                // Pill loại hệ thống
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

            // NHÓM NỘI DUNG TEXT – padding 12
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TAG SAVING
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAFEE8), // đúng Figma
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
                              fontSize: 10.sp,
                              height: 12 / 10,
                              color: const Color.fromARGB(255, 4, 67, 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // NAME + PRICE + RADIO
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
