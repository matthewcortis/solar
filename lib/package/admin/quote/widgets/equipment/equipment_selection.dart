import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../equipment/card_item_option.dart';
import '../equipment/card_item_device.dart';
import '../bottomsheet/bottomsheet_select.dart';
import '../../../../combo/model/tron_goi_model.dart';

class DanhMucThietBiVaVatTu extends StatefulWidget {
  final String? selectedType; // 'Hy-Brid' hoặc 'On-grid'
  final String? selectedPhase; // '1', '3', ...
  final TronGoiModel tronGoi;

  const DanhMucThietBiVaVatTu({
    super.key,
    this.selectedType,
    this.selectedPhase,
    required this.tronGoi,
  });

  @override
  State<DanhMucThietBiVaVatTu> createState() => _DanhMucThietBiVaVatTuState();
}

class _DanhMucThietBiVaVatTuState extends State<DanhMucThietBiVaVatTu> {
  // segmented choice
  bool _apMai = true;

  late final List panels;
  late final List inverters;
  late final List batteries;

  @override
  void initState() {
    super.initState();

    panels = widget.tronGoi.panels;
    inverters = widget.tronGoi.inverters;
    batteries = widget.tronGoi.batteries;

    print("Panels = ${panels.length}");
    print("Inverters = ${inverters.length}");
    print("Batteries = ${batteries.length}");
  }

  List<String> get _selectedTags {
    final tags = <String>[];

    if (widget.selectedType != null && widget.selectedType!.isNotEmpty) {
      tags.add(widget.selectedType!);
    }

    final phase = widget.selectedPhase;
    if (phase != null && phase.isNotEmpty) {
      final phaseLabel = phase == '1' ? 'Một pha' : 'Ba pha';
      tags.add(phaseLabel);
    }

    return tags;
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh mục thiết bị và vật tư',
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 28 / 18,
                  color: Color(0xFF4F4F4F),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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

              // ===================== CÁC LỰA CHỌN =====================
              Column(
                children: [
                  // ===================== TẤM PIN =====================
                  OptionCard(
                    title: 'Tấm quang năng',
                    items: panels
                        .where(
                          (item) => item.vatTu != null,
                        ) // lọc bỏ item không có vật tư
                        .map((item) {
                          final vt = item.vatTu;
                          final duLieu = vt.duLieuRieng;
                          String getField(String key) {
                            final raw = duLieu is Map<String, dynamic>
                                ? duLieu[key]
                                : null;
                            if (raw == null) return '';
                            if (raw is Map && raw['giaTri'] != null) {
                              return raw['giaTri'].toString();
                            }
                            return raw.toString();
                          }

                          return SolarMaxCartCard(
                            image: const AssetImage(
                              'assets/images/product.png',
                            ),
                            title: vt.ten ?? '', // String? -> String
                            modeTag: widget.selectedType ?? '',
                            congSuat: getField('cong_suat'),
                            chiSoIp: getField('ip'),
                            khoiLuong: getField('khoi_luong'),
                            baoHanh: item.gm != null ? '${item.gm} tháng' : '',
                            priceText: (item.gia ?? 0).toString(), // tránh null
                            quantity: (item.soLuong ?? 0).toInt(),
                            onIncrease: () {},
                            onDecrease: () {},
                          );
                        })
                        .toList(),
                    onChange: () {
                      _openProductBottomSheet(
                        context,
                        categoryLabel: 'Tấm quang năng',
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // ===================== BIẾN TẦN =====================
                  OptionCard(
                    title: 'Biến tần',
                    items: inverters.where((item) => item.vatTu != null).map((
                      item,
                    ) {
                      final vt = item.vatTu;
                      final duLieu = vt.duLieuRieng;

                      String getField(String key) {
                        final raw = duLieu is Map<String, dynamic>
                            ? duLieu[key]
                            : null;
                        if (raw == null) return '';
                        if (raw is Map && raw['giaTri'] != null) {
                          return raw['giaTri'].toString();
                        }
                        return raw.toString();
                      }

                      return SolarMaxCartCard(
                        image: const AssetImage('assets/images/product.png'),
                        title: vt.ten ?? '',
                        modeTag: widget.selectedType ?? '',
                        congSuat: getField('cong_suat'),
                        chiSoIp: getField('ip'),
                        khoiLuong: getField('khoi_luong'),
                        baoHanh: item.gm != null ? '${item.gm} tháng' : '',
                        priceText: (item.gia ?? 0).toString(),
                        quantity: (item.soLuong ?? 0).toInt(),
                        onIncrease: () {},
                        onDecrease: () {},
                      );
                    }).toList(),
                    onChange: () {
                      _openProductBottomSheet(
                        context,
                        categoryLabel: 'Biến tần',
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // ===================== PIN LƯU TRỮ =====================
                  OptionCard(
                    title: 'Pin lưu trữ',
                    items: batteries.where((item) => item.vatTu != null).map((
                      item,
                    ) {
                      final vt = item.vatTu;
                      final duLieu = vt.duLieuRieng;

                      String getField(String key) {
                        final raw = duLieu is Map<String, dynamic>
                            ? duLieu[key]
                            : null;
                        if (raw == null) return '';
                        if (raw is Map && raw['giaTri'] != null) {
                          return raw['giaTri'].toString();
                        }
                        return raw.toString();
                      }

                      return SolarMaxCartCard(
                        image: const AssetImage('assets/images/product.png'),
                        title: vt.ten ?? '',
                        modeTag: widget.selectedType ?? '',
                        congSuat: getField('dung_luong'),
                        chiSoIp:
                            '', // nếu có trường ip riêng thì getField('ip')
                        khoiLuong: getField('khoi_luong'),
                        baoHanh: item.gm != null ? '${item.gm} tháng' : '',
                        priceText: (item.gia ?? 0).toString(),
                        quantity: (item.soLuong ?? 0).toInt(),
                        onIncrease: () {},
                        onDecrease: () {},
                      );
                    }).toList(),
                    onChange: () {
                      _openProductBottomSheet(
                        context,
                        categoryLabel: 'Pin lưu trữ',
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  OptionCard(title: 'Hình thức lắp đặt'),
                ],
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
                alignment: Alignment.topCenter,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _apMai
                    ? const SizedBox.shrink()
                    : const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: _GiaKhungSatFrame(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x33B5B5B5),
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 2,
            spreadRadius: -1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF4F4F4F),
          ),
        ),
      ),
    );
  }
}

class _GiaKhungSatFrame extends StatelessWidget {
  const _GiaKhungSatFrame();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 398),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _LabeledField(
              label: 'Giá bán khung sắt',
              hint: 'Nhập giá bán khung sắt',
            ),
            SizedBox(height: 12),
            _LabeledField(
              label: 'Giá nhân công khung sắt',
              hint: 'Nhập giá Nhân công khung sắt',
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4F4F4F),
            ),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26D1D1D1),
                  offset: Offset(0, 15),
                  blurRadius: 34,
                ),
                BoxShadow(
                  color: Color(0x21D1D1D1),
                  offset: Offset(0, 61),
                  blurRadius: 61,
                ),
                BoxShadow(
                  color: Color(0x14D1D1D1),
                  offset: Offset(0, 137),
                  blurRadius: 82,
                ),
              ],
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 16,
                  color: Color(0xFF848484),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1E)),
            ),
          ),
        ],
      ),
    );
  }
}
