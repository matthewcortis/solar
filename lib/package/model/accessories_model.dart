class AccessoriesModel {
  final int id;
  final String title;
  final String phase;      // "Hệ điện: 1 pha"
  final String accessory;  // "Phụ kiện: ..."
  final String image;      // asset path
  final int quantity;

  const AccessoriesModel({
    required this.id,
    required this.title,
    required this.phase,
    required this.accessory,
    required this.image,
    this.quantity = 0,
  });

  AccessoriesModel copyWith({
    int? id,
    String? title,
    String? phase,
    String? accessory,
    String? image,
    int? quantity,
  }) {
    return AccessoriesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      phase: phase ?? this.phase,
      accessory: accessory ?? this.accessory,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  factory AccessoriesModel.fromJson(Map<String, dynamic> j) => AccessoriesModel(
        id: j['id'] as int,
        title: j['title'] as String,
        phase: j['phase'] as String,
        accessory: j['accessory'] as String,
        image: j['image'] as String,
        quantity: (j['quantity'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'phase': phase,
        'accessory': accessory,
        'image': image,
        'quantity': quantity,
      };
}
