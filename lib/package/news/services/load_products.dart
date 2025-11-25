import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/product_device_model.dart';

Future<List<ProductDeviceModel>> loadProducts() async {
  try {
   
    final String jsonString = await rootBundle.loadString('assets/data/news.json');
    final data = json.decode(jsonString);

    if (data['products'] == null || data['products'] is! List) {
      print("⚠️ Không tìm thấy mảng 'products' trong JSON.");
      return [];
    }

    final List<dynamic> newsList = data['products'];
    return newsList.map((item) => ProductDeviceModel.fromJson(item)).toList();
  } catch (e) {
    print("❌ Lỗi khi load news.json: $e");
    return [];
  }
}
