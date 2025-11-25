import '../../api/api_service.dart';
import '../../model/hop_dong_model.dart';
import '../../controllers/login/auth_storage.dart';

class HopDongRepository {
  Future<List<HopDongModel>> getHopDongCuaUserDangNhap() async {
    final userIdStr = await AuthStorage.getUserId();
    if (userIdStr == null) return [];

    final userId = int.tryParse(userIdStr);
    if (userId == null) return [];

    final body = {
      "filters": [
        {
          "fieldName": "nguoiGioiThieu.id",
          "operation": "EQUALS",
          "value": userId,
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
    final content = res["data"]["content"] as List<dynamic>;
    return content.map((e) => HopDongModel.fromJson(e)).toList();
  }
}
