import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';

class TronGoiRepository {
  TronGoiRepository();

  Future<TronGoiDto> getTronGoiById(int id) async {
    final raw = await ApiService.get('/basic-api/tron-goi/$id');

    final response = ResponseData<TronGoiDto>.fromJson(
      raw as Map<String, dynamic>,
      (json) => TronGoiDto.fromJson(json as Map<String, dynamic>),
    );

    if (response.status != 200) {
      throw Exception(
        'Lấy chi tiết trọn gói thất bại, status: ${response.status}',
      );
    }

    return response.data;
  }

  Future<ResponseData<TronGoiDto>> getTronGoiResponseById(int id) async {
    final raw = await ApiService.get('/basic-api/tron-goi/$id');

    final response = ResponseData<TronGoiDto>.fromJson(
      raw as Map<String, dynamic>,
      (json) => TronGoiDto.fromJson(json as Map<String, dynamic>),
    );

    return response;
  }
}
