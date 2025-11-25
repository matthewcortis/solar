// lib/model/bai_viet_model.dart
class TepTinModel {
  final int id;
  final String tenTepGoc;
  final String tenTaiLen;
  final String tenLuuTru;
  final String duongDan;
  final String loaiTepTin;
  final String duoiTep;
  final String taoLuc;
  final int trangThai;

  TepTinModel({
    required this.id,
    required this.tenTepGoc,
    required this.tenTaiLen,
    required this.tenLuuTru,
    required this.duongDan,
    required this.loaiTepTin,
    required this.duoiTep,
    required this.taoLuc,
    required this.trangThai,
  });

  factory TepTinModel.fromJson(Map<String, dynamic> json) {
    return TepTinModel(
      id: json['id'] as int,
      tenTepGoc: json['tenTepGoc'] ?? '',
      tenTaiLen: json['tenTaiLen'] ?? '',
      tenLuuTru: json['tenLuuTru'] ?? '',
      duongDan: json['duongDan'] ?? '',
      loaiTepTin: json['loaiTepTin'] ?? '',
      duoiTep: json['duoiTep'] ?? '',
      taoLuc: json['taoLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTepGoc': tenTepGoc,
      'tenTaiLen': tenTaiLen,
      'tenLuuTru': tenLuuTru,
      'duongDan': duongDan,
      'loaiTepTin': loaiTepTin,
      'duoiTep': duoiTep,
      'taoLuc': taoLuc,
      'trangThai': trangThai,
    };
  }
}

class BaiVietModel {
  final int id;
  final String loaiBaiViet;
  final String tieuDe;
  final TepTinModel? anhBia;
  final TepTinModel? noiDung;
  final String? lienQuan;
  final bool hoatDong;
  final String taoLuc;
  final int trangThai;

  BaiVietModel({
    required this.id,
    required this.loaiBaiViet,
    required this.tieuDe,
    this.anhBia,
    this.noiDung,
    this.lienQuan,
    required this.hoatDong,
    required this.taoLuc,
    required this.trangThai,
  });

  factory BaiVietModel.fromJson(Map<String, dynamic> json) {
    return BaiVietModel(
      id: json['id'] as int,
      loaiBaiViet: json['loaiBaiViet'] ?? '',
      tieuDe: json['tieuDe'] ?? '',
      anhBia: json['anhBia'] != null
          ? TepTinModel.fromJson(json['anhBia'])
          : null,
      noiDung: json['noiDung'] != null
          ? TepTinModel.fromJson(json['noiDung'])
          : null,
      lienQuan: json['lienQuan'],
      hoatDong: json['hoatDong'] ?? false,
      taoLuc: json['taoLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loaiBaiViet': loaiBaiViet,
      'tieuDe': tieuDe,
      'anhBia': anhBia?.toJson(),
      'noiDung': noiDung?.toJson(),
      'lienQuan': lienQuan,
      'hoatDong': hoatDong,
      'taoLuc': taoLuc,
      'trangThai': trangThai,
    };
  }

  // Getter tiện dùng
  String? get imageUrl => anhBia?.duongDan;
}
