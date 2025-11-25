import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Sau 3 giây thì chuyển màn hình
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');

      if (!mounted) return;

      if (role == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
      } else {
        switch (role) {
          case "admin":
          case "sale":
          case "agent":
          case "customer":
            Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
            break;

          case "guest":
          default:
            Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D9A56),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Logo ---
            SizedBox(
              width: 255.75,
              height: 66,
              child: Image.asset(
                'assets/images/iconapp.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),
            if (_controller != null)
              AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  final pos = _controller!.value;
                  return Container(
                    width: 265,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [
                          (pos - 0.2).clamp(0.0, 1.0),
                          pos.clamp(0.0, 1.0),
                          (pos + 0.2).clamp(0.0, 1.0),
                        ],
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white,
                          Colors.white.withOpacity(0.2),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
