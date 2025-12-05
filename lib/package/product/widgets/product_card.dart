import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../routes.dart';
import '../../utils/app_utils.dart';
import '../../model/tron_goi_models.dart';

/// Card sản phẩm (hiển thị ở trang Home) và combo
class ProductItemCard extends StatelessWidget {
  final TronGoiDto combo;

  const ProductItemCard({super.key, required this.combo});

  @override
  Widget build(BuildContext context) {
    final imageUrl = combo.tepTin.duongDan;

    return GestureDetector(
      onTap: () {
        print("ID combo: ${combo.id}");
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.detailProduct, arguments: combo.id);
      },
      child: Container(
        width: 280.w,
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
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 260.w,
                          height: 260.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/product.png',
                            width: 260.w,
                            height: 260.w,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/product.png',
                          width: 260.w,
                          height: 260.w,
                          fit: BoxFit.cover,
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
              width: 260.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h, // ~ 2 dòng với font 16.sp
                    child: Text(
                      combo.ten,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 20 / 16,
                        color: const Color(0xFF4F4F4F),
                      ),
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
                      fontSize: 18.sp,
                      height: 24 / 18,
                      color: const Color(0xFFEE4037),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 260.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAFEE8).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ), // glass effect
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/new-releases.svg',
                                width: 22.w,
                                height: 22.w,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  combo.congSuatHeThong != null
                                      ? '${(combo.congSuatHeThong! / 1000).toStringAsFixed(1)} W/p'
                                      : '—',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    height: 16 / 14,
                                    color: const Color.fromARGB(255, 3, 90, 19),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // --- BUTTON ---
            Container(
              width: 260.w,
              height: 45.h,
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

/// Shimmer skeleton cho ProductItemCard – dùng trong ComboShimmerList
class ProductItemCardShimmer extends StatelessWidget {
  const ProductItemCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1500),
      interval: const Duration(milliseconds: 300),
      color: Colors.grey.shade300,
      colorOpacity: 0.4,
      enabled: true,
      child: Container(
        width: 280.w,
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
            // IMAGE skeleton
            Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(height: 12.h),
            // TEXT skeleton
            SizedBox(
              width: 260.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 220.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 160.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 260.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // BUTTON skeleton
            Container(
              width: 260.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
