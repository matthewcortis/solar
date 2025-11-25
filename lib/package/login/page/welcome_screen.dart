import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final screenWidth = size.width;
    final screenHeight = size.height - padding.top - padding.bottom;

    double scaleW(double w) => w * screenWidth / 430;
    double scaleH(double h) => h * screenHeight / 932;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Nút back
            Positioned(
              top: scaleH(16),
              left: scaleW(16),
              child: GestureDetector(
                onTap: () {
                   Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.bottomNav,
                          );
                },
                child: Container(
                  width: scaleW(40),
                  height: scaleW(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(scaleW(12)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1FD1D1D1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: scaleH(230),
              left: scaleW(16),
              right: scaleW(16),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/welcome.svg',
                  width: scaleW(399),
                  height: scaleH(267),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Positioned(
              top: scaleH(665),
              left: scaleW(16),
              right: scaleW(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng đến với SLM',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: scaleW(24),
                      color: const Color(0xFF27273E),
                    ),
                  ),
                  SizedBox(height: scaleH(4)),
                  Text(
                    'Hãy bắt đầu tất cả mọi thứ tại đây!',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                      fontSize: scaleW(14),
                      color: const Color(0xFF7B7D9D),
                    ),
                  ),
                ],
              ),
            ),

            /// --- Buttons ---
            Positioned(
              bottom: scaleH(32),
              left: scaleW(16),
              right: scaleW(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: scaleH(48),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.registerScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F5F8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(scaleW(12)),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: const Color(0xFFED1C24),
                          fontSize: scaleW(16),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: scaleH(12)),
                  SizedBox(
                    width: double.infinity,
                    height: scaleH(48),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.loginScreenPage);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED1C24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(scaleW(12)),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: scaleW(16),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
