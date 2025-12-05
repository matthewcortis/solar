import '../api/api_service.dart';
import '../model/tron_goi_models.dart';

class QuangCaoRepository {
  Future<List<QuangCaoModel>> getQuangCaoByViTri(
    String viTri, {
    int page = 0,
    int size = 20,
  }) async {
    final body = {
      "filters": [
        {
          "fieldName": "viTri",
          "operation": "EQUALS",
          "value": viTri,
          "logicType": "AND",
        },
      ],
      "sorts": [],
      "page": page,
      "size": size,
    };

    final res =
        await ApiService.post("/basic-api/quang-cao/filter", body);

    final content = res["data"]["content"] as List<dynamic>;
    return content
        .map((e) => QuangCaoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<QuangCaoModel?> getFirstByViTri(String viTri) async {
    final list = await getQuangCaoByViTri(viTri, page: 0, size: 1);
    if (list.isEmpty) return null;
    return list.first;
  }
}
