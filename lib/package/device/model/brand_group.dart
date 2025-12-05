// lib/device/widgets/brand_group.dart
import '../../model/tron_goi_models.dart';

class BrandMeta {
  final String? localIconAsset; // icon fallback từ assets
  final String description;

  const BrandMeta({
    this.localIconAsset,
    required this.description,
  });
}

/// Map meta: mô tả + icon fallback cho từng thương hiệu
const Map<String, BrandMeta> kBrandMetaMap = {
  // Ví dụ, bạn sửa lại tên cho đúng với DB:
  'JA SOLAR': BrandMeta(
    localIconAsset: 'assets/images/ja.png',
    description: 'JA Solar là thương hiệu tấm pin hiệu suất cao, độ bền tốt.',
  ),
  'Canadian Solar': BrandMeta(
    localIconAsset: 'assets/images/canadian.png',
    description: 'Canadian Solar nổi bật về hiệu suất ổn định và độ tin cậy.',
  ),
  'Solis': BrandMeta(
    localIconAsset: 'assets/images/soliss.png',
    description: 'Solis là thương hiệu biến tần của Ginlong, phổ biến toàn cầu.',
  ),
  'Dyness': BrandMeta(
    localIconAsset: 'assets/images/dyness.png',
    description: 'Dyness tập trung vào hệ thống pin lưu trữ an toàn, bền bỉ.',
  ),
};

const BrandMeta kDefaultBrandMeta = BrandMeta(
  localIconAsset: 'assets/images/default_brand.png',
  description: 'Thương hiệu thiết bị điện mặt trời chất lượng.',
);

class BrandGroup {
  final String brandKey;

  final String brandName;

  final TepTinDto? logoFile;

  final String description;

  final List<VatTuDto> products;

  BrandGroup({
    required this.brandKey,
    required this.brandName,
    required this.logoFile,
    required this.description,
    required this.products,
  });
}

String _extractBrandKey(VatTuDto v) {
  final thuongHieu = v.thuongHieu;
  if (thuongHieu.tenQuocTe.trim().isNotEmpty) {
    return thuongHieu.tenQuocTe.trim();
  }
  if (thuongHieu.ten.trim().isNotEmpty) {
    return thuongHieu.ten.trim();
  }
  return 'Khác';
}

/// Tên hiển thị thương hiệu
String _extractBrandName(VatTuDto v) {
  final name = v.thuongHieu.ten.trim();
  if (name.isNotEmpty) return name;
  final intlName = v.thuongHieu.tenQuocTe.trim();
  if (intlName.isNotEmpty) return intlName;
  return 'Thương hiệu khác';
}

List<BrandGroup> buildBrandGroups(List<VatTuDto> items) {
  final Map<String, List<VatTuDto>> grouped = {};

  for (final v in items) {
    final key = _extractBrandKey(v);
    grouped.putIfAbsent(key, () => []).add(v);
  }

  final List<BrandGroup> result = [];

  grouped.forEach((brandKey, list) {
    if (list.isEmpty) return;

    final first = list.first;
    final brandName = _extractBrandName(first);
    final meta = kBrandMetaMap[brandKey] ?? kBrandMetaMap[brandName] ?? kDefaultBrandMeta;

    result.add(
      BrandGroup(
        brandKey: brandKey,
        brandName: brandName,
        logoFile: first.thuongHieu.tepTin, // logo từ API
        description: meta.description,
        products: list,
      ),
    );
  });

  // Sort theo tên thương hiệu
  result.sort((a, b) => a.brandName.compareTo(b.brandName));
  return result;
}
