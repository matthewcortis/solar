import 'package:flutter/material.dart';
import '../quantity_control.dart';

class SolarMaxCartCard extends StatelessWidget {
  /// Nhận đường dẫn ảnh (có thể là URL http hoặc asset path).
  /// Nếu null hoặc rỗng sẽ dùng ảnh fallback.
  final String? imageUrl;

  final String title;
  final String modeTag; // "Hy-Brid"
  final String congSuat;
  final String chiSoIp;
  final String khoiLuong;
  final String baoHanh;
  final String priceText; // Ví dụ: "9.999.999đ"

  /// Số lượng hiện tại
  final int quantity;

  /// Callback bấm nút +
  final VoidCallback? onIncrease;

  /// Callback bấm nút -
  final VoidCallback? onDecrease;

  /// Có hiển thị cụm tăng/giảm không
  final bool showQuantityControl;

  /// Màu nền card
  final Color? backgroundColor;

  const SolarMaxCartCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.modeTag,
    required this.congSuat,
    required this.chiSoIp,
    required this.khoiLuong,
    required this.baoHanh,
    required this.priceText,
    required this.quantity,
    this.onIncrease,
    this.onDecrease,
    this.showQuantityControl = true,
    this.backgroundColor = const Color(0xFFE6E6E6),
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Center(
      child: Container(
        width: scale(398),
        height: scale(176),
        padding: EdgeInsets.all(scale(16)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
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
        child: SizedBox(
          width: scale(366),
          height: scale(144),
          child: Row(
            children: [
              _GradientBorderImage(
                imageUrl: imageUrl,
                size: scale(100),
              ),
              SizedBox(width: scale(12)), // gap: 12
              Expanded(
                child: _RightContent(
                  title: title,
                  modeTag: modeTag,
                  congSuat: congSuat,
                  chiSoIp: chiSoIp,
                  khoiLuong: khoiLuong,
                  baoHanh: baoHanh,
                  priceText: priceText,
                  quantity: quantity,
                  onIncrease: onIncrease,
                  onDecrease: onDecrease,
                  scale: scale,
                  showQuantityControl: showQuantityControl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ảnh 100×100, viền gradient 1px, bo 12, bóng mờ 0 0 12
class _GradientBorderImage extends StatelessWidget {
  const _GradientBorderImage({
    required this.imageUrl,
    required this.size,
  });

  final String? imageUrl;
  final double size;

  Widget _buildImage() {
    // Không có ảnh -> dùng fallback asset
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Image.asset(
        'assets/images/product.png',
        fit: BoxFit.cover,
      );
    }

    // Nếu là http/https -> Image.network
    if (imageUrl!.startsWith('http')) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
      );
    }

    // Còn lại coi như asset path
    return Image.asset(
      imageUrl!,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
            colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1), // border-width: 1
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(),
          ),
        ),
      ),
    );
  }
}

class _RightContent extends StatelessWidget {
  final String title;
  final String modeTag;
  final String congSuat;
  final String chiSoIp;
  final String khoiLuong;
  final String baoHanh;
  final String priceText;
  final int quantity;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final double Function(double v) scale;
  final bool showQuantityControl;

  const _RightContent({
    required this.title,
    required this.modeTag,
    required this.congSuat,
    required this.chiSoIp,
    required this.khoiLuong,
    required this.baoHanh,
    required this.priceText,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.scale,
    required this.showQuantityControl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale(254),
      height: scale(144),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // frame: tiêu đề + tag
          SizedBox(
            height: scale(20),
            width: scale(254),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: scale(16),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C1C1E),
                    ),
                  ),
                ),
                SizedBox(width: scale(8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: scale(12),
                    vertical: scale(3),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    modeTag,
                    style: TextStyle(
                      fontSize: scale(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // frame: 4 dòng thông tin
          SizedBox(
            height: scale(84),
            width: scale(254),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoRow(label: 'Công suất:', value: congSuat, scale: scale),
                _InfoRow(label: 'Chỉ số IP:', value: chiSoIp, scale: scale),
                _InfoRow(label: 'Khối lượng:', value: khoiLuong, scale: scale),
                _InfoRow(label: 'Bảo hành:', value: baoHanh, scale: scale),
              ],
            ),
          ),

          // frame: giá + nút tăng/giảm
          SizedBox(
            height: scale(28),
            width: scale(254),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  priceText,
                  style: TextStyle(
                    fontSize: scale(16),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF3B30),
                  ),
                ),
                if (showQuantityControl)
                  QuantityControl(
                    quantity: quantity,
                    onAdd: onIncrease,
                    onRemove: onDecrease,
                    width: scale(94),
                    height: scale(28),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double Function(double v) scale;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: scale(13),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF7D7D7D),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: scale(13),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1C1C1E),
          ),
        ),
      ],
    );
  }
}
