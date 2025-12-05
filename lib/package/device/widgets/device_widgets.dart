import 'package:flutter/material.dart';
import '../widgets/product_device_card.dart';
import '../../model/tron_goi_models.dart'; 
import '../model/category.dart';

/// ----------------- BRAND GROUP HELPER -----------------

class _BrandGroup {
  final String key;
  final String name; 
  final TepTinDto? logoFile;
  final String description;
  final List<VatTuDto> products;

  _BrandGroup({
    required this.key,
    required this.name,
    required this.logoFile,
    required this.description,
    required this.products,
  });
}

const Map<String, String> _brandDescriptions = {
  'JA SOLAR':
      'JA Solar là thương hiệu tấm pin hiệu suất cao, độ bền tốt, phổ biến toàn cầu.',
  'Canadian Solar':
      'Canadian Solar nổi bật về hiệu suất ổn định và độ tin cậy ở nhiều điều kiện khí hậu.',
  'Solis': 'Solis',
  'Dyness': 'Dyness',
};

String _extractBrandKey(VatTuDto v) {
  final intl = v.thuongHieu.tenQuocTe.trim();
  if (intl.isNotEmpty) return intl;
  final name = v.thuongHieu.ten.trim();
  if (name.isNotEmpty) return name;
  return 'Khác';
}

String _extractBrandName(VatTuDto v) {
  final name = v.thuongHieu.ten.trim();
  if (name.isNotEmpty) return name;
  final intl = v.thuongHieu.tenQuocTe.trim();
  if (intl.isNotEmpty) return intl;
  return 'Thương hiệu khác';
}

List<_BrandGroup> _buildBrandGroups(List<VatTuDto> items) {
  final Map<String, List<VatTuDto>> grouped = {};

  for (final v in items) {
    final key = _extractBrandKey(v);
    grouped.putIfAbsent(key, () => []).add(v);
  }

  final List<_BrandGroup> result = [];

  grouped.forEach((key, list) {
    if (list.isEmpty) return;

    final first = list.first;
    final brandName = _extractBrandName(first);

    final String apiDesc = (first.thuongHieu.moTa ?? '').trim();

    final String fallbackDesc =
        _brandDescriptions[key] ?? _brandDescriptions[brandName] ?? '';

    final String desc = apiDesc.isNotEmpty ? apiDesc : fallbackDesc;

    result.add(
      _BrandGroup(
        key: key,
        name: brandName,
        logoFile: first.thuongHieu.tepTin,
        description: desc,
        products: list,
      ),
    );
  });

  result.sort((a, b) => a.name.compareTo(b.name));
  return result;
}

/// ----------------- DEVICE WIDGET SECTION -----------------

class DeviceWidgetSection extends StatelessWidget {
  final CategoryModel category;
  final void Function(String, List<VatTuDto>) onShowAll;

  const DeviceWidgetSection({
    super.key,
    required this.category,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    final List<_BrandGroup> brandGroups = _buildBrandGroups(category.products);

    return Container(
      width: scale(398),
      margin: EdgeInsets.symmetric(horizontal: scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header danh mục ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.categoryName,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(16),
                  height: 24 / 16,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    onShowAll(category.categoryName, category.products),
                child: Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: scale(14),
                    height: 20 / 14,
                    color: const Color(0xFFEE4037),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFEE4037),
                    decorationThickness: 1.6,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: scale(16)),

          // --- Danh sách các thương hiệu bên trong danh mục ---
          for (final brand in brandGroups) ...[
            _BrandBlock(
              brand: brand,
              categoryName: category.categoryName,
              onShowAll: onShowAll,
            ),
            if (brand != brandGroups.last)
              Padding(
                padding: EdgeInsets.symmetric(vertical: scale(12)),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: const Color(0xFFE0E0E0),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// ----------------- BRAND BLOCK -----------------

class _BrandBlock extends StatelessWidget {
  final _BrandGroup brand;
  final String categoryName;
  final void Function(String, List<VatTuDto>) onShowAll;

  const _BrandBlock({
    required this.brand,
    required this.categoryName,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _BrandLogo(brand: brand),
            SizedBox(width: scale(8)),
            Expanded(
              child: Text(
                brand.name,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(15),
                  height: 22 / 15,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () =>
            //       onShowAll('$categoryName - ${brand.name}', brand.products),
            //   child: Text(
            //     'Xem chi tiết',
            //     style: TextStyle(
            //       fontFamily: 'SFProDisplay',
            //       fontWeight: FontWeight.w500,
            //       fontSize: scale(13),
            //       height: 18 / 13,
            //       color: const Color(0xFF2F80ED),
            //       decoration: TextDecoration.underline,
            //       decorationColor: const Color(0xFF2F80ED),
            //       decorationThickness: 1.4,
            //     ),
            //   ),
            // ),
          ],
        ),

        if (brand.description.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: scale(4), bottom: scale(8)),
            child: Text(
              brand.description,
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400,
                fontSize: scale(12),
                height: 18 / 12,
                color: const Color(0xFF828282),
              ),
            ),
          ),

        // --- Danh sách sản phẩm của thương hiệu (scroll ngang) ---
        SizedBox(
          height: scale(480), 
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: brand.products.length,
            separatorBuilder: (_, __) => SizedBox(width: scale(16)),
            itemBuilder: (context, index) {
              final VatTuDto product = brand.products[index];
              return SizedBox(
                width: scale(280),
                child: ProductDeviceCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// ----------------- BRAND LOGO -----------------

class _BrandLogo extends StatelessWidget {
  final _BrandGroup brand;

  const _BrandLogo({required this.brand});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    final TepTinDto? logoFile = brand.logoFile;

    if (logoFile != null && logoFile.duongDan.isNotEmpty) {
      final imageUrl = logoFile.duongDan;

      return ClipRRect(
        borderRadius: BorderRadius.circular(scale(6)),
        child: Image.network(
          imageUrl,
          width: scale(50),
          height: scale(32),
          fit: BoxFit.contain
        ),
      );
    }

    return Container(
      width: scale(50),
      height: scale(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(scale(6)),
        color: const Color(0xFFE0E0E0),
      ),
      child: Text(
        brand.name.isNotEmpty ? brand.name[0] : '?',
        style: TextStyle(
          fontFamily: 'SFProDisplay',
          fontWeight: FontWeight.w600,
          fontSize: scale(14),
          color: const Color(0xFF4F4F4F),
        ),
      ),
    );
  }
}
