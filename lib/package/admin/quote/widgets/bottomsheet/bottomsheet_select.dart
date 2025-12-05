import 'package:flutter/material.dart';
import '../equipment/card_item_device.dart';
import '../../../../model/tron_goi_models.dart';
import '../../../../model/extension.dart';
import '../../../controller/tao_bao_gia.dart';
import '../../../../device/repository/vat_tu_repository.dart'; // DeviceRepository

/// Hiển thị danh sách VẬT TƯ (VatTuDto) theo nhóm:
/// nhomMa: 'TAM_PIN' / 'BIEN_TAN' / 'PIN_LUU_TRU'
void showSelectProductBottomSheet(
  BuildContext context, {
  required String nhomMa,
  String? type, // Hy-Brid / On-grid
  String? phase, // '1' / '3'
  String? categoryLabel, // 'Tấm quang năng' / 'Biến tần'...
  required ValueChanged<VatTuDto> onSelected,
}) {
  final width = MediaQuery.of(context).size.width;
  double scale(double v) => v * width / 430;

  final tags = <String>['Tất cả'];

  if (type != null && type.isNotEmpty) {
    tags.add(type);
  }

  if (phase != null && phase.isNotEmpty) {
    final phaseLabel = phase == '1' ? 'Một pha' : 'Ba pha';
    tags.add(phaseLabel);
  }

  // if (categoryLabel != null && categoryLabel.isNotEmpty) {
  //   tags.add(categoryLabel);
  // }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) {
          return _SelectProductSheetBody(
            scale: scale,
            scrollController: scrollController,
            tags: tags,
            nhomMa: nhomMa,
            type: type,
            onSelected: onSelected,
          );
        },
      );
    },
  );
}

class _SelectProductSheetBody extends StatefulWidget {
  final double Function(double v) scale;
  final ScrollController scrollController;
  final List<String> tags;
  final String nhomMa; // 'TAM_PIN' / 'BIEN_TAN' / 'PIN_LUU_TRU'
  final String? type; // Hy-Brid / On-grid
  final ValueChanged<VatTuDto> onSelected;

  const _SelectProductSheetBody({
    required this.scale,
    required this.scrollController,
    required this.tags,
    required this.nhomMa,
    required this.onSelected,
    this.type,
  });

  @override
  State<_SelectProductSheetBody> createState() =>
      _SelectProductSheetBodyState();
}

class _SelectProductSheetBodyState extends State<_SelectProductSheetBody> {
  late List<String> _tags;
  int _selectedIndex = 0;

  final _repo = DeviceRepository();
  List<VatTuDto> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tags = widget.tags;
    _load();
  }

  Future<void> _load() async {
    try {
      List<VatTuDto> list;
      switch (widget.nhomMa) {
        case 'TAM_PIN':
          list = await _repo.getPanels();
          break;
        case 'BIEN_TAN':
          list = await _repo.getInverters();
          break;
        case 'PIN_LUU_TRU':
          list = await _repo.getBatteries();
          break;
        default:
          list = []; // nếu thêm nhóm khác thì bổ sung sau
      }

      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  num _getGiaBan(VatTuDto vt) {
    if (vt.thongTinGias.isEmpty) return 0;

    // Ưu tiên bản ghi giá đang active, nếu không có thì lấy cuối cùng
    final ThongTinGiaDto giaDto = vt.thongTinGias.firstWhere(
      (g) => g.trangThai == 1,
      orElse: () => vt.thongTinGias.last,
    );

    if (giaDto.dsGia.isEmpty) return 0;
    final GiaInfo giaInfo = giaDto.dsGia.first;
    return giaInfo.giaBan ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return Container(
      padding: EdgeInsets.fromLTRB(
        scale(16),
        scale(8),
        scale(16),
        MediaQuery.of(context).padding.bottom + scale(16),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo
          Center(
            child: Container(
              width: scale(56),
              height: scale(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          SizedBox(height: scale(16)),

          Text(
            'Chọn sản phẩm',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: scale(18),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),
          SizedBox(height: scale(16)),

          // Tag filter
          SizedBox(
            height: scale(32),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              separatorBuilder: (_, __) => SizedBox(width: scale(8)),
              itemBuilder: (context, index) {
                final bool isActive = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale(16),
                      vertical: scale(6),
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFFFE5E5)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _tags[index],
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: scale(14),
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive
                            ? const Color(0xFFE63B3B)
                            : const Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: scale(16)),

          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Expanded(
              child: Center(
                child: Text(
                  'Lỗi: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                controller: widget.scrollController,
                itemCount: _items.length,
                separatorBuilder: (_, __) => SizedBox(height: scale(16)),
                itemBuilder: (context, index) {
                  final vt = _items[index];

                  // LẤY GIÁ TỪ thongTinGias
                  final num giaBan = _getGiaBan(vt);
                  final num lineTotal = giaBan; // SL mặc định = 1

                  // Label hiển thị
                  final String congSuatLabel = vt.nhomVatTu.ma == 'PIN_LUU_TRU'
                      ? 'Lưu trữ:'
                      : 'Công suất:';

                  // Giá trị hiển thị: PIN_LUU_TRU -> dung_luong, còn lại -> cong_suat
                  String congSuatText = '';

                  if (vt.nhomVatTu.ma == 'PIN_LUU_TRU') {
                    // LẤY dung_luong
                    final dynamic rawDungLuong = vt.fieldValue('dung_luong');
                    final num dungLuong = (rawDungLuong is num)
                        ? rawDungLuong
                        : num.tryParse(rawDungLuong.toString()) ?? 0;

                    if (dungLuong > 0) {
                      congSuatText = '${dungLuong.toStringAsFixed(1)} kWh';
                    }
                  } else {
                    // TAM_PIN, BIEN_TAN (hoặc nhóm khác dùng cong_suat)
                    final dynamic rawCongSuat = vt.fieldValue('cong_suat');
                    final num congSuat = (rawCongSuat is num)
                        ? rawCongSuat
                        : num.tryParse(rawCongSuat.toString()) ?? 0;

                    if (congSuat > 0) {
                      congSuatText = '${congSuat.toStringAsFixed(1)} kW';
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onSelected(vt);
                    },
                    child: SolarMaxCartCard(
                      imageUrl: vt.mainImageUrl,
                      title: vt.ten,
                      modeTag: widget.type ?? '',
                      congSuatLabel: congSuatLabel,
                      congSuat: congSuatText,
                      khoiLuong: '${vt.fieldValue('khoi_luong')} kg',
                      baoHanh: TronGoiUtils.convertMonthToYearAndMonth(vt.thoiGianBaoHanh),
                      priceText: lineTotal > 0
                          ? TronGoiUtils.formatMoney(lineTotal)
                          : '--',
                      quantity: 1,
                      showQuantityControl: false,
                      backgroundColor: Colors.white,
                      onIncrease: () {},
                      onDecrease: () {},
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
