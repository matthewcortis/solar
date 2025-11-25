// lib/package/product/model/product_detail_model.dart
class ProductDetailModel {
  final int id;
  final String code;
  final String name;
  final String brandName;
  final String unit;

  // Link datasheet
  final String? sheetLink;

  // Các trường thông số kỹ thuật từ duLieuRieng
  final String tech;       // công_nghe
  final String power;      // cong_suat
  final String efficiency; // hieu_suat
  final String weight;     // khoi_luong
  final String size;       // kich_thuoc

  // Giá bán
  final double? price;

  ProductDetailModel({
    required this.id,
    required this.code,
    required this.name,
    required this.brandName,
    required this.unit,
    required this.tech,
    required this.power,
    required this.efficiency,
    required this.weight,
    required this.size,
    required this.price,
    this.sheetLink,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final duLieu = json['duLieuRieng'] as Map<String, dynamic>?;

    String getGiaTri(String key) {
      final v = duLieu?[key];
      if (v is Map && v['giaTri'] != null) {
        return v['giaTri'].toString();
      }
      return '';
    }

    double? getPrice() {
      final thongTinGias = json['thongTinGias'];
      if (thongTinGias is List && thongTinGias.isNotEmpty) {
        final first = thongTinGias.first;
        final dsGia = first['dsGia'];
        if (dsGia is List && dsGia.isNotEmpty) {
          final giaBan = dsGia.first['giaBan'];
          if (giaBan is num) return giaBan.toDouble();
        }
      }
      return null;
    }

    return ProductDetailModel(
      id: json['id'] as int,
      code: (json['ma'] ?? '').toString(),
      name: (json['ten'] ?? '').toString(),
      brandName: (json['thuongHieu']?['ten'] ?? '').toString(),
      unit: (json['donVi'] ?? '').toString(),
      sheetLink: json['sheetLink']?.toString(),
      tech: getGiaTri('cong_nghe'),
      power: getGiaTri('cong_suat'),
      efficiency: getGiaTri('hieu_suat'),
      weight: getGiaTri('khoi_luong'),
      size: getGiaTri('kich_thuoc'),
      price: getPrice(),
    );
  }
}
