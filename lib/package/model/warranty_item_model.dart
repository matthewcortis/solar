// lib/package/device/model/warranty_item_model.dart
class WarrantyItemModel {
  final String productName;
  final String image;
  final DateTime? activeDate;
  final DateTime? endDate;
  final int duration; // tháng
  final double progress; // 0 -> 1
  final String statusText;
  final String? groupCode; // TAM_PIN / BIEN_TAN / PIN_LUU_TRU
  final String? groupName; // Tấm pin / Biến tần / ...

  WarrantyItemModel({
    required this.productName,
    required this.image,
    required this.activeDate,
    required this.endDate,
    required this.duration,
    required this.progress,
    required this.statusText,
    this.groupCode,
    this.groupName,
  });
}
