class ProductHotModel {
  final int id;
  final String name;
  final String price;
  final String type;
  final String phase;
  final String saving;
  final String image;

  ProductHotModel({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.phase,
    required this.saving,
    required this.image,
  });

  factory ProductHotModel.fromJson(Map<String, dynamic> json) {
    return ProductHotModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      type: json['type'] ?? '',
      phase: json['phase'] ?? '',
      saving: json['saving'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'type': type,
        'phase': phase,
        'saving': saving,
        'image': image,
      };
}
