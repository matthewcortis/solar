import 'package:flutter/material.dart';
import '../../../../model/tron_goi_models.dart';
import '../equipment/card_item_accessories_supplies.dart';

class ClassVatTuPhu extends StatefulWidget {
  const ClassVatTuPhu({
    super.key,
    required this.materials,
  });

  /// Danh sách vật tư phụ đã lọc sẵn từ bên ngoài
  final List<VatTuTronGoiDto> materials;

  @override
  State<ClassVatTuPhu> createState() => _ClassVatTuPhuState();
}

class _ClassVatTuPhuState extends State<ClassVatTuPhu> {
  /// Lưu số lượng hiển thị trên UI, tách khỏi model gốc
  late List<int> _quantities;

  @override
  void initState() {
    super.initState();
    // Khởi tạo quantity từ soLuong ban đầu của từng vật tư
    _quantities = widget.materials
        .map((m) => m.soLuong.toInt())
        .toList(growable: false);
  }

  void _inc(int index) {
    setState(() {
      _quantities[index] = _quantities[index] + 1;
    });
  }

  void _dec(int index) {
    if (_quantities[index] == 0) return;
    setState(() {
      _quantities[index] = _quantities[index] - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.materials.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Không có vật tư phụ',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF828282),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phụ kiện và vật tư đi kèm',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF4F4F4F),
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.materials.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final item = widget.materials[i];
              final vt = item.vatTu;
              final quantity = _quantities[i];

              return ProductCard(
                title: vt.ten,                        // tên vật tư
                phaseText: vt.donVi,                  // ví dụ: đơn vị tính
                accessoryText: vt.nhomVatTu.ten,      // tên nhóm vật tư
                imageProvider: const AssetImage(      // tạm dùng ảnh default
                  'assets/images/product.png',
                ),
                quantity: quantity,
                onAdd: () => _inc(i),
                onRemove: () => _dec(i),
              );
            },
          ),
        ],
      ),
    );
  }
}
