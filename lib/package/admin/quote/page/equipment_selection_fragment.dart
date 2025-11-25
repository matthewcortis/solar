import 'package:flutter/material.dart';
import '../widgets/equipment/equipment_selection.dart';
import '../widgets/equipment/equipment_list.dart';
import '../../../combo/model/tron_goi_model.dart';
class DanhMucScreen extends StatefulWidget {
  final String? selectedType;
  final String? selectedPhase;
  final TronGoiModel tronGoi;
  final int comboId;

  const DanhMucScreen({
    super.key,
    this.selectedType,
    this.selectedPhase,
    required this.tronGoi,
    required this.comboId,
  });

  @override
  State<DanhMucScreen> createState() => _DanhMucScreenState();
}

class _DanhMucScreenState extends State<DanhMucScreen> {
  @override
  void initState() {
    super.initState();
    print("Combo ID step 3 = ${widget.comboId}");
    print("TronGoi ID step 3 = ${widget.tronGoi.id}");
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
              
            ),

            AccessoriesListScreen(
      
            ),
          ],
        ),
      ),
    );
  }
}
