import 'package:flutter/material.dart';
import '../../model/tron_goi.dart'; 

class OtherMaterialsSection extends StatelessWidget {
  final List<VatTuTronGoi> materials;

  const OtherMaterialsSection({super.key, required this.materials});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;


    String formatQuantity(num? q) {
      if (q == null) return '-';
      if (q % 1 == 0) return q.toInt().toString();
      return q.toString();
    }

    String formatWarranty(VatTuTronGoi item) {
      if (item.duocBaoHanh != true) {
        return 'Không bảo hành';
      }

      final gm = item.gm?.toInt();
      if (gm == null) {
        return 'Có bảo hành';
      }
      final years = gm ~/ 12;
      final months = gm % 12;

      if (years > 0 && months > 0) {
        return '$years năm $months tháng';
      } else if (years > 0) {
        return '$years năm';
      } else {
        return '$months tháng';
      }
    }

    return Container(
      width: scale(430),
      padding: EdgeInsets.all(scale(16)),
      decoration: BoxDecoration(
        color: Colors.white,
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header: "Vật tư khác" + "{n} vật tư" ---
          Row(
            children: [
              Text(
                'Vật tư khác',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(16),
                  height: 24 / 16,
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
                    '${materials.length} vật tư',
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

          SizedBox(height: scale(3)),

          // --- Header table ---
          Padding(
            padding: EdgeInsets.only(bottom: scale(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    'Tên thiết bị',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: scale(14),
                      height: 20 / 14,
                      color: const Color(0xFF848484),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Bảo hành',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: scale(14),
                      height: 20 / 14,
                      color: const Color(0xFF848484),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Số lượng',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: scale(14),
                      height: 20 / 14,
                      color: const Color(0xFF848484),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Danh sách vật tư ---
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: materials.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
            itemBuilder: (context, index) {
              final item = materials[index];
              final vatTu = item.vatTu;

              final name = vatTu.ten;
              final warranty = formatWarranty(item);
              final quantity = formatQuantity(item.soLuong);

              return Padding(
                padding: EdgeInsets.symmetric(vertical: scale(8)),
                child: Row(
                  children: [
                    // Tên thiết bị
                    Expanded(
                      flex: 6,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w400,
                          fontSize: scale(14),
                          height: 20 / 14,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    // Bảo hành
                    Expanded(
                      flex: 2,
                      child: Text(
                        warranty,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w500,
                          fontSize: scale(14),
                          height: 20 / 14,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    // Số lượng
                    Expanded(
                      flex: 2,
                      child: Text(
                        quantity,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w500,
                          fontSize: scale(14),
                          height: 20 / 14,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
