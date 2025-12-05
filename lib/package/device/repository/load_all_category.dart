import '../model/category.dart';
import '../../model/tron_goi_models.dart';
import './vat_tu_repository.dart';

Future<List<CategoryModel>> loadAllCategories() async {
  final repo = DeviceRepository();

  final results = await Future.wait([
    repo.getPanels(),
    repo.getInverters(),
    repo.getBatteries(),
  ]);

  final List<VatTuDto> panels = results[0];
  final List<VatTuDto> inverters = results[1];
  final List<VatTuDto> batteries = results[2];

  return [
    CategoryModel(
      id: 1,
      categoryName: 'Tấm quang năng',
      products: panels,
    ),
    CategoryModel(
      id: 2,
      categoryName: 'Biến tần',
      products: inverters,
    ),
    CategoryModel(
      id: 3,
      categoryName: 'Pin Lithium',
      products: batteries,
    ),
  ];
}

Future<CategoryModel> loadCategoryById(int id) async {
  final repo = DeviceRepository();

  switch (id) {
    case 1:
      return CategoryModel(
        id: 1,
        categoryName: 'Tấm quang năng',
        products: await repo.getPanels(),
      );
    case 2:
      return CategoryModel(
        id: 2,
        categoryName: 'Biến tần',
        products: await repo.getInverters(),
      );
    case 3:
      return CategoryModel(
        id: 3,
        categoryName: 'Pin Lithium',
        products: await repo.getBatteries(),
      );
    default:
      return CategoryModel(
        id: 0,
        categoryName: 'Danh mục khác',
        products: const [],
      );
  }
}
