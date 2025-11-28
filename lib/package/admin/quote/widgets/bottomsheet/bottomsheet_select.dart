import 'package:flutter/material.dart';
import '../equipment/card_item_device.dart'; // import đúng path

void showSelectProductBottomSheet(
  BuildContext context, {
  String? type, // Hy-Brid / On-grid
  String? phase, // '1' / '3'
  String? categoryLabel, // 'Tấm quang năng' / 'Biến tần'...
}) {
  final width = MediaQuery.of(context).size.width;
  double scale(double v) => v * width / 430;

  // build list tag từ tham số truyền vào
  final tags = <String>['Tất cả'];

  if (type != null && type.isNotEmpty) {
    tags.add(type);
  }

  if (phase != null && phase.isNotEmpty) {
    final phaseLabel = phase == '1' ? 'Một pha' : 'Ba pha';
    tags.add(phaseLabel);
  }

  if (categoryLabel != null && categoryLabel.isNotEmpty) {
    tags.add(categoryLabel);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) {
          return _SelectProductSheetBody(
            scale: scale,
            scrollController: scrollController,
            tags: tags,
          );
        },
      );
    },
  );
}

class _SelectProductSheetBody extends StatefulWidget {
  final double Function(double v) scale;
  final ScrollController scrollController;
  final List<String> tags;

  const _SelectProductSheetBody({
    required this.scale,
    required this.scrollController,
    required this.tags,
  });

  @override
  State<_SelectProductSheetBody> createState() =>
      _SelectProductSheetBodyState();
}

class _SelectProductSheetBodyState extends State<_SelectProductSheetBody> {
  late List<String> _tags;
  int _selectedIndex = 0;

  // Demo data – thay bằng list sản phẩm thật của bạn
  final List<Map<String, String>> _products = List.generate(10, (_) {
    return {
      'title': 'Biến tần Solis 5kW',
      'mode': 'Hy-Brid',
      'congSuat': 'Công suất: 1 pha',
      'ip': 'Chỉ số IP: IP66',
      'khoiLuong': 'Khối lượng: 24 kg',
      'baoHanh': 'Bảo hành: 05 năm',
      'price': '12.000.000đ',
    };
  });
  @override
  void initState() {
    super.initState();
    _tags = widget.tags; // <<< BẮT BUỘC PHẢI CÓ
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return Container(
      padding: EdgeInsets.fromLTRB(
        scale(16),
        scale(8),
        scale(16),
        MediaQuery.of(context).padding.bottom + scale(16),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo nhỏ trên đầu
          Center(
            child: Container(
              width: scale(56),
              height: scale(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          SizedBox(height: scale(16)),

          // Title
          Text(
            'Chọn sản phẩm',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: scale(18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),
          SizedBox(height: scale(16)),

          // Tag filter row
          SizedBox(
            height: scale(32),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              separatorBuilder: (_, __) => SizedBox(width: scale(8)),
              itemBuilder: (context, index) {
                final bool isActive = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    // TODO: lọc list theo tag nếu cần
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale(16),
                      vertical: scale(6),
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(
                              0xFFFFE5E5,
                            ) // giống tab “Tất cả” đỏ nhạt
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _tags[index],
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: scale(14),
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive
                            ? const Color(0xFFE63B3B)
                            : const Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: scale(16)),

          // List sản phẩm
          // Expanded(
          //   child: ListView.separated(
          //     controller: widget.scrollController,
          //     itemCount: _products.length,
          //     separatorBuilder: (_, __) => SizedBox(height: scale(16)),
          //     itemBuilder: (context, index) {
          //       final p = _products[index];
          //       return SolarMaxCartCard(
          //         image:
          //             (p['image'] != null &&
          //                 p['image'].toString().isNotEmpty &&
          //                 p['image'].toString().startsWith('http'))
          //             ? NetworkImage(p['image']!)
          //             : const AssetImage('assets/images/product.png'),

          //         title: p['title'] ?? '',
          //         modeTag: p['mode'] ?? '',
          //         congSuat: p['congSuat'] ?? '',
          //         chiSoIp: p['ip'] ?? '',
          //         khoiLuong: p['khoiLuong'] ?? '',
          //         baoHanh: p['baoHanh'] ?? '',
          //         priceText: p['price'] ?? '',
          //         quantity: 1,
          //         showQuantityControl: false,
          //         backgroundColor: Colors.white,
          //         onIncrease: () {},
          //         onDecrease: () {},
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
