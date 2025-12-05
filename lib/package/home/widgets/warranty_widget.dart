// lib/package/device/widgets/warranty_widget.dart
import 'package:flutter/material.dart';

import '../../model/tron_goi_models.dart';
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
  late Future<HopDongBaoHanhDto?> _futureHopDong;

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

  /// Lọc & sort danh sách vật tư bảo hành chính
  List<VatTuHopDongBaoHanhDto> _buildItems(HopDongBaoHanhDto hopDong) {
    final filtered = hopDong.vatTuHopDongs.where((e) {
      // vật tư chính dựa vào nhomVatTu.vatTuChinh
      final nhom = e.vatTu.nhomVatTu;
      return nhom.vatTuChinh == true;
    }).toList();

    filtered.sort((a, b) {
      final maA = a.nhomMa.isNotEmpty ? a.nhomMa : a.vatTu.nhomVatTu.ma;
      final maB = b.nhomMa.isNotEmpty ? b.nhomMa : b.vatTu.nhomVatTu.ma;
      return _groupPriority(maA).compareTo(_groupPriority(maB));
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return FutureBuilder<HopDongBaoHanhDto?>(
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
        final now = DateTime.now();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: scale(0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Giá trị hợp đồng + ngày tạo (gần tương đương ngày bàn giao)
              ContractValueCard(
                deliveryDate: hopDong.taoLuc != null
                    ? AppUtils.date(hopDong.taoLuc!.toIso8601String())
                    : '',
                totalValue: AppUtils.currency(hopDong.tongGia),
              ),

              SizedBox(height: scale(20)),

              // Tên hợp đồng
              Text(
                hopDong.tenHopDong,
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
                    final vatTu = item.vatTu;

                    final start = item.baoHanhBatDau;
                    final end = item.baoHanhKetThuc;

                    String statusText = '';
                    if (start != null && end != null) {
                      statusText = now.isAfter(end) ? 'Hết hạn' : 'Còn hạn';
                    }

                    // ảnh
                    final anhList = vatTu.anhVatTus;
                    final String image = anhList.isNotEmpty
                        ? (anhList.first.tepTin.duongDan)
                        : 'assets/images/product.png';

                    // DateTime? -> String dd/MM/yyyy
                    final activeDateStr = start != null
                        ? AppUtils.date(start.toIso8601String())
                        : '';

                    final endDateStr = end != null
                        ? AppUtils.date(end.toIso8601String())
                        : '';

                    // int tháng -> "X năm Y tháng"
                    final durationMonths = item.thoiGianBaoHanhEffective;
                    final durationStr = AppUtils.convertMonthToYearAndMonth(
                      durationMonths.toDouble(),
                    );

                    return WarrantyItemCard(
                      image: image,
                      statusText: statusText,
                      productName: vatTu.ten,
                      activeDate: activeDateStr,
                      duration: durationStr,
                      endDate: endDateStr,
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
