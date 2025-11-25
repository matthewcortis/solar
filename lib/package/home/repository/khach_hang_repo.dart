import '../../api/api_service.dart';
import '../../model/hop_dong_model.dart';
import '../../controllers/login/auth_storage.dart';
import '../../model/khach_hang.dart';

class KhachHangRepository {
  Future<List<CustomerDisplay>> getCustomersOfCurrentUser() async {
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

    final List<HopDongModel> hopDongs =
        content.map((e) => HopDongModel.fromJson(e)).toList();

    return hopDongs.map((h) {
      final kh = h.khachHang;
      final user = h.nguoiGioiThieu;

      final double tongGia = (h.tongGia ?? 0).toDouble();
      final double percent = (user?.phanTramHoaHong ?? 0).toDouble();
      final double hoaHong = tongGia * percent / 100;

      return CustomerDisplay(
        hopDongId: h.id ?? 0,
        hoTenKH: kh?.hoVaTen ?? "Không tên",
        tongGia: tongGia,
        ngayTao: DateTime.tryParse(h.taoLuc ?? "") ?? DateTime.now(),
        hoaHong: hoaHong,
      );
    }).toList();
  }
}
