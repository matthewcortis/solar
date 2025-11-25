import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../repository/rarranty_repo.dart';
import '../../model/hop_dong_bao_hanh_model.dart';

class WarrantyContractCard extends StatelessWidget {
    final int hopDongId;
  const WarrantyContractCard({super.key, required this.hopDongId});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

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
                  value: "HOÀNG NGỌC TÂN",
                  scale: scale,
                ),
                buildRow(
                  title: "Ngày ký",
                  value: "19/03/2025",
                  scale: scale,
                  hasBorder: false, 
                ),
              ],
            ),
          ),
        ),
      ),
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

  const DetailInfoCard({
    super.key,
    required this.hopDongId,
  });

  @override
  State<DetailInfoCard> createState() => _DetailInfoCardState();
}

class _DetailInfoCardState extends State<DetailInfoCard> {
  final _repo = WarrantyRepository();
  late Future<HopDongBaoHanh?> _futureHopDong;

  @override
  void initState() {
    super.initState();
    _futureHopDong = _repo.getHopDongById(widget.hopDongId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return FutureBuilder<HopDongBaoHanh?>(
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

        // Danh sách vật tư trong hợp đồng (VatTuHopDongBH)
        final List<VatTuHopDongBH> allItems = hopDong.vatTuHopDongs;

        // Lọc chỉ vật tư chính (nhomVatTu.vatTuChinh == true)
        final items = allItems.where((e) {
          final nhom = e.vatTu?.nhomVatTu;
          return nhom != null && nhom.vatTuChinh == true;
        }).toList();

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
                    /// ===== TITLE =====
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

                    /// ===== CÁC DÒNG VẬT TƯ =====
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

  List<Widget> _buildVatTuRows(
    List<VatTuHopDongBH> items,
    double Function(double) scale,
  ) {
    final List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final vatTu = item.vatTu;
      final nhom = vatTu?.nhomVatTu;

      // Tên nhóm: "Tấm Quang Năng", "Biến tần", ...
      final String title = nhom?.ten ?? 'Vật tư';

      // Tên vật tư: "PV JASolar | 580W | 1 mặt kính", ...
      final String value = vatTu?.ten ?? '';

      // Thời gian bảo hành X tháng
      final String duration =
          item.thoiGianBaoHanh != null && item.thoiGianBaoHanh! > 0
              ? '${item.thoiGianBaoHanh} tháng'
              : '';

      widgets.add(
        buildItem(
          scale: scale,
          title: title,
          value: value,
          quantity: duration,
          isLast: i == items.length - 1,
        ),
      );
    }

    return widgets;
  }

  /// === ONE ROW ITEM ===
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
                /// Small title
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

                /// Bold value
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
                  "Thời gian BH",
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
