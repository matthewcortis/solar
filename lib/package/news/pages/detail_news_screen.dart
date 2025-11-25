import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import '../widgets/header_news_detail.dart';
import '../model/bai_viet_model.dart';
import '../repository/bai_viet_detail.dart'; // repo gọi /bai-viet/filter

import '../../home/widgets/list_product.dart';
import '../../home/model/tron_goi_hot.dart';
import '../../home/repository/hot_combo_repo.dart';
class DetailNewsScreen extends StatefulWidget {
  const DetailNewsScreen({super.key});

  @override
  State<DetailNewsScreen> createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  late Future<List<TronGoiBanChayModel>> _productNews;
  late Future<_BaiVietDetailData> _detailFuture;
  bool _initialized = false;
  final _baiVietRepo = BaiVietRepository();
   final TronGoiRepository _productNewsRepository = TronGoiRepository();

  @override
  void initState() {
    super.initState();
    _productNews = _productNewsRepository.getDanhSachBanChay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      int? articleId;

      if (args is int) {
        articleId = args;
      } else if (args is String) {
        articleId = int.tryParse(args);
      }

      if (articleId == null) {
        _detailFuture = Future.error("Không nhận được ID bài viết");
      } else {
        _detailFuture = _loadArticle(articleId);
      }

      _initialized = true;
    }
  }

  Future<_BaiVietDetailData> _loadArticle(int id) async {
    // 1. Gọi API lấy thông tin bài viết theo id
    final baiViet = await _baiVietRepo.getBaiVietById(id);

    // 2. Lấy link file HTML từ trường noiDung.duongDan
    final noiDungFile = baiViet.noiDung;
    if (noiDungFile == null || noiDungFile.duongDan.isEmpty) {
      throw Exception("Bài viết không có nội dung.");
    }

    final uri = Uri.parse(noiDungFile.duongDan);

    // 3. Tải nội dung HTML
    final res = await http.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Tải nội dung bài viết thất bại (${res.statusCode}).");
    }

    // 4. Decode UTF-8 để hiển thị tiếng Việt đúng
    final htmlString = utf8.decode(res.bodyBytes);

    return _BaiVietDetailData(baiViet: baiViet, htmlContent: htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: FutureBuilder<_BaiVietDetailData>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu bài viết'));
          }

          final data = snapshot.data!;
          final baiViet = data.baiViet;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Header =====
                SolarArticleHeader(
                  // Nếu widget này đang dùng Image.asset,
                  // tạm thời vẫn để banner local. Nếu bạn đã sửa
                  // sang network thì có thể truyền baiViet.anhBia?.duongDan ở đây.
                  imageAsset: 'assets/images/banner-detail.jpg',
                  title: baiViet.tieuDe,
                  authorName: 'SolarMax', // tạm thời hard-code vì API chưa có
                  authorRole: 'MEGA STORY',
                  avatarAsset: 'assets/images/avatar.jpg',
                  onBack: () => Navigator.pop(context),
                  onAction: () {
                    // xử lý PDF nếu có
                  },
                ),

                const SizedBox(height: 12),

                // ===== Tóm tắt =====
                Center(
                  child: NewsSummaryCard(
                    views: 3800,
                    datePosted: baiViet.taoLuc.split('T').first,
                    dateUpdated: baiViet.taoLuc.split('T').first,
                    title: 'Tóm tắt ',
                    // Nếu sau này API có field tóm tắt thì thay vào,
                    // hiện tại giữ text mẫu hoặc bỏ hẳn summary nếu không cần.
                    content:
                        'Bài viết thuộc nhóm ${baiViet.loaiBaiViet} trên hệ thống SolarMax.',
                  ),
                ),

                const SizedBox(height: 12),

                // ===== Nội dung chi tiết HTML hiển thị ở đây =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Html(
                    data: data.htmlContent,
                    // Có thể custom style tại đây nếu cần
                    // style: { 'p': Style(fontSize: FontSize(16)) }
                  ),
                ),

                const SizedBox(height: 10),

                FutureBuilder<List<TronGoiBanChayModel>>(
                  future: _productNews,
                  builder: (context, bestSnapshot) {
                    if (bestSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (bestSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Không thể tải combo bán chạy: ${bestSnapshot.error}',
                        ),
                      );
                    }

                    final bestSellers = bestSnapshot.data ?? [];
                    if (bestSellers.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return BestSellerSection(combos: bestSellers);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BaiVietDetailData {
  final BaiVietModel baiViet;
  final String htmlContent;

  _BaiVietDetailData({required this.baiViet, required this.htmlContent});
}
