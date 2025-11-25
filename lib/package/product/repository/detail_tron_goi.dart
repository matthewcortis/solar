import '../../api/api_service.dart';
import '../../model/tron_goi.dart'; 

class TronGoiRepository {
  TronGoiRepository();

  Future<TronGoiBase> getTronGoiById(int id) async {

    final raw = await ApiService.get('/basic-api/tron-goi/$id');

    final response = TronGoiResponse.fromJson(raw as Map<String, dynamic>);

    if (response.status != 200) {
      throw Exception('Lấy chi tiết trọn gói thất bại, status: ${response.status}');
    }

    return response.data; 
  }

  ///muốn nhận luôn cả wrapper `TronGoiResponse`
  Future<TronGoiResponse> getTronGoiResponseById(int id) async {
    final raw = await ApiService.get('/basic-api/tron-goi/$id');
    return TronGoiResponse.fromJson(raw as Map<String, dynamic>);
  }
}
