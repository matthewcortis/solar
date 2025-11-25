import '../../model/ProductModel.dart';
import '../../model/product_device_model.dart';
class ProductCategoryModel {
  final List<ProductHotModel> hotProducts;
  final List<ProductDeviceModel> deviceProducts;

  ProductCategoryModel({
    required this.hotProducts,
    required this.deviceProducts,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    final categories = json['categories'] as List<dynamic>;

    final hotCategory = categories.firstWhere(
      (c) => c['id'] == 1,
      orElse: () => {'products': []},
    );

    final deviceCategory = categories.firstWhere(
      (c) => c['id'] == 2,
      orElse: () => {'products': []},
    );

    final hotList = (hotCategory['products'] as List<dynamic>)
        .map((e) => ProductHotModel.fromJson(e))
        .toList();

    final deviceList = (deviceCategory['products'] as List<dynamic>)
        .map((e) => ProductDeviceModel.fromJson(e))
        .toList();

    return ProductCategoryModel(
      hotProducts: hotList,
      deviceProducts: deviceList,
    );
  }
}
