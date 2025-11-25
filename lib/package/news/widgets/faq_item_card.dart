import 'package:flutter/material.dart';

class FAQItem extends StatefulWidget {
  final String title;
  final String content;

  const FAQItem({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: scale(398),
      margin: EdgeInsets.only(bottom: scale(12)),
      padding: EdgeInsets.symmetric(
        horizontal: scale(16),
        vertical: scale(18),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x26D1D1D1), blurRadius: 34, offset: Offset(0, 15)),
          BoxShadow(color: Color(0x21D1D1D1), blurRadius: 61, offset: Offset(0, 61)),
          BoxShadow(color: Color(0x14D1D1D1), blurRadius: 82, offset: Offset(0, 137)),
          BoxShadow(color: Color(0x0DD1D1D1), blurRadius: 98, offset: Offset(0, 244)),
          BoxShadow(color: Color(0x00D1D1D1), blurRadius: 107, offset: Offset(0, 382)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(16),
                      height: 24 / 16,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFF4F4F4F),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            SizedBox(height: scale(8)),
            Text(
              widget.content,
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400,
                fontSize: scale(14),
                height: 20 / 14,
                color: const Color(0xFF4F4F4F),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
