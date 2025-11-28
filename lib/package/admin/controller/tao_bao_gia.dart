import '../../model/tron_goi_models.dart';

/// Gom các vật tư chính thành 3 nhóm tấm pin / biến tần / pin lưu trữ
class MainDeviceGroups {
  final List<VatTuTronGoiDto> panels;
  final List<VatTuTronGoiDto> inverters;
  final List<VatTuTronGoiDto> batteries;

  MainDeviceGroups({
    required this.panels,
    required this.inverters,
    required this.batteries,
  });
}

/// Hàm logic: nhận TronGoiDto -> trả về 3 list đã lọc
MainDeviceGroups buildMainDeviceGroups(TronGoiDto tronGoi) {
  final all = tronGoi.vatTuTronGois;

  // Log kiểm tra dữ liệu thô
  print('Total vatTuTronGois = ${all.length}');
  for (final vt in all) {
    print(
      ' - id=${vt.id}, nhom=${vt.vatTu.nhomVatTu.ma}, '
      'vatTuChinh=${vt.vatTu.nhomVatTu.vatTuChinh}, duocXem=${vt.duocXem}',
    );
  }

  // 1) Lọc vật tư chính + được xem
  final deviceProducts = all.where(
    (e) =>
        e.vatTu.nhomVatTu.vatTuChinh == true &&
        (e.duocXem ?? true),
  );

  // 2) Lọc theo nhóm
  final panels = deviceProducts
      .where((item) => item.vatTu.nhomVatTu.ma == 'TAM_PIN')
      .toList();

  final inverters = deviceProducts
      .where((item) => item.vatTu.nhomVatTu.ma == 'BIEN_TAN')
      .toList();

  final batteries = deviceProducts
      .where((item) => item.vatTu.nhomVatTu.ma == 'PIN_LUU_TRU')
      .toList();

  print("Panels = ${panels.length}");
  print("Inverters = ${inverters.length}");
  print("Batteries = ${batteries.length}");

  return MainDeviceGroups(
    panels: panels,
    inverters: inverters,
    batteries: batteries,
  );
}

/// Extension đọc duLieuRieng
extension VatTuDuLieuRiengX on VatTuDto {
  /// key: 'cong_suat', 'ip', 'khoi_luong', 'dung_luong', ...
  String fieldValue(String key) {
    final tt = duLieuRieng[key];
    if (tt == null) return '';
    return tt.giaTri?.toString() ?? '';
  }
}

/// Build danh sách tag "đã chọn" từ type + phase
List<String> buildSelectedTags(String? selectedType, String? selectedPhase) {
  final tags = <String>[];

  if (selectedType != null && selectedType.isNotEmpty) {
    tags.add(selectedType);
  }

  if (selectedPhase != null && selectedPhase.isNotEmpty) {
    final phaseLabel = selectedPhase == '1' ? 'Một pha' : 'Ba pha';
    tags.add(phaseLabel);
  }

  return tags;
}
