import 'tron_goi_models.dart';
import 'package:intl/intl.dart';

class extBaoGiaTronGoi {
  extBaoGiaTronGoi._();
  static String formatCongSuatTong(String congSuat1BienTan, double soLuong) {
    if (congSuat1BienTan.isEmpty) return '';

    final parsed = num.tryParse(
      congSuat1BienTan.replaceAll(RegExp('[^0-9.]'), ''),
    );
    if (parsed == null) return congSuat1BienTan;

    final total = (parsed * soLuong) / 1000; // W → kW

    final isInt = total % 1 == 0;

    final display = isInt ? total.toInt().toString() : total.toStringAsFixed(1);

    return '$display kW';
  }
}

class TronGoiUtils {
  TronGoiUtils._(); // prevent instance

  static String formatCongSuatHeThong(num? value) {
    if (value == null) return '--';
    final kwp = value;
    if (value % 1 == 0) {
      return '${kwp.toStringAsFixed(0)} ';
    }
    return '${kwp.toStringAsFixed(1)} ';
  }

  static String formatMoney(num value) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(value)}đ';
  }

  static double? calcCongSuatByGroup(
    List<VatTuTronGoiDto> items,
    String group,
  ) {
    double totalWatt = 0;

    for (final item in items) {
      if (item.vatTu.nhomVatTu.ma != group) continue;

      final String key = (group == 'PIN_LUU_TRU') ? 'dung_luong' : 'cong_suat';

      final duLieu = item.vatTu.duLieuRieng[key];
      if (duLieu == null || duLieu.giaTri == null) continue;

      final cs = double.tryParse(duLieu.giaTri.toString());
      if (cs == null) continue;

      totalWatt += cs * item.soLuong;
    }

    if (totalWatt == 0) return null;
    if (group == 'TAM_PIN') {
      return totalWatt / 1000.0; // Wp → kWp
    }

    return totalWatt; // W → kW
  }

  /// Format công suất: 8.7 kW
  static String formatKw(num? kw) {
    if (kw == null) return '--';
    return '${kw.toStringAsFixed(1)} kW';
  }



  /// Tính diện tích tấm pin:
  /// kich_thuoc = "2278 x 1134 x 30" mm → chỉ lấy dài * rộng
  /// đổi sang m²: (dài * rộng) / 1e6
  /// nhân với số lượng
  static double? calcDienTichTamPinM2(List<VatTuTronGoiDto> items) {
    VatTuTronGoiDto? tamPin;

    for (final e in items) {
      if (e.vatTu.nhomVatTu.ma == 'TAM_PIN' &&
          e.vatTu.duLieuRieng['kich_thuoc'] != null) {
        tamPin = e;
        break;
      }
    }

    if (tamPin == null) return null;

    final duLieu = tamPin.vatTu.duLieuRieng['kich_thuoc'];
    if (duLieu == null || duLieu.giaTri == null) return null;

    final raw = duLieu.giaTri.toString();
    final parts = raw.split(RegExp(r'[xX×]')).map((e) => e.trim()).toList();

    if (parts.length < 2) return null;

    final daiMm = double.tryParse(parts[0]);
    final rongMm = double.tryParse(parts[1]);

    if (daiMm == null || rongMm == null) return null;

    final areaPerPanel = (daiMm * rongMm) / 1_000_000.0; // mm² → m²
    return areaPerPanel * tamPin.soLuong;
  }

  static String convertMonthToYearAndMonth(num? totalMonths) {
    if (totalMonths == null) return '--';

    final int m = totalMonths.ceil(); // làm tròn lên

    final int years = m ~/ 12;
    final int months = m % 12;

    if (years > 0 && months > 0) {
      return '$years năm $months tháng';
    } else if (years > 0) {
      return '$years năm';
    } else {
      return '$months tháng';
    }
  }

  /// (2) Tính số tháng hoàn vốn
  static double? calcDienTichM2(List<VatTuTronGoiDto> items) {
    VatTuTronGoiDto? item;

    // Tìm tấm pin
    for (final e in items) {
      if (e.vatTu.nhomVatTu.ma == 'TAM_PIN' &&
          e.vatTu.duLieuRieng['kich_thuoc'] != null) {
        item = e;
        break;
      }
    }

    if (item == null) return null;

    final raw = item.vatTu.duLieuRieng['kich_thuoc']?.giaTri?.toString();
    if (raw == null || raw.isEmpty) return null;

    final parts = raw.split(RegExp(r'[xX×]')).map((e) => e.trim()).toList();
    if (parts.length < 2) return null;

    final daiMm = double.tryParse(parts[0]);
    final rongMm = double.tryParse(parts[1]);
    if (daiMm == null || rongMm == null) return null;

    final area1 = (daiMm * rongMm) / 1_000_000.0; // mm² → m²
    final total = area1 * item.soLuong;

    return total;
  }
}

class VatTuGroupResult {
  final String title;
  final List<VatTuTronGoiDto> items;
  final String warrantyText;

  VatTuGroupResult({
    required this.title,
    required this.items,
    required this.warrantyText,
  });
}

VatTuGroupResult groupVatTuByNhom(
  List<VatTuTronGoiDto> allMaterials,
  String groupCode,
  String title,
) {
  final list = allMaterials
      .where((e) => e.vatTu.nhomVatTu.ma == groupCode)
      .toList();

  String warranty = '--';

  if (list.isNotEmpty) {
    final months = list.first.thoiGianBaoHanh;
    warranty = months > 0 ? 'Bảo hành $months tháng' : 'Không bảo hành';
  }

  return VatTuGroupResult(title: title, items: list, warrantyText: warranty);
}

extension VatTuGiaX on VatTuDto {
  double? get giaBanDefault {
    if (thongTinGias.isEmpty) return null;

    final ThongTinGiaDto block = thongTinGias.firstWhere(
      (t) => t.trangThai == 1,
      orElse: () => thongTinGias.first,
    );

    if (block.dsGia.isEmpty) return null;

    // ưu tiên GiaInfo có giaBan != null
    final GiaInfo giaInfo = block.dsGia.firstWhere(
      (g) => g.giaBan != null,
      orElse: () => block.dsGia.first,
    );

    return giaInfo.giaBan;
  }
}

extension VatTuTronGoiCopy on VatTuTronGoiDto {
  VatTuTronGoiDto copyWith({
    VatTuDto? vatTu,
    String? moTa,
    double? soLuong,
    double? gia,
    double? gm,
  }) {
    return VatTuTronGoiDto(
      id: id,
      vatTu: vatTu ?? this.vatTu,
      moTa: moTa ?? this.moTa,
      soLuong: soLuong ?? this.soLuong,
      gia: gia ?? this.gia,
      gm: gm ?? this.gm,
      taoLuc: taoLuc,
      thoiGianBaoHanh: thoiGianBaoHanh,
      duocBaoHanh: duocBaoHanh,
      duocXem: duocXem,
      trangThai: trangThai,
    );
  }
}

extension VatTuViewExt on VatTuDto {
  /// Ảnh chính: ưu tiên ảnh có `anhChinh = true`, fallback ảnh đầu tiên,
  /// cuối cùng fallback chuỗi rỗng (UI sẽ dùng asset mặc định).
  String get mainImageUrl {
    AnhVatTuDto? main;
    if (anhVatTus.isNotEmpty) {
      main = anhVatTus.firstWhere(
        (e) => e.anhChinh,
        orElse: () => anhVatTus.first,
      );
    }
    return main?.tepTin.duongDan ?? '';
  }

  /// Tag nhỏ ở góc ảnh – ở đây hiển thị thương hiệu.
  String get quantityTag {
    if (thuongHieu.tenQuocTe.isNotEmpty) {
      return thuongHieu.tenQuocTe;
    }
    if (thuongHieu.ten.isNotEmpty) {
      return thuongHieu.ten;
    }
    // fallback đơn vị nếu không có brand
    return donVi.isNotEmpty ? 'Đơn vị: $donVi' : '';
  }

  /// Tiêu đề hiển thị trên card
  String get title => ten;

  /// Giá bán: lấy giá bán mới nhất từ dsThongTinGia.
  /// Ưu tiên phần tử cuối + dsGia cuối có giaBan > 0.
  num get price {
    // duyệt từ mới nhất về cũ nhất
    for (final tt in thongTinGias.reversed) {
      for (final info in tt.dsGia.reversed) {
        if (info.giaBan != null && info.giaBan! > 0) {
          return info.giaBan!;
        }
      }
    }
    return 0;
  }

  /// Thời gian bảo hành (tháng) lấy từ dữ liệu riêng (nếu backend có key này).
  int get warrantyMonths {
    final ThuocTinh? tt = duLieuRieng['thoiGianBaoHanh'];
    if (tt == null) return 0;
    final v = tt.giaTri;
    if (v == null) return 0;
    if (v is num) return v.toInt();
    final parsed = int.tryParse(v.toString());
    return parsed ?? 0;
  }

  /// Text bảo hành hiển thị cho UI, dạng “5 năm”, “1 năm 6 tháng”, “12 tháng”, ...
  String get warrantyLabel {
    final months = warrantyMonths;
    if (months <= 0) return 'theo chính sách hãng';

    final years = months ~/ 12;
    final remain = months % 12;

    if (years > 0 && remain > 0) {
      return '$years năm $remain tháng';
    }
    if (years > 0) {
      return '$years năm';
    }
    return '$remain tháng';
  }
}
extension NumberFormatExtension on num {
  String formatKwpWithUnit() {
    final result = this / 1000;
    if (result % 1 == 0) {
      return '${result.toInt()} kWp';
    }
    return '${result.toStringAsFixed(1)} kWp';
  }
}

