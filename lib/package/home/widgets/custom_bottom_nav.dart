import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': 'assets/icons/home.svg', 'label': 'Trang chủ'},
      {'icon': 'assets/icons/combo.svg', 'label': 'Combo'},
      {'icon': 'assets/icons/thietbi.svg', 'label': 'Thiết bị'},
      {'icon': 'assets/icons/new.svg', 'label': 'Tin tức'},
      {'icon': 'assets/icons/user.svg', 'label': 'Tôi'},
    ];
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               SvgPicture.asset(
                  items[i]['icon']!,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isActive ? const Color(0xFFFF5347) : const Color(0xFF999999),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items[i]['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? const Color(0xFFFF5347)
                        : const Color(0xFF999999),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
