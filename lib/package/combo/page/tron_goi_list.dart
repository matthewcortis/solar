import 'package:flutter/material.dart';
import '../../model/tron_goi_models.dart';
import '../repository/tron_goi_repo.dart';
import '../../product/widgets/product_card_combo.dart';

class ProductListScreen extends StatefulWidget {
  final int nhomTronGoiId; // ID nhóm trọn gói truyền từ màn trước
  final String? comboName;
  final VoidCallback? onBack;
  const ProductListScreen({
    super.key,
    required this.nhomTronGoiId,
    this.comboName,
    this.onBack,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isHybridSelected = true;

  final _repo = TronGoiRepository();
  late Future<List<TronGoiDto>> _futureHybrid;
  late Future<List<TronGoiDto>> _futureOnGrid;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureHybrid = _repo.fetchTronGoi(
      nhomTronGoiId: widget.nhomTronGoiId,
      loaiHeThong: "Hy-Brid",
    );

    _futureOnGrid = _repo.fetchTronGoi(
      nhomTronGoiId: widget.nhomTronGoiId,
      loaiHeThong: "On-Grid",
    );
  }

  @override
  Widget build(BuildContext context) {
    final future = isHybridSelected ? _futureHybrid : _futureOnGrid;

    return SafeArea(
      child: Column(
        children: [
          // --- Header ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack ?? () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),

                const SizedBox(width: 16),
                Text(
                  widget.comboName ?? 'Danh sách trọn gói',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),

          // --- Tabs ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildTabButton('Hy-Brid', true),
                  _buildTabButton('On-Grid', false),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Product List ---
          Expanded(
            child: FutureBuilder<List<TronGoiDto>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi tải danh sách trọn gói',
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  );
                }

                final list = snapshot.data ?? [];
                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có trọn gói nào',
                      style: TextStyle(fontSize: 14, color: Color(0xFF828282)),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cột
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio:
                        202 / 395, // tỉ lệ giống BrandCard/ComboCard
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final tronGoi =
                        list[index]; // <- kiểu TronGoiModel, nhưng đã implements TronGoiBase
                    return ProductItemCard(combo: tronGoi);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isHybrid) {
    final selected = isHybrid ? isHybridSelected : !isHybridSelected;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isHybridSelected = isHybrid),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00D26A) : Colors.transparent,
            borderRadius: BorderRadius.circular(23),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF666666),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
