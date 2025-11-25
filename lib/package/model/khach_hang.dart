class KhachHang {
  final int? id;
  final String? email;
  final String? sdt;
  final String? hoVaTen;
  final bool? gioiTinh;
  final String? diaChi;
  final bool? daBanDuocHang;
  final String? taoLuc;
  final int? trangThai;

  KhachHang({
    this.id,
    this.email,
    this.sdt,
    this.hoVaTen,
    this.gioiTinh,
    this.diaChi,
    this.daBanDuocHang,
    this.taoLuc,
    this.trangThai,
  });

  factory KhachHang.fromJson(Map<String, dynamic> json) {
    return KhachHang(
      id: json["id"],
      email: json["email"],
      sdt: json["sdt"],
      hoVaTen: json["hoVaTen"],
      gioiTinh: json["gioiTinh"],
      diaChi: json["diaChi"],
      daBanDuocHang: json["daBanDuocHang"],
      taoLuc: json["taoLuc"],
      trangThai: json["trangThai"],
    );
  }
}


class CustomerDisplay {
  final int hopDongId; 
  final String hoTenKH;
  final double tongGia;
  final DateTime ngayTao;
  final double hoaHong;

  CustomerDisplay({
    required this.hopDongId,
    required this.hoTenKH,
    required this.tongGia,
    required this.ngayTao,
    required this.hoaHong,
  });
}

