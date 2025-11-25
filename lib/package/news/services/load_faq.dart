import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/faq_model.dart';

Future<List<FAQModel>> loadFAQ() async {
  try {
    // ✅ Đọc file news.json (chứa cả news và faqs)
    final String jsonString = await rootBundle.loadString('assets/data/news.json');
    final data = json.decode(jsonString);

    final List<dynamic> faqs = data['faqs'] ?? [];
    return faqs.map((item) => FAQModel.fromJson(item)).toList();
  } catch (e) {
    print("❌ Lỗi khi load faqs từ news.json: $e");
    return [];
  }
}
