import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';

class NhomTronGoiRepository {
  Future<List<NhomTronGoiDto>> getAllNhomTronGoi() async {
    final res = await ApiService.get("/basic-api/nhom-tron-goi/all");

    final data = res["data"] as List;

    return data.map((e) => NhomTronGoiDto.fromJson(e)).toList();
  }
}
