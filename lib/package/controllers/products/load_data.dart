import 'dart:convert';
import 'package:flutter/services.dart';
import './category_product.dart';

Future<ProductCategoryModel> loadAllProducts() async {
  final String response = await rootBundle.loadString('assets/data/product.json');
  final Map<String, dynamic> jsonData = json.decode(response);
  return ProductCategoryModel.fromJson(jsonData);
}
