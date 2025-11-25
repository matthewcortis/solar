import '../../api/api_service.dart';

import '../model/extesion.dart'; // extension VatTu.toDeviceModel()
import '../model/product_device_model.dart';
import '../model/category.dart';

import '../../model/tron_goi.dart'; // chứa VatTu, VatTuFilterResponse

class DeviceRepository {
  Future<List<VatTu>> _fetch(String ma) async {
    final body = {
      "filters": [
        {
          "fieldName": "nhomVatTu.ma",
          "operation": "EQUALS",
          "value": ma,
          "logicType": "AND",
        },
      ],
      "sorts": [
        {"fieldName": "taoLuc", "direction": "ASC"},
      ],
      "page": 0,
      "size": 1000,
    };

    final res = await ApiService.post("/basic-api/vat-tu/filter", body);

    // Dùng model VatTuFilterResponse (model mới)
    final parsed = VatTuFilterResponse.fromJson(res as Map<String, dynamic>);
    return parsed.items; // List<VatTu>
  }

  Future<List<ProductDeviceModel>> getPanels() async {
    final data = await _fetch("TAM_PIN");
    return data.map((e) => e.toDeviceModel()).toList();
  }

  Future<List<ProductDeviceModel>> getInverters() async {
    final data = await _fetch("BIEN_TAN");
    return data.map((e) => e.toDeviceModel()).toList();
  }

  Future<List<ProductDeviceModel>> getBatteries() async {
    final data = await _fetch("PIN_LUU_TRU");
    return data.map((e) => e.toDeviceModel()).toList();
  }
}

Future<List<CategoryModel>> loadAllCategories() async {
  final repo = DeviceRepository();

  final results = await Future.wait([
    repo.getPanels(), // TAM_PIN
    repo.getInverters(), // BIEN_TAN
    repo.getBatteries(), // PIN_LUU_TRU
  ]);

  final panels = results[0];
  final inverters = results[1];
  final batteries = results[2];

  return [
    CategoryModel(
      id: 1,
      categoryName: 'Tấm quang năng',
      categoryIcon: 'assets/images/ja.png',
      categoryDes:
          'Thương hiệu JA SOLAR được thành lập từ năm 2005, tuy nhiên công ty mẹ tập đoàn Jinglong đã là nhà sản xuất các cấu phẩm năng lượng mặt trời như Cell & module từ những năm 1996. ',
      products: panels,
    ),
    CategoryModel(
      id: 2,
      categoryName: 'Biến tần',
      categoryIcon: 'assets/images/soliss.png',
      categoryDes:
          'Solis là thương hiệu của Ginlong, một nhà sản xuất biến tần năng lượng mặt trời lớn trên thế giới. Công ty được thành lập vào năm 2005, tập trung vào công nghệ biến tần chuỗi tiên tiến, độ tin cậy cao và dịch vụ khách hàng tại các thị trường Châu Âu, Châu Mỹ, và Châu Á. ',
      products: inverters,
    ),
    CategoryModel(
      id: 3,
      categoryName: 'Pin Lithium',
      categoryIcon: 'assets/images/dyness.png',
      categoryDes:
          'Thành lập năm 2017 tại Tô Châu, Trung Quốc, Dyness tập trung vào nghiên cứu, phát triển và sản xuất hệ thống pin lưu trữ năng lượng mặt trời tiên tiến',
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
        categoryIcon: 'assets/images/ja.png',
        categoryDes:
            'Thương hiệu JA SOLAR được thành lập từ năm 2005, tuy nhiên công ty mẹ tập đoàn Jinglong đã là nhà sản xuất các cấu phẩm năng lượng mặt trời như Cell & module từ những năm 1996. ',
        products: await repo.getPanels(),
      );

    case 2:
      return CategoryModel(
        id: 2,
        categoryName: 'Biến tần',
        categoryIcon: 'assets/images/soliss.png',
        categoryDes:
            'Solis là thương hiệu của Ginlong, một nhà sản xuất biến tần năng lượng mặt trời lớn trên thế giới. Công ty được thành lập vào năm 2005, tập trung vào công nghệ biến tần chuỗi tiên tiến, độ tin cậy cao và dịch vụ khách hàng tại các thị trường Châu Âu, Châu Mỹ, và Châu Á. ',
        products: await repo.getInverters(),
      );

    case 3:
      return CategoryModel(
        id: 3,
        categoryName: 'Pin Lithium',
        categoryIcon: 'assets/images/dyness.png',
        categoryDes:
            'Thành lập năm 2017 tại Tô Châu, Trung Quốc, Dyness tập trung vào nghiên cứu, phát triển và sản xuất hệ thống pin lưu trữ năng lượng mặt trời tiên tiến',
        products: await repo.getBatteries(),
      );

    default:
      return CategoryModel(
        id: 0,
        categoryName: 'Danh mục khác',
        categoryIcon: 'assets/icons/default.png',
        categoryDes: 'Các thiết bị khác.',
        products: [],
      );
  }
}
