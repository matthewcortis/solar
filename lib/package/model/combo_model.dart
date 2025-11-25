
import '../model/ProductModel.dart';

class ComboModel {
  final int id;
  final String icon;
  final String text;
  final List<ProductHotModel> products;

  ComboModel({
    required this.id,
    required this.icon,
    required this.text,
    required this.products,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    var productList = <ProductHotModel>[];
    if (json['products'] != null) {
      productList = (json['products'] as List)
          .map((e) => ProductHotModel.fromJson(e))
          .toList();
    }
    return ComboModel(
      id: json['id'],
      icon: json['icon'],
      text: json['text'],
      products: productList,
    );
  }
}

class ComboData {
  final List<ComboModel> combos;

  ComboData({required this.combos});

  factory ComboData.fromJson(Map<String, dynamic> json) {
    return ComboData(
      combos: (json['combos'] as List)
          .map((comboJson) => ComboModel.fromJson(comboJson))
          .toList(),
    );
  }
}