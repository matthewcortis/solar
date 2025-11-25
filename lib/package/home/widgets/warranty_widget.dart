// lib/package/device/widgets/warranty_widget.dart
import 'package:flutter/material.dart';

import '../../model/hop_dong_bao_hanh_model.dart';
import '../../model/warranty_item_model.dart';
import '../repository/rarranty_repo.dart';
import 'warranty_item_card.dart';
import '../../utils/app_utils.dart';
import 'warranty_price.dart';

class WarrantyWidget extends StatefulWidget {
  final int hopDongId;

  const WarrantyWidget({super.key, required this.hopDongId});

  @override
  State<WarrantyWidget> createState() => _WarrantyWidgetState();
}

class _WarrantyWidgetState extends State<WarrantyWidget> {
  final _repo = WarrantyRepository();
  late Future<HopDongBaoHanh?> _futureHopDong;

  @override
  void initState() {
    super.initState();
    _futureHopDong = _repo.getHopDongById(widget.hopDongId);
  }

  // ưu tiên nhóm
  int _groupPriority(String? ma) {
    switch (ma) {
      case 'TAM_PIN':
        return 0;
      case 'BIEN_TAN':
        return 1;
      case 'PIN_LUU_TRU':
        return 2;
      default:
        return 99;
    }
  }

  List<WarrantyItemModel> _buildItems(HopDongBaoHanh hopDong) {
    final now = DateTime.now();

    final filtered = hopDong.vatTuHopDongs.where((e) {
      final nhom = e.vatTu?.nhomVatTu;
      return nhom != null && nhom.vatTuChinh == true;
    }).toList();

    filtered.sort((a, b) {
      final maA = a.vatTu?.nhomVatTu?.ma;
      final maB = b.vatTu?.nhomVatTu?.ma;
      return _groupPriority(maA).compareTo(_groupPriority(maB));
    });

    return filtered.map((e) {
      final vatTu = e.vatTu;
      final nhom = vatTu?.nhomVatTu;

      final start = e.baoHanhBatDau;
      final end = e.baoHanhKetThuc;

      double progress = 0;
      String statusText = '';

      if (start != null && end != null) {
        final total = end.difference(start).inDays;
        final passed = now.difference(start).inDays;
        if (total > 0) {
          progress = (passed / total).clamp(0, 1).toDouble();
        }

        statusText = now.isAfter(end) ? 'Hết hạn' : 'Còn hạn';
      }

      final anhList = vatTu?.anhVatTus ?? [];
      final image = anhList.isNotEmpty
          ? (anhList.first.tepTin?.duongDan ?? '')
          : 'assets/images/product.png';

      return WarrantyItemModel(
        productName: vatTu?.ten ?? '',
        image: image,
        activeDate: start,
        endDate: end,
        duration: e.thoiGianBaoHanh ?? 0,
        progress: progress,
        statusText: statusText,
        groupCode: nhom?.ma,
        groupName: nhom?.ten,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return FutureBuilder<HopDongBaoHanh?>(
      future: _futureHopDong,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Lỗi tải dữ liệu hợp đồng');
        }

        final hopDong = snapshot.data;
        if (hopDong == null) {
          return const Text('Không tìm thấy dữ liệu hợp đồng');
        }

        final items = _buildItems(hopDong);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: scale(0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContractValueCard(
                deliveryDate: hopDong.taoLuc != null
                    ? AppUtils.date(hopDong.taoLuc!.toIso8601String())
                    : '',
                totalValue: AppUtils.currency(hopDong.tongGia),
              ),

              SizedBox(height: scale(20)),
              // ten hợp đồng
              Text(
                hopDong.ten,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(20),
                  color: const Color(0xFF4F4F4F),
                ),
              ),

              SizedBox(height: scale(12)),

              Text(
                'Sản phẩm bảo hành',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(18),
                  color: const Color(0xFF4F4F4F),
                ),
              ),
              SizedBox(height: scale(12)),

              if (items.isEmpty) const Text('Không có sản phẩm bảo hành'),
              if (items.isNotEmpty)
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: scale(12)),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    // DateTime? -> String dd/MM/yyyy qua AppUtils
                    final activeDateStr = item.activeDate != null
                        ? AppUtils.date(item.activeDate!.toIso8601String())
                        : '';

                    final endDateStr = item.endDate != null
                        ? AppUtils.date(item.endDate!.toIso8601String())
                        : '';

                    // int tháng -> "X năm Y tháng"
                    final durationStr = AppUtils.convertMonthToYearAndMonth(
                      item.duration.toDouble(),
                    );

                    return WarrantyItemCard(
                      image: item.image,
                      statusText: item.statusText,
                      productName: item.productName,
                      activeDate: activeDateStr, // String
                      duration: durationStr, // String
                      endDate: endDateStr, // String
                      progress: item.progress,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

   
}
