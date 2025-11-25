import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SolarArticleHeader extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String authorName;
  final String authorRole;
  final String avatarAsset;
  final VoidCallback? onBack;
  final VoidCallback? onAction;

  const SolarArticleHeader({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.authorName,
    required this.authorRole,
    required this.avatarAsset,
    this.onBack,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ảnh cover
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(scale(20)),
            bottomRight: Radius.circular(scale(20)),
          ),
          child: Stack(
            children: [
              Image.asset(
                imageAsset,
                width: width,
                height: scale(355),
                fit: BoxFit.cover,
              ),
              Container(
                width: width,
                height: scale(355),
                color: const Color(0x52000000),
              ),
              Positioned(
                top: scale(82),
                left: scale(16),
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: scale(48),
                    height: scale(48),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      shape: BoxShape.circle,
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
                        BoxShadow(
                          color: Color(0x00D1D1D1),
                          blurRadius: 107,
                          offset: Offset(0, 382),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: scale(10)),

        // Tiêu đề
        Padding(
          padding: EdgeInsets.symmetric(horizontal: scale(16)),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: scale(24),
              height: 30 / 24,
              color: const Color(0xFF4F4F4F),
            ),
          ),
        ),

        SizedBox(height: scale(12)),

        // Thông tin user
        Padding(
          padding: EdgeInsets.symmetric(horizontal: scale(16)),
          child: SizedBox(
            width: scale(398),
            height: scale(47),
            child: Row(
              children: [
                Container(
                  width: scale(40),
                  height: scale(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x1A000000),
                      width: 1,
                    ),
                    image: DecorationImage(
                      image: AssetImage(avatarAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: scale(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        authorName,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w600,
                          fontSize: scale(16),
                          height: 1.5,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                      Text(
                        authorRole,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w400,
                          fontSize: scale(14),
                          height: 1.5,
                          color: const Color(0xFF848484),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onAction,
                  child: Container(
                    width: scale(40),
                    height: scale(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(scale(12)),
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
                        BoxShadow(
                          color: Color(0x00D1D1D1),
                          blurRadius: 107,
                          offset: Offset(0, 382),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/pdf-02.svg', // Thay bằng đường dẫn tệp SVG của bạn
                      width: 18, // Tương đương với size: 18
                      height: 18, // Tương đương với size: 18
                      colorFilter: const ColorFilter.mode(
                        // Sử dụng colorFilter để đặt màu cho SVG
                        Color.fromARGB(255, 255, 0, 0),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NewsSummaryCard extends StatefulWidget {
  final int views; // Lượt xem
  final String datePosted; // Ngày đăng
  final String dateUpdated; // Ngày cập nhật
  final String title; // Tiêu đề (Tóm tắt, Giới thiệu,...)
  final String content; // Nội dung

  const NewsSummaryCard({
    super.key,
    required this.views,
    required this.datePosted,
    required this.dateUpdated,
    required this.title,
    required this.content,
  });

  @override
  State<NewsSummaryCard> createState() => _NewsSummaryCardState();
}

class _NewsSummaryCardState extends State<NewsSummaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      padding: EdgeInsets.all(scale(16)),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF), // #FFFFFF1A
        borderRadius: BorderRadius.circular(scale(20)),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Frame: lượt xem + ngày giờ =====
          Row(
            children: [
              const Icon(
                Icons.remove_red_eye_outlined,
                size: 14,
                color: Color(0xFF848484),
              ),
              SizedBox(width: scale(4)),
              Text(
                '${widget.views} lượt xem',
                style: const TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF848484),
                ),
              ),
              SizedBox(width: scale(12)),
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xFF848484),
              ),
              SizedBox(width: scale(4)),
              Text(
                widget.datePosted,
                style: const TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF848484),
                ),
              ),
              SizedBox(width: scale(12)),
              const Icon(
                Icons.access_time_outlined,
                size: 14,
                color: Color(0xFF848484),
              ),
              SizedBox(width: scale(4)),
              Text(
                widget.dateUpdated,
                style: const TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF848484),
                ),
              ),
            ],
          ),

          SizedBox(height: scale(16)),

          // ===== Tiêu đề =====
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(8)),

          // ===== Nội dung =====
          AnimatedCrossFade(
            firstChild: Text(
              widget.content.length > 180
                  ? '${widget.content.substring(0, 180)}...'
                  : widget.content,
              style: const TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF4F4F4F),
              ),
            ),
            secondChild: Text(
              widget.content,
              style: const TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF4F4F4F),
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),

          SizedBox(height: scale(12)),

          // ===== Nút xem thêm / thu gọn =====
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _expanded ? 'Thu gọn' : 'Xem thêm',
                  style: const TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF4F4F4F),
                  ),
                ),
                SizedBox(width: scale(6)),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: const Color(0xFF4F4F4F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
