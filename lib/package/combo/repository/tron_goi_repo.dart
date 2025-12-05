import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';
import '../../controllers/login/auth_storage.dart';

class TronGoiRepository {
  Future<List<TronGoiDto>> fetchTronGoi({
    required int nhomTronGoiId,
    required String loaiHeThong, // "Hy-Brid" hoặc "On-Grid"
    int page = 0,
    int size = 1000,
  }) async {

    String? branchCode = await AuthStorage.getBranchCode();
    if (branchCode == null || branchCode.isEmpty) {
      branchCode = "HN"; 
    }
    final body = {
      "filters": [
        {
          "fieldName": "coSo.ma",
          "operation": "EQUALS",
          "value": branchCode,   
          "logicType": "AND"
        },
        {
          "fieldName": "nhomTronGoi.id",
          "operation": "EQUALS",
          "value": nhomTronGoiId,
          "logicType": "AND"
        },
        {
          "fieldName": "loaiHeThong",
          "operation": "EQUALS",
          "value": loaiHeThong,
          "logicType": "AND"
        }
      ],
      "sorts": [
        {
          "fieldName": "taoLuc",
          "direction": "DESC",
        }
      ],
      "page": page,
      "size": size,
    };

    final res = await ApiService.post("/basic-api/tron-goi/filter", body);

    final content = (res['data']?['content'] ?? []) as List;

    return content.map((e) => TronGoiDto.fromJson(e)).toList();
  }
}
