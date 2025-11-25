import 'package:flutter/material.dart';
import './package/login/page/splash_screen.dart';
import 'package/login/page/welcome_screen.dart';
import 'package/login/page/resiger_screen.dart';
import './package/login/page/login_screen_page.dart';
import './package/bottom_nav.dart';
import './package/home/page/home_page_screen.dart';
import './package/news/pages/detail_news_screen.dart';
import './package/device/page/detail_product_device_screen.dart';
import './package/product/page/detail_product_screen.dart';
import './package/home/page/warranty_device_screenn.dart';
import 'package:provider/provider.dart';
//
import './package/controllers/login/login_controller.dart';
import './package/admin/quote/page/quote_screen.dart';
import './package/product/page/bao_gia_screen.dart';

class AppRoutes {
  static final String splashScreen = '/splash-screen';
  static final String welcomeScreen = '/welcome-screen';
  static final String registerScreen = '/login-with-register-screen';
  static final String loginScreenPage = '/login-screen-page';
  static final String bottomNav = '/bottom-nav';
  static final String homeScreen = '/home';
  static final String detailNewsScreen = '/detail-news';
  static final String detailProductDevice = '/detail-product-device';
  static final String detailProduct = '/detail-product';
  static final String warrantyDeviceScreen = "/warranty";
  static final String homeAdminScreen = '/admin-home';
  static final String adminBottomNav = '/admin-bottom-nav';
  static final String quoteScreen = '/quote';
  static final String baoGiaScreen = '/thong-tin-bao-gia';
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splashScreen: (context) => const SplashScreen(),
      welcomeScreen: (context) => const WelcomeScreen(),
      registerScreen: (context) => LoginWithRegisterScreen(),

      loginScreenPage: (context) => ChangeNotifierProvider(
        create: (context) => LoginController(),
        child: const LoginScreenPage(),
      ),
      bottomNav: (context) => const MainNavScreen(),
      homeScreen: (context) => const HomeScreen(),
      detailNewsScreen: (context) => const DetailNewsScreen(),
      detailProductDevice: (context) => const ProductDetailScreen(),
      detailProduct: (context) => const DetailProduct(),
      warrantyDeviceScreen: (context) => const WarrantyDeviceScreen(),
      baoGiaScreen: (context) => ThongTinBaoGiaScreen(),

      //admin
      quoteScreen: (context) => const TaoBaoGiaScreen(),
    };
  }
}


// push() ➜ thêm 1 route mới lên stack

// pop() ➜ quay lại route trước đó

// pushReplacement() ➜ thay route hiện tại 

// pushNamed() ➜ điều hướng theo tên route (nếu đã định nghĩa trước)