class NhomTronGoiModel {
  final int id;
  final String ten;

  NhomTronGoiModel({
    required this.id,
    required this.ten,
  });

  factory NhomTronGoiModel.fromJson(Map<String, dynamic> json) {
    return NhomTronGoiModel(
      id: json['id'],
      ten: json['ten'] ?? '',
    );
  }
}
