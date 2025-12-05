import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../equipment/card_item_option.dart';
import '../equipment/card_item_device.dart';
import '../bottomsheet/bottomsheet_select.dart';
import '../../../../model/tron_goi_models.dart';
import '../../../controller/tao_bao_gia.dart';
import '../../../../model/extension.dart';

class DanhMucThietBiVaVatTu extends StatefulWidget {
  final String? selectedType; // 'Hy-Brid' hoặc 'On-Grid'
  final String? selectedPhase; // '1', '3', ...
  final TronGoiDto tronGoi;
  final ValueChanged<num>? onTotalChanged;
  final ValueChanged<List<VatTuTronGoiDto>>? onMainDevicesChanged;

  // NEW: callback báo giá khung sắt / nhân công
  final ValueChanged<num>? onGiaBanKhungSatChanged;
  final ValueChanged<num>? onGiaNhanCongKhungSatChanged;
  const DanhMucThietBiVaVatTu({
    super.key,
    this.selectedType,
    this.selectedPhase,
    required this.tronGoi,
    this.onTotalChanged,
    this.onMainDevicesChanged,
    this.onGiaBanKhungSatChanged,
    this.onGiaNhanCongKhungSatChanged,
  });

  @override
  State<DanhMucThietBiVaVatTu> createState() => _DanhMucThietBiVaVatTuState();
}

class _DanhMucThietBiVaVatTuState extends State<DanhMucThietBiVaVatTu>
    with TickerProviderStateMixin {
  bool _apMai = true;

  late final MainDeviceGroups _groups;
  late final List<String> _selectedTags;

  late final num _baseOtherPart;
  num _giaBanKhungSat = 0;
  num _giaNhanCongKhungSat = 0;

  double _getGiaBanFromVatTu(VatTuDto vt) {
    if (vt.thongTinGias.isEmpty) return 0.0;

    final giaDto = vt.thongTinGias.firstWhere(
      (g) => g.trangThai == 1,
      orElse: () => vt.thongTinGias.last,
    );

    if (giaDto.dsGia.isEmpty) return 0.0;
    return (giaDto.dsGia.first.giaBan ?? 0).toDouble();
  }

  @override
  void initState() {
    super.initState();

    // Logic gom nhóm
    _groups = buildMainDeviceGroups(widget.tronGoi);

    // Logic build tag đã chọn
    _selectedTags = buildSelectedTags(
      widget.selectedType,
      widget.selectedPhase,
    );

    // ===== TÍNH PHẦN CỐ ĐỊNH (nhân công, vật tư phụ, ...) =====
    num mainInitialTotal = 0;

    for (final item in _groups.panels) {
      mainInitialTotal += item.gia * item.soLuong;
    }
    for (final item in _groups.inverters) {
      mainInitialTotal += item.gia * item.soLuong;
    }
    for (final item in _groups.batteries) {
      mainInitialTotal += item.gia * item.soLuong;
    }

    final num tronGoiTotal = widget.tronGoi.tongGia;
    num base = tronGoiTotal - mainInitialTotal;

    // Phòng trường hợp data lệch khiến base âm
    if (base < 0) base = 0;

    _baseOtherPart = base;
  }

  void _notifyTotalChanged() {
    // TÍNH LẠI TỔNG 3 THIẾT BỊ CHÍNH THEO SỐ LƯỢNG HIỆN TẠI
    num currentMain = 0;

    for (final item in _groups.panels) {
      currentMain += item.gia * item.soLuong;
    }
    for (final item in _groups.inverters) {
      currentMain += item.gia * item.soLuong;
    }
    for (final item in _groups.batteries) {
      currentMain += item.gia * item.soLuong;
    }

    // TỔNG MỚI = PHẦN CỐ ĐỊNH (nhân công, vật tư phụ, ...) + 3 THIẾT BỊ CHÍNH
    final num total =
        _baseOtherPart + currentMain + _giaBanKhungSat + _giaNhanCongKhungSat;
    widget.onTotalChanged?.call(total);

    final mainDevices = <VatTuTronGoiDto>[
      ..._groups.panels,
      ..._groups.inverters,
      ..._groups.batteries,
    ];
    widget.onMainDevicesChanged?.call(mainDevices);
    widget.onGiaBanKhungSatChanged?.call(_giaBanKhungSat);
    widget.onGiaNhanCongKhungSatChanged?.call(_giaNhanCongKhungSat);
  }

  void _openProductBottomSheet(
    BuildContext context, {
    required String nhomMa,
    required int indexInGroup,
  }) {
    showSelectProductBottomSheet(
      context,
      nhomMa: nhomMa,
      type: widget.selectedType,
      phase: widget.selectedPhase,
      categoryLabel: _mapNhomMaToLabel(nhomMa),
      onSelected: (VatTuDto vtMoi) {
        setState(() {
          final num giaMoi = _getGiaBanFromVatTu(vtMoi);

          if (nhomMa == 'TAM_PIN') {
            final old = _groups.panels[indexInGroup];
            _groups.panels[indexInGroup] = old.copyWith(
              vatTu: vtMoi,
              gia: giaMoi.toDouble(),
            );
          } else if (nhomMa == 'BIEN_TAN') {
            final old = _groups.inverters[indexInGroup];
            _groups.inverters[indexInGroup] = old.copyWith(
              vatTu: vtMoi,
              gia: giaMoi.toDouble(),
            );
          } else if (nhomMa == 'PIN_LUU_TRU') {
            final old = _groups.batteries[indexInGroup];
            _groups.batteries[indexInGroup] = old.copyWith(
              vatTu: vtMoi,
              gia: giaMoi.toDouble(),
            );
          }
        });

        _notifyTotalChanged();
      },
    );
  }

  String _mapNhomMaToLabel(String nhomMa) {
    switch (nhomMa) {
      case 'TAM_PIN':
        return 'Tấm quang năng';
      case 'BIEN_TAN':
        return 'Biến tần';
      case 'PIN_LUU_TRU':
        return 'Pin lưu trữ';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F8F8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh mục thiết bị và vật tư',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 28 / 18,
                color: Color(0xFF4F4F4F),
              ),
            ),
            const SizedBox(height: 12),

            // ---- ĐÃ CHỌN ----
            Row(
              children: [
                const Text(
                  'Đã chọn:',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF848484),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedTags
                        .map((t) => _TagChip(label: t))
                        .toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===================== TẤM PIN =====================
            OptionCard(
              title: 'Tấm quang năng',
              items: _groups.panels.asMap().entries.map((entry) {
                final int index = entry.key;
                final VatTuTronGoiDto item = entry.value;
                final vt = item.vatTu;
                final String congSuatLabel = vt.nhomVatTu.ma == 'PIN_LUU_TRU'
                    ? 'Lưu trữ:'
                    : 'Công suất:';

                final num lineTotal = item.gia * item.soLuong;
                return SolarMaxCartCard(
                  imageUrl: vt.mainImageUrl,
                  title: vt.ten,
                  modeTag: widget.selectedType ?? '',
                  congSuatLabel: congSuatLabel,
                  congSuat: vt.nhomVatTu.ma == 'TAM_PIN'
                      ? extBaoGiaTronGoi.formatCongSuatTong(
                          vt.fieldValue('cong_suat'),
                          item.soLuong,
                        )
                      : '',
                  khoiLuong: '${vt.fieldValue('khoi_luong')} kg',
                  baoHanh: item.thoiGianBaoHanh > 0
                      ? TronGoiUtils.convertMonthToYearAndMonth(
                          item.thoiGianBaoHanh,
                        )
                      : '',
                  priceText: TronGoiUtils.formatMoney(lineTotal),
                  quantity: item.soLuong.toInt(),
                  onIncrease: () {
                    setState(() {
                      final updated = item.copyWith(soLuong: item.soLuong + 1);
                      _groups.panels[index] = updated;
                    });
                    _notifyTotalChanged();
                  },
                  onDecrease: () {
                    if (item.soLuong > 1) {
                      setState(() {
                        final updated = item.copyWith(
                          soLuong: item.soLuong - 1,
                        );
                        _groups.panels[index] = updated;
                      });
                      _notifyTotalChanged();
                    }
                  },
                );
              }).toList(),
              // MỞ BOTTOM SHEET: đổi thiết bị đầu tiên trong nhóm TẤM PIN
              onChange: () {
                if (_groups.panels.isEmpty) return;
                _openProductBottomSheet(
                  context,
                  nhomMa: 'TAM_PIN',
                  indexInGroup: 0,
                );
              },
            ),

            const SizedBox(height: 12),

            // ===================== BIẾN TẦN =====================
            OptionCard(
              title: 'Biến tần',
              items: _groups.inverters.asMap().entries.map((entry) {
                final int index = entry.key;
                final VatTuTronGoiDto item = entry.value;
                final vt = item.vatTu;
                final String congSuatLabel = vt.nhomVatTu.ma == 'PIN_LUU_TRU'
                    ? 'Lưu trữ:'
                    : 'Công suất:';

                final num lineTotal = item.gia * item.soLuong;

                return SolarMaxCartCard(
                  imageUrl: vt.mainImageUrl,
                  title: vt.ten,
                  modeTag: widget.selectedType ?? '',
                  congSuatLabel: congSuatLabel,
                  congSuat: vt.nhomVatTu.ma == 'BIEN_TAN'
                      ? '${(num.tryParse(vt.fieldValue("cong_suat").toString()) ?? 0) * item.soLuong} kW'
                      : '',

                  khoiLuong: '${vt.fieldValue('khoi_luong')} kg',
                  baoHanh: item.thoiGianBaoHanh > 0
                      ? TronGoiUtils.convertMonthToYearAndMonth(
                          item.thoiGianBaoHanh,
                        )
                      : '',
                  priceText: TronGoiUtils.formatMoney(lineTotal),
                  quantity: item.soLuong.toInt(),
                  onIncrease: () {
                    setState(() {
                      final updated = item.copyWith(soLuong: item.soLuong + 1);
                      _groups.inverters[index] = updated;
                    });
                    _notifyTotalChanged();
                  },
                  onDecrease: () {
                    if (item.soLuong > 1) {
                      setState(() {
                        final updated = item.copyWith(
                          soLuong: item.soLuong - 1,
                        );
                        _groups.inverters[index] = updated;
                      });
                      _notifyTotalChanged();
                    }
                  },
                );
              }).toList(),
              onChange: () {
                if (_groups.inverters.isEmpty) return;
                _openProductBottomSheet(
                  context,
                  nhomMa: 'BIEN_TAN',
                  indexInGroup: 0,
                );
              },
            ),

            const SizedBox(height: 12),

            // ===================== PIN LƯU TRỮ =====================
            // ===================== PIN LƯU TRỮ =====================
            OptionCard(
              title: 'Pin lưu trữ',
              items: _groups.batteries.asMap().entries.map((entry) {
                final int index = entry.key;
                final VatTuTronGoiDto item = entry.value;
                final vt = item.vatTu;

                final num lineTotal = item.gia * item.soLuong;

                // --- TÍNH TỔNG DUNG LƯỢNG THEO SỐ LƯỢNG ---
                final dynamic rawDungLuong = vt.fieldValue('dung_luong');
                num baseDungLuong = 0;
                if (rawDungLuong is num) {
                  baseDungLuong = rawDungLuong;
                } else if (rawDungLuong is String) {
                  baseDungLuong = num.tryParse(rawDungLuong) ?? 0;
                }
                final num totalDungLuong = baseDungLuong * item.soLuong;

                return SolarMaxCartCard(
                  imageUrl: vt.mainImageUrl,
                  title: vt.ten,
                  modeTag: widget.selectedType ?? '',
                  congSuatLabel: 'Lưu trữ:',
                  // VD: 1 cái 5 kWh -> 2 cái: 10.0 kWh (có thể chỉnh 0 chữ số thập phân nếu muốn)
                  congSuat: '${totalDungLuong.toStringAsFixed(1)} kWh',
                  khoiLuong: '${vt.fieldValue('khoi_luong')} kg',
                  baoHanh: item.thoiGianBaoHanh > 0
                      ? TronGoiUtils.convertMonthToYearAndMonth(
                          item.thoiGianBaoHanh,
                        )
                      : '',
                  priceText: TronGoiUtils.formatMoney(lineTotal),
                  quantity: item.soLuong.toInt(),
                  onIncrease: () {
                    setState(() {
                      final updated = item.copyWith(soLuong: item.soLuong + 1);
                      _groups.batteries[index] = updated;
                    });
                    _notifyTotalChanged();
                  },
                  onDecrease: () {
                    if (item.soLuong > 1) {
                      setState(() {
                        final updated = item.copyWith(
                          soLuong: item.soLuong - 1,
                        );
                        _groups.batteries[index] = updated;
                      });
                      _notifyTotalChanged();
                    }
                  },
                );
              }).toList(),
              onChange: () {
                if (_groups.batteries.isEmpty) return;
                _openProductBottomSheet(
                  context,
                  nhomMa: 'PIN_LUU_TRU',
                  indexInGroup: 0,
                );
              },
            ),

            const SizedBox(height: 12),

            OptionCard(
              title: 'Hình thức lắp đặt',
              items: const [],
              onChange: () {},
            ),

            const SizedBox(height: 16),

            // ===================== Segment ÁP MÁI / KHUNG SẮT =====================
            Row(
              children: [
                Expanded(
                  child: SegmentPill(
                    label: 'Áp mái',
                    selected: _apMai,
                    onTap: () => setState(() => _apMai = true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SegmentPill(
                    label: 'Khung sắt',
                    selected: !_apMai,
                    onTap: () => setState(() => _apMai = false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _apMai
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: _GiaKhungSatFrame(
                        onGiaBanChanged: (value) {
                          setState(() => _giaBanKhungSat = value);
                          _notifyTotalChanged();
                        },
                        onGiaNhanCongChanged: (value) {
                          setState(() => _giaNhanCongKhungSat = value);
                          _notifyTotalChanged();
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x33B5B5B5),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF4F4F4F)),
        ),
      ),
    );
  }
}

class _GiaKhungSatFrame extends StatelessWidget {
  final ValueChanged<num> onGiaBanChanged;
  final ValueChanged<num> onGiaNhanCongChanged;

  const _GiaKhungSatFrame({
    required this.onGiaBanChanged,
    required this.onGiaNhanCongChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabeledField(
          label: 'Giá bán khung sắt',
          hint: 'Nhập giá bán khung sắt',
          onValueChanged: onGiaBanChanged,
        ),
        const SizedBox(height: 12),
        _LabeledField(
          label: 'Giá nhân công khung sắt',
          hint: 'Nhập giá nhân công khung sắt',
          onValueChanged: onGiaNhanCongChanged,
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final ValueChanged<num>? onValueChanged;

  const _LabeledField({
    required this.label,
    required this.hint,
    this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '',
            ),
            onChanged: (value) {
              final numVal = num.tryParse(value) ?? 0;
              onValueChanged?.call(numVal);
            },
          ),
        ),
      ],
    );
  }
}
