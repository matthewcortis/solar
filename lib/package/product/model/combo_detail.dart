import '../../model/tron_goi.dart';
import './device_model.dart';
import '../../utils/app_utils.dart';

/// Hàm đổi số tháng -> "X năm Y tháng"
String convertMonthToYearAndMonth(double months) {
  final totalMonths = months.isFinite ? months.ceil() : 0;
  final years = totalMonths ~/ 12;
  final remainMonths = totalMonths % 12;

  if (years > 0 && remainMonths > 0) {
    return '$years năm $remainMonths tháng';
  } else if (years > 0) {
    return '$years năm';
  } else {
    return '$remainMonths tháng';
  }
}

/// Model gom những dữ liệu cần dùng cho màn detail
class TronGoiDetailData {
  final String? imageUrl; // tepTin.duongDan
  final String comboName; // ten
  final num totalPrice; // tongGia (giá trọn gói)
  final String description; // moTa
  final int sanLuongMin; // sanLuongToiThieu
  final int sanLuongMax; // sanLuongToiDa
  final double sanLuongTB; // (min + max) / 2
  final double? soThangHoanVon; // tongGia / sanLuongTB
  final String? showingTime; // convertMonthToYearAndMonth(soThangHoanVon)
  final double? dungLuongLuuTruKwh;

  final num?
  congSuatTamPin; // vatTu.nhomVatTu.ma == 'TAM_PIN' -> duLieuRieng['cong_suat']
  final num?
  congSuatBienTan; // vatTu.nhomVatTu.ma == 'BIEN_TAN' -> duLieuRieng['cong_suat']

  final String?
  kichThuocTamPinText; // duLieuRieng['kich_thuoc'].giaTri (vd: "2278 x 1134 x 30")
  final double? dienTichTamPinM2; // (dài_mm * rộng_mm) / 1_000_000

  TronGoiDetailData({
    required this.imageUrl,
    required this.comboName,
    required this.totalPrice,
    required this.description,
    required this.sanLuongMin,
    required this.sanLuongMax,
    required this.sanLuongTB,
    required this.soThangHoanVon,
    required this.showingTime,
    required this.congSuatTamPin,
    required this.congSuatBienTan,
    required this.kichThuocTamPinText,
    required this.dienTichTamPinM2,
    required this.dungLuongLuuTruKwh,
  });
}

/// =============================
///  EXTENSION TRÊN TronGoiBase
/// =============================
extension TronGoiComputed on TronGoiBase {
  /// tepTin.duongDan
  String? get imageUrl => tepTin?.duongDan;

  /// tên combo
  String get comboName => ten;

  /// tổng giá trọn gói
  num get totalPrice => tongGia;

  /// mô tả
  String get description => moTa ?? '';

  /// sản lượng tối thiểu
  int get sanLuongMin => sanLuongToiThieu ?? 0;

  /// sản lượng tối đa
  int get sanLuongMax => sanLuongToiDa ?? 0;

  /// sản lượng TB
  double get sanLuongTB {
    if (sanLuongMin == 0 && sanLuongMax == 0) return 0;
    return (sanLuongMin + sanLuongMax) / 2.0;
  }

  /// số tháng hoàn vốn
  double? get soThangHoanVon {
    if (sanLuongTB <= 0) return null;
    return totalPrice / (sanLuongTB * 3000);
  }

  /// thời gian hiển thị hoàn vốn
  String? get showingTime {
    final months = soThangHoanVon;
    if (months == null || !months.isFinite) return null;
    return convertMonthToYearAndMonth(months);
  }

  /// =============================
  ///  Helper nội bộ
  /// =============================

  VatTuTronGoi? _findVatTuByGroupCode(String groupCode) {
    for (final item in vatTuTronGois) {
      final maNhom = item.vatTu.nhomVatTu?.ma;
      if (maNhom == groupCode) {
        return item;
      }
    }
    return null;
  }

  num? _parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      final normalized = value.replaceAll('.', '').replaceAll(',', '.');
      return num.tryParse(normalized);
    }
    return null;
  }

  /// Lấy thuộc tính động kiểu số theo mã nhóm + key
  num? _getNumericAttr(String groupCode, String key) {
    final vtItem = _findVatTuByGroupCode(groupCode);
    if (vtItem == null) return null;
    final attr = vtItem.vatTu.duLieuRieng[key];
    return _parseNum(attr?.giaTri);
  }

  /// =============================
  ///  Công suất theo nhóm vật tư
  /// =============================

  /// Công suất tấm pin (vatTu.nhomVatTu.ma == 'TAM_PIN' -> duLieuRieng.cong_suat)
  num? get congSuatTamPin => _getNumericAttr('TAM_PIN', 'cong_suat');

  /// Công suất biến tần (vatTu.nhomVatTu.ma == 'BIEN_TAN' -> duLieuRieng.cong_suat)
  num? get congSuatBienTan => _getNumericAttr('BIEN_TAN', 'cong_suat');

  /// Dung lượng pin lưu trữ (vatTu.nhomVatTu.ma == 'PIN_LUU_TRU' -> duLieuRieng.dung_luong)
  double? get dungLuongLuuTruKwh {
    final val = _getNumericAttr('PIN_LUU_TRU', 'dung_luong');
    return val?.toDouble();
  }

  /// =============================
  ///  Kích thước & diện tích tấm pin
  /// =============================

  /// Text kích thước gốc, ví dụ: "2278 x 1134 x 30"
  String? get kichThuocTamPinText {
    final vtItem = _findVatTuByGroupCode('TAM_PIN');
    final attr = vtItem?.vatTu.duLieuRieng['kich_thuoc'];
    return attr?.giaTri?.toString();
  }

  /// Diện tích tấm pin (m2) = dài_mm * rộng_mm *  so luong tam pin

double? get dienTichTamPinM2 {
  final raw = kichThuocTamPinText;
  if (raw == null || raw.isEmpty) return null;

  // Tách theo 'x', 'X' hoặc '×'
  final parts = raw.split(RegExp(r'[xX×]')).map((e) => e.trim()).toList();
  if (parts.length < 2) return null;

  // Loại bỏ ký tự không phải số, chấm, phẩy
  double? parseMm(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9,\.]'), '');
    final normalized = cleaned.replaceAll(',', '.'); // đổi "2,5" -> "2.5"
    return double.tryParse(normalized);
  }

  final daiMm = parseMm(parts[0]);
  final rongMm = parseMm(parts[1]);

  if (daiMm == null || rongMm == null) return null;

  // Tìm vật tư tấm pin để lấy số lượng
  final vtTamPin = _findVatTuByGroupCode('TAM_PIN');
  final num soLuongRaw = vtTamPin?.soLuong ?? 1;
  final double soLuong =
      soLuongRaw <= 0 ? 1 : soLuongRaw.toDouble(); // fallback

  // Đổi mm -> m
  final daiM = daiMm / 1000.0;
  final rongM = rongMm / 1000.0;

  // Kết quả diện tích
  final area = daiM * rongM * soLuong;

  // Làm tròn chữ số thập phân
  return area.ceilToDouble();
}


  List<VatTuTronGoi> get mainVisibleVatTus {
    // Thứ tự ưu tiên hiển thị: Tấm pin -> Biến tần -> Pin lưu trữ
    const priorityOrder = ['TAM_PIN', 'BIEN_TAN', 'PIN_LUU_TRU'];

    // LỌC: vatTuChinh == true && duocXem == true
    final list = vatTuTronGois.where((item) {
      final isChinh = item.vatTu.nhomVatTu?.vatTuChinh == true;
      final isXem = item.duocXem == true;
      return isChinh && isXem;
    }).toList();

    // SẮP XẾP theo ma nhóm ưu tiên
    list.sort((a, b) {
      String? maA = a.vatTu.nhomVatTu?.ma;
      String? maB = b.vatTu.nhomVatTu?.ma;

      int idx(String? ma) {
        final i = ma != null ? priorityOrder.indexOf(ma) : -1;
        return i == -1 ? priorityOrder.length : i;
      }

      return idx(maA).compareTo(idx(maB));
    });

    return list;
  }

  List<VatTuTronGoi> get otherVisibleVatTus {
    final priority = {
      'HE_KHUNG_NHOM': 1,
      'HE_DAY_DIEN': 2,
      'HE_TIEP_DIA': 3,
      'TRON_GOI_LAP_DAT': 4,
    };

    // LỌC: vatTuChinh == false && duocXem == true
    final list = vatTuTronGois.where((e) {
      final nhom = e.vatTu.nhomVatTu;
      final bool isOther = nhom?.vatTuChinh == false; // xử lý nullable
      final bool isVisible = e.duocXem == true;
      return isOther && isVisible;
    }).toList();

    // SẮP XẾP theo ma nhóm ưu tiên
    list.sort((a, b) {
      final maA = a.vatTu.nhomVatTu?.ma; // thêm ?
      final maB = b.vatTu.nhomVatTu?.ma;

      final pA = priority[maA] ?? 999;
      final pB = priority[maB] ?? 999;

      return pA.compareTo(pB);
    });

    return list;
  }

  /// =============================
  ///  Gộp tất cả dữ liệu cần cho detail
  /// =============================
  TronGoiDetailData toDetailData() {
    final image = imageUrl;
    final name = comboName;
    final price = totalPrice;
    final desc = description;

    final minSL = sanLuongMin;
    final maxSL = sanLuongMax;
    final tbSL = sanLuongTB;
    final months = soThangHoanVon;
    final timeText = months != null && months.isFinite
        ? convertMonthToYearAndMonth(months)
        : null;

    final csTamPin = congSuatTamPin;
    final csBienTan = congSuatBienTan;
    final kichThuocText = kichThuocTamPinText;
    final areaM2 = dienTichTamPinM2;
    final luuTruKwh = dungLuongLuuTruKwh;
    return TronGoiDetailData(
      imageUrl: image,
      comboName: name,
      totalPrice: price,
      description: desc,
      sanLuongMin: minSL,
      sanLuongMax: maxSL,
      sanLuongTB: tbSL,
      soThangHoanVon: months,
      showingTime: timeText,
      congSuatTamPin: csTamPin,
      congSuatBienTan: csBienTan,
      kichThuocTamPinText: kichThuocText,
      dienTichTamPinM2: areaM2,
      dungLuongLuuTruKwh: luuTruKwh,
    );
  }

  List<ProductDeviceModel> get mainDeviceProducts {
    return mainVisibleVatTus.map((item) {
      final vatTu = item.vatTu;

      final String imageUrl = tepTin?.duongDan ?? '';

      final String quantityTag = 'x ${item.soLuong} ${vatTu.donVi}';

      // Bảo hành
      final String warrantyText = item.duocBaoHanh == true
          ? 'Bảo hành ${item.gm ?? ''} năm'
          : 'Không bảo hành';

      String formatVnd(num value) {
        return AppUtils.formatVNDNUM(value);
      }

      final String priceText = '${formatVnd(item.gia)} ';

      // Công suất: lấy từ duLieuRieng['cong_suat'] nếu có
      final congSuatAttr = vatTu.duLieuRieng['cong_suat'];
      final String powerText = congSuatAttr?.giaTri?.toString() ?? '';

      // Công nghệ: lấy từ duLieuRieng['cong_nghe'] nếu có
      final congNgheAttr = vatTu.duLieuRieng['cong_nghe'];
      final String technologyText = congNgheAttr?.giaTri?.toString() ?? '';
      final String groupCode = vatTu.nhomVatTu?.ma ?? '';

      final dungLuongAttr = vatTu.duLieuRieng['dung_luong'];
      final String capacityText = dungLuongAttr?.giaTri?.toString() ?? '';

      return ProductDeviceModel(
        id: vatTu.id, // nếu model có field id
        image: imageUrl,
        groupCode: groupCode,
        title: vatTu.ten,
        quantityTag: quantityTag,
        warranty: warrantyText,
        price: priceText,
        power: powerText,
        technology: technologyText,
        capacity: capacityText,
      );
    }).toList();
  }
}
