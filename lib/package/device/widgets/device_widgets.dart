import 'package:flutter/material.dart';
import '../widgets/product_device_card.dart';
import '../model/product_device_model.dart';
import '../model/category.dart';
// fragment widget hiển thị từng danh mục thiết bị
class DeviceWidgetSection extends StatelessWidget {
  final CategoryModel category;
  final Function(String, List<ProductDeviceModel>) onShowAll;

  const DeviceWidgetSection({
    super.key,
    required this.category,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      margin: EdgeInsets.symmetric(horizontal: scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.categoryName,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(16),
                  height: 24 / 16,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    onShowAll(category.categoryName, category.products),
                child: Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: scale(14),
                    height: 20 / 14,
                    color: const Color(0xFFEE4037),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFEE4037),
                    decorationThickness: 1.6,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: scale(8)),

          Image.asset(
            category.categoryIcon,
            width: scale(97),
            height: scale(30),
            fit: BoxFit.contain,
          ),
          SizedBox(height: scale(8)),

          Text(
            category.categoryDes,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: scale(14),
              height: 20 / 14,
              color: const Color(0xFF848484),
            ),
          ),

          SizedBox(height: scale(24)),

          SizedBox(
            height: scale(520),
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: category.products.length,
              separatorBuilder: (_, __) => SizedBox(width: scale(16)),
              itemBuilder: (context, index) {
                final product = category.products[index];
                return ProductDeviceCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
