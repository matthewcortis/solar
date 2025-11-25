class CustomerModel {
  final String name;
  final String avatar;
  final String giaTriHopDong;
  final String ngayBanGiao;
  final String hoaHong;
  final String trangThai;

  CustomerModel({
    required this.name,
    required this.avatar,
    required this.giaTriHopDong,
    required this.ngayBanGiao,
    required this.hoaHong,
    required this.trangThai,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      giaTriHopDong: json['giaTriHopDong'] ?? '',
      ngayBanGiao: json['ngayBanGiao'] ?? '',
      hoaHong: json['hoaHong'] ?? '',
      trangThai: json['trangThai'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
        'giaTriHopDong': giaTriHopDong,
        'ngayBanGiao': ngayBanGiao,
        'hoaHong': hoaHong,
        'trangThai': trangThai,
      };
}
