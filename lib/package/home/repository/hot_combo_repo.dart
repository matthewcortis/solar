import '../../api/api_service.dart';
import '../model/tron_goi_hot.dart';

class TronGoiRepository {
  Future<List<TronGoiBanChayModel>> getDanhSachBanChay() async {
    final body = {
      "filters": [
        {
          "fieldName": "banChay",
          "operation": "EQUALS",
          "value": true,
          "logicType": "AND"
        }
      ],
      "sorts": [
        {
          "fieldName": "taoLuc",
          "direction": "DESC"
        }
      ],
      "page": 0,
      "size": 100
    };

    final raw = await ApiService.post('/basic-api/tron-goi/filter', body);

    final data = raw['data'] as Map<String, dynamic>;
    final List content = data['content'] as List;

    return content
        .map(
          (e) => TronGoiBanChayModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
