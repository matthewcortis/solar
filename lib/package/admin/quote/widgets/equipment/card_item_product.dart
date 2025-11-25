import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String tag;
  final String phase;    // 1 pha
  final String ip;       // IP66
  final String weight;   // 24 kg
  final String warranty; // 05 năm
  final String price;    // 9.999.999đ
  final String imageUrl;
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const ProductCard({
    super.key,
    required this.title,
    required this.tag,
    required this.phase,
    required this.ip,
    required this.weight,
    required this.warranty,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 398.w,
      height: 176.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          // xấp xỉ chuỗi shadow trong thiết kế
          BoxShadow(blurRadius: 34, offset: Offset(0, 15), color: Color(0x1AD1D1D1)),
          BoxShadow(blurRadius: 61, offset: Offset(0, 61), color: Color(0x1BD1D1D1)),
          BoxShadow(blurRadius: 82, offset: Offset(0, 137), color: Color(0x24D1D1D1)),
          BoxShadow(blurRadius: 98, offset: Offset(0, 244), color: Color(0x14D1D1D1)),
          BoxShadow(blurRadius: 107, offset: Offset(0, 382), color: Color(0x00D1D1D1)),
        ],
      ),
      child: Row(
        children: [
          _GradientImageBox(url: imageUrl),
          SizedBox(width: 12.w),
          SizedBox(
            width: 254.w,
            height: 144.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // tên + tag
                SizedBox(
                  height: 20.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600, // ~ Semibold
                            color: const Color(0xFF4F4F4F),
                            height: 20 / 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _Tag(text: tag),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                // cụm thông tin
                SizedBox(
                  height: 110.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _specRow('Công suất:', phase),
                      _specRow('Chỉ số IP:', ip),
                      _specRow('Khối lượng:', weight),
                      _specRow('Bảo hành:', warranty),
                      const Spacer(),
                      // giá + stepper
                      SizedBox(
                        height: 28.h,
                        child: Row(
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF3B30), // đỏ giá
                              ),
                            ),
                            const Spacer(),
                            _QuantityStepper(
                              value: quantity,
                              onMinus: onMinus,
                              onPlus: onPlus,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _specRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF848484),
              height: 18 / 12,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4F4F4F),
                height: 18 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3).withOpacity(1.0), // #F3F3F3 / #FFFFFFCC
        borderRadius: BorderRadius.circular(100.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF4F4F4F),
          height: 1,
        ),
      ),
    );
  }
}

class _GradientImageBox extends StatelessWidget {
  final String url;
  const _GradientImageBox({required this.url});

  @override
  Widget build(BuildContext context) {
    // mô phỏng viền gradient bằng “vỏ” gradient + inner box
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0x00FFFFFF),
          ],
        ),
        boxShadow: const [
          BoxShadow(blurRadius: 12, color: Color(0x1A000000)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(1.w), // độ dày “stroke”
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: Container(
            decoration: const BoxDecoration(
              // nền nhạt để ăn gradient viền
              color: Colors.white,
            ),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black12),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QuantityStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          _circleIcon(Icons.remove, onTap: onMinus),
          SizedBox(width: 8.w),
          Text(
            '$value',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF4F4F4F)),
          ),
          SizedBox(width: 8.w),
          _circleIcon(Icons.add, onTap: onPlus),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFF3B30), width: 1.2.w),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16.w, color: const Color(0xFFFF3B30)),
      ),
    );
  }
}
