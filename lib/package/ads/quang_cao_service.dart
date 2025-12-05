import '../model/tron_goi_models.dart';
import './quang_cao_repository.dart';
class QuangCaoBannerService {
  QuangCaoBannerService._internal();

  static final QuangCaoBannerService instance =
      QuangCaoBannerService._internal();

  final QuangCaoRepository _repo = QuangCaoRepository();

  final Map<String, Future<List<QuangCaoModel>>> _bannerListCache = {};

  Future<List<QuangCaoModel>> getBannersByViTri(String viTri) {
    if (_bannerListCache.containsKey(viTri)) {
      return _bannerListCache[viTri]!;
    }

    final future = _repo.getQuangCaoByViTri(viTri).catchError((e) {
      return <QuangCaoModel>[];
    });

    _bannerListCache[viTri] = future;
    return future;
  }

  Future<QuangCaoModel?> getFirstBannerByViTri(String viTri) async {
    final list = await getBannersByViTri(viTri);
    if (list.isEmpty) return null;
    return list.first;
  }

  Future<List<String>> getBannerUrls(String viTri) async {
    final list = await getBannersByViTri(viTri);
    return list
        .map((e) => e.tepTin?.duongDan ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  Future<String?> getFirstBannerUrl(String viTri) async {
    final urls = await getBannerUrls(viTri);
    if (urls.isEmpty) return null;
    return urls.first;
  }

  Future<List<String>> getTrangChuBannerUrls() =>
      getBannerUrls('TRANG_CHU');

  Future<List<String>> getBaoGiaBannerUrls() =>
      getBannerUrls('BAO_GIA');

  Future<String?> getTrangChuFirstBannerUrl() =>
      getFirstBannerUrl('TRANG_CHU');

  Future<String?> getBaoGiaFirstBannerUrl() =>
      getFirstBannerUrl('BAO_GIA');
}
