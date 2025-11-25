import 'dart:convert';

/// =============================
///  ENTRY: parse từ raw JSON
/// =============================
TronGoiResponse tronGoiResponseFromJson(String source) =>
    TronGoiResponse.fromJson(json.decode(source) as Map<String, dynamic>);

/// =============================
///  RESPONSE: {status, data}
/// =============================
class TronGoiResponse {
  final int status;
  final TronGoiBase data;

  TronGoiResponse({required this.status, required this.data});

  factory TronGoiResponse.fromJson(Map<String, dynamic> json) {
    return TronGoiResponse(
      status: json['status'] as int,
      data: TronGoiBase.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'data': data.toJson()};
}

/// =============================
///  TRỌN GÓI (data)
/// =============================
class TronGoiBase {
  final int id;
  final NhomTronGoi? nhomTronGoi;
  final CoSo? coSo;
  final String ten;
  final TepTin? tepTin;
  final String? loaiHeThong;
  final String? loaiPha;
  final num? congSuatHeThong;
  final int? sanLuongToiThieu;
  final int? sanLuongToiDa;
  final String? moTa;
  final DateTime? taoLuc;
  final num tongGia;
  final num? gmTong;
  final bool? banChay;
  final int? trangThai;
  final List<VatTuTronGoi> vatTuTronGois;

  TronGoiBase({
    required this.id,
    this.nhomTronGoi,
    this.coSo,
    required this.ten,
    this.tepTin,
    this.loaiHeThong,
    this.loaiPha,
    this.congSuatHeThong,
    this.sanLuongToiThieu,
    this.sanLuongToiDa,
    this.moTa,
    this.taoLuc,
    required this.tongGia,
    this.gmTong,
    this.banChay,
    this.trangThai,
    required this.vatTuTronGois,
  });

  factory TronGoiBase.fromJson(Map<String, dynamic> json) {
    return TronGoiBase(
      id: json['id'] as int,
      nhomTronGoi: json['nhomTronGoi'] != null
          ? NhomTronGoi.fromJson(json['nhomTronGoi'] as Map<String, dynamic>)
          : null,
      coSo: json['coSo'] != null
          ? CoSo.fromJson(json['coSo'] as Map<String, dynamic>)
          : null,
      ten: json['ten'] as String? ?? '',
      tepTin: json['tepTin'] != null
          ? TepTin.fromJson(json['tepTin'] as Map<String, dynamic>)
          : null,
      loaiHeThong: json['loaiHeThong'] as String?,
      loaiPha: json['loaiPha'] as String?,
      congSuatHeThong: (json['congSuatHeThong'] as num?),
      sanLuongToiThieu: (json['sanLuongToiThieu'] as num?)?.toInt(),
      sanLuongToiDa: (json['sanLuongToiDa'] as num?)?.toInt(),

      moTa: json['moTa'] as String?,
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      tongGia: (json['tongGia'] as num?) ?? 0,
      gmTong: json['gmTong'] as num?,
      banChay: json['banChay'] as bool?,
      trangThai: json['trangThai'] as int?,
      vatTuTronGois: (json['vatTuTronGois'] as List<dynamic>? ?? [])
          .map((e) => VatTuTronGoi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nhomTronGoi': nhomTronGoi?.toJson(),
    'coSo': coSo?.toJson(),
    'ten': ten,
    'tepTin': tepTin?.toJson(),
    'loaiHeThong': loaiHeThong,
    'loaiPha': loaiPha,
    'congSuatHeThong': congSuatHeThong,
    'sanLuongToiThieu': sanLuongToiThieu,
    'sanLuongToiDa': sanLuongToiDa,
    'moTa': moTa,
    'taoLuc': taoLuc?.toIso8601String(),
    'tongGia': tongGia,
    'gmTong': gmTong,
    'banChay': banChay,
    'trangThai': trangThai,
    'vatTuTronGois': vatTuTronGois.map((e) => e.toJson()).toList(),
  };
}

/// =============================
///  NHÓM TRỌN GÓI
/// =============================
class NhomTronGoi {
  final int id;
  final NganhHang? nganhHang;
  final String ten;
  final ThuongHieu? thuongHieuTamPin;
  final ThuongHieu? thuongHieuInverter;
  final ThuongHieu? thuongHieuPinLuuTru;
  final DateTime? taoLuc;
  final int? trangThai;

  NhomTronGoi({
    required this.id,
    this.nganhHang,
    required this.ten,
    this.thuongHieuTamPin,
    this.thuongHieuInverter,
    this.thuongHieuPinLuuTru,
    this.taoLuc,
    this.trangThai,
  });

  factory NhomTronGoi.fromJson(Map<String, dynamic> json) {
    return NhomTronGoi(
      id: json['id'] as int,
      nganhHang: json['nganhHang'] != null
          ? NganhHang.fromJson(json['nganhHang'] as Map<String, dynamic>)
          : null,
      ten: json['ten'] as String? ?? '',
      thuongHieuTamPin: json['thuongHieuTamPin'] != null
          ? ThuongHieu.fromJson(
              json['thuongHieuTamPin'] as Map<String, dynamic>,
            )
          : null,
      thuongHieuInverter: json['thuongHieuInverter'] != null
          ? ThuongHieu.fromJson(
              json['thuongHieuInverter'] as Map<String, dynamic>,
            )
          : null,
      thuongHieuPinLuuTru: json['thuongHieuPinLuuTru'] != null
          ? ThuongHieu.fromJson(
              json['thuongHieuPinLuuTru'] as Map<String, dynamic>,
            )
          : null,
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nganhHang': nganhHang?.toJson(),
    'ten': ten,
    'thuongHieuTamPin': thuongHieuTamPin?.toJson(),
    'thuongHieuInverter': thuongHieuInverter?.toJson(),
    'thuongHieuPinLuuTru': thuongHieuPinLuuTru?.toJson(),
    'taoLuc': taoLuc?.toIso8601String(),
    'trangThai': trangThai,
  };
}

/// =============================
///  NGÀNH HÀNG
/// =============================
class NganhHang {
  final int id;
  final String ma;
  final String ten;
  final String? sdtSale;
  final String? sdtTech;
  final int? trangThai;

  NganhHang({
    required this.id,
    required this.ma,
    required this.ten,
    this.sdtSale,
    this.sdtTech,
    this.trangThai,
  });

  factory NganhHang.fromJson(Map<String, dynamic> json) {
    return NganhHang(
      id: json['id'] as int,
      ma: json['ma'] as String? ?? '',
      ten: json['ten'] as String? ?? '',
      sdtSale: json['sdtSale'] as String?,
      sdtTech: json['sdtTech'] as String?,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'ten': ten,
    'sdtSale': sdtSale,
    'sdtTech': sdtTech,
    'trangThai': trangThai,
  };
}

/// =============================
///  THƯƠNG HIỆU (Tam pin / Inverter / Pin lưu trữ / Vật tư)
/// =============================
class ThuongHieu {
  final int id;
  final String tenQuocTe;
  final String ten;
  final String? quocGia;
  final int? trangThai;

  ThuongHieu({
    required this.id,
    required this.tenQuocTe,
    required this.ten,
    this.quocGia,
    this.trangThai,
  });

  factory ThuongHieu.fromJson(Map<String, dynamic> json) {
    return ThuongHieu(
      id: json['id'] as int,
      tenQuocTe: json['tenQuocTe'] as String? ?? '',
      ten: json['ten'] as String? ?? '',
      quocGia: json['quocGia'] as String?,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tenQuocTe': tenQuocTe,
    'ten': ten,
    'quocGia': quocGia,
    'trangThai': trangThai,
  };
}

/// =============================
///  CƠ SỞ
/// =============================
class CoSo {
  final int id;
  final String ma;
  final String ten;
  final String? dcVanPhong;
  final String? dcKho;
  final DateTime? taoLuc;
  final int? trangThai;

  CoSo({
    required this.id,
    required this.ma,
    required this.ten,
    this.dcVanPhong,
    this.dcKho,
    this.taoLuc,
    this.trangThai,
  });

  factory CoSo.fromJson(Map<String, dynamic> json) {
    return CoSo(
      id: json['id'] as int,
      ma: json['ma'] as String? ?? '',
      ten: json['ten'] as String? ?? '',
      dcVanPhong: json['dcVanPhong'] as String?,
      dcKho: json['dcKho'] as String?,
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'ten': ten,
    'dcVanPhong': dcVanPhong,
    'dcKho': dcKho,
    'taoLuc': taoLuc?.toIso8601String(),
    'trangThai': trangThai,
  };
}

/// =============================
///  TỆP TIN HÌNH ẢNH COMBO
/// =============================
class TepTin {
  final int id;
  final String tenTepGoc;
  final String tenTaiLen;
  final String tenLuuTru;
  final String duongDan;
  final String loaiTepTin;
  final String duoiTep;

  TepTin({
    required this.id,
    required this.tenTepGoc,
    required this.tenTaiLen,
    required this.tenLuuTru,
    required this.duongDan,
    required this.loaiTepTin,
    required this.duoiTep,
  });

  factory TepTin.fromJson(Map<String, dynamic> json) {
    return TepTin(
      id: json['id'] as int,
      tenTepGoc: json['tenTepGoc'] as String? ?? '',
      tenTaiLen: json['tenTaiLen'] as String? ?? '',
      tenLuuTru: json['tenLuuTru'] as String? ?? '',
      duongDan: json['duongDan'] as String? ?? '',
      loaiTepTin: json['loaiTepTin'] as String? ?? '',
      duoiTep: json['duoiTep'] as String? ?? '',
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
  };
}

/// =============================
///  VẬT TƯ TRỌN GÓI (element trong vatTuTronGois)
/// =============================
class VatTuTronGoi {
  final int id;
  final VatTu vatTu;
  final String? moTa;
  final num soLuong;
  final num gia;
  final num? gm;
  final bool? duocBaoHanh;
  final bool? duocXem;
  final int? trangThai;

  VatTuTronGoi({
    required this.id,
    required this.vatTu,
    this.moTa,
    required this.soLuong,
    required this.gia,
    this.gm,
    this.duocBaoHanh,
    this.duocXem,
    this.trangThai,
  });

  factory VatTuTronGoi.fromJson(Map<String, dynamic> json) {
    return VatTuTronGoi(
      id: json['id'] as int,
      vatTu: VatTu.fromJson(json['vatTu'] as Map<String, dynamic>),
      moTa: json['moTa'] as String?,
      soLuong: json['soLuong'] as num? ?? 0,
      gia: json['gia'] as num? ?? 0,
      gm: json['gm'] as num?,
      duocBaoHanh: json['duocBaoHanh'] as bool?,
      duocXem: json['duocXem'] as bool?,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'vatTu': vatTu.toJson(),
    'moTa': moTa,
    'soLuong': soLuong,
    'gia': gia,
    'gm': gm,
    'duocBaoHanh': duocBaoHanh,
    'duocXem': duocXem,
    'trangThai': trangThai,
  };
}

/// =============================
///  VẬT TƯ
/// =============================
class VatTu {
  final int id;
  final String ma;
  final NhomVatTu? nhomVatTu;
  final ThuongHieu? thuongHieu;
  final String ten;
  final String donVi;
  final Map<String, ThuocTinhDong> duLieuRieng;
  final DateTime? taoLuc;
  final int? trangThai;
  final List<dynamic> anhVatTus; // chưa có cấu trúc chi tiết
  final List<ThongTinGia> thongTinGias;

  VatTu({
    required this.id,
    required this.ma,
    this.nhomVatTu,
    this.thuongHieu,
    required this.ten,
    required this.donVi,
    required this.duLieuRieng,
    this.taoLuc,
    this.trangThai,
    required this.anhVatTus,
    required this.thongTinGias,
  });

  factory VatTu.fromJson(Map<String, dynamic> json) {
    return VatTu(
      id: json['id'] as int,
      ma: json['ma'] as String? ?? '',
      nhomVatTu: json['nhomVatTu'] != null
          ? NhomVatTu.fromJson(json['nhomVatTu'] as Map<String, dynamic>)
          : null,
      thuongHieu: json['thuongHieu'] != null
          ? ThuongHieu.fromJson(json['thuongHieu'] as Map<String, dynamic>)
          : null,
      ten: json['ten'] as String? ?? '',
      donVi: json['donVi'] as String? ?? '',
      duLieuRieng: _parseThuocTinhMap(json['duLieuRieng']),
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      trangThai: json['trangThai'] as int?,
      anhVatTus: (json['anhVatTus'] as List<dynamic>? ?? []),
      thongTinGias: (json['thongTinGias'] as List<dynamic>? ?? [])
          .map((e) => ThongTinGia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'nhomVatTu': nhomVatTu?.toJson(),
    'thuongHieu': thuongHieu?.toJson(),
    'ten': ten,
    'donVi': donVi,
    'duLieuRieng': duLieuRieng.map(
      (k, v) => MapEntry(k, v.toJson()),
    ), // map dynamic
    'taoLuc': taoLuc?.toIso8601String(),
    'trangThai': trangThai,
    'anhVatTus': anhVatTus,
    'thongTinGias': thongTinGias.map((e) => e.toJson()).toList(),
  };
}
/// =============================
///  RESPONSE FILTER VẬT TƯ
///  { status, data: { content, totalElements, totalPages, ... } }
/// =============================
class VatTuFilterResponse {
  final int status;
  final List<VatTu> items;
  final int totalElements;
  final int totalPages;
  final String message;
  final String timestamp;

  VatTuFilterResponse({
    required this.status,
    required this.items,
    required this.totalElements,
    required this.totalPages,
    required this.message,
    required this.timestamp,
  });

  factory VatTuFilterResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final content = data['content'] as List<dynamic>? ?? [];

    return VatTuFilterResponse(
      status: json['status'] as int? ?? 0,
      items: content
          .map((e) => VatTu.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: data['totalElements'] as int? ?? 0,
      totalPages: data['totalPages'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': {
          'content': items.map((e) => e.toJson()).toList(),
          'totalElements': totalElements,
          'totalPages': totalPages,
        },
        'message': message,
        'timestamp': timestamp,
      };
}

/// =============================
///  NHÓM VẬT TƯ
/// =============================
class NhomVatTu {
  final int id;
  final String ma;
  final NganhHang? nghanhHang;
  final String ten;
  final Map<String, ThuocTinhDong> thuocTinhRieng;
  final num? gm;
  final bool? vatTuChinh;
  final DateTime? taoLuc;
  final int? trangThai;

  NhomVatTu({
    required this.id,
    required this.ma,
    this.nghanhHang,
    required this.ten,
    required this.thuocTinhRieng,
    this.gm,
    this.vatTuChinh,
    this.taoLuc,
    this.trangThai,
  });

  factory NhomVatTu.fromJson(Map<String, dynamic> json) {
    return NhomVatTu(
      id: json['id'] as int,
      ma: json['ma'] as String? ?? '',
      nghanhHang: json['nghanhHang'] != null
          ? NganhHang.fromJson(json['nghanhHang'] as Map<String, dynamic>)
          : null,
      ten: json['ten'] as String? ?? '',
      thuocTinhRieng: _parseThuocTinhMap(json['thuocTinhRieng']),
      gm: json['gm'] as num?,
      vatTuChinh: json['vatTuChinh'] as bool?,
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ma': ma,
    'nghanhHang': nghanhHang?.toJson(),
    'ten': ten,
    'thuocTinhRieng': thuocTinhRieng.map((k, v) => MapEntry(k, v.toJson())),
    'gm': gm,
    'vatTuChinh': vatTuChinh,
    'taoLuc': taoLuc?.toIso8601String(),
    'trangThai': trangThai,
  };
}

/// =============================
///  THUỘC TÍNH ĐỘNG (dùng cho duLieuRieng / thuocTinhRieng)
/// =============================
class ThuocTinhDong {
  final String ten;
  final String donVi;
  final dynamic giaTri; // có thể là String hoặc số

  ThuocTinhDong({required this.ten, required this.donVi, this.giaTri});

  factory ThuocTinhDong.fromJson(Map<String, dynamic> json) {
    return ThuocTinhDong(
      ten: json['ten'] as String? ?? '',
      donVi: json['donVi'] as String? ?? '',
      giaTri: json['giaTri'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ten': ten,
    'donVi': donVi,
    'giaTri': giaTri,
  };
}

Map<String, ThuocTinhDong> _parseThuocTinhMap(dynamic raw) {
  if (raw == null || raw is! Map<String, dynamic>) {
    return {};
  }
  return raw.map(
    (key, value) =>
        MapEntry(key, ThuocTinhDong.fromJson(value as Map<String, dynamic>)),
  );
}

/// =============================
///  THÔNG TIN GIÁ
/// =============================
class ThongTinGia {
  final int id;
  final List<GiaCoSo> dsGia;
  final DateTime? taoLuc;
  final int? trangThai;

  ThongTinGia({
    required this.id,
    required this.dsGia,
    this.taoLuc,
    this.trangThai,
  });

  factory ThongTinGia.fromJson(Map<String, dynamic> json) {
    return ThongTinGia(
      id: json['id'] as int,
      dsGia: (json['dsGia'] as List<dynamic>? ?? [])
          .map((e) => GiaCoSo.fromJson(e as Map<String, dynamic>))
          .toList(),
      taoLuc: json['taoLuc'] != null
          ? DateTime.tryParse(json['taoLuc'] as String)
          : null,
      trangThai: json['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dsGia': dsGia.map((e) => e.toJson()).toList(),
    'taoLuc': taoLuc?.toIso8601String(),
    'trangThai': trangThai,
  };
}

/// =============================
///  GIÁ THEO CƠ SỞ
/// =============================
class GiaCoSo {
  final String maCoSo;
  final String tenCoSo;
  final num giaNhap;
  final num giaBan;

  GiaCoSo({
    required this.maCoSo,
    required this.tenCoSo,
    required this.giaNhap,
    required this.giaBan,
  });

  factory GiaCoSo.fromJson(Map<String, dynamic> json) {
    return GiaCoSo(
      maCoSo: json['maCoSo'] as String? ?? '',
      tenCoSo: json['tenCoSo'] as String? ?? '',
      giaNhap: json['giaNhap'] as num? ?? 0,
      giaBan: json['giaBan'] as num? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'maCoSo': maCoSo,
    'tenCoSo': tenCoSo,
    'giaNhap': giaNhap,
    'giaBan': giaBan,
  };
}
