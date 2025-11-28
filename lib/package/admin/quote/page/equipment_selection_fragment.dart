import 'package:flutter/material.dart';
import '../widgets/equipment/equipment_selection.dart';
import '../widgets/equipment/equipment_list.dart';
import '../../../model/tron_goi_models.dart';

class DanhMucScreen extends StatefulWidget {
  final String? selectedType;
  final String? selectedPhase;
  final TronGoiDto tronGoi;
  final int comboId;
  final ValueChanged<num>? onTotalChanged;

  const DanhMucScreen({
    super.key,
    this.selectedType,
    this.selectedPhase,
    required this.tronGoi,
    required this.comboId,
     this.onTotalChanged,
  });

  @override
  State<DanhMucScreen> createState() => _DanhMucScreenState();
}

class _DanhMucScreenState extends State<DanhMucScreen> {
  late final List<VatTuTronGoiDto> _otherMaterials;

  @override
  void initState() {
    super.initState();

    print("TronGoi ID step 3 = ${widget.tronGoi.id}");

    final allItems = widget.tronGoi.vatTuTronGois;

    // Vật tư phụ: vatTuChinh = false, và được phép xem (duocXem == null hoặc true)
    _otherMaterials = allItems
        .where(
          (e) =>
              e.vatTu.nhomVatTu.vatTuChinh == false &&
              (e.duocXem ?? true),
        )
        .toList();

    print('Other materials (phụ) = ${_otherMaterials.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F8F8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DanhMucThietBiVaVatTu(
              selectedType: widget.selectedType,
              selectedPhase: widget.selectedPhase,
              tronGoi: widget.tronGoi,
              onTotalChanged: widget.onTotalChanged,
            ),

            // Vật tư phụ
            ClassVatTuPhu(
              materials: _otherMaterials,
            ),
          ],
        ),
      ),
    );
  }
}
