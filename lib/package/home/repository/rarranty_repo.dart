
import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';
class WarrantyRepository {
  Future<HopDongBaoHanhDto?> getHopDongById(int id) async {
    final body = {
      "filters": [
        {
          "fieldName": "id",
          "operation": "EQUALS",
          "value": id,
          "logicType": "AND"
        }
      ],
      "sorts": [
        {"fieldName": "id", "direction": "ASC"}
      ],
      "page": 0,
      "size": 100
    };

    final res = await ApiService.post("/basic-api/hop-dong/filter", body);

    final content = res['data']?['content'] as List? ?? [];
    if (content.isEmpty) return null;

    return HopDongBaoHanhDto.fromJson(content.first);
  }
}
