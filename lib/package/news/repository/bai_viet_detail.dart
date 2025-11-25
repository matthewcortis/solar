
import '../../api/api_service.dart';
import '../model/bai_viet_model.dart';

class BaiVietRepository {
  // Hàm list có thể bạn đã có rồi, đây là hàm mới lấy theo id
  Future<BaiVietModel> getBaiVietById(int id) async {
    final body = {
      "filters": [
        {
          "fieldName": "id",
          "operation": "EQUALS",
          "value": id,
          "logicType": "AND"
        }
      ],
      "sorts": [],
      "page": 0,
      "size": 1
    };

    final res = await ApiService.post(
      "/basic-api/bai-viet/filter",
      body,
    );

    final data = res['data'];
    if (data == null || data['content'] == null) {
      throw Exception("Không có dữ liệu bài viết");
    }

    final content = data['content'] as List;
    if (content.isEmpty) {
      throw Exception("Không tìm thấy bài viết");
    }

    return BaiVietModel.fromJson(content.first as Map<String, dynamic>);
  }
}
