import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../product/widgets/product_card.dart';
import '../../model/tron_goi_models.dart';

/// Section Sản phẩm bán chạy (có lazy load local, giữ nguyên giao diện và tên class)
class BestSellerSection extends StatefulWidget {
  final List<TronGoiDto> combos;

  const BestSellerSection({super.key, required this.combos});

  @override
  State<BestSellerSection> createState() => _BestSellerSectionState();
}

class _BestSellerSectionState extends State<BestSellerSection> {
  final ScrollController _scrollController = ScrollController();

  // Danh sách hiển thị dần (lazy)
  final List<TronGoiDto> _visibleCombos = [];

  // Mỗi lần load thêm bao nhiêu item
  final int _itemsPerBatch = 4;

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initFirstBatch();

    _scrollController.addListener(_onScroll);
  }

  void _initFirstBatch() {
    if (widget.combos.isEmpty) return;

    final int loadCount = min(_itemsPerBatch, widget.combos.length);
    _visibleCombos.addAll(widget.combos.take(loadCount));
  }

  void _onScroll() {
    // nếu gần cuối list ngang thì load thêm
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 80 &&
        !_isLoadingMore &&
        _visibleCombos.length < widget.combos.length) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 300)); // giả lập delay nhẹ

    final int remaining = widget.combos.length - _visibleCombos.length;
    final int loadCount = min(_itemsPerBatch, remaining);
    if (loadCount > 0) {
      _visibleCombos.addAll(
        widget.combos
            .skip(_visibleCombos.length)
            .take(loadCount),
      );
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void didUpdateWidget(covariant BestSellerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu danh sách combos thay đổi (data mới từ API), reset lazy load
    if (oldWidget.combos != widget.combos) {
      _visibleCombos.clear();
      _initFirstBatch();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    if (widget.combos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(horizontal: scale(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sản phẩm bán chạy',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600, // Semibold ~590
                  fontSize: scale(18),
                  height: 28 / 18,
                  color: const Color(0xFF4F4F4F),
                ),
              )
            ],
          ),

          SizedBox(height: scale(12)),

          // --- Horizontal List (lazy load local) ---
          SizedBox(
            width: 398.w,
            height: 480.h,
            child: ListView.separated(
              controller: _scrollController,
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: _visibleCombos.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => SizedBox(width: scale(16)),
              itemBuilder: (context, index) {
                if (index < _visibleCombos.length) {
                  return ProductItemCard(combo: _visibleCombos[index]);
                }
                // item cuối khi đang load thêm: dùng shimmer card
                return const ProductItemCardShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer list dùng khi đang load combos lần đầu (FutureBuilder waiting)
class ComboShimmerList extends StatelessWidget {
  const ComboShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(horizontal: scale(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header giữ nguyên text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sản phẩm bán chạy',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(18),
                  height: 28 / 18,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
            ],
          ),
          SizedBox(height: scale(12)),
          SizedBox(
            width: 398.w,
            height: 480.h,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: 3, // số skeleton hiển thị
              separatorBuilder: (_, __) => SizedBox(width: scale(16)),
              itemBuilder: (context, index) {
                return const ProductItemCardShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
