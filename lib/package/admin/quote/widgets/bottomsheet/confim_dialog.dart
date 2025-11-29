import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: _contentBox(context),
      ),
    );
  }

  Widget _contentBox(BuildContext context) {
    const iosBlue = Color(0xFF007AFF);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Nội dung chính
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 32,
                  color: Color( 0xFFFF3B30), 
                ),
                const SizedBox(height: 12),
                const Text(
                  "Xác nhận tạo báo giá",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Vui lòng kiểm tra lại thông tin trước khi xác nhận.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E93), // grey iOS
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Divider trên hàng nút
          const Divider(height: 0, thickness: 0.5, color: Color(0x1F000000)),

          // Hàng nút iOS style
          SizedBox(
            height: 44,
            child: Row(
              children: [
                // Nút Hủy
                Expanded(
                  child: InkWell(
                    onTap: onCancel,
                    child: Center(
                      child: Text(
                        "Hủy",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color( 0xFFFF3B30), 
                        ),
                      ),
                    ),
                  ),
                ),

                // Divider giữa hai nút
                Container(
                  width: 0.5,
                  color: const Color(0x1F000000),
                ),

                // Nút Xác nhận
                Expanded(
                  child: InkWell(
                    onTap: onConfirm,
                    child: const Center(
                      child: Text(
                        "Xác nhận",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color( 0xFFFF3B30), // red iOS
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
