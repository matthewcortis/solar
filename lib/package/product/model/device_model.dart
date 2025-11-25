class ProductDeviceModel {
  final int id;
  final String image;
  final String groupCode;
  final String title;
  final String quantityTag;
  final String warranty;
  final String price;
  final String power;
  final String technology;
  final String capacity; // <--- thêm mới

  ProductDeviceModel({
    required this.id,
    required this.image,
    required this.groupCode,
    required this.title,
    required this.quantityTag,
    required this.warranty,
    required this.price,
    required this.power,
    required this.technology,
    required this.capacity, // <--- thêm mới
  });
}
