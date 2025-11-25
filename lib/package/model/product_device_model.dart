class ProductDeviceModel {
  final int id;
  final String image;
  final String title;
  final String warranty;
  final String price;
  final String power;
  final String technology;
  final String quantityTag;

  ProductDeviceModel({
    required this.id,
    required this.image,
    required this.title,
    required this.warranty,
    required this.price,
    required this.power,
    required this.technology,
    required this.quantityTag,
  });

  factory ProductDeviceModel.fromJson(Map<String, dynamic> json) {
    return ProductDeviceModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      warranty: json['warranty'] ?? '',
      price: json['price'] ?? '',
      power: json['power'] ?? '',
      technology: json['technology'] ?? '',
      quantityTag: json['quantityTag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
        'warranty': warranty,
        'price': price,
        'power': power,
        'technology': technology,
        'quantityTag': quantityTag,
      };
}
