import 'package:flutter/material.dart';
import '../../model/tron_goi_models.dart';
import '../../model/extension.dart';

/// Row dữ liệu hiển thị trong bảng (Tên – Bảo hành – Số lượng)
class _RowItem {
  final String name;
  final String warranty;
  final String quantityText;

  _RowItem({
    required this.name,
    required this.warranty,
    required this.quantityText,
  });
} 

class OtherMaterialsSection extends StatelessWidget {
  final List<VatTuGroupResult> groups;
  final List<VatTuTronGoiDto> mainDevices;

  const OtherMaterialsSection({
    super.key,
    required this.groups,
    required this.mainDevices,
  });

  // Ưu tiên sort cho thiết bị chính theo mã nhóm vật tư
  int _priorityForMainDevice(VatTuTronGoiDto item) {
    final String ma = item.vatTu.nhomVatTu.ma;
    switch (ma) {
      case 'TAM_PIN':
        return 0;
      case 'BIEN_TAN':
      case 'BEN_TAN':
        return 1;
      case 'PIN_LUU_TRU':
        return 2;
      default:
        return 10; // Các nhóm khác sau cùng
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    String formatQuantity(num? q) {
      if (q == null) return '-';
      if (q % 1 == 0) return q.toInt().toString();
      return q.toString();
    }

    // ===== 1) Chuẩn bị danh sách dòng hiển thị (tên – bảo hành – số lượng) =====

    final List<_RowItem> rows = [];

    // ---- 1.a. Thêm THIẾT BỊ CHÍNH lên đầu, đã sort theo ưu tiên ----
    final List<VatTuTronGoiDto> sortedMain = [...mainDevices]
      ..sort((a, b) {
        final pa = _priorityForMainDevice(a);
        final pb = _priorityForMainDevice(b);
        if (pa != pb) return pa - pb;
        // Nếu cùng priority thì sort theo tên thiết bị
        return (a.vatTu.ten).compareTo(b.vatTu.ten);
      });

    for (final item in sortedMain) {
      final String name = item.vatTu.ten;

      String warranty;
      if (item.thoiGianBaoHanh > 0) {
        warranty = TronGoiUtils.convertMonthToYearAndMonth(
          item.thoiGianBaoHanh,
        );
      } else {
        warranty = 'Không bảo hành';
      }

      final String quantityText = formatQuantity(item.soLuong);

      rows.add(
        _RowItem(
          name: name,
          warranty: warranty,
          quantityText: quantityText,
        ),
      );
    }

    // ---- 1.b. Thêm các NHÓM VẬT TƯ PHỤ, quantity = tổng số lượng ----
    for (final group in groups) {
      if (group.items.isEmpty) continue;

      final VatTuTronGoiDto firstItem = group.items.first;

      final String name = group.title;
      final String warranty = (firstItem.thoiGianBaoHanh > 0)
          ? TronGoiUtils.convertMonthToYearAndMonth(firstItem.thoiGianBaoHanh)
          : group.warrantyText.isNotEmpty
              ? group.warrantyText
              : 'Không bảo hành';

      // Tổng số lượng trong group
      // final num totalQty = group.items.fold<num>(
      //   0,
      //   (sum, e) => sum + e.soLuong,
      // );
      //final String quantityText = formatQuantity(totalQty);

      rows.add(
        _RowItem(
          name: name,
          warranty: warranty,
          quantityText: "1",
        ),
      );
    }

    // Tổng dòng để hiển thị trong chip header
    final int totalRows = rows.length;
    final String quantity = totalRows.toString();

    // ===== 2) UI =====
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
          // --- Header: "Danh mục vật tư lắp đặt" + "{n} mục" ---
          Row(
            children: [
              Text(
                'Danh mục vật tư lắp đặt',
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
                    '$quantity mục', // tổng số dòng
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

          // --- Danh sách dòng (thiết bị chính + nhóm vật tư) ---
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
            itemBuilder: (context, index) {
              final row = rows[index];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: scale(8)),
                child: Row(
                  children: [
                    // Tên thiết bị
                    Expanded(
                      flex: 6,
                      child: Text(
                        row.name,
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
                        row.warranty,
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
                        row.quantityText,
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
