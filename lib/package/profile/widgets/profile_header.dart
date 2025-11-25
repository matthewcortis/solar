import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarmaxapp/routes.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String fullName;
  final String role;

  const ProfileHeader({
    super.key,
    required this.avatarUrl,
    required this.fullName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: scale(10)),

          // --- Tiêu đề "Hồ sơ" ---
          Text(
            'Hồ sơ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: scale(20),
              height: 25 / 20,
              color: const Color(0xFF4F4F4F),
            ),
          ),

          SizedBox(height: scale(24)),

          // --- Frame chứa Avatar + Thông tin ---
          SizedBox(
            width: scale(178),
            height: scale(159),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar động
                Container(
                  width: scale(96),
                  height: scale(96),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: avatarUrl.isNotEmpty && avatarUrl.startsWith('http')
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/avatar.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            avatarUrl.isNotEmpty
                                ? avatarUrl
                                : 'assets/images/avatar.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                SizedBox(height: scale(12)),

                // --- Tên + Vai trò động ---
                Column(
                  children: [
                    Text(
                      fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: scale(18),
                        height: 28 / 18,
                        color: const Color(0xFF4F4F4F),
                      ),
                    ),
                    SizedBox(height: scale(4)),
                    Text(
                      role,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: scale(12),
                        height: 18 / 12,
                        color: const Color(0xFF848484),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSettingsTopSection extends StatelessWidget {
  const ProfileSettingsTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;
    // --- BUTTON DÙNG SVG ---
    Widget buildButton({
      required String label,
      required String svgPath,
      Color? iconColor,
      Color? textColor,
      Color? bgColor,
      bool isDanger = false,
    }) {
      return Container(
        width: scale(402),
        height: scale(64),
        padding: EdgeInsets.symmetric(
          horizontal: scale(16),
          vertical: scale(18),
        ),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: scale(24),
                  height: scale(24),
                  colorFilter: ColorFilter.mode(
                    iconColor ?? const Color(0xFF4F4F4F),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: scale(12)),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: scale(16),
                    height: 24 / 16,
                    color: textColor ?? const Color(0xFF4F4F4F),
                  ),
                ),
              ],
            ),
            if (!isDanger)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: scale(18),
                color: const Color(0xFFBDBDBD),
              ),
          ],
        ),
      );
    }

    // --- TIÊU ĐỀ SECTION ---
    Widget buildTitle(String title) {
      return Padding(
        padding: EdgeInsets.only(left: scale(14)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: scale(20),
              height: 30 / 20,
              color: const Color(0xFF4F4F4F),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: scale(32)),

          // --- Nút yêu cầu mật khẩu ---
          buildButton(
            label: 'Yêu cầu mật khẩu',
            svgPath: 'assets/icons/square-password.svg',
            iconColor: const Color(0xFFEE4037),
            textColor: const Color(0xFFEE4037),
            bgColor: Colors.white,
          ),

          SizedBox(height: scale(18)),

          // --- Nhóm Tài khoản ---
          buildTitle('Tài khoản'),
          SizedBox(height: scale(12)),
          buildButton(
            label: 'Thông tin cá nhân',
            svgPath: 'assets/icons/user-square.svg',
          ),

          SizedBox(height: scale(18)),

          // --- Nhóm Cài đặt ---
          buildTitle('Cài đặt'),
          SizedBox(height: scale(12)),
          buildButton(
            label: 'Mật khẩu',
            svgPath: 'assets/icons/square-password.svg',
          ),
          SizedBox(height: scale(12)),
          buildButton(
            label: 'Thông báo',
            svgPath: 'assets/icons/file-validation.svg',
          ),
        ],
      ),
    );
  }
}

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    // --- BUTTON DÙNG SVG ---
    Widget buildButton({
      required String label,
      required String svgPath,
      Color? iconColor,
      Color? textColor,
      Color? bgColor,
      bool isDanger = false,
    }) {
      return Container(
        width: scale(402),
        height: scale(64),
        padding: EdgeInsets.symmetric(
          horizontal: scale(16),
          vertical: scale(18),
        ),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: scale(24),
                  height: scale(24),
                  colorFilter: ColorFilter.mode(
                    iconColor ?? const Color(0xFF4F4F4F),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: scale(12)),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: scale(16),
                    height: 24 / 16,
                    color: textColor ?? const Color(0xFF4F4F4F),
                  ),
                ),
              ],
            ),
            if (!isDanger)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: scale(18),
                color: const Color(0xFFBDBDBD),
              ),
          ],
        ),
      );
    }

    // --- TIÊU ĐỀ SECTION ---
    Widget buildTitle(String title) {
      return Padding(
        padding: EdgeInsets.only(left: scale(14)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: scale(20),
              height: 30 / 20,
              color: const Color(0xFF4F4F4F),
            ),
          ),
        ),
      );
    }

    // --- UI CHÍNH ---
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: scale(18)),

          // --- Nhóm Thông tin ứng dụng ---
          buildTitle('Thông tin ứng dụng'),
          SizedBox(height: scale(12)),
          buildButton(
            label: 'Phiên bản ứng dụng',
            svgPath: 'assets/icons/user-square.svg',
          ),
          SizedBox(height: scale(12)),
          buildButton(
            label: 'Điều khoản ứng dụng',
            svgPath: 'assets/icons/license-maintenance.svg',
          ),
          SizedBox(height: scale(12)),
          buildButton(
            label: 'Liên hệ hỗ trợ',
            svgPath: 'assets/icons/information-circle.svg',
          ),

          SizedBox(height: scale(18)),
        ],
      ),
    );
  }
}

class ProfileLogoutSection extends StatelessWidget {
  const ProfileLogoutSection({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();

            if (!context.mounted) return;

            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(AppRoutes.bottomNav, (route) => false);
          },
          child: Container(
            width: scale(402),
            height: scale(48),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/logout-04.svg',
                  width: scale(24),
                  height: scale(24),
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFEE4037),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: scale(10)),
                Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(16),
                    color: const Color(0xFFEE4037),
                    height: 24 / 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: scale(20)),
      ],
    );
  }
}
