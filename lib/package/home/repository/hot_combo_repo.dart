import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';
import '../../controllers/login/auth_storage.dart';

class TronGoiRepository {
  Future<List<TronGoiDto>> getDanhSachBanChay({
    String? branchCodeOverride, 
  }) async {
    String? branchCode = branchCodeOverride ?? await AuthStorage.getBranchCode();

    if (branchCode == null || branchCode.isEmpty) {
      branchCode = 'HN';
    }

    final body = {
      "filters": [
        {
          "fieldName": "coSo.ma",
          "operation": "EQUALS",
          "value": branchCode,  
          "logicType": "AND",
        },
        {
          "fieldName": "banChay",
          "operation": "EQUALS",
          "value": true,
          "logicType": "AND",
        }
      ],
      "page": 0,
      "size": 20,
    };

    final res = await ApiService.post('/basic-api/tron-goi/filter', body);

    final response =
        ResponseData<PageResponse<TronGoiDto>>.fromJson(
      res as Map<String, dynamic>,
      (dataJson) => PageResponse<TronGoiDto>.fromJson(
        dataJson as Map<String, dynamic>,
        (itemJson) => TronGoiDto.fromJson(itemJson as Map<String, dynamic>),
      ),
    );

    final page = response.data;

    // (optional) debug để kiểm tra vị trí
    // debugPrint('getDanhSachBanChay branchCode = $branchCode, total = ${page.totalElements}');

    return page.content;
  }
}
