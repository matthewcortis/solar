import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandCard extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback? onTap;

  const BrandCard({
    super.key,
    required this.iconPath,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), 
        child: Container(
          width: 191.w,
          height: 126.w,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(
              0x33F3F3F3,
            ), 
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE6E6E6), 
              width: 1,
            ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x33E6E6E6), 
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
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
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFEE4037), 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 20 / 12,
                  color: Color(0xFF4F4F4F), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
