// lib/package/product/repository/product_repository.dart
import '../../api/api_service.dart';
import '../../model/tron_goi_models.dart';

class ProductRepository {
  Future<VatTuDto?> getProductDetailById(int id) async {
    final body = BaseFilterRequest(
      filters: [
        FilterCriteria(
          fieldName: 'id',
          operation: 'EQUALS',
          value: id,
          logicType: 'AND',
        ),
      ],
      sorts: const [],
      page: 0,
      size: 1,
    ).toJson();

    final res = await ApiService.post("/basic-api/vat-tu/filter", body);

    final parsed = ResponseData<PageResponse<VatTuDto>>.fromJson(
      res as Map<String, dynamic>,
      (dataJson) => PageResponse<VatTuDto>.fromJson(
        dataJson as Map<String, dynamic>,
        (itemJson) => VatTuDto.fromJson(itemJson as Map<String, dynamic>),
      ),
    );

    final page = parsed.data;
    if (page.content.isEmpty) return null;

    return page.content.first;
  }
}
