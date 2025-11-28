import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../model/extension.dart';
import '../../model/tron_goi_models.dart';

class DeviceHorizontalItemCard extends StatelessWidget {
  final String image;
  final String tag;
  final String warrantyText;
  final String name;
  final num price;

  const DeviceHorizontalItemCard({
    super.key,
    required this.image,
    required this.tag,
    required this.warrantyText,
    required this.name,
    required this.price,
  });

  /// ========= FACTORY TRUYỀN TRỰC TIẾP VatTuTronGoiDto =========
  factory DeviceHorizontalItemCard.fromVatTuTronGoi(
    VatTuTronGoiDto vatTuTronGoi, {
    Key? key,
  }) {
    final VatTuDto vatTu = vatTuTronGoi.vatTu;

    // ==== Ảnh sản phẩm ====
    // ==== Ảnh sản phẩm ====
    String imagePath = 'assets/images/product.png';
    if (vatTu.anhVatTus.isNotEmpty) {
      final TepTinDto tep = vatTu.anhVatTus.first.tepTin;
      if (tep.duongDan.isNotEmpty) {
        imagePath = tep.duongDan;
      }
    }

    // ==== Tag theo nhóm vật tư ====
    final String tag = vatTu.thuongHieu.ten;

    // ==== Bảo hành ====
    final String warrantyText = vatTuTronGoi.thoiGianBaoHanh > 0
        ? 'Bảo hành ${ TronGoiUtils.convertMonthToYearAndMonth(vatTuTronGoi.thoiGianBaoHanh)}'
        : 'Không bảo hành';
     

    // ==== Giá ====
    num gia = vatTuTronGoi.gia;

    if (gia <= 0 && vatTu.thongTinGias.isNotEmpty) {
      // Lấy bản giá đầu tiên còn dữ liệu
      final ThongTinGiaDto thongTinGia = vatTu.thongTinGias.firstWhere(
        (e) => e.dsGia.isNotEmpty,
        orElse: () => vatTu.thongTinGias.first,
      );

      final GiaInfo giaInfo = thongTinGia.dsGia.firstWhere(
        (g) => g.giaBan != null || g.giaNhap != null,
        orElse: () => thongTinGia.dsGia.first,
      );

      gia = giaInfo.giaBan ?? giaInfo.giaNhap ?? 0;
    }

    return DeviceHorizontalItemCard(
      key: key,
      image: imagePath,
      tag: tag,
      warrantyText: warrantyText,
      name: vatTu.ten,
      price: gia,
    );
  }

  /// format tiền tệ
  String _formatCurrency(num value) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(value)}đ';
  }

  Widget _buildImageWidget() {
    if (image.startsWith('http')) {
      return Image.network(image, fit: BoxFit.cover);
    }
    return Image.asset(image, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(402),
      height: scale(126),
      padding: EdgeInsets.symmetric(horizontal: scale(12), vertical: scale(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1FD1D1D1),
            blurRadius: 34,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ==== ẢNH PRODUCT ====
          Container(
            width: scale(120),
            height: scale(125),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: RadialGradient(
                radius: 0.7356,
                center: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(child: _buildImageWidget()),
                  // Positioned.fill(
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       gradient: RadialGradient(
                  //         center: Alignment.center,
                  //         radius: 0.75,
                  //         colors: [
                  //           Colors.transparent,
                  //           Color.fromRGBO(211, 211, 211, 0.2),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // TAG
                  Positioned(
                    left: scale(8),
                    top: scale(8),
                    child: Container(
                      height: scale(22),
                      padding: EdgeInsets.symmetric(
                        horizontal: scale(8),
                        vertical: scale(4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x33B5B5B5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: scale(12),
                            color: const Color(0xFF4F4F4F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: scale(12)),

          // ==== NỘI DUNG ====
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bảo hành
                Container(
                  height: scale(26),
                  padding: EdgeInsets.symmetric(
                    horizontal: scale(8),
                    vertical: scale(4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33B5B5B5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/new-releases.svg',
                        width: scale(16),
                        height: scale(16),
                      ),
                      SizedBox(width: scale(4)),
                      Text(
                        warrantyText,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: scale(12),
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: scale(8)),

                // TÊN SP
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(14),
                    color: const Color(0xFF4F4F4F),
                  ),
                ),

                SizedBox(height: scale(4)),

                // GIÁ SP
                Text(
                  _formatCurrency(price),
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(16),
                    color: const Color(0xFFEE4037),
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
