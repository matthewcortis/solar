import 'package:flutter/material.dart';
import '../../../../model/accessories_model.dart';
import '../equipment/card_item_accessories_supplies.dart';
import '../../services/load_accessories.dart';

class AccessoriesListScreen extends StatefulWidget {
  const AccessoriesListScreen({super.key});

  @override
  State<AccessoriesListScreen> createState() => _AccessoriesListScreenState();
}

class _AccessoriesListScreenState extends State<AccessoriesListScreen> {
  final _repo = const ProductRepository();
  List<AccessoriesModel> _products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _repo.loadFromAssets('assets/data/product.json');
    setState(() => _products = items);
  }

  void _inc(int index) {
    final p = _products[index];
    setState(() => _products[index] = p.copyWith(quantity: p.quantity + 1));
  }

  void _dec(int index) {
    final p = _products[index];
    if (p.quantity == 0) return;
    setState(() => _products[index] = p.copyWith(quantity: p.quantity - 1));
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      shrinkWrap: true,        
      physics: const NeverScrollableScrollPhysics(), // tắt cuộn riêng
      padding: const EdgeInsets.all(16),

      itemCount: _products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final p = _products[i];
        return ProductCard(
          title: p.title,
          phaseText: p.phase,
          accessoryText: p.accessory,
          imageProvider: AssetImage(p.image),
          quantity: p.quantity,
          onAdd: () => _inc(i),
          onRemove: () => _dec(i),
        );
      },
    );
  }
}
