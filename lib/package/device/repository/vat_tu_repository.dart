// lib/package/product/repository/vat_tu_repository.dart
import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';

class DeviceRepository {
  Future<List<VatTuDto>> _fetch(String maNhomVatTu) async {
    final body = BaseFilterRequest(
      filters: [
        FilterCriteria(
          fieldName: 'nhomVatTu.ma',   
          operation: 'EQUALS',
          value: maNhomVatTu,
          logicType: 'AND',
        ),
        FilterCriteria(
          fieldName: 'trangThai',   
          operation: 'EQUALS',
          value: "1",
          logicType: 'AND',
        ),
         FilterCriteria(
          fieldName: 'vatTuChinh',   
          operation: 'EQUALS',
          value: true,
          logicType: 'AND',
        ),
      ],
      sorts: [
        SortCriteria(fieldName: 'taoLuc', direction: 'ASC'),
      ],
      page: 0,
      size: 1000,
    ).toJson();

    final res = await ApiService.post("/basic-api/vat-tu/filter", body);

    final parsed = ResponseData<PageResponse<VatTuDto>>.fromJson(
      res as Map<String, dynamic>,
      (dataJson) => PageResponse<VatTuDto>.fromJson(
        dataJson as Map<String, dynamic>,
        (itemJson) => VatTuDto.fromJson(itemJson as Map<String, dynamic>),
      ),
    );

    return parsed.data.content; // List<VatTuDto>
  }

  Future<List<VatTuDto>> getPanels() async {
    return _fetch("TAM_PIN");
  }

  Future<List<VatTuDto>> getInverters() async {
    return _fetch("BIEN_TAN");
  }

  Future<List<VatTuDto>> getBatteries() async {
    return _fetch("PIN_LUU_TRU");
  }
}
