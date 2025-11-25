import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/warranty_model.dart';

Future<List<WarrantyItemModel>> loadWarrantyItems() async {
  final jsonString = await rootBundle.loadString('assets/data/warranty.json');
  final data = json.decode(jsonString);

  final List items = data['items'];
  return items.map((item) => WarrantyItemModel.fromJson(item)).toList();
}
