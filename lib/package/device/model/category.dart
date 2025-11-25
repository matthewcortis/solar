import 'product_device_model.dart';

class CategoryModel {
  final int id;

  final String categoryName;

  // Icon danh mục: assets/images/xxx.png
  final String categoryIcon;

  // Mô tả danh mục
  final String categoryDes;

  // Danh sách sản phẩm trong danh mục
  final List<ProductDeviceModel> products;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryDes,
    required this.products,
  });
}
