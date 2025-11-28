import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../product/widgets/product_card.dart';
import '../../model/tron_goi_models.dart';


//done
class BestSellerSection extends StatelessWidget {
  final List<TronGoiDto> combos;
  const BestSellerSection({super.key, required this.combos});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(horizontal: scale(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sản phẩm bán chạy',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600, // Semibold ~590
                  fontSize: scale(18),
                  height: 28 / 18,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
              // Text(
              //   'Xem chi tiết',
              //   style: TextStyle(
              //     fontFamily: 'SFProDisplay',
              //     fontWeight: FontWeight.w600,
              //     fontSize: scale(12),
              //     height: 18 / 12,
              //     color: const Color(0xFFEE4037),
              //     decoration: TextDecoration.underline,
              //     decorationColor: const Color(0xFFEE4037),
              //     decorationThickness: 1,
              //   ),
              // ),
            ],
          ),

          SizedBox(height: scale(12)),

          // --- Horizontal List ---
          SizedBox(
            width: 398.w,
            height: 480.h,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: combos.length,
              separatorBuilder: (_, __) => SizedBox(width: scale(16)),
              itemBuilder: (context, index) {
                return ProductItemCard(combo: combos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
 
