import 'package:flutter/material.dart';
import '../../model/tron_goi_models.dart';
import '../widgets/product_card_temp.dart';
import '../../../routes.dart';

class DeviceSection extends StatelessWidget {
  final List<VatTuTronGoiDto> deviceProducts;

  const DeviceSection({super.key, required this.deviceProducts});

  // Hàm priority giống bên OtherMaterialsSection
  int _priority(VatTuTronGoiDto item) {
    final String ma = item.vatTu.nhomVatTu.ma;
    switch (ma) {
      case 'TAM_PIN':
        return 0;
      case 'BIEN_TAN':
        return 1;
      case 'PIN_LUU_TRU':
        return 2;
      default:
        return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    // ==== SORT DANH SÁCH THIẾT BỊ CHÍNH ====
    final List<VatTuTronGoiDto> sorted = [...deviceProducts]
      ..sort((a, b) {
        final pa = _priority(a);
        final pb = _priority(b);
        if (pa != pb) return pa - pb;
        return (a.vatTu.ten).compareTo(b.vatTu.ten);
      });

    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(vertical: scale(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              Text(
                'Danh mục thiết bị chính',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(18),
                  height: 28 / 18,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
              SizedBox(width: scale(12)),
              Container(
                height: scale(28),
                padding: EdgeInsets.symmetric(
                  horizontal: scale(12),
                  vertical: scale(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0x33B5B5B5),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Center(
                  child: Text(
                    '${deviceProducts.length} thiết bị',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w500,
                      fontSize: scale(14),
                      height: 20 / 14,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: scale(12)),

          SizedBox(
            width: scale(398),
            height: scale(545),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: sorted.length,
              separatorBuilder: (_, __) => SizedBox(width: scale(16)),
              itemBuilder: (context, index) {
                final item = sorted[index];
                return ProductDeviceCard(
                  item: item,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailProductDevice,
                      arguments: item.vatTu.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
