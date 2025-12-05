import '../../model/tron_goi_models.dart';

class CategoryModel {
  final int id;

  final String categoryName;

  final List<VatTuDto> products;

  CategoryModel({
    required this.id,
    required this.categoryName,
    // required this.categoryIcon,
    // required this.categoryDes,
    required this.products,
  });
}
