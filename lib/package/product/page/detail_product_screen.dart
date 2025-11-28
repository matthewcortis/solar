import 'package:flutter/material.dart';
import '../widgets/top_bar_detail.dart';
import '../widgets/device_section.dart';
import '../../product/widgets/other_materials_section.dart';

import '../repository/detail_tron_goi.dart';
import '../../model/tron_goi_models.dart';
import '../../utils/app_utils.dart';
import '../../model/extension.dart';

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
      body: FutureBuilder<TronGoiDto>(
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

          // Ảnh combo: dùng đường dẫn từ TepTinDto
          final String imageUrl = tronGoi.tepTin.duongDan;

          // Danh sách vật tư trong combo
          final allItems = tronGoi.vatTuTronGois;

          // Thiết bị chính (vatTuChinh = true, duocXem != false)
          final deviceProducts = allItems
              .where(
                (e) =>
                    e.vatTu.nhomVatTu.vatTuChinh == true && (e.duocXem ?? true),
              )
              .toList();

          // Vật tư phụ (vatTuChinh = false, duocXem == false)
          final otherMaterials = allItems
              .where(
                (e) =>
                    e.vatTu.nhomVatTu.vatTuChinh == false &&
                    (e.duocXem == false),
              )
              .toList();

          print('==============================');
          print(' DETAIL COMBO ID = $comboId');
          print(' tronGoi.id = ${tronGoi.id}');
          print(' tronGoi.co so = ${tronGoi.coSo.id}');
          print(' tronGoi.ten = ${tronGoi.ten}');
          print(' tronGoi.taoLuc = ${tronGoi.taoLuc}');
          print(' tronGoi.tongGia = ${tronGoi.tongGia}');
          print(' tronGoi.tepTin.duongDan = ${tronGoi.tepTin.duongDan}');
          print(' mainDeviceProducts.length = ${deviceProducts.length}');
          print(' otherMaterials.length = ${otherMaterials.length}');
          print(' sanLuongToiThieu = ${tronGoi.sanLuongToiThieu}');
          print(' sanLuongToiDa = ${tronGoi.sanLuongToiDa}');
          print(' congSuatHeThong = ${tronGoi.congSuatHeThong}');
          print('==============================');
          final vatTuTronGois = tronGoi.vatTuTronGois;
          final String priceText = AppUtils.formatVNDNUM(tronGoi.tongGia);

          final double? congSuatPVkWp = TronGoiUtils.calcCongSuatByGroup(
            vatTuTronGois,
            'TAM_PIN',
          );
          final String congSuatPVText = TronGoiUtils.formatKw(congSuatPVkWp);

          final double? congSuatBienTanKw = TronGoiUtils.calcCongSuatByGroup(
            vatTuTronGois,
            'BIEN_TAN',
          );
          final String bienTanText = TronGoiUtils.formatKw(congSuatBienTanKw);

          final double? luuTru = TronGoiUtils.calcCongSuatByGroup(
            vatTuTronGois,
            'PIN_LUU_TRU',
          );
          final String luuTruText = TronGoiUtils.formatKw(luuTru);

          final String sanLuongText =
              '${TronGoiUtils.formatCongSuatHeThong(tronGoi.sanLuongToiThieu)}'
              ' - ${TronGoiUtils.formatCongSuatHeThong(tronGoi.sanLuongToiDa)} kWh/tháng';

          // 2) Số tháng hoàn vốn
          final double sanLuongTB =
              tronGoi.sanLuongToiThieu / 2 + tronGoi.sanLuongToiDa / 2;
          final double soThangHoanVon = tronGoi.tongGia / sanLuongTB / 3000.0;
          final String showingTime = TronGoiUtils.convertMonthToYearAndMonth(
            soThangHoanVon,
          );

          final double? dienTich = TronGoiUtils.calcDienTichM2(
            tronGoi.vatTuTronGois,
          );

          final String dienTichText = dienTich != null
              ? '${dienTich.toStringAsFixed(1)} m²'
              : '--';

          final khungNhom = groupVatTuByNhom(
            otherMaterials,
            'HE_KHUNG_NHOM',
            'Hệ khung nhôm',
          );
          final dayDien = groupVatTuByNhom(
            otherMaterials,
            'HE_DAY_DIEN',
            'Hệ dây điện',
          );
          final tuDien = groupVatTuByNhom(otherMaterials, 'TU_DIEN', 'Tủ điện');
          final tiepDia = groupVatTuByNhom(
            otherMaterials,
            'HE_TIEP_DIA',
            'Hệ tiếp địa',
          );
          final tronGoiLapDat = groupVatTuByNhom(
            otherMaterials,
            'TRON_GOI_LAP_DAT',
            'Trọn gói lắp đặt',
          );

          final List<VatTuGroupResult> groupedMaterials = [
            khungNhom,
            dayDien,
            tuDien,
            tiepDia,
            tronGoiLapDat,
          ];

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Ảnh combo
                    SizedBox(
                      width: width,
                      height: 340,
                      child: ProductImagePreview(imageUrl: imageUrl),
                    ),

                    // Card thông tin combo
                    ComboDetailCard(
                      title: tronGoi.ten,
                      priceText: priceText,
                      description: tronGoi.moTa,
                      tronGoi: tronGoi,
                    ),

                    // Thông tin chi tiết (PV, inverter, lưu trữ...)
                    ComboDetailInfo(
                      congSuatPV: congSuatPVText,
                      bienTan: bienTanText,
                      luuTru: luuTruText,
                      sanLuong: sanLuongText,
                      hoanVon: showingTime,
                      dienTich: dienTichText,
                    ),

                    const SizedBox(height: 10),

                    // Danh sách thiết bị chính
                    DeviceSection(deviceProducts: deviceProducts),

                    const SizedBox(height: 10),

                    // Vật tư khác
                    OtherMaterialsSection(groups: groupedMaterials),
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
