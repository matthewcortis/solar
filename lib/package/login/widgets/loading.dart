import 'package:flutter/material.dart';

class ExpandingCircleScreen extends StatefulWidget {
  const ExpandingCircleScreen({super.key});

  @override
  State<ExpandingCircleScreen> createState() => _ExpandingCircleScreenState();
}

class _ExpandingCircleScreenState extends State<ExpandingCircleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final maxRadius = size.height * 1.2;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.white),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: maxRadius * _animation.value,
                height: maxRadius * _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
