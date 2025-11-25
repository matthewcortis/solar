import 'package:flutter/material.dart';


class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({
    super.key,
    required this.currentStep, // 1..3
    this.width = 368,
    this.height = 53,
  });

  final int currentStep;
  final double width;
  final double height;

  static const Color green = Color(0xFF34C759);
  static const Color g2 = Color(0xFFE6E6E6);
  static const Color textGray = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    // Mỗi "frame" theo Figma ~ 398/3 = 132.6667
    final double segment = width / 3;                 // ~132.6667
    final double boxSize = 24;                        // số trong khung 24×24
    final double centerYForLine = 12;                 // vector y = 12px
    final double lineWidth = segment - boxSize;       // ~108.6667 ≈ 109
    final double c1 = segment * 0.5;                  // tâm step 1
    final double c2 = segment * 1.5;                  // tâm step 2
    //final double c3 = segment * 2.5;                  // tâm step 3

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Vẽ 2 vector nối theo đúng thông số Figma xấp xỉ:
          // left ~ 78px, width ~ 109px cho đoạn 1-2; đoạn 2-3 tương tự.
          Positioned(
            left: c1 + boxSize / 2,                   // ~78.33
            top: centerYForLine,
            width: lineWidth,                         // ~108.67
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: currentStep > 1 ? green : g2,
              ),
            ),
          ),
          Positioned(
            left: c2 + boxSize / 2,
            top: centerYForLine,
            width: lineWidth,
            height: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: currentStep > 2 ? green : g2,
              ),
            ),
          ),

          // Nội dung 3 frame: mỗi frame rộng ~132.6667, cao 43, gap 7
          Row(
            children: [
              _stepFrame(label: "Loại combo", index: 1, width: segment, boxSize: boxSize),
              _stepFrame(label: "Dòng sản phẩm", index: 2, width: segment, boxSize: boxSize),
              _stepFrame(label: "Thiết bị và vật tư", index: 3, width: segment, boxSize: boxSize),
            ],
          ),

          
        ],
      ),
    );
  }

  Widget _stepFrame({
    required String label,
    required int index,
    required double width,
    required double boxSize,
  }) {
    final bool done = index < currentStep;
    final bool current = index == currentStep;

    Color bg;
    Color border;
    Color textColor;
    if (done) {
      bg = green;
      border = green;
      textColor = Colors.white;
    } else if (current) {
      bg = g2;         // bước hiện tại xám
      border = g2;
      textColor = textGray;
    } else {
      bg = Colors.white;
      border = g2;
      textColor = textGray;
    }

    return SizedBox(
      width: width,              // ~132.6667 theo Figma
      height: 43,                // đúng Figma
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Number box 24x24, bo góc 8
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border, width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 12,
                height: 1,
                fontWeight: FontWeight.w400,
                color: textColor,
                fontFamily: 'SF Pro',
              ),
            ),
          ),
          const SizedBox(height: 7), // gap: 7px theo Figma
          SizedBox(
            height: 12, // còn lại cho text trong 43px tổng chiều cao
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1,
                  fontWeight: FontWeight.w400,
                  color: textGray,
                  fontFamily: 'SF Pro',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  static const double width = 398;
  static const double height = 48;

  @override
  Widget build(BuildContext context) {
   
    final Color background = enabled
        ? const Color(0xFFEE4037) // Primary P4
        : const Color(0xFFFEE3E2); // Primary P2


    return Opacity(
      
      opacity: enabled ? 1 : 1, // opacity không đổi
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x1FD1D1D1), offset: Offset(0, 15), blurRadius: 34),
            BoxShadow(color: Color(0x1FD1D1D1), offset: Offset(0, 61), blurRadius: 61),
            BoxShadow(color: Color(0x24D1D1D1), offset: Offset(0, 137), blurRadius: 82),
            BoxShadow(color: Color(0x14D1D1D1), offset: Offset(0, 244), blurRadius: 98),
            BoxShadow(color: Color(0x00D1D1D1), offset: Offset(0, 382), blurRadius: 107),
          ],
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            disabledBackgroundColor: background,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              height: 28 / 18,
              letterSpacing: 0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}