// lib/package/device/repository/warranty_repository.dart
import '../../api/api_service.dart'; // chỉnh lại path cho đúng
import '../../model/hop_dong_bao_hanh_model.dart';

class WarrantyRepository {
  Future<HopDongBaoHanh?> getHopDongById(int id) async {
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

    return HopDongBaoHanh.fromJson(content.first);
  }
}
