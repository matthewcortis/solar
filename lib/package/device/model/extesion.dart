// extesion.dart (đặt đúng đường dẫn bạn đang import)
import '../model/product_device_model.dart';
import '../../model/tron_goi.dart';

String convertMonthToYearAndMonth(num months) {
  final total = months.isFinite ? months.ceil() : 0;
  final y = total ~/ 12;
  final m = total % 12;

  if (y > 0 && m > 0) return "$y năm $m tháng";
  if (y > 0) return "$y năm";
  if (m > 0) return "$m tháng";
  return "0 tháng";
}

/// Extension trên model mới: VatTu (trong tron_goi.dart)
extension VatTuToDevice on VatTu {
  num get _price {
    if (thongTinGias.isEmpty) return 0;
    final firstThongTin = thongTinGias.first;
    if (firstThongTin.dsGia.isEmpty) return 0;
    return firstThongTin.dsGia.first.giaBan;
  }

  String get _image {
    if (anhVatTus.isEmpty) return 'assets/images/product.png';

    final first = anhVatTus.first;

    // Nếu backend trả kiểu {"duongDan": "..."}
    if (first is Map<String, dynamic>) {
      final path = first['duongDan'];
      if (path is String && path.isNotEmpty) return path;

      // Nếu lồng trong "tepTin": {"tepTin": {"duongDan": "..."}}
      final tepTin = first['tepTin'];
      if (tepTin is Map<String, dynamic>) {
        final p2 = tepTin['duongDan'];
        if (p2 is String && p2.isNotEmpty) return p2;
      }
    }

    return 'assets/images/product.png';
  }

  String get _warrantyText {
    final gmValue = nhomVatTu?.gm ?? 0;
    if (gmValue == 0) return 'Không bảo hành';
    return convertMonthToYearAndMonth(gmValue);
  }

  ThuocTinhDong? _attr(String key) => duLieuRieng[key];

  String get _powerText {
    final attr = _attr('congSuat');
    if (attr == null || attr.giaTri == null) return '';
    final v = attr.giaTri;
    final u = attr.donVi;
    return '${v.toString()} ${u ?? ''}'.trim();
  }

  String get _technologyText {
    final mode = _attr('phanLoai')?.giaTri?.toString() ?? '';
    final pha = _attr('soPha')?.giaTri?.toString() ?? '';

    if (mode.isNotEmpty && pha.isNotEmpty) return '$mode - $pha';
    if (mode.isNotEmpty) return mode;
    return pha;
  }

  String get _quantityTagText => donVi;

  ProductDeviceModel toDeviceModel() {
    return ProductDeviceModel(
      id: id,
      image: _image,
      title: ten,
      warranty: _warrantyText,
      price: _price,
      power: _powerText,
      technology: _technologyText,
      quantityTag: _quantityTagText,
    );
  }
}
