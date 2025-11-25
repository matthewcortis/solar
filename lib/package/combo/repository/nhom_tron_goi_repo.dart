import '../../api/api_service.dart';
import '../model/nhom_tron_goi_model.dart';

class NhomTronGoiRepository {
  Future<List<NhomTronGoiModel>> getAllNhomTronGoi() async {
    final res = await ApiService.get("/basic-api/nhom-tron-goi/all");

    final data = res["data"] as List;

    return data.map((e) => NhomTronGoiModel.fromJson(e)).toList();
  }
}
