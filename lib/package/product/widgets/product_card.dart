import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routes.dart';
import '../../utils/app_utils.dart';
import '../../model/tron_goi_base.dart';

/// Card sản phẩm (hiển thị ở trang Home) va ̣combo
class ProductItemCard extends StatelessWidget {
  final TronGoiInfo combo;

  const ProductItemCard({super.key, required this.combo});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("ID combo: ${combo.id}");
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.detailProduct, arguments: combo.id);
      },
      child: Container(
        width: 190.w,

        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
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
          children: [
            // --- IMAGE + TYPE TAG ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: combo.duongDan != null && combo.duongDan!.isNotEmpty
                      ? Image.network(
                          combo.duongDan!,
                          width: 167.w,
                          height: 167.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 167.w,
                          height: 167.w,
                          color: const Color(0xFFE6E6E6),
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
                // Container(
                //   width: 167.w,
                //   height: 157.w,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20.r),
                //     gradient: const RadialGradient(
                //       center: Alignment.center,
                //       radius: 0.75,
                //       colors: [
                //         Colors.transparent,
                //         Color.fromRGBO(0, 0, 0, 0.2),
                //       ],
                //     ),
                //   ),
                // ),
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
                      combo.loaiHeThong,
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

            // --- TEXT CONTENT ---
            SizedBox(
              width: 167.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    combo.ten,
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
                  Text(
                    AppUtils.formatVND(combo.tongGia),
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
                  SizedBox(height: 8.h),
                  Container(
                    width: 161.w,
                    height: 26.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
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
                            '${(combo.congSuatHeThong / 1000).toStringAsFixed(1)} W/p',
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
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // --- BUTTON ---
            Container(
              width: 167.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(12.r),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        height: 24 / 16,
                        color: const Color(0xFFEE4037),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SvgPicture.asset(
                      'assets/icons/circle-arrow-right-02-round.svg',
                      width: 20.w,
                      height: 20.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFEE4037),
                        BlendMode.srcIn,
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
