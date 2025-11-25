import '../model/khach_hang.dart';

class CoSo {
  final int? id;
  final String? ma;
  final String? ten;
  final String? dcVanPhong;
  final String? dcKho;
  final String? taoLuc;
  final int? trangThai;

  CoSo({
    this.id,
    this.ma,
    this.ten,
    this.dcVanPhong,
    this.dcKho,
    this.taoLuc,
    this.trangThai,
  });

  factory CoSo.fromJson(Map<String, dynamic> json) {
    return CoSo(
      id: json['id'],
      ma: json['ma'],
      ten: json['ten'],
      dcVanPhong: json['dcVanPhong'],
      dcKho: json['dcKho'],
      taoLuc: json['taoLuc'],
      trangThai: json['trangThai'],
    );
  }
}

class NganhHang {
  final int? id;
  final String? ma;
  final String? ten;
  final String? sdtSale;
  final String? sdtTech;
  final int? trangThai;

  NganhHang({
    this.id,
    this.ma,
    this.ten,
    this.sdtSale,
    this.sdtTech,
    this.trangThai,
  });

  factory NganhHang.fromJson(Map<String, dynamic> json) {
    return NganhHang(
      id: json['id'],
      ma: json['ma'],
      ten: json['ten'],
      sdtSale: json['sdtSale'],
      sdtTech: json['sdtTech'],
      trangThai: json['trangThai'],
    );
  }
}

class NguoiGioiThieu {
  final int? id;
  final CoSo? coSo;
  final String? phanQuyen;
  final String? email;
  final String? sdt;
  final String? hoVaTen;
  final bool? gioiTinh;
  final String? sinhNhat;
  final double? phanTramHoaHong;
  final double? tongHoaHong;
  final String? diaChi;
  final String? nganHang;
  final String? maNganHang;
  final String? taoLuc;
  final int? trangThai;
  final List<KhachHang> khachHangs;

  NguoiGioiThieu({
    this.id,
    this.coSo,
    this.phanQuyen,
    this.email,
    this.sdt,
    this.hoVaTen,
    this.gioiTinh,
    this.sinhNhat,
    this.phanTramHoaHong,
    this.tongHoaHong,
    this.diaChi,
    this.nganHang,
    this.maNganHang,
    this.taoLuc,
    this.trangThai,
    this.khachHangs = const [],
  });

  factory NguoiGioiThieu.fromJson(Map<String, dynamic> json) {
    return NguoiGioiThieu(
      id: json['id'],
      coSo: json['coSo'] != null ? CoSo.fromJson(json['coSo']) : null,
      phanQuyen: json['phanQuyen'],
      email: json['email'],
      sdt: json['sdt'],
      hoVaTen: json['hoVaTen'],
      gioiTinh: json['gioiTinh'],
      sinhNhat: json['sinhNhat'],
      phanTramHoaHong:
          json['phanTramHoaHong'] != null ? (json['phanTramHoaHong'] as num).toDouble() : null,
      tongHoaHong:
          json['tongHoaHong'] != null ? (json['tongHoaHong'] as num).toDouble() : null,
      diaChi: json['diaChi'],
      nganHang: json['nganHang'],
      maNganHang: json['maNganHang'],
      taoLuc: json['taoLuc'],
      trangThai: json['trangThai'],
      khachHangs: (json['khachHangs'] as List<dynamic>? ?? [])
          .map((e) => KhachHang.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HopDongModel {
  final int? id;
  final CoSo? coSo;
  final NganhHang? nganhHang;
  final String? ten;
  final String? loaiHeThong;
  final String? loaiPha;
  final double? sanLuongToiThieu;
  final double? sanLuongToiDa;
  final double? giaKhungSat;
  final String? moTa;
  final NguoiGioiThieu? nguoiGioiThieu;
  final KhachHang? khachHang;
  final double? tongGia;
  final String? taoLuc;
  final int? trangThai;

  HopDongModel({
    this.id,
    this.coSo,
    this.nganhHang,
    this.ten,
    this.loaiHeThong,
    this.loaiPha,
    this.sanLuongToiThieu,
    this.sanLuongToiDa,
    this.giaKhungSat,
    this.moTa,
    this.nguoiGioiThieu,
    this.khachHang,
    this.tongGia,
    this.taoLuc,
    this.trangThai,
  });

  factory HopDongModel.fromJson(Map<String, dynamic> json) {
    return HopDongModel(
      id: json['id'],
      coSo: json['coSo'] != null ? CoSo.fromJson(json['coSo']) : null,
      nganhHang:
          json['nghanhHang'] != null ? NganhHang.fromJson(json['nghanhHang']) : null,
      ten: json['ten'],
      loaiHeThong: json['loaiHeThong'],
      loaiPha: json['loaiPha'],
      sanLuongToiThieu: json['sanLuongToiThieu'] != null
          ? (json['sanLuongToiThieu'] as num).toDouble()
          : null,
      sanLuongToiDa: json['sanLuongToiDa'] != null
          ? (json['sanLuongToiDa'] as num).toDouble()
          : null,
      giaKhungSat:
          json['giaKhungSat'] != null ? (json['giaKhungSat'] as num).toDouble() : null,
      moTa: json['moTa'],
      nguoiGioiThieu: json['nguoiGioiThieu'] != null
          ? NguoiGioiThieu.fromJson(json['nguoiGioiThieu'])
          : null,
      khachHang: json['khachHang'] != null
          ? KhachHang.fromJson(json['khachHang'])
          : null,
      tongGia:
          json['tongGia'] != null ? (json['tongGia'] as num).toDouble() : null,
      taoLuc: json['taoLuc'],
      trangThai: json['trangThai'],
    );
  }
}
