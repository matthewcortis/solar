import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../page/customer_screen.dart';
import '../repository/khach_hang_repo.dart';

class BankContractCard extends StatefulWidget {
  // DỮ LIỆU ĐỘNG TRUYỀN VÀO
  final String bankName; // Tên ngân hàng: "Techcombank"
  final String accountNumber; // Số tài khoản: "0123456789"
  final String handoverDateText; // Ngày bàn giao: "12/03/2025"
  final String totalContractValue; // Tổng giá trị hợp đồng: "12.650.000"
  final String customerCount; // Số khách hàng: "12"
  final String totalCommission; // Tổng hoa hồng: "100.000.000đ"

  // Callback khi bấm vào "Danh sách khách hàng" (nếu muốn custom)
  final VoidCallback? onTapCustomerList;

  const BankContractCard({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.handoverDateText,
    required this.totalContractValue,
    required this.customerCount,
    required this.totalCommission,
    this.onTapCustomerList,
  });

  @override
  State<BankContractCard> createState() => _BankContractCardState();
}

class _BankContractCardState extends State<BankContractCard>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  final repo = KhachHangRepository();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMainCard(scale),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded ? _buildExpandedCard(scale) : const SizedBox(),
        ),

        SizedBox(height: scale(10)),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            width: scale(32),
            height: scale(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: scale(24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(Function(double) scale) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(scale(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: scale(398),
            padding: EdgeInsets.all(scale(16)),
            decoration: BoxDecoration(
              color: const Color(0x33E6E6E6),
              borderRadius: BorderRadius.circular(scale(20)),
              border: Border.all(color: Colors.white, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26D1D1D1),
                  blurRadius: 15,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                // HÀNG BANK + SỐ TÀI KHOẢN
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tài khoản ngân hàng",
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        color: Color(0xFF848484),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.bankName, // Techcombank (dynamic)
                          style: const TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 20 / 14,
                            color: Color(0xFF4F4F4F),
                          ),
                        ),
                        SizedBox(height: scale(4)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.accountNumber, // 0123456789 (dynamic)
                              style: const TextStyle(
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 20 / 14,
                                color: Color(0xFF4F4F4F),
                              ),
                            ),
                            SizedBox(width: scale(6)),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: widget.accountNumber),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Đã sao chép số tài khoản"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                "assets/icons/copy.svg",
                                width: scale(20),
                                height: scale(20),
                                colorFilter: const ColorFilter.mode(
                                  Color.fromARGB(255, 255, 0, 0),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: scale(10)),

                // HÀNG NGÀY BÀN GIAO + TỔNG GIÁ TRỊ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: scale(174),
                          height: scale(22),
                          padding: EdgeInsets.symmetric(
                            vertical: scale(3),
                            horizontal: scale(8),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x33E6E6E6),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Ngày bàn giao:",
                                style: TextStyle(
                                  fontFamily: "SF Pro",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  height: 12 / 10,
                                  color: Color(0xFF4F4F4F),
                                ),
                              ),
                              SizedBox(width: scale(2)),
                              Text(
                                widget.handoverDateText, // dynamic
                                style: const TextStyle(
                                  fontFamily: "SF Pro",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  height: 12 / 10,
                                  color: Color(0xFF4F4F4F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: scale(4)),
                        const Text(
                          "Tổng giá trị hợp đồng",
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 20 / 14,
                            color: Color(0xFF4F4F4F),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.totalContractValue, // "12.650.000" dynamic
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: scale(22),
                            height: 1.0,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: scale(6)),
                        Icon(
                          Icons.visibility_outlined,
                          size: scale(20),
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CARD MỞ RỘNG
  Widget _buildExpandedCard(Function(double) scale) {
    return Container(
      width: scale(398),
      height: scale(99),
      margin: EdgeInsets.only(top: scale(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DANH SÁCH KHÁCH HÀNG
          GestureDetector(
            onTap: () {
              if (widget.onTapCustomerList != null) {
                widget.onTapCustomerList!();
              } else {
                // Default: sang màn danh sách khách hàng như cũ
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerListScreen(
                      customersDisplay: repo.getCustomersOfCurrentUser(),
                      totalCommission: widget.totalCommission,
                      customerCount: widget.customerCount,
                    ),
                  ),
                );
              }
            },
            child: _buildSmallInfoCard(
              scale,
              title: "Danh sách khách hàng",
              value: widget.customerCount, // dynamic
            ),
          ),

          // TỔNG SỐ HOA HỒNG
          _buildSmallInfoCard(
            scale,
            title: "Tổng số hoa hồng",
            value: widget.totalCommission, // dynamic
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard(
    Function(double) scale, {
    required String title,
    required String value,
  }) {
    return Container(
      width: scale(191),
      height: scale(99),
      padding: EdgeInsets.all(scale(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 0,
              color: Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(8)),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: scale(22),
              height: 1.0,
              letterSpacing: 0,
              color: const Color(0xFFEE4037),
            ),
          ),
        ],
      ),
    );
  }
}
