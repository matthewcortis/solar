import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../repository/rarranty_repo.dart';
import '../../model/hop_dong_bao_hanh_model.dart';
import '../../model/tron_goi_models.dart';
import '../../model/extension.dart';

class WarrantyContractCard extends StatelessWidget {
  final int hopDongId;

  const WarrantyContractCard({super.key, required this.hopDongId});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return FutureBuilder<HopDongBaoHanhDto?>(
      future: WarrantyRepository().getHopDongById(hopDongId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: scale(402),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi tải hợp đồng bảo hành',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: scale(14),
                color: const Color(0xFFE53935),
              ),
            ),
          );
        }

        final hopDong = snapshot.data;
        if (hopDong == null) {
          return Center(
            child: Text(
              'Không tìm thấy hợp đồng bảo hành',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: scale(14),
                color: const Color(0xFF4F4F4F),
              ),
            ),
          );
        }

        // Bên mua: khachHang.hoVaTen
        final String benMua = hopDong.khachHangTen;

        // Ngày ký: content.taoLuc (hiện đúng field, có thể format sau nếu cần)
        final raw = hopDong.taoLuc;
        String formattedNgayKy = '';

        if (raw != null) {
          String rawStr = raw.toString(); // Ép sang String an toàn

          final date = DateTime.tryParse(rawStr);
          if (date != null) {
            formattedNgayKy =
                "${date.day.toString().padLeft(2, '0')}/"
                "${date.month.toString().padLeft(2, '0')}/"
                "${date.year}";
          }
        }

        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                width: scale(402),
                padding: EdgeInsets.all(scale(16)),
                decoration: BoxDecoration(
                  color: const Color(0x33F3F3F3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ==== TITLE ====
                    Text(
                      "Hợp đồng bảo hành",
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: scale(18),
                        height: 28 / 18,
                        color: const Color(0xFF4F4F4F),
                      ),
                    ),

                    SizedBox(height: scale(12)),

                    buildRow(
                      title: "Bên bán",
                      value: "CÔNG TY CỔ PHẦN ĐẦU TƯ SLM",
                      scale: scale,
                    ),
                    buildRow(
                      title: "Bên mua",
                      value: benMua, // <-- khachHang.hoVaTen
                      scale: scale,
                    ),
                    buildRow(
                      title: "Ngày ký",
                      value: formattedNgayKy, // <-- content.taoLuc
                      scale: scale,
                      hasBorder: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ====== WIDGET DÒNG ======
  Widget buildRow({
    required String title,
    required String value,
    required double Function(double) scale,
    bool isCopy = false,
    bool hasBorder = true,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: scale(12)),
      decoration: BoxDecoration(
        border: hasBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1),
              )
            : null,
      ),
      child: Row(
        children: [
          /// Cột trái
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400,
                fontSize: scale(12),
                height: 18 / 12,
                color: const Color(0xFF848484),
              ),
            ),
          ),

          /// Cột phải
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(14),
                      height: 20 / 14,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                ),
                if (isCopy)
                  Padding(
                    padding: EdgeInsets.only(left: scale(6)),
                    child: SvgPicture.asset(
                      'assets/icons/copy.svg',
                      width: scale(24),
                      height: scale(24),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailInfoCard extends StatefulWidget {
  final int hopDongId;

  const DetailInfoCard({super.key, required this.hopDongId});

  @override
  State<DetailInfoCard> createState() => _DetailInfoCardState();
}

class _DetailInfoCardState extends State<DetailInfoCard> {
  final _repo = WarrantyRepository();
  late Future<HopDongBaoHanhDto?> _futureHopDong;

  @override
  void initState() {
    super.initState();
    _futureHopDong = _repo.getHopDongById(widget.hopDongId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return FutureBuilder<HopDongBaoHanhDto?>(
      future: _futureHopDong,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: scale(402),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi tải thông tin chi tiết',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: scale(14),
                color: const Color(0xFFE53935),
              ),
            ),
          );
        }

        final hopDong = snapshot.data;
        if (hopDong == null) {
          return Center(
            child: Text(
              'Không tìm thấy hợp đồng',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: scale(14),
                color: const Color(0xFF4F4F4F),
              ),
            ),
          );
        }

        final List<VatTuHopDongBaoHanhDto> items = hopDong.vatTuHopDongs
            .where((e) => e.duocBaoHanh)
            .toList();

        if (items.isEmpty) {
          return Center(
            child: Text(
              'Chưa có thông tin vật tư',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: scale(14),
                color: const Color(0xFF4F4F4F),
              ),
            ),
          );
        }

        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                width: scale(402),
                padding: EdgeInsets.all(scale(16)),
                decoration: BoxDecoration(
                  color: const Color(0x33F3F3F3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thông tin chi tiết",
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: scale(18),
                        height: 28 / 18,
                        color: const Color(0xFF4F4F4F),
                      ),
                    ),
                    SizedBox(height: scale(12)),

                    /// Nhóm Tấm pin, Biến tần, Pin lưu trữ + các hệ vật tư khác
                    ..._buildVatTuRows(items, scale),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int _groupOrder(String? ma) {
    switch (ma) {
      case 'TAM_PIN':
        return 0;
      case 'BIEN_TAN':
        return 1;
      case 'PIN_LUU_TRU':
        return 2;
      case 'HE_KHUNG_NHOM':
        return 3;
      case 'HE_DAY_DIEN':
        return 4;
      case 'TU_DIEN':
        return 5;
      case 'HE_TIEP_DIA':
        return 6;
      // case 'TRON_GOI_LAP_DAT':
      //   return 7;
      default:
        return 99;
    }
  }

  List<Widget> _buildVatTuRows(
    List<VatTuHopDongBaoHanhDto> items,
    double Function(double) scale,
  ) {
    final List<Widget> widgets = [];

    // 1) Gom theo nhomMa
    final Map<String, List<VatTuHopDongBaoHanhDto>> grouped = {};
    for (final item in items) {
      final String code = item.nhomMa.isNotEmpty
          ? item.nhomMa
          : item.vatTu.nhomVatTu.ma;
      grouped.putIfAbsent(code, () => []).add(item);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => _groupOrder(a.key).compareTo(_groupOrder(b.key)));

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final code = entry.key;
      final groupItems = entry.value;

      final sample = groupItems.first;
      final vatTu = sample.vatTu;
      final nhom = vatTu.nhomVatTu;

      final String title = nhom.ten.isNotEmpty ? nhom.ten : 'Vật tư';

      final mainCodes = {'TAM_PIN', 'BIEN_TAN', 'PIN_LUU_TRU'};
      final bool isMain = mainCodes.contains(code);

  
      final String value = isMain ? vatTu.ten : nhom.ten;

     
      int months;
      if (isMain) {
        months = sample.thoiGianBaoHanhEffective;
      } else {
        months = 12; //  1 năm cho các hệ khác
      }

      final String duration = months > 0
          ? TronGoiUtils.convertMonthToYearAndMonth(months)
          : '';

      widgets.add(
        buildItem(
          scale: scale,
          title: title,
          value: value,
          quantity: duration,
          isLast: i == entries.length - 1,
        ),
      );
    }

    return widgets;
  }

  /// ONE ROW ITEM
  Widget buildItem({
    required double Function(double) scale,
    required String title,
    required String value,
    required String quantity,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: scale(12)),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT (title + value)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: scale(12),
                    height: 18 / 12,
                    color: const Color(0xFF848484),
                  ),
                ),
                SizedBox(height: scale(4)),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(14),
                    height: 20 / 14,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT (Thời gian BH)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Bảo hành",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: scale(12),
                    height: 18 / 12,
                    color: const Color(0xFF848484),
                  ),
                ),
                SizedBox(height: scale(4)),
                Text(
                  quantity,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(14),
                    height: 20 / 14,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
