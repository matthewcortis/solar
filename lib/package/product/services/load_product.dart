import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/ProductModel.dart';

Future<List<ProductHotModel>> loadProducts() async {
  try {
    final String response = await rootBundle.loadString('assets/data/product.json');
    final data = json.decode(response);

    // Truy cập mảng "products" trong JSON (nằm trong data["products"][0]["products"])
    final List<dynamic> productList = data['products'][0]['products'];

    return productList.map((e) => ProductHotModel.fromJson(e)).toList();
  } catch (e) {
    print('❌ Lỗi khi load products.json: $e');
    return [];
  }
}
