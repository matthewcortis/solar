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
      id: json["id"],
      ma: json["ma"],
      ten: json["ten"],
      dcVanPhong: json["dcVanPhong"],
      dcKho: json["dcKho"],
      taoLuc: json["taoLuc"],
      trangThai: json["trangThai"],
    );
  }
}
