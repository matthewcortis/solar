import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';

class TronGoiRepository {
  Future<List<TronGoiDto>> getDanhSachBanChay() async {
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
          (e) => TronGoiDto.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
