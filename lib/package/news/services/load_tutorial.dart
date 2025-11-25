import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/tutorial_model.dart';

Future<List<TutorialModel>> loadTutorial() async {
  try {
    // ✅ Đọc cùng file chứa cả "news" và "faqs"
    final String jsonString = await rootBundle.loadString('assets/data/news.json');
    final data = json.decode(jsonString);

    // ✅ Kiểm tra xem có key "news" không
    if (data['tutorial'] == null || data['tutorial'] is! List) {
      print("⚠️ Không tìm thấy mảng 'tutorial' trong JSON.");
      return [];
    }

    // ✅ Parse danh sách tin tức
    final List<dynamic> newsList = data['tutorial'];
    return newsList.map((item) => TutorialModel.fromJson(item)).toList();
  } catch (e) {
    print("❌ Lỗi khi load tutorial.json: $e");
    return [];
  }
}
