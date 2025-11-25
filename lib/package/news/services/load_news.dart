import 'dart:convert';
import 'package:flutter/services.dart';
import '../../model/news_model.dart';

Future<List<NewsModel>> loadNews() async {
  try {
    // ✅ Đọc cùng file chứa cả "news" và "faqs"
    final String jsonString = await rootBundle.loadString('assets/data/news.json');
    final data = json.decode(jsonString);

    // ✅ Kiểm tra xem có key "news" không
    if (data['news'] == null || data['news'] is! List) {
      print("⚠️ Không tìm thấy mảng 'news' trong JSON.");
      return [];
    }

    // ✅ Parse danh sách tin tức
    final List<dynamic> newsList = data['news'];
    return newsList.map((item) => NewsModel.fromJson(item)).toList();
  } catch (e) {
    print("❌ Lỗi khi load news.json: $e");
    return [];
  }
}
