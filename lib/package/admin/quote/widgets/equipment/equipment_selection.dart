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

  const DanhMucThietBiVaVatTu({
    super.key,
    this.selectedType,
    this.selectedPhase,
    required this.tronGoi,
    this.onTotalChanged,
  });

  @override
  State<DanhMucThietBiVaVatTu> createState() => _DanhMucThietBiVaVatTuState();
}

class _DanhMucThietBiVaVatTuState extends State<DanhMucThietBiVaVatTu>
    with TickerProviderStateMixin {
  bool _apMai = true;

  late final MainDeviceGroups _groups;
  late final List<String> _selectedTags;

  // PHẦN CỐ ĐỊNH: nhân công + vật tư phụ + phần còn lại ngoài 3 thiết bị chính
  late final num _baseOtherPart;
  num _giaBanKhungSat = 0;
  num _giaNhanCongKhungSat = 0;
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
  }

  void _openProductBottomSheet(
    BuildContext context, {
    required String categoryLabel,
  }) {
    showSelectProductBottomSheet(
      context,
      type: widget.selectedType,
      phase: widget.selectedPhase,
      categoryLabel: categoryLabel,
    );
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
                print(item.thoiGianBaoHanh);

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
              onChange: () => _openProductBottomSheet(
                context,
                categoryLabel: 'Tấm quang năng',
              ),
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
              onChange: () =>
                  _openProductBottomSheet(context, categoryLabel: 'Biến tần'),
            ),

            const SizedBox(height: 12),

            // ===================== PIN LƯU TRỮ =====================
            OptionCard(
              title: 'Pin lưu trữ',
              items: _groups.batteries.asMap().entries.map((entry) {
                final int index = entry.key;
                final VatTuTronGoiDto item = entry.value;
                final vt = item.vatTu;

                final num lineTotal = item.gia * item.soLuong;
                final String congSuatLabel = vt.nhomVatTu.ma == 'PIN_LUU_TRU'
                    ? 'Lưu trữ:'
                    : 'Công suất:';

                return SolarMaxCartCard(
                  imageUrl: vt.mainImageUrl,
                  title: vt.ten,
                  modeTag: widget.selectedType ?? '',
                  congSuatLabel: congSuatLabel,

                  congSuat: vt.nhomVatTu.ma == 'PIN_LUU_TRU'
                      ? extBaoGiaTronGoi.formatCongSuatTong(
                          vt.fieldValue('dung_luong'),
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
              onChange: () => _openProductBottomSheet(
                context,
                categoryLabel: 'Pin lưu trữ',
              ),
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
                      padding: EdgeInsets.only(top: 4),
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
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
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
