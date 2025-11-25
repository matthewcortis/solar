import 'package:flutter/material.dart';
import '../widgets/top_bar_detail.dart';
import '../widgets/device_section.dart';

import '../../product/widgets/other_materials_section.dart';

import '../repository/detail_tron_goi.dart';
import '../model/combo_detail.dart';
import '../../model/tron_goi.dart';
import '../../utils/app_utils.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final Object? args = ModalRoute.of(context)?.settings.arguments;

    int? comboId;
    if (args is int) {
      comboId = args;
    } else if (args is String) {
      comboId = int.tryParse(args);
    }

    if (comboId == null) {
      print('DetailProduct: KHÔNG nhận được comboId, args = $args');
      return const Scaffold(body: Center(child: Text('Không tìm thấy combo')));
    }

    print('DetailProduct nhận comboId: $comboId');

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<TronGoiBase>(
        future: TronGoiRepository().getTronGoiById(comboId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Lỗi load chi tiết combo $comboId: ${snapshot.error}');
            return const Center(child: Text('Lỗi tải dữ liệu combo'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu combo'));
          }

          final tronGoi = snapshot.data!;
          final detail = tronGoi.toDetailData();
          final deviceProducts = tronGoi.mainDeviceProducts;

          String showingTime = tronGoi.showingTime ?? 'Đang cập nhật';

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      height: 355,
                      child: ProductImagePreview(imageUrl: detail.imageUrl),
                    ),
                    ComboDetailCard(
                      savingPerMonthText: '5.000.000 đ',
                      title: detail.comboName,
                      priceText: AppUtils.formatVNDNUM(detail.totalPrice),
                      description: detail.description,
                    ),
                    ComboDetailInfo(
                      congSuatPV: detail.congSuatTamPin != null
                          ? '${detail.congSuatTamPin} kWp'
                          : '--',
                      bienTan: detail.congSuatBienTan != null
                          ? '${detail.congSuatBienTan} kW'
                          : '--',
                      luuTru: detail.dungLuongLuuTruKwh != null
                          ? '${detail.dungLuongLuuTruKwh} kWh'
                          : '--',
                      sanLuong:
                          '${detail.sanLuongMin} - ${detail.sanLuongMax} kWh/tháng',
                      hoanVon: showingTime,
                      dienTich: detail.dienTichTamPinM2 != null
                          ? '${detail.dienTichTamPinM2} m²'
                          : '--',
                    ),

                    const SizedBox(height: 10),

                    DeviceSection(deviceProducts: deviceProducts),

                    const SizedBox(height: 10),
                    OtherMaterialsSection(
                      materials: tronGoi.otherVisibleVatTus,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
