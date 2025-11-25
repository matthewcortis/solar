import 'package:flutter/material.dart';
import '../../model/product_device_model.dart';
import '../../model/tutorial_model.dart';

import '../../news/widgets/news_item_card.dart';

class RelatedNewsSection extends StatelessWidget {
  final List<ProductDeviceModel> productsDevice;

  final Future<List<TutorialModel>> futureTutorial;

  const RelatedNewsSection({
    super.key,
    required this.productsDevice,
    required this.futureTutorial,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      padding: EdgeInsets.only(top: scale(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Tiêu đề "Tin tức liên quan" =====
          Padding(
            padding: EdgeInsets.symmetric(horizontal: scale(4)),
            child: Text(
              'Tin tức liên quan',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w600,
                fontSize: scale(16),
                height: 1.5,
                color: const Color(0xFF4F4F4F),
              ),
            ),
          ),
          SizedBox(height: scale(12)),

          // ===== Danh sách card tin tức =====
          SizedBox(
            width: scale(398),
            height: scale(355),
            child: FutureBuilder<List<TutorialModel>>(
              future: futureTutorial,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi tải tin: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final tutorialList = snapshot.data ?? [];
                if (tutorialList.isEmpty) {
                  return const Center(
                    child: Text('Không có tin tức nào hiện tại'),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  primary: false,
                  clipBehavior: Clip.hardEdge,
                  itemCount: tutorialList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 17),
                  itemBuilder: (context, index) {
                    return NewsCardCard(news: tutorialList[index]);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
