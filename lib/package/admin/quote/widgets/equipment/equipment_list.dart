import 'package:flutter/material.dart';
import '../../../../model/tron_goi_models.dart';
import '../equipment/card_item_accessories_supplies.dart';
import '../../../../model/extension.dart';

class ClassVatTuPhu extends StatefulWidget {
  const ClassVatTuPhu({super.key, required this.materials, this.onDeltaChange});

  final List<VatTuTronGoiDto> materials;

  final ValueChanged<num>? onDeltaChange;

  @override
  State<ClassVatTuPhu> createState() => _ClassVatTuPhuState();
}

class _ClassVatTuPhuState extends State<ClassVatTuPhu> {
  late List<int> _quantities;
  late num _initialTotal;

  @override
  void initState() {
    super.initState();

    _quantities = widget.materials
        .map((m) => m.soLuong.toInt())
        .toList(growable: false);

    _initialTotal = 0;
    for (final item in widget.materials) {
      _initialTotal += item.gia * item.soLuong;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDeltaChange?.call(0);
    });
  }

  num _currentTotal() {
    num total = 0;
    for (int i = 0; i < widget.materials.length; i++) {
      final item = widget.materials[i];
      total += item.gia * _quantities[i];
    }
    return total;
  }

  void _notifyDelta() {
    final current = _currentTotal();
    final delta = current - _initialTotal;
    widget.onDeltaChange?.call(delta);
  }

  void _inc(int index) {
    setState(() => _quantities[index]++);
    _notifyDelta();
  }

  void _dec(int index) {
    if (_quantities[index] == 0) return;
    setState(() => _quantities[index]--);
    _notifyDelta();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.materials.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Không có vật tư phụ',
          style: TextStyle(fontSize: 14, color: Color(0xFF828282)),
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

              final num lineTotal = item.gia * quantity;
              final String priceText = TronGoiUtils.formatMoney(lineTotal);

              final String? imageUrl = vt.mainImageUrl;
              print('Accessory imageUrl: $imageUrl');

              final ImageProvider imageProvider;
              if (imageUrl != null && imageUrl.isNotEmpty) {
                imageProvider = NetworkImage(imageUrl);
              } else {
                imageProvider = const AssetImage('assets/images/product.png');
              }

              return ProductCard(
                title: vt.ten,
                phaseText: vt.donVi,
                price: priceText,
                accessoryText: vt.nhomVatTu.ten,
                imageProvider: imageProvider,
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
