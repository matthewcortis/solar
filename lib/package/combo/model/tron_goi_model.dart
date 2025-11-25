import '../../model/tron_goi_base.dart';
import '../../model/tron_goi.dart';

class TronGoiModel implements TronGoiInfo {
  @override
  final int id;

  @override
  final String ten;

  @override
  final String loaiHeThong;

  @override
  final double congSuatHeThong;

  @override
  final double tongGia;

  @override
  final String? duongDan;
  final List<VatTuTronGoi> vatTuTronGois;
  TronGoiModel({
    required this.id,
    required this.ten,
    required this.loaiHeThong,
    required this.congSuatHeThong,
    required this.tongGia,
    this.duongDan,
    required this.vatTuTronGois,
  });

  factory TronGoiModel.fromJson(Map<String, dynamic> json) {
    final tepTin = json['tepTin']; // có thể null

    return TronGoiModel(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      loaiHeThong: json['loaiHeThong'] ?? '',
      congSuatHeThong: (json['congSuatHeThong'] ?? 0).toDouble(),
      tongGia: (json['tongGia'] ?? 0).toDouble(),
      duongDan: tepTin != null ? tepTin['duongDan'] as String? : null,
      vatTuTronGois: (json['vatTuTronGois'] as List<dynamic>)
          .map((e) => VatTuTronGoi.fromJson(e))
          .toList(),
    );
  }
  List<VatTuTronGoi> get panels => vatTuTronGois.where((e) {
        final nhom = e.vatTu.nhomVatTu;
        return (e.duocXem ?? true) && nhom?.ma == 'TAM_PIN';
      }).toList();

  /// BIẾN TẦN (BIEN_TAN)
  List<VatTuTronGoi> get inverters => vatTuTronGois.where((e) {
        final nhom = e.vatTu.nhomVatTu;
        return (e.duocXem ?? true) && nhom?.ma == 'BIEN_TAN';
      }).toList();

  /// PIN LƯU TRỮ (PIN_LUU_TRU)
  List<VatTuTronGoi> get batteries => vatTuTronGois.where((e) {
        final nhom = e.vatTu.nhomVatTu;
        return (e.duocXem ?? true) && nhom?.ma == 'PIN_LUU_TRU';
      }).toList();

}
