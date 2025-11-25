import 'package:flutter/material.dart';
import '../model/bai_viet_model.dart';
import '../../utils/app_utils.dart';
import '../../../routes.dart';
class NewsCardCard extends StatelessWidget {
  final dynamic news;

  const NewsCardCard({super.key, required this.news});

  bool get isApi => news is BaiVietModel;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scale(double v) => v * screenWidth / 430;

    final String title = isApi ? news.tieuDe : news.title;
    final String tag = isApi ? news.loaiBaiViet : news.tag;
    final String time = isApi ? AppUtils.timeAgo(news.taoLuc) : news.time;

    final String? imageUrl = isApi ? news.imageUrl : null;
    final String? imageAsset = !isApi ? news.image : null;

    return GestureDetector(
      onTap: () {
        if (isApi) {
          // Dữ liệu từ API: BaiVietModel -> truyền id sang màn chi tiết
          final BaiVietModel article = news as BaiVietModel;
          Navigator.of(context).pushNamed(
            AppRoutes.detailNewsScreen,
            arguments: article.id,
          );
        } else {
          // Dữ liệu local (FAQ, hướng dẫn, v.v.)
          // Tuỳ bạn xử lý: có thể mở màn chi tiết khác hoặc dùng cùng màn chi tiết
          // Ví dụ: nếu local cũng có field id thì:
          // Navigator.of(context).pushNamed(
          //   AppRoutes.detailNewsScreen,
          //   arguments: news.id,
          // );
        }
      },
      child: Center(
        child: Container(
          width: scale(398),
          padding: EdgeInsets.fromLTRB(
            scale(12),
            scale(16),
            scale(12),
            scale(16),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(scale(28)),
            border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26D1D1D1),
                blurRadius: 34,
                offset: Offset(0, 15),
              ),
              BoxShadow(
                color: Color(0x21D1D1D1),
                blurRadius: 61,
                offset: Offset(0, 61),
              ),
              BoxShadow(
                color: Color(0x14D1D1D1),
                blurRadius: 82,
                offset: Offset(0, 137),
              ),
              BoxShadow(
                color: Color(0x0DD1D1D1),
                blurRadius: 98,
                offset: Offset(0, 244),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: scale(372),
                height: scale(170),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(scale(20)),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      if (imageUrl == null && imageAsset != null)
                        Image.asset(
                          imageAsset,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      if ((imageUrl == null || imageUrl.isEmpty) &&
                          imageAsset == null)
                        Container(
                          color: const Color(0xFFE6E6E6),
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(scale(20)),
                          gradient: const RadialGradient(
                            center: Alignment.center,
                            radius: 0.75,
                            colors: [
                              Colors.transparent,
                              Color.fromRGBO(0, 0, 0, 0.2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: scale(10)),

              Container(
                width: scale(372),
                padding: EdgeInsets.all(scale(16)),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE6E6E6), width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TAG
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale(10),
                        vertical: scale(4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w500,
                          fontSize: scale(12),
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ),

                    SizedBox(height: scale(12)),

                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: scale(340)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TITLE
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w600,
                              fontSize: scale(14),
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),

                          SizedBox(height: scale(6)),

                          // TIME
                          Text(
                            time,
                            style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w400,
                              fontSize: scale(12),
                              color: const Color(0xFF828282),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
