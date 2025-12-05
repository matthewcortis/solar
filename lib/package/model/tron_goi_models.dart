import 'dart:convert';

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

/// ---- COMMON WRAPPERS ----

class ResponseData<T> {
  final int status;
  final T data;
  final String message;
  final String timestamp;
  final dynamic error;

  ResponseData({
    required this.status,
    required this.data,
    required this.message,
    required this.timestamp,
    this.error,
  });

  factory ResponseData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromData,
  ) {
    return ResponseData<T>(
      status: json['status'] ?? 0,
      data: fromData(json['data']),
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      error: json['error'],
    );
  }
}

class PageResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;

  PageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? itemJson) fromItem,
  ) {
    final list = (json['content'] as List<dynamic>? ?? []);
    return PageResponse<T>(
      content: list.map((e) => fromItem(e)).toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: json['size'] ?? 0,
      number: json['number'] ?? 0,
    );
  }
}

/// ---- FILTER STRUCT ----

class FilterCriteria {
  final String fieldName;
  final String operation; // 'EQUALS', 'LIKE', 'IN', ...
  final dynamic value;
  final String? logicType; // 'AND' | 'OR'

  FilterCriteria({
    required this.fieldName,
    required this.operation,
    required this.value,
    this.logicType,
  });

  Map<String, dynamic> toJson() => {
    'fieldName': fieldName,
    'operation': operation,
    'value': value,
    if (logicType != null) 'logicType': logicType,
  };
}

class SortCriteria {
  final String fieldName;
  final String direction; // 'ASC' | 'DESC'

  SortCriteria({required this.fieldName, required this.direction});

  Map<String, dynamic> toJson() => {
    'fieldName': fieldName,
    'direction': direction,
  };
}

class BaseFilterRequest {
  final List<FilterCriteria> filters;
  final List<SortCriteria> sorts;
  final int page;
  final int size;

  BaseFilterRequest({
    required this.filters,
    required this.sorts,
    required this.page,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
    'filters': filters.map((f) => f.toJson()).toList(),
    'sorts': sorts.map((s) => s.toJson()).toList(),
    'page': page,
    'size': size,
  };
}

/// ---- THUỘC TÍNH RIÊNG ----

class ThuocTinh {
  final String ten;
  final String donVi;
  final dynamic giaTri;

  ThuocTinh({required this.ten, required this.donVi, required this.giaTri});

  factory ThuocTinh.fromJson(Map<String, dynamic> json) {
    return ThuocTinh(
      ten: json['ten'] ?? '',
      donVi: json['donVi'] ?? '',
      giaTri: json['giaTri'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ten': ten,
    'donVi': donVi,
    'giaTri': giaTri,
  };
}

/// ---- GIÁ / THÔNG TIN GIÁ ----

class GiaInfo {
  final String maCoSo;
  final String tenCoSo;
  final double? giaNhap;
  final double? giaBan;
  final String? giaNhapRaw;
  final String? giaBanRaw;

  GiaInfo({
    required this.maCoSo,
    required this.tenCoSo,
    this.giaNhap,
    this.giaBan,
    this.giaNhapRaw,
    this.giaBanRaw,
  });

  factory GiaInfo.fromJson(Map<String, dynamic> json) {
    return GiaInfo(
      maCoSo: json['maCoSo'] ?? '',
      tenCoSo: json['tenCoSo'] ?? '',
      giaNhap: _toDouble(json['giaNhap']),
      giaBan: _toDouble(json['giaBan']),
      giaNhapRaw: json['giaNhapRaw'],
      giaBanRaw: json['giaBanRaw'],
    );
  }

  Map<String, dynamic> toJson() => {
    'maCoSo': maCoSo,
    'tenCoSo': tenCoSo,
    'giaNhap': giaNhap,
    'giaBan': giaBan,
    'giaNhapRaw': giaNhapRaw,
    'giaBanRaw': giaBanRaw,
  };
}

class QuangCaoModel {
  final int id;
  final NganhHangDto? nganhHang;
  final TepTinDto? tepTin;
  final String tieuDe;
  final String viTri;
  final bool hoatDong;
  final String? taoLuc;
  final int? trangThai;

  QuangCaoModel({
    required this.id,
    this.nganhHang,
    this.tepTin,
    required this.tieuDe,
    required this.viTri,
    required this.hoatDong,
    this.taoLuc,
    this.trangThai,
  });

  factory QuangCaoModel.fromJson(Map<String, dynamic> json) {
    return QuangCaoModel(
      id: json['id'] as int,
      nganhHang: json['nganhHang'] != null
          ? NganhHangDto.fromJson(json['nganhHang'] as Map<String, dynamic>)
          : null,
      tepTin: json['tepTin'] != null
          ? TepTinDto.fromJson(json['tepTin'] as Map<String, dynamic>)
          : null,
      tieuDe: json['tieuDe'] ?? '',
      viTri: json['viTri'] ?? '',
      hoatDong: json['hoatDong'] ?? false,
      taoLuc: json['taoLuc'] as String?,
      trangThai: json['trangThai'] as int?,
    );
  }
}

class TepTinDto {
  final int id;
  final String tenTepGoc;
  final String tenTaiLen;
  final String tenLuuTru;
  final String duongDan;
  final String loaiTepTin;
  final String duoiTep;
  final int kichCo;
  final String moTa;
  final String taoLuc;
  final String suaLuc;
  final int trangThai;

  TepTinDto({
    required this.id,
    required this.tenTepGoc,
    required this.tenTaiLen,
    required this.tenLuuTru,
    required this.duongDan,
    required this.loaiTepTin,
    required this.duoiTep,
    required this.kichCo,
    required this.moTa,
    required this.taoLuc,
    required this.suaLuc,
    required this.trangThai,
  });

  factory TepTinDto.fromJson(Map<String, dynamic> json) {
    return TepTinDto(
      id: json['id'] ?? 0,
      tenTepGoc: json['tenTepGoc'] ?? '',
      tenTaiLen: json['tenTaiLen'] ?? '',
      tenLuuTru: json['tenLuuTru'] ?? '',
      duongDan: json['duongDan'] ?? '',
      loaiTepTin: json['loaiTepTin'] ?? '',
      duoiTep: json['duoiTep'] ?? '',
      kichCo: json['kichCo'] ?? 0,
      moTa: json['moTa'] ?? '',
      taoLuc: json['taoLuc'] ?? '',
      suaLuc: json['suaLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tenTepGoc': tenTepGoc,
    'tenTaiLen': tenTaiLen,
    'tenLuuTru': tenLuuTru,
    'duongDan': duongDan,
    'loaiTepTin': loaiTepTin,
    'duoiTep': duoiTep,
    'kichCo': kichCo,
    'moTa': moTa,
    'taoLuc': taoLuc,
    'suaLuc': suaLuc,
    'trangThai': trangThai,
  };
}

class AnhVatTuDto {
  final int id;
  final TepTinDto tepTin;
  final bool anhChinh;
  final int trangThai;

  AnhVatTuDto({
    required this.id,
    required this.tepTin,
    required this.anhChinh,
    required this.trangThai,
  });

  factory AnhVatTuDto.fromJson(Map<String, dynamic> json) {
    return AnhVatTuDto(
      id: json['id'] ?? 0,
      tepTin: TepTinDto.fromJson(json['tepTin'] ?? {}),
      anhChinh: json['anhChinh'] ?? false,
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tepTin': tepTin.toJson(),
    'anhChinh': anhChinh,
    'trangThai': trangThai,
  };
}

class ThongTinGiaDto {
  final int id;
  final List<GiaInfo> dsGia;
  final String taoLuc;
  final int trangThai;

  ThongTinGiaDto({
    required this.id,
    required this.dsGia,
    required this.taoLuc,
    required this.trangThai,
  });

  factory ThongTinGiaDto.fromJson(Map<String, dynamic> json) {
    return ThongTinGiaDto(
      id: json['id'] ?? 0,
      dsGia: (json['dsGia'] as List<dynamic>? ?? [])
          .map((e) => GiaInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      taoLuc: json['taoLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dsGia': dsGia.map((e) => e.toJson()).toList(),
    'taoLuc': taoLuc,
    'trangThai': trangThai,
  };
}

/// ---- NHÓM / THƯƠNG HIỆU / NHÀ CUNG CẤP ----

class NhomVatTuDto {
  final int id;
  final String ma;
  final String ten;
  final Map<String, ThuocTinh> thuocTinhRieng;
  final double gm;
  final bool vatTuChinh;
  final String taoLuc;
  final int trangThai;

  NhomVatTuDto({
    required this.id,
    required this.ma,
    required this.ten,
    required this.thuocTinhRieng,
    required this.gm,
    required this.vatTuChinh,
    required this.taoLuc,
    required this.trangThai,
  });

  factory NhomVatTuDto.fromJson(Map<String, dynamic> json) {
    final rawRieng = json['thuocTinhRieng'] as Map<String, dynamic>? ?? {};
    final mapRieng = <String, ThuocTinh>{};
    rawRieng.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        mapRieng[key] = ThuocTinh.fromJson(value);
      }
    });

    return NhomVatTuDto(
      id: json['id'] ?? 0,
      ma: json['ma'] ?? '',
      ten: json['ten'] ?? '',
      thuocTinhRieng: mapRieng,
      gm: _toDouble(json['gm']) ?? 0,
      vatTuChinh: json['vatTuChinh'] ?? false,
      taoLuc: json['taoLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'ten': ten,
    'thuocTinhRieng': thuocTinhRieng.map((k, v) => MapEntry(k, v.toJson())),
    'gm': gm,
    'vatTuChinh': vatTuChinh,
    'taoLuc': taoLuc,
    'trangThai': trangThai,
  };
}

class ThuongHieuDto {
  final int id;
  final String tenQuocTe;
  final String ten;
  final String? quocGia;
  final String? moTa;
  final TepTinDto? tepTin; // thêm field này

  ThuongHieuDto({
    required this.id,
    required this.tenQuocTe,
    required this.ten,
    this.quocGia,
    this.moTa,
    this.tepTin,
  });

  factory ThuongHieuDto.fromJson(Map<String, dynamic> json) {
    return ThuongHieuDto(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      tenQuocTe: json['tenQuocTe'] ?? '',
      quocGia: json['quocGia'],
      moTa: json['moTa'],
      tepTin: json['tepTin'] != null
          ? TepTinDto.fromJson(json['tepTin'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ten': ten,
    'tenQuocTe': tenQuocTe,
    'quocGia': quocGia,
    'moTa': moTa,
    'tepTin': tepTin?.toJson(),
  };
}

class NhaCungCapDto {
  final int id;
  final String ten;
  final String tenQuocTe;

  NhaCungCapDto({required this.id, required this.ten, required this.tenQuocTe});

  factory NhaCungCapDto.fromJson(Map<String, dynamic> json) {
    return NhaCungCapDto(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      tenQuocTe: json['tenQuocTe'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ten': ten,
    'tenQuocTe': tenQuocTe,
  };
}

class NganhHangDto {
  final int id;
  final String ma;
  final String ten;
  final String sdtSale;
  final String sdtTech;
  final String anhNgang;
  final String anhVuong;
  final int trangThai;

  NganhHangDto({
    required this.id,
    required this.ma,
    required this.ten,
    required this.sdtSale,
    required this.sdtTech,
    required this.anhNgang,
    required this.anhVuong,
    required this.trangThai,
  });

  factory NganhHangDto.fromJson(Map<String, dynamic> json) {
    return NganhHangDto(
      id: json['id'] ?? 0,
      ma: json['ma'] ?? '',
      ten: json['ten'] ?? '',
      sdtSale: json['sdtSale'] ?? '',
      sdtTech: json['sdtTech'] ?? '',
      anhNgang: json['anhNgang'] ?? '',
      anhVuong: json['anhVuong'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'ten': ten,
    'sdtSale': sdtSale,
    'sdtTech': sdtTech,
    'anhNgang': anhNgang,
    'anhVuong': anhVuong,
    'trangThai': trangThai,
  };
}

class NhomTronGoiDto {
  final int id;
  final NganhHangDto nganhHang;
  final String ten;
  final ThuongHieuDto thuongHieuTamPin;
  final ThuongHieuDto thuongHieuInverter;
  final ThuongHieuDto thuongHieuPinLuuTru;
  final int trangThai;
  final String? taoLuc;

  NhomTronGoiDto({
    required this.id,
    required this.nganhHang,
    required this.ten,
    required this.thuongHieuTamPin,
    required this.thuongHieuInverter,
    required this.thuongHieuPinLuuTru,
    required this.trangThai,
    this.taoLuc,
  });

  factory NhomTronGoiDto.fromJson(Map<String, dynamic> json) {
    return NhomTronGoiDto(
      id: json['id'] ?? 0,
      nganhHang: NganhHangDto.fromJson(json['nganhHang'] ?? {}),
      ten: json['ten'] ?? '',
      thuongHieuTamPin: ThuongHieuDto.fromJson(json['thuongHieuTamPin'] ?? {}),
      thuongHieuInverter: ThuongHieuDto.fromJson(
        json['thuongHieuInverter'] ?? {},
      ),
      thuongHieuPinLuuTru: ThuongHieuDto.fromJson(
        json['thuongHieuPinLuuTru'] ?? {},
      ),
      trangThai: json['trangThai'] ?? 0,
      taoLuc: json['taoLuc'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nganhHang': nganhHang.toJson(),
    'ten': ten,
    'thuongHieuTamPin': thuongHieuTamPin.toJson(),
    'thuongHieuInverter': thuongHieuInverter.toJson(),
    'thuongHieuPinLuuTru': thuongHieuPinLuuTru.toJson(),
    'trangThai': trangThai,
    'taoLuc': taoLuc,
  };
}

/// ---- CƠ SỞ ----

class CoSoDto {
  final int id;
  final String ma;
  final String ten;
  final String dcVanPhong;
  final String dcKho;
  final String taoLuc;
  final int trangThai;

  CoSoDto({
    required this.id,
    required this.ma,
    required this.ten,
    required this.dcVanPhong,
    required this.dcKho,
    required this.taoLuc,
    required this.trangThai,
  });

  factory CoSoDto.fromJson(Map<String, dynamic> json) {
    return CoSoDto(
      id: json['id'] ?? 0,
      ma: json['ma'] ?? '',
      ten: json['ten'] ?? '',
      dcVanPhong: json['dcVanPhong'] ?? '',
      dcKho: json['dcKho'] ?? '',
      taoLuc: json['taoLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'ten': ten,
    'dcVanPhong': dcVanPhong,
    'dcKho': dcKho,
    'taoLuc': taoLuc,
    'trangThai': trangThai,
  };
}

/// ---- VẬT TƯ / VẬT TƯ TRỌN GÓI ----

class VatTuDto {
  final int id;
  final String ma;
  final NhomVatTuDto nhomVatTu;
  final ThuongHieuDto thuongHieu;
  final NhaCungCapDto nhaCungCap;
  final String ten;
  final String sheetLink;
  final String donVi;
  final String moTaBaoGia;
  final String moTaHopDong;
  final Map<String, ThuocTinh> duLieuRieng;
  final String taoLuc;
  final int trangThai;
  final List<AnhVatTuDto> anhVatTus;
  final List<ThongTinGiaDto> thongTinGias;
  final int? thoiGianBaoHanh;

  VatTuDto({
    required this.id,
    required this.ma,
    required this.nhomVatTu,
    required this.thuongHieu,
    required this.nhaCungCap,
    required this.ten,
    required this.sheetLink,
    required this.donVi,
    required this.moTaBaoGia,
    required this.moTaHopDong,
    required this.duLieuRieng,
    required this.taoLuc,
    required this.trangThai,
    required this.anhVatTus,
    required this.thongTinGias,
    this.thoiGianBaoHanh,
  });

  factory VatTuDto.fromJson(Map<String, dynamic> json) {
    final rawRieng = json['duLieuRieng'] as Map<String, dynamic>? ?? {};
    final mapRieng = <String, ThuocTinh>{};
    rawRieng.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        mapRieng[key] = ThuocTinh.fromJson(value);
      }
    });

    return VatTuDto(
      id: json['id'] ?? 0,
      ma: json['ma'] ?? '',
      nhomVatTu: NhomVatTuDto.fromJson(json['nhomVatTu'] ?? {}),
      thuongHieu: ThuongHieuDto.fromJson(json['thuongHieu'] ?? {}),
      nhaCungCap: NhaCungCapDto.fromJson(json['nhaCungCap'] ?? {}),
      ten: json['ten'] ?? '',
      sheetLink: json['sheetLink'] ?? '',
      donVi: json['donVi'] ?? '',
      moTaBaoGia: json['moTaBaoGia'] ?? '',
      moTaHopDong: json['moTaHopDong'] ?? '',
      duLieuRieng: mapRieng,
      taoLuc: json['taoLuc'] ?? '',
      trangThai: json['trangThai'] ?? 0,
      anhVatTus: (json['anhVatTus'] as List<dynamic>? ?? [])
          .map((e) => AnhVatTuDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      thongTinGias: (json['thongTinGias'] as List<dynamic>? ?? [])
          .map((e) => ThongTinGiaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      thoiGianBaoHanh: json['thoiGianBaoHanh'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'nhomVatTu': nhomVatTu.toJson(),
    'thuongHieu': thuongHieu.toJson(),
    'nhaCungCap': nhaCungCap.toJson(),
    'ten': ten,
    'sheetLink': sheetLink,
    'donVi': donVi,
    'moTaBaoGia': moTaBaoGia,
    'moTaHopDong': moTaHopDong,
    'duLieuRieng': duLieuRieng.map((k, v) => MapEntry(k, v.toJson())),
    'taoLuc': taoLuc,
    'trangThai': trangThai,
    'anhVatTus': anhVatTus.map((e) => e.toJson()).toList(),
    'thongTinGias': thongTinGias.map((e) => e.toJson()).toList(),
    'thoiGianBaoHanh': thoiGianBaoHanh,
  };
}

class VatTuTronGoiDto {
  final int id;
  final VatTuDto vatTu;
  final String moTa;
  final double soLuong;
  final double gia;
  final double gm;
  final String taoLuc;
  final int thoiGianBaoHanh;
  final bool duocBaoHanh;
  final bool? duocXem;
  final int trangThai;

  VatTuTronGoiDto({
    required this.id,
    required this.vatTu,
    required this.moTa,
    required this.soLuong,
    required this.gia,
    required this.gm,
    required this.taoLuc,
    required this.thoiGianBaoHanh,
    required this.duocBaoHanh,
    this.duocXem,
    required this.trangThai,
  });

  factory VatTuTronGoiDto.fromJson(Map<String, dynamic> json) {
    return VatTuTronGoiDto(
      id: json['id'] ?? 0,
      vatTu: VatTuDto.fromJson(json['vatTu'] ?? {}),
      moTa: json['moTa'] ?? '',
      soLuong: _toDouble(json['soLuong']) ?? 0,
      gia: _toDouble(json['gia']) ?? 0,
      gm: _toDouble(json['gm']) ?? 0,
      taoLuc: json['taoLuc'] ?? '',
      thoiGianBaoHanh: json['thoiGianBaoHanh'] ?? 0,
      duocBaoHanh: json['duocBaoHanh'] ?? false,
      duocXem: json['duocXem'],
      trangThai: json['trangThai'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'vatTu': vatTu.toJson(),
    'moTa': moTa,
    'soLuong': soLuong,
    'gia': gia,
    'gm': gm,
    'taoLuc': taoLuc,
    'thoiGianBaoHanh': thoiGianBaoHanh,
    'duocBaoHanh': duocBaoHanh,
    'duocXem': duocXem,
    'trangThai': trangThai,
  };
}

/// ---- TRỌN GÓI ----
/// ---- TRỌN GÓI ----
/// /// ---- TRỌN GÓI ----
class TronGoiDto {
  final int id;
  final CoSoDto coSo;
  final NhomTronGoiDto nhomTronGoi;
  final String ten;
  final TepTinDto tepTin;
  final String loaiHeThong;
  final String loaiPha;
  final double? congSuatHeThong;
  final double sanLuongToiThieu;
  final double sanLuongToiDa;
  final String moTa;
  final String taoLuc;
  final double tongGia;
  final double? gmTong;
  final bool banChay;
  final int trangThai;
  final List<VatTuTronGoiDto> vatTuTronGois;

  TronGoiDto({
    required this.id,
    required this.coSo,
    required this.nhomTronGoi,
    required this.ten,
    required this.tepTin,
    required this.loaiHeThong,
    required this.loaiPha,
    this.congSuatHeThong,
    required this.sanLuongToiThieu,
    required this.sanLuongToiDa,
    required this.moTa,
    required this.taoLuc,
    required this.tongGia,
    this.gmTong,
    required this.banChay,
    required this.trangThai,
    required this.vatTuTronGois,
  });

  factory TronGoiDto.fromJson(Map<String, dynamic> json) {
    return TronGoiDto(
      id: json['id'] ?? 0,
      coSo: CoSoDto.fromJson(json['coSo'] ?? {}),
      nhomTronGoi: NhomTronGoiDto.fromJson(json['nhomTronGoi'] ?? {}),
      ten: json['ten'] ?? '',
      tepTin: TepTinDto.fromJson(json['tepTin'] ?? {}),
      loaiHeThong: json['loaiHeThong'] ?? '',
      loaiPha: json['loaiPha'] ?? '',
      congSuatHeThong: _toDouble(json['congSuatHeThong']),
      sanLuongToiThieu: _toDouble(json['sanLuongToiThieu']) ?? 0,
      sanLuongToiDa: _toDouble(json['sanLuongToiDa']) ?? 0,
      moTa: json['moTa'] ?? '',
      taoLuc: json['taoLuc'] ?? '',
      tongGia: _toDouble(json['tongGia']) ?? 0,
      gmTong: _toDouble(json['gmTong']),
      banChay: json['banChay'] ?? false,
      trangThai: json['trangThai'] ?? 0,
      vatTuTronGois: (json['vatTuTronGois'] as List<dynamic>? ?? [])
          .map((e) => VatTuTronGoiDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coSo': coSo.toJson(),
    'nhomTronGoi': nhomTronGoi.toJson(),
    'ten': ten,
    'tepTin': tepTin.toJson(),
    'loaiHeThong': loaiHeThong,
    'loaiPha': loaiPha,
    'congSuatHeThong': congSuatHeThong,
    'sanLuongToiThieu': sanLuongToiThieu,
    'sanLuongToiDa': sanLuongToiDa,
    'moTa': moTa,
    'taoLuc': taoLuc,
    'tongGia': tongGia,
    'gmTong': gmTong,
    'banChay': banChay,
    'trangThai': trangThai,
    'vatTuTronGois': vatTuTronGois.map((e) => e.toJson()).toList(),
  };
}

class HopDongBaoHanhDto {
  final int id;
  final String tenHopDong;
  final String coSoMa;
  final String khachHangTen;
  final double tongGia;
  final DateTime? taoLuc;
  final List<VatTuHopDongBaoHanhDto> vatTuHopDongs;

  HopDongBaoHanhDto({
    required this.id,
    required this.tenHopDong,
    required this.coSoMa,
    required this.khachHangTen,
    required this.tongGia,
    required this.vatTuHopDongs,
    this.taoLuc,
  });

  factory HopDongBaoHanhDto.fromJson(Map<String, dynamic> json) {
    final coSo = json['coSo'] as Map<String, dynamic>? ?? {};
    final khachHang = json['khachHang'] as Map<String, dynamic>? ?? {};

    final List<dynamic> list =
        json['vatTuHopDongs'] as List<dynamic>? ?? const [];

    return HopDongBaoHanhDto(
      id: json['id'] as int? ?? 0,
      tenHopDong: json['ten']?.toString() ?? '',
      coSoMa: coSo['ma']?.toString() ?? '',
      khachHangTen: khachHang['hoVaTen']?.toString() ?? '',
      tongGia: (json['tongGia'] as num?)?.toDouble() ?? 0,
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      vatTuHopDongs: list
          .map(
            (e) => VatTuHopDongBaoHanhDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class VatTuHopDongBaoHanhDto {
  final int id;

  final VatTuDto vatTu;
  final ThuongHieuDto? thuongHieu;

  final String tenVatTu;
  final String thuongHieuTen;
  final String donVi;

  final String nhomMa;
  final String nhomTen;

  final int? thoiGianBaoHanhThietBi; // tháng

  final int? thoiGianBaoHanhThucTe; // tháng

  final int soLuong;

  final double? giaHeThong;
  final double? giaHienThi;
  final double? gm;

  final DateTime? baoHanhBatDau;
  final DateTime? baoHanhKetThuc;
  final bool duocBaoHanh;

  final String? moTa;
  final DateTime? taoLuc;
  final int? trangThai;

  VatTuHopDongBaoHanhDto({
    required this.id,
    required this.vatTu,
    required this.tenVatTu,
    required this.thuongHieuTen,
    required this.donVi,
    required this.nhomMa,
    required this.nhomTen,
    required this.soLuong,
    required this.duocBaoHanh,
    this.thuongHieu,
    this.thoiGianBaoHanhThietBi,
    this.thoiGianBaoHanhThucTe,
    this.giaHeThong,
    this.giaHienThi,
    this.gm,
    this.baoHanhBatDau,
    this.baoHanhKetThuc,
    this.moTa,
    this.taoLuc,
    this.trangThai,
  });

  factory VatTuHopDongBaoHanhDto.fromJson(Map<String, dynamic> json) {
    final vatTuJson = json['vatTu'] as Map<String, dynamic>? ?? {};
    final vatTu = VatTuDto.fromJson(vatTuJson);

    final thuongHieuJson = json['thuongHieu'] as Map<String, dynamic>?;
    final ThuongHieuDto? thuongHieu = thuongHieuJson != null
        ? ThuongHieuDto.fromJson(thuongHieuJson)
        : null;

    final nhomVatTu = vatTuJson['nhomVatTu'] as Map<String, dynamic>? ?? {};
    final String nhomMa = nhomVatTu['ma']?.toString() ?? '';
    final String nhomTen = nhomVatTu['ten']?.toString() ?? '';

    // Trong JSON của bạn có cả:
    // - vatTu.thoiGianBaoHanh (VD: 144 tháng)
    // - thoiGianBaoHanh tại cấp vatTuHopDong (VD: 60, 12,...)
    final int? thoiGianBaoHanhThietBi = vatTuJson['thoiGianBaoHanh'] as int?;
    final int? thoiGianBaoHanhThucTe = json['thoiGianBaoHanh'] as int?;

    return VatTuHopDongBaoHanhDto(
      id: json['id'] as int? ?? 0,
      vatTu: vatTu,
      thuongHieu: thuongHieu,
      tenVatTu: vatTu.ten,
      thuongHieuTen: thuongHieu?.ten ?? '--',
      donVi: vatTu.donVi,
      nhomMa: nhomMa,
      nhomTen: nhomTen,
      thoiGianBaoHanhThietBi: thoiGianBaoHanhThietBi,
      thoiGianBaoHanhThucTe: thoiGianBaoHanhThucTe,
      soLuong: json['soLuong'] as int? ?? 0,
      giaHeThong: (json['giaHeThong'] as num?)?.toDouble(),
      giaHienThi: (json['giaHienThi'] as num?)?.toDouble(),
      gm: (json['gm'] as num?)?.toDouble(),
      baoHanhBatDau: json['baoHanhBatDau'] != null
          ? DateTime.tryParse(json['baoHanhBatDau'] as String)
          : null,
      baoHanhKetThuc: json['baoHanhKetThuc'] != null
          ? DateTime.tryParse(json['baoHanhKetThuc'] as String)
          : null,
      duocBaoHanh: json['duocBaoHanh'] as bool? ?? false,
      moTa: json['moTa'] as String?,
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vatTu': vatTu.toJson(),
      'thuongHieu': thuongHieu?.toJson(),
      'tenVatTu': tenVatTu,
      'thuongHieuTen': thuongHieuTen,
      'donVi': donVi,
      'nhomMa': nhomMa,
      'nhomTen': nhomTen,
      'thoiGianBaoHanhThietBi': thoiGianBaoHanhThietBi,
      'thoiGianBaoHanhThucTe': thoiGianBaoHanhThucTe,
      'soLuong': soLuong,
      'giaHeThong': giaHeThong,
      'giaHienThi': giaHienThi,
      'gm': gm,
      'baoHanhBatDau': baoHanhBatDau?.toIso8601String(),
      'baoHanhKetThuc': baoHanhKetThuc?.toIso8601String(),
      'duocBaoHanh': duocBaoHanh,
      'moTa': moTa,
      'taoLuc': taoLuc?.toIso8601String(),
      'trangThai': trangThai,
    };
  }

  /// Ưu tiên dùng thoiGianBaoHanhThucTe, nếu null thì fallback qua thietBi
  int get thoiGianBaoHanhEffective {
    return thoiGianBaoHanhThucTe ?? thoiGianBaoHanhThietBi ?? 0;
  }

  /// "xx tháng", "x năm y tháng"
  String get thoiGianBaoHanhText {
    final m = thoiGianBaoHanhEffective;
    if (m <= 0) return '--';
    if (m < 12) return '$m tháng';
    final year = m ~/ 12;
    final month = m % 12;
    if (month == 0) return '$year năm';
    return '$year năm $month tháng';
  }

  /// khoảng thời gian bảo hành: "29/07/2024 - 29/07/2029"
  String get khoangThoiGianBaoHanhText {
    if (baoHanhBatDau == null || baoHanhKetThuc == null) return '--';
    final start =
        '${baoHanhBatDau!.day.toString().padLeft(2, '0')}/${baoHanhBatDau!.month.toString().padLeft(2, '0')}/${baoHanhBatDau!.year}';
    final end =
        '${baoHanhKetThuc!.day.toString().padLeft(2, '0')}/${baoHanhKetThuc!.month.toString().padLeft(2, '0')}/${baoHanhKetThuc!.year}';
    return '$start - $end';
  }

  /// Thiết bị còn trong hạn bảo hành hay không
  bool get isConBaoHanh {
    if (!duocBaoHanh || baoHanhKetThuc == null) return false;
    final now = DateTime.now();
    return !now.isAfter(baoHanhKetThuc!);
  }
}
