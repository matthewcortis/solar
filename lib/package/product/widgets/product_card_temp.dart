import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/tron_goi_models.dart';
import '../../model/extension.dart';
class ProductDeviceCard extends StatelessWidget {
  final VatTuTronGoiDto item;
  final VoidCallback? onTap;

  const ProductDeviceCard({
    super.key,
    required this.item,
    this.onTap,
  });

  String _buildQuantityTag() {
    // Hiển thị dạng "x4 tấm" hoặc "x2 bộ" tùy theo đơn vị
    final soLuong = item.soLuong;
    final donVi = item.vatTu.donVi;
    if (soLuong == soLuong.roundToDouble()) {
      // là số nguyên
      return 'x${soLuong.toInt()} $donVi';
    }
    return 'x$soLuong $donVi';
  }

  String _buildWarrantyText() {
    if (!item.duocBaoHanh) return 'Không bảo hành';
    if (item.thoiGianBaoHanh <= 0) return 'Không bảo hành';
    final String thoiGian_baoHanh = TronGoiUtils.convertMonthToYearAndMonth(item.thoiGianBaoHanh);
    return  'Bảo hành $thoiGian_baoHanh';
  }

  String _formatPrice(double value) {
    // Đơn giản: format "1.000.000 đ"
    final str = value.toStringAsFixed(0);
    final reversed = str.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buf.write('.');
      }
      buf.write(reversed[i]);
    }
    final formatted = buf.toString().split('').reversed.join();
    return '$formatted đ';
  }

  String _getThuocTinh(VatTuDto vatTu, String key) {
    // key phụ thuộc backend: ví dụ 'congSuat', 'congNghe'
    final tt = vatTu.duLieuRieng[key];
    if (tt == null || tt.giaTri == null) return 'Đang cập nhật';
    final value = tt.giaTri.toString();
    if (tt.donVi.isNotEmpty) {
      return '$value ${tt.donVi}';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final vatTu = item.vatTu;

    // Ảnh chính
    String? imageUrl;
    if (vatTu.anhVatTus.isNotEmpty) {
      final main = vatTu.anhVatTus.firstWhere(
        (e) => e.anhChinh,
        orElse: () => vatTu.anhVatTus.first,
      );
      imageUrl = main.tepTin.duongDan;
    }

    final quantityTag = _buildQuantityTag();
    final warrantyText = _buildWarrantyText();
    final priceText = _formatPrice(item.gia);

    final powerText = _getThuocTinh(vatTu, 'cong_suat');
    final techText = _getThuocTinh(vatTu, 'cong_nghe');

    return InkWell(
      borderRadius: BorderRadius.circular(28.r),
      onTap: onTap,
      child: Container(
        width: 295.w,
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
            BoxShadow(
              color: Color(0x0DD1D1D1),
              blurRadius: 98,
              offset: Offset(0, 244),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---------------- ẢNH ----------------
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      width: 271.w,
                      height: 271.h,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.asset(
                      'assets/images/product.png',
                      width: 271.w,
                      height: 271.h,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    width: 271.w,
                    height: 271.h,
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
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        quantityTag,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // ---------------- THÔNG TIN ----------------
            SizedBox(
              width: 271.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 28.h,
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
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          warrantyText,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: const Color(0xFF4F4F4F),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    vatTu.ten,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: const Color(0xFF4F4F4F),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    priceText,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: const Color(0xFFEE4037),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Công suất:',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                      Text(
                        powerText,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Công nghệ:',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                      Text(
                          techText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: const Color(0xFF4F4F4F),
                      ),
                      ),
                    ],
                  ),
                
                 SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số lượng:',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                      Text(
                        quantityTag,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // ---------------- NÚT ----------------
            Container(
              width: 271.w,
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
                        fontSize: 16.sp,
                        height: 24 / 16,
                        color: const Color(0xFFEE4037),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SvgPicture.asset(
                      'assets/icons/circle-arrow-right-02-round.svg',
                      width: 18.w,
                      height: 18.h,
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
