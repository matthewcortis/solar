// lib/repository/bai_viet_repository.dart
import '../../api/api_service.dart';
import '../model/bai_viet_model.dart';

class BaiVietRepository {
  // Lấy danh sách bài viết theo loaiBaiViet (ví dụ MEGA_STORY)
  Future<List<BaiVietModel>> getBaiVietByLoai({
    required String loaiBaiViet, // "MEGA_STORY", "HOI_DAP", ...
    int page = 0,
    int size = 3,
  }) async {
    final body = {
      "filters": [
        {
          "fieldName": "loaiBaiViet",
          "operation": "EQUALS",
          "value": loaiBaiViet,
          "logicType": "AND",
        },
      ],
      "sorts": [
        {"fieldName": "taoLuc", "direction": "DESC"},
      ],
      "page": page,
      "size": size,
    };

    final response = await ApiService.post("/basic-api/bai-viet/filter", body);

    // response root: { status, data: { content: [...] }, message, timestamp }
    final data = response['data'];
    final List<dynamic> content = data['content'] ?? [];

    return content
        .map((item) => BaiVietModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Nếu cần lấy chi tiết 1 bài (id -> rồi từ noiDung.duongDan load text)

  Future<List<BaiVietModel>> getMegaStory({int page = 0, int size = 100}) {
    return getBaiVietByLoai(loaiBaiViet: "MEGA_STORY", page: page, size: size);
  }

    Future<List<BaiVietModel>> getHuongDan({int page = 0, int size = 100}) {
    return getBaiVietByLoai(loaiBaiViet: "HUONG_DAN_BAO_HANH", page: page, size: size);
  }

  Future<List<BaiVietModel>> getHoiDap({int page = 0, int size = 100}) {
    return getBaiVietByLoai(loaiBaiViet: "HOI_DAP", page: page, size: size);
  }
}
