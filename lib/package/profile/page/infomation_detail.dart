import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: scale(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: scale(20)),

              /// BACK BUTTON + TITLE
              Row(
                children: [
                  Container(
                    width: scale(48),
                    height: scale(48),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E6E6),
                      shape: BoxShape.circle,
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
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color.fromARGB(221, 255, 0, 0),
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Thông tin cá nhân',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w600,
                      fontSize: scale(20),
                      height: 25 / 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: scale(48)), // cân giữa
                ],
              ),

              SizedBox(height: scale(24)),

              /// CARD FORM
              Container(
                width: scale(398),
                padding: EdgeInsets.all(scale(16)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(scale(20)),
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
                      color: Color(0x0FD1D1D1),
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
                  children: [
                    _buildInput(
                      context,
                      label: "Họ và tên",
                      svgPath: 'assets/icons/user.svg',
                      value: "Nguyễn Văn A",
                      scale: scale,
                    ),
                    SizedBox(height: scale(12)),
                    _buildInput(
                      context,
                      label: "Ngày sinh",
                      svgPath: 'assets/icons/calendar-02.svg',
                      value: "24/07/2002",
                      scale: scale,
                    ),
                    SizedBox(height: scale(12)),
                    _buildInput(
                      context,
                      label: "Số điện thoại",
                      svgPath: 'assets/icons/call.svg',
                      value: "012345678",
                      scale: scale,
                    ),
                    SizedBox(height: scale(12)),
                    _buildInput(
                      context,
                      label: "Email",
                      svgPath: 'assets/icons/mail-01.svg',
                      value: "email@example.com",
                      scale: scale,
                    ),
                    SizedBox(height: scale(12)),
                    _buildInput(
                      context,
                      label: "Địa chỉ",
                      svgPath: 'assets/icons/location-05.svg',
                      value: "Thanh Xuân, Hà Nội",
                      scale: scale,
                    ),
                  ],
                ),
              ),

              SizedBox(height: scale(30)),

              /// BUTTON
              Container(
                width: scale(398),
                height: scale(48),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(scale(10)),
                ),
                child: Center(
                  child: Text(
                    "Chỉnh sửa thông tin",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w600,
                      fontSize: scale(16),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: scale(30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    BuildContext context, {
    required String label,
    required String svgPath,
    required String value,
    required double Function(double v) scale,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "SFPro",
            fontWeight: FontWeight.w500,
            fontSize: scale(14),
            color: Colors.black87,
          ),
        ),
        SizedBox(height: scale(8)),
        Container(
          height: scale(48),
          padding: EdgeInsets.symmetric(horizontal: scale(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(scale(12)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26D1D1D1),
                blurRadius: 34,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: Row(
            children: [
              SvgPicture.asset(svgPath, width: scale(20), height: scale(20)),
              SizedBox(width: scale(12)),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w500,
                    fontSize: scale(16),
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
