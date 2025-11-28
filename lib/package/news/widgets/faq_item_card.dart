import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class FAQItem extends StatefulWidget {
  final String title;
  final String? htmlUrl; // URL tới file .html

  const FAQItem({
    super.key,
    required this.title,
    required this.htmlUrl,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;
  Future<String>? _htmlFuture;

Future<String> _loadHtml(String url) async {
  debugPrint('FAQItem – load HTML from: $url');

  final uri = Uri.parse(url);
  final res = await http.get(uri);

  debugPrint('FAQItem – status: ${res.statusCode}');

  if (res.statusCode < 200 || res.statusCode >= 300) {
    // In thêm body (cắt bớt để log gọn)
    debugPrint('FAQItem – body: ${res.body.substring(0, res.body.length.clamp(0, 500))}');
    throw Exception('Tải nội dung thất bại (${res.statusCode}).');
  }

  return utf8.decode(res.bodyBytes);
}


  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;

      // Lần đầu mở thì mới gọi API
      if (isExpanded && _htmlFuture == null && widget.htmlUrl != null && widget.htmlUrl!.isNotEmpty) {
        _htmlFuture = _loadHtml(widget.htmlUrl!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: scale(398),
      margin: EdgeInsets.only(bottom: scale(12)),
      padding: EdgeInsets.symmetric(horizontal: scale(16), vertical: scale(18)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26D1D1D1),
            blurRadius: 34,
            offset: Offset(0, 15),
          ),
          BoxShadow(
            color: Color(0x21D1D1D1),
            blurRadius: 17,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: title + arrow
          GestureDetector(
            onTap: _toggleExpand,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(16),
                      height: 1.4,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
                SizedBox(width: scale(8)),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: scale(24),
                  color: const Color(0xFF848484),
                ),
              ],
            ),
          ),

          if (isExpanded)
            SizedBox(height: scale(8)),

          if (isExpanded)
            (widget.htmlUrl == null || widget.htmlUrl!.isEmpty)
                ? Text(
                    'Không có nội dung.',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: scale(14),
                      color: const Color(0xFF4F4F4F),
                    ),
                  )
                : FutureBuilder<String>(
                    future: _htmlFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Lỗi tải nội dung: ${snapshot.error}',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: scale(14),
                              color: Colors.red,
                            ),
                          ),
                        );
                      }

                      final htmlContent = snapshot.data ?? '';

                      return Html(
                        data: htmlContent,
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(scale(14)),
                            color: const Color(0xFF4F4F4F),
                            lineHeight: LineHeight.number(1.5),
                          ),
                          'p': Style(
                            margin: Margins.only(bottom: scale(4)),
                          ),
                        },
                      );
                    },
                  ),
        ],
      ),
    );
  }
}
