import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../model/accessories_model.dart';

class ProductRepository {
  const ProductRepository();

  Future<List<AccessoriesModel>> loadFromAssets(String path) async {
    final raw = await rootBundle.loadString(path);
    final map = json.decode(raw) as Map<String, dynamic>;
    final list = (map['phukien'] as List).cast<Map<String, dynamic>>();
    return list.map(AccessoriesModel.fromJson).toList();
  }
}
