import 'package:flutter/material.dart';
import '../widgets/bao_gia_item_card.dart';
import '../widgets/chi_tiet_bao_gia_card.dart';

class ThongTinBaoGiaScreen extends StatelessWidget {
  const ThongTinBaoGiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    final detailItems = [
      {'index': 1, 'name': 'Tấm quang năng – N-Type', 'qty': '8 tấm'},
      {'index': 2, 'name': 'Biến tần On-Grid 5kW – 1 pha', 'qty': '1 bộ'},
      {'index': 3, 'name': 'Hệ thống khung đỡ tấm quang năng', 'qty': '1 bộ'},
      {'index': 4, 'name': 'Hệ dây dẫn, định lượng mặt trời', 'qty': '1 bộ'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // ================= TOP HEADER =================
            Container(
              width: double.infinity,
              height: scale(55.78),
              padding: EdgeInsets.symmetric(
                horizontal: scale(16),
                vertical: scale(12),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00B86B), Color(0xFF00A85A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo SolarMax
                  SizedBox(
                    width: scale(123.16),
                    height: scale(31.78),
                    child: Image.asset(
                      'assets/images/iconapp.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: scale(12),
                      vertical: scale(4),
                    ),
                    child: Text(
                      'BẬT ĐỂ TIẾT KIỆM ĐIỆN',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                        fontSize: scale(14),
                        height: 20 / 14,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: scale(12)),

            // ============ FRAME BACK + TITLE ============
            Padding(
              padding: EdgeInsets.symmetric(horizontal: scale(14)),
              child: SizedBox(
                width: scale(402),
                height: scale(48),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: scale(40),
                        height: scale(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'THÔNG TIN BÁO GIÁ',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: scale(18),
                            height: 24 / 18,
                            color: const Color(0xFF4F4F4F),
                          ),
                        ),
                      ),
                    ),
                    // để cân 2 bên với nút back
                    SizedBox(width: scale(40)),
                  ],
                ),
              ),
            ),

            SizedBox(height: scale(8)),

            // ================== BODY ==================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ===== LIST THIẾT BỊ =====
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: scale(14)),
                      child: SizedBox(
                        width: scale(402),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DeviceHorizontalItemCard(
                              image: 'assets/images/product.png',
                              tag: 'Hy-Brid',
                              warrantyText: 'Bảo hành 12 năm vật lý',
                              name: 'Tấm PV JA SOLAR',
                              price: 2150000,
                            ),
                            SizedBox(height: scale(12)),
                            DeviceHorizontalItemCard(
                              image: 'assets/images/product.png',
                              tag: 'Hy-Brid',
                              warrantyText: 'Bảo hành 12 năm vật lý',
                              name: 'Biến Tần SOLIS | 5kW',
                              price: 49900000,
                            ),
                            SizedBox(height: scale(12)),
                            DeviceHorizontalItemCard(
                              image: 'assets/images/product.png',
                              tag: 'Hy-Brid',
                              warrantyText: 'Bảo hành 12 năm vật lý',
                              name: 'Pin DYNESS | Bàn Đứng',
                              price: 49900000,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: scale(16)),

                    // ===== BANNER QUẢNG CÁO =====
                    _buildComboBanner(
                      scale,
                      'assets/images/banner-thietbi.png',
                    ),

                    SizedBox(height: scale(8)),

                    // ===== THÔNG TIN CHI TIẾT =====
                    _buildDetailSection(scale, detailItems),

                    SizedBox(height: scale(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboBanner(double Function(double v) scale, String imageUrl) {
    return SizedBox(
      width: scale(430),
      height: scale(180),
      child: ClipRRect(
        child: Image.asset(
          "assets/images/banner-thietbi.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    double Function(double v) scale,
    List<Map<String, Object>> detailItems,
  ) {
    return Container(
      width: scale(430),
      padding: EdgeInsets.only(
        top: scale(16),
        left: scale(16),
        right: scale(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: scale(16),
              height: 24 / 16,
              color: const Color(0xFF4F4F4F),
            ),
          ),

          SizedBox(height: scale(12)),

          Column(
            children: detailItems.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: scale(6)),
                child: BaoGiaItemCard(
                  index: item['index'] as int,
                  title: item['name'] as String,
                  qty: item['qty'] as String,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
