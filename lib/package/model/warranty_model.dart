class WarrantyItemModel {
  final String image;
  final String statusText;
  final String productName;
  final String activeDate;
  final String duration;
  final String endDate;
  final double progress;

  WarrantyItemModel({
    required this.image,
    required this.statusText,
    required this.productName,
    required this.activeDate,
    required this.duration,
    required this.endDate,
    required this.progress,
  });

  factory WarrantyItemModel.fromJson(Map<String, dynamic> json) {
    return WarrantyItemModel(
      image: json['image'],
      statusText: json['statusText'],
      productName: json['productName'],
      activeDate: json['activeDate'],
      duration: json['duration'],
      endDate: json['endDate'],
      progress: (json['progress'] as num).toDouble(),
    );
  }
}
