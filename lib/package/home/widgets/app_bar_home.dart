import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarmaxapp/routes.dart';

class SolarHeaderFullCard extends StatefulWidget {
  const SolarHeaderFullCard({
    super.key,
    required this.userName, // Tên người dùng truyền từ ngoài
    required this.roleTitle, // Vai trò hiển thị: "Khách hàng", "SALE", ...
    required this.avatarImage, // Ảnh avatar: AssetImage / NetworkImage
    this.roleCode, // Mã vai trò: "admin", "sale", "agent", "customer", "guest"
  });

  final String userName;
  final String roleTitle;
  final ImageProvider avatarImage;
  final String? roleCode;

  static const double _baseWidth = 430.0;

  @override
  State<SolarHeaderFullCard> createState() => _SolarHeaderFullCardState();
}

class _SolarHeaderFullCardState extends State<SolarHeaderFullCard> {
  double _scale(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return value * screenWidth / SolarHeaderFullCard._baseWidth;
  }

  bool get _isGuest => widget.roleCode == null || widget.roleCode == 'guest';

  // ====== BANNER AUTO SLIDE ======
  final List<String> _bannerImages = const [
    'assets/images/banner.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted || _bannerImages.isEmpty) return;
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _bannerImages.length;
      });
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  Widget _buildActionByRole(
    BuildContext context,
    String? role,
    double Function(double) scale,
  ) {
    if (role == 'admin' || role == 'sale') {
      // Admin: icon Báo giá
      return GestureDetector(
        onTap: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed(AppRoutes.quoteScreen);
        },
        child: Container(
          width: scale(46),
          height: scale(46),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/baogia.svg',
              width: scale(20),
              height: scale(20),
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    // Các role khác: icon Notification
    return Container(
      width: scale(46),
      height: scale(46),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: const Icon(Icons.notifications_none, size: 20, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    double scale(double v) => _scale(context, v);

    // KHAI BÁO style ở đây để dùng bên dưới
    final nameTextStyle = TextStyle(
      fontFamily: 'SF Pro',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: scale(16),
      height: 20 / 16,
      letterSpacing: 0,
      color: const Color(0xFF4F4F4F),
    );

    final roleTextStyle = TextStyle(
      fontFamily: 'SF Pro',
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: scale(12),
      height: 18 / 12,
      letterSpacing: 0,
      color: const Color(0xFF4F4F4F),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: scale(430),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ========= BACKGROUND BANNER FADE =========
          AnimatedSwitcher(
            duration: const Duration(seconds: 2), // fade 2s
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.asset(
              _bannerImages[_currentBannerIndex],
              key: ValueKey(_bannerImages[_currentBannerIndex]),
              fit: BoxFit.cover,
            ),
          ),

          // --- Header Avatar Glass ---
          Positioned(
            top: scale(60),
            left: scale(16),
            right: scale(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(256),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: scale(66),
                  padding: EdgeInsets.symmetric(horizontal: scale(10)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(256),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Ảnh avatar truyền từ ngoài
                          Container(
                            width: scale(55),
                            height: scale(55),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: widget.avatarImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: scale(10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TÊN / WELCOME (có animation nếu guest)
                              if (_isGuest)
                                _AnimatedGuestName(style: nameTextStyle)
                              else
                                Text(widget.userName, style: nameTextStyle),

                              if (_isGuest)
                                Text('Xin chào!', style: roleTextStyle)
                              else
                                Text(widget.roleTitle, style: roleTextStyle),
                            ],
                          ),
                        ],
                      ),
                      // Nút action theo roleCode (admin -> Báo giá, còn lại -> notification)
                      _buildActionByRole(context, widget.roleCode, scale),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Bottom content ---
          Positioned(
            bottom: scale(40),
            left: scale(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill "Hy - Brid"
                Container(
                  width: scale(84),
                  height: scale(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: scale(12),
                          vertical: scale(4),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Hy - Brid',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            fontSize: scale(11),
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: scale(6)),
                Text(
                  'Bán hàng thật dễ dàng',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: scale(24),
                    height: 36 / 24,
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: scale(10)),
                Container(
                  width: scale(148),
                  height: scale(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED1C24),
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
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_isGuest) {
                        // Guest: sang màn Welcome (đăng nhập)
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          AppRoutes.welcomeScreen,
                          (route) => false,
                        );
                      } else {
                        // Navigator.of(
                        //   context,
                        //   rootNavigator: true,
                        // ).pushNamed(AppRoutes.detailNewsScreen);
                      }
                    },
                    label: Text(
                      _isGuest ? 'Đăng nhập' : 'Tham gia ngay',
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w700,
                        fontSize: scale(14),
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: scale(18),
                        vertical: scale(8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
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

/// Text cho guest: "Solar Max" -> xóa dần -> gõ "Xin chào !"
class _AnimatedGuestName extends StatefulWidget {
  const _AnimatedGuestName({required this.style});

  final TextStyle style;

  @override
  State<_AnimatedGuestName> createState() => _AnimatedGuestNameState();
}

class _AnimatedGuestNameState extends State<_AnimatedGuestName> {
  static const String _text1 = 'Solar Max';
  static const String _text2 = 'Xin chào !';

  String _display = _text1;
  String _currentTarget = _text2; // sau khi xóa xong sẽ gõ text này
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Để nguyên "Solar Max" trong 1s rồi bắt đầu xóa
    Future.delayed(const Duration(milliseconds: 1000), _startDelete);
  }

  void _startDelete() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_display.isNotEmpty) {
        setState(() {
          _display = _display.substring(0, _display.length - 1);
        });
      } else {
        t.cancel();
        _startType();
      }
    });
  }

  void _startType() {
    _timer?.cancel();
    final target = _currentTarget;
    int index = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (index < target.length) {
        setState(() {
          _display += target[index];
          index++;
        });
      } else {
        t.cancel();

        _currentTarget = (target == _text2) ? _text1 : _text2;

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          _startDelete();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_display, style: widget.style);
  }
}
