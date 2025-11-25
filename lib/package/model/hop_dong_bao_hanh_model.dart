
class HopDongBaoHanh {
  final int id;
  final String ten;
  final DateTime? taoLuc;
  final double tongGia;
  final KhachHangBH? khachHang;
  final List<VatTuHopDongBH> vatTuHopDongs;

  HopDongBaoHanh({
    required this.id,
    required this.ten,
    required this.taoLuc,
    required this.tongGia,
    required this.khachHang,
    required this.vatTuHopDongs,
  });

  factory HopDongBaoHanh.fromJson(Map<String, dynamic> json) {
    final vatTuList = (json['vatTuHopDongs'] as List? ?? [])
        .map((e) => VatTuHopDongBH.fromJson(e as Map<String, dynamic>))
        .toList();

    return HopDongBaoHanh(
      id: json['id'] ?? 0,
      ten: json['ten'] ?? '',
      taoLuc: json['taoLuc'] != null ? DateTime.tryParse(json['taoLuc']) : null,
      tongGia: (json['tongGia'] is num)
          ? (json['tongGia'] as num).toDouble()
          : double.tryParse('${json['tongGia']}') ?? 0,
      khachHang: json['khachHang'] != null
          ? KhachHangBH.fromJson(json['khachHang'])
          : null,
      vatTuHopDongs: vatTuList,
    );
  }
}

class KhachHangBH {
  final int? id;
  final String? hoVaTen;
  final String? diaChi;

  KhachHangBH({
    this.id,
    this.hoVaTen,
    this.diaChi,
  });

  factory KhachHangBH.fromJson(Map<String, dynamic> json) {
    return KhachHangBH(
      id: json['id'],
      hoVaTen: json['hoVaTen'],
      diaChi: json['diaChi'],
    );
  }
}

class VatTuHopDongBH {
  final int id;
  final VatTuBH? vatTu;
  final int? thoiGianBaoHanh; // tháng
  final DateTime? baoHanhBatDau;
  final DateTime? baoHanhKetThuc;
  final bool duocBaoHanh;

  VatTuHopDongBH({
    required this.id,
    required this.vatTu,
    required this.thoiGianBaoHanh,
    required this.baoHanhBatDau,
    required this.baoHanhKetThuc,
    required this.duocBaoHanh,
  });

  factory VatTuHopDongBH.fromJson(Map<String, dynamic> json) {
    return VatTuHopDongBH(
      id: json['id'] ?? 0,
      vatTu: json['vatTu'] != null ? VatTuBH.fromJson(json['vatTu']) : null,
      thoiGianBaoHanh: json['thoiGianBaoHanh'],
      baoHanhBatDau: json['baoHanhBatDau'] != null
          ? DateTime.tryParse(json['baoHanhBatDau'])
          : null,
      baoHanhKetThuc: json['baoHanhKetThuc'] != null
          ? DateTime.tryParse(json['baoHanhKetThuc'])
          : null,
      duocBaoHanh: json['duocBaoHanh'] ?? false,
    );
  }
}

class VatTuBH {
  final int? id;
  final String? ten;
  final NhomVatTuBH? nhomVatTu;
  final List<AnhVatTuBH> anhVatTus;

  VatTuBH({
    this.id,
    this.ten,
    this.nhomVatTu,
    required this.anhVatTus,
  });

  factory VatTuBH.fromJson(Map<String, dynamic> json) {
    final anhList = (json['anhVatTus'] as List? ?? [])
        .map((e) => AnhVatTuBH.fromJson(e as Map<String, dynamic>))
        .toList();

    return VatTuBH(
      id: json['id'],
      ten: json['ten'],
      nhomVatTu: json['nhomVatTu'] != null
          ? NhomVatTuBH.fromJson(json['nhomVatTu'])
          : null,
      anhVatTus: anhList,
    );
  }
}

class NhomVatTuBH {
  final int? id;
  final String? ma; // ví dụ: TAM_PIN, BIEN_TAN, PIN_LUU_TRU
  final String? ten;
  final bool vatTuChinh;

  NhomVatTuBH({
    this.id,
    this.ma,
    this.ten,
    required this.vatTuChinh,
  });

  factory NhomVatTuBH.fromJson(Map<String, dynamic> json) {
    return NhomVatTuBH(
      id: json['id'],
      ma: json['ma'],
      ten: json['ten'],
      vatTuChinh: json['vatTuChinh'] ?? false,
    );
  }
}

class AnhVatTuBH {
  final TepTinBH? tepTin;

  AnhVatTuBH({this.tepTin});

  factory AnhVatTuBH.fromJson(Map<String, dynamic> json) {
    return AnhVatTuBH(
      tepTin: json['tepTin'] != null
          ? TepTinBH.fromJson(json['tepTin'])
          : null,
    );
  }
}

class TepTinBH {
  final String? duongDan;

  TepTinBH({this.duongDan});

  factory TepTinBH.fromJson(Map<String, dynamic> json) {
    return TepTinBH(
      duongDan: json['duongDan'],
    );
  }
}
