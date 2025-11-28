# solar

flutter run --release

admin
 0394307569
 slm123slm123
sale
0966663387
slm123slm123

bỏ phần home header

click vào giá hợp đồng ra chi tiết bảo hành của sale

Hợp đồng bảo hành fix 

fix hiển thị thời gian bảo hành line

fix chi tiết thiết bị 


import 'package:flutter/material.dart';
import 'package:cupertino_native/components/tab_bar.dart';
import 'package:cupertino_native/style/sf_symbol.dart';

import './home/page/home_page_screen.dart';
import './combo/page/combo_screen.dart';
import './profile/page/profile_screen.dart';
import './news/pages/news_screen.dart';
import '../package/device/page/device_screen.dart';
import '../package/news/pages/detail_news_screen.dart';
import '../package/device/page/detail_product_device_screen.dart';
import '../package/product/page/detail_product_screen.dart';
import '../package/home/page/warranty_device_screenn.dart';
import './product/page/bao_gia_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0; // Mặc định

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Combo
    GlobalKey<NavigatorState>(), // Device
    GlobalKey<NavigatorState>(), // News
    GlobalKey<NavigatorState>(), // Profile
  ];

  void _onTap(int index) {
    if (index == _currentIndex) {
      // Nhấn lại tab hiện tại -> pop về root của tab đó
      _navigatorKeys[index].currentState!.popUntil((r) => r.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();

        if (isFirstRouteInTab && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return isFirstRouteInTab;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFFF8F8F8),

        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildNavigator(_navigatorKeys[0], const HomeScreen()),
            _buildNavigator(_navigatorKeys[1], const ComboListScreen()),
            _buildNavigator(_navigatorKeys[2], const DeviceListScreen()),
            _buildNavigator(_navigatorKeys[3], const NewsScreen()),
            _buildNavigator(_navigatorKeys[4], const ProfileScreen()),
          ],
        ),

        // Thanh tab dạng "viên thuốc" nổi, thấp xuống nhưng vẫn tránh home indicator
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 8.0 : 16.0,
          ),
          child: CNTabBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            split: false,
            backgroundColor: Colors.transparent,
            // nếu muốn đổi màu icon/text active:
            // tint: const Color(0xFF00A13A),

            items: const [
              CNTabBarItem(
                label: 'Trang chủ',
                icon: CNSymbol('house'),
              ),
              CNTabBarItem(
                label: 'Combo',
                icon: CNSymbol('shippingbox'),
              ),
              CNTabBarItem(
                label: 'Thiết bị',
                icon: CNSymbol('square.grid.2x2'),
              ),
              CNTabBarItem(
                label: 'Tin tức',
                icon: CNSymbol('newspaper'),
              ),
              CNTabBarItem(
                label: 'Cá nhân',
                icon: CNSymbol('person.crop.circle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigator(GlobalKey<NavigatorState> key, Widget child) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) {
        if (settings.name == '/detail-product-device') {
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(),
            settings: settings,
          );
        }

        if (settings.name == '/thong-tin-bao-gia') {
          return MaterialPageRoute(
            builder: (_) => ThongTinBaoGiaScreen(),
            settings: settings,
          );
        }

        if (settings.name == '/detail-product') {
          return MaterialPageRoute(
            builder: (_) => const DetailProduct(),
            settings: settings,
          );
        }

        if (settings.name == '/warranty') {
          return MaterialPageRoute(
            builder: (_) => const WarrantyDeviceScreen(),
            settings: settings,
          );
        }

        if (settings.name == '/detail-news') {
          return MaterialPageRoute(
            builder: (_) => const DetailNewsScreen(),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (_) => child,
          settings: settings,
        );
      },
    );
  }
}
