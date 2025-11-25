import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaoGiaItemCard extends StatelessWidget {
  final int index;
  final String title;
  final String qty;

  const BaoGiaItemCard({
    super.key,
    required this.index,
    required this.title,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      height: scale(32.44),
      padding: EdgeInsets.only(
        bottom: scale(12), // padding-bottom
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF3F3F3), // Gray-G1
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: scale(20.44), // frame content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ===== LEFT: index + name =====
            Expanded(
              child: Text(
                '$index. $title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  fontSize: scale(14),
                  color: const Color(0xFF4F4F4F),
                ),
              ),
            ),

            SizedBox(width: scale(8)), 

            SizedBox(
              width: scale(80), 
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/icon-app.svg', 
                  height: scale(18),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(width: scale(8)),

            SizedBox(
              width: scale(60), 
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  qty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    fontSize: scale(14),
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
