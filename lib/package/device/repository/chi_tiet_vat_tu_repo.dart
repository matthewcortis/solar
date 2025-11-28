// lib/package/product/repository/product_repository.dart
import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';

class ProductRepository {
  Future<VatTuDto?> getProductDetailById(int id) async {
    final body = {
      "filters": [
        {
          "fieldName": "id",
          "operation": "EQUALS",
          "value": id,
          "logicType": "OR",
        }
      ],
      "sorts": [],
      "page": 0,
      "size": 1,
    };

    final res = await ApiService.post("/basic-api/vat-tu/filter", body);
    final data = res['data'];
    if (data == null) return null;

    final content = data['content'];
    if (content is List && content.isNotEmpty) {
      return VatTuDto.fromJson(content.first);
    }
    return null;
  }
}
