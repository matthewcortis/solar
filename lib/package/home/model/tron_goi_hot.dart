import '../../model/tron_goi_base.dart';

class TronGoiBanChayModel implements TronGoiInfo {
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

  TronGoiBanChayModel({
    required this.id,
    required this.ten,
    required this.loaiHeThong,
    required this.congSuatHeThong,
    required this.tongGia,
    this.duongDan,
  });

  factory TronGoiBanChayModel.fromJson(Map<String, dynamic> json) {
    final tepTin = json['tepTin'];

    return TronGoiBanChayModel(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      loaiHeThong: json['loaiHeThong'] ?? '',
      congSuatHeThong: (json['congSuatHeThong'] ?? 0).toDouble(),
      tongGia: (json['tongGia'] ?? 0).toDouble(),
      duongDan: tepTin != null ? tepTin['duongDan'] as String? : null,
    );
  }
}
