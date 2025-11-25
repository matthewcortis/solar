import 'package:flutter/material.dart';
import '../quantity_control.dart'; // import widget mới

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.phaseText,
    required this.accessoryText,
    required this.imageProvider,
    required this.quantity,
    this.onAdd,
    this.onRemove,
  });

  final String title;
  final String phaseText;
  final String accessoryText;
  final ImageProvider imageProvider;
  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  static const _titleStyle = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4F4F4F),
  );

  static const _subTextStyle = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    color: Color(0xFF8E8E93),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 398,
      height: 162,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            // Nội dung chính
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GradientBorderImage(imageProvider: imageProvider),
                const SizedBox(width: 12),
                // Thông tin sản phẩm
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _titleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phaseText,
                        style: _subTextStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        accessoryText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _subTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Tăng/giảm số lượng
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                QuantityControl(
                  quantity: quantity,
                  onAdd: onAdd,
                  onRemove: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientBorderImage extends StatelessWidget {
  const _GradientBorderImage({required this.imageProvider});

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 81,
      height: 81,
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 12)],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0x00FFFFFF),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x00FFFFFF),
                  Color(0xB3FFFFFF),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: imageProvider,
                  width: 78,
                  height: 78,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
