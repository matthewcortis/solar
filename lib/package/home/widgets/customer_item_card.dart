import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerItemCard extends StatelessWidget {
  final int hopDongId;
  final String name;
  final String avatar;
  final String giaTriHopDong;
  final String ngayBanGiao;
  final String hoaHong;

  const CustomerItemCard({
    super.key,
    required this.hopDongId,
    required this.name,
    required this.avatar,
    required this.giaTriHopDong,
    required this.ngayBanGiao,
    required this.hoaHong,
  });

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
            width: scale(398),
            height: scale(162),
            padding: EdgeInsets.all(scale(16)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26D1D1D1),
                  blurRadius: 34,
                  offset: Offset(0, 15),
                ),
                BoxShadow(
                  color: Color(0x21D1D1D1),
                  blurRadius: 61,
                  offset: Offset(0, 61),
                ),
                BoxShadow(
                  color: Color(0x14D1D1D1),
                  blurRadius: 82,
                  offset: Offset(0, 137),
                ),
                BoxShadow(
                  color: Color(0x0DD1D1D1),
                  blurRadius: 98,
                  offset: Offset(0, 244),
                ),
                BoxShadow(
                  color: Color(0x00D1D1D1),
                  blurRadius: 107,
                  offset: Offset(0, 382),
                ),
              ],
            ),

            /// ✅ Stack để thêm nút ở góc phải trên
            child: Stack(
              children: [
                /// ===== Nội dung chính: avatar + text =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: scale(60),
                      height: scale(60),
                      padding: EdgeInsets.all(scale(1)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.transparent],
                        ),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0D000000), blurRadius: 12),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(avatar, fit: BoxFit.cover),
                      ),
                    ),

                    SizedBox(width: scale(12)),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: scale(4)),

                          // _buildStatusTag(scale, trangThai),
                          SizedBox(height: scale(6)),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                              fontSize: scale(16),
                              height: 24 / 16,
                              color: const Color(0xFF4F4F4F),
                            ),
                          ),

                          SizedBox(height: scale(4)),
                          Row(
                            children: [
                              Text(
                                "Giá trị hợp đồng  • ",
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: scale(14),
                                  height: 20 / 14,
                                  color: const Color(0xFF848484),
                                ),
                              ),
                              Text(
                                giaTriHopDong,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                  fontSize: scale(14),
                                  height: 20 / 14,
                                  color: const Color(0xFFEE4037),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                "Ngày bàn giao  • ",
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: scale(14),
                                  height: 20 / 14,
                                  color: const Color(0xFF848484),
                                ),
                              ),
                              Text(
                                ngayBanGiao,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: scale(14),
                                  height: 20 / 14,
                                  color: const Color(0xFF4F4F4F),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                "Hoa hồng  • ",
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: scale(14),
                                  height: 20 / 14,
                                  color: const Color(0xFF848484),
                                ),
                              ),
                              Text(
                                hoaHong,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                  fontSize: scale(14),
                                  height: 20 / 14,
                                  color: const Color(0xFFEE4037),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// NÚT BẤM
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/warranty',
                        arguments: hopDongId,
                      );
                    },

                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: scale(40),
                      height: scale(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26D1D1D1),
                            blurRadius: 34,
                            offset: Offset(0, 15),
                          ),
                          BoxShadow(
                            color: Color(0x21D1D1D1),
                            blurRadius: 61,
                            offset: Offset(0, 61),
                          ),
                          BoxShadow(
                            color: Color(0x14D1D1D1),
                            blurRadius: 82,
                            offset: Offset(0, 137),
                          ),
                          BoxShadow(
                            color: Color(0x0DD1D1D1),
                            blurRadius: 98,
                            offset: Offset(0, 244),
                          ),
                          BoxShadow(
                            color: Color(0x00D1D1D1),
                            blurRadius: 107,
                            offset: Offset(0, 382),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/arrow-up-right-01-round.svg",
                          width: scale(22),
                          height: scale(22),
                          colorFilter: const ColorFilter.mode(
                            Color.fromARGB(255, 255, 0, 0),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildStatusTag(Function(double) scale, String trangThai) {
  //   final hetHan = trangThai.toLowerCase().contains("đã hết hạn");

  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: scale(8), vertical: scale(4)),
  //     decoration: BoxDecoration(
  //       color: hetHan ? const Color(0xFFFCEEE6) : const Color(0xFFEFFEF5),
  //       borderRadius: BorderRadius.circular(100),
  //       border: Border.all(
  //         color: hetHan
  //             ? const Color(0xFFF8DECD)
  //             : Colors.white.withOpacity(0.7),
  //         width: 1,
  //       ),
  //     ),
  //     child: Text(
  //       trangThai,
  //       style: TextStyle(
  //         fontFamily: 'SF Pro',
  //         fontWeight: FontWeight.w400,
  //         fontSize: scale(10),
  //         height: 12 / 10,
  //         color: hetHan ? const Color(0xFFDC5903) : const Color(0xFF0F974A),
  //       ),
  //     ),
  //   );
  // }
}
