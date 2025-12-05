import 'package:flutter/material.dart';
import '../widgets/equipment/equipment_selection.dart';
import '../widgets/equipment/equipment_list.dart';
import '../../../model/tron_goi_models.dart';
import '../../../model/bao_gia_draft.dart';

class DanhMucScreen extends StatefulWidget {
  final String? selectedType;
  final String? selectedPhase;
  final TronGoiDto tronGoi;
  final int comboId;
  final ValueChanged<num>? onTotalChanged;
  final ValueChanged<BaoGiaDraft>? onDraftChanged;

  const DanhMucScreen({
    super.key,
    this.selectedType,
    this.selectedPhase,
    required this.tronGoi,
    required this.comboId,
    this.onTotalChanged,
    this.onDraftChanged,
  });

  @override
  State<DanhMucScreen> createState() => _DanhMucScreenState();
}

class _DanhMucScreenState extends State<DanhMucScreen> {
  late final List<VatTuTronGoiDto> _otherMaterials;

  num _mainTotal = 0;
  num _otherDelta = 0;
  List<VatTuTronGoiDto> _currentMainDevices = [];
  List<VatTuTronGoiDto> _currentOtherMaterials = [];
  num _giaBanKhungSat = 0;
  num _giaNhanCongKhungSat = 0;

  @override
  void initState() {
    super.initState();

    print("TronGoi ID step 3 = ${widget.tronGoi.id}");

    final allItems = widget.tronGoi.vatTuTronGois;

    const order = <String, int>{
      'PIN_LUU_TRU': 0,
      'HE_KHUNG_NHOM': 1,
      'HE_DAY_DIEN': 2,
      'TU_DIEN': 3,
      'HE_TIEP_DIA': 4,
      'TRON_GOI_LAP_DAT': 5,
    };

    _otherMaterials = allItems.where((e) {
      final ma = e.vatTu.nhomVatTu.ma;
      final isGroup = order.containsKey(ma);
      final bool isMain = e.vatTu.nhomVatTu.vatTuChinh;

      return isGroup && !isMain;
    }).toList();

    _otherMaterials.sort((a, b) {
      final orderA = a.vatTu.nhomVatTu.ma;
      final orderB = b.vatTu.nhomVatTu.ma;

      final idxA = order[orderA] ?? 999;
      final idxB = order[orderB] ?? 999;
      return idxA.compareTo(idxB);
    });
  }

  void _rebuildDraft() {
    final num baseMain = _mainTotal == 0 ? widget.tronGoi.tongGia : _mainTotal;
    final num total = baseMain + _otherDelta;

    widget.onTotalChanged?.call(total);

    if (widget.onDraftChanged != null) {
      final draft = BaoGiaDraft(
        tronGoi: widget.tronGoi,
        mainDevices: _currentMainDevices,
        extraMaterials: _currentOtherMaterials,
        giaBanKhungSat: _giaBanKhungSat,
        giaNhanCongKhungSat: _giaNhanCongKhungSat,
        tongTien: total,
      );
      widget.onDraftChanged!(draft);
    }
  }

  // void _notifyParentTotal() {
  //   // Nếu _mainTotal chưa được set, dùng tronGoi.tongGia làm base
  //   final num baseMain = _mainTotal == 0 ? widget.tronGoi.tongGia : _mainTotal;

  //   final num total = baseMain + _otherDelta;
  //   widget.onTotalChanged?.call(total);
  // }

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
              onTotalChanged: (value) {
                setState(() => _mainTotal = value);
                _rebuildDraft();
              },
              onMainDevicesChanged: (devices) {
                setState(() => _currentMainDevices = devices);
                _rebuildDraft();
              },
              onGiaBanKhungSatChanged: (v) {
                setState(() => _giaBanKhungSat = v);
                _rebuildDraft();
              },
              onGiaNhanCongKhungSatChanged: (v) {
                setState(() => _giaNhanCongKhungSat = v);
                _rebuildDraft();
              },
            ),

            ClassVatTuPhu(
              materials: _otherMaterials,
              onDeltaChange: (delta) {
                setState(() => _otherDelta = delta);
                _rebuildDraft();
              },
              onMaterialsChanged: (materials) {
                setState(() => _currentOtherMaterials = materials);
                _rebuildDraft();
              },
            ),

        
          ],
        ),
      ),
    );
  }
}
