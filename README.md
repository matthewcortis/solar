# solar

bottomsheet bỏ biến tần ở - biến tần

Thiết bị bảo hành - 7 hệ 


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

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../widgets/bao_gia_item_card.dart';
import '../widgets/chi_tiet_bao_gia_card.dart';
import '../../model/tron_goi_models.dart';
import '../../model/bao_gia_draft.dart';
class ThongTinBaoGiaScreen extends StatefulWidget {
  const ThongTinBaoGiaScreen({super.key});

  @override
  State<ThongTinBaoGiaScreen> createState() => _ThongTinBaoGiaScreenState();
}

class _ThongTinBaoGiaScreenState extends State<ThongTinBaoGiaScreen> {
  final GlobalKey _captureKey = GlobalKey();
  bool _isCapturing = false;
  Uint8List? _imageBytes;

  // Channel trùng với bên iOS (AppDelegate.swift)
  static const MethodChannel _saveImageChannel = MethodChannel(
    'solarmax/save_image',
  );



  double _scale(BuildContext context, double v) {
    final width = MediaQuery.of(context).size.width;
    return v * width / 430;
  }

  /// Lấy danh sách "Thông tin chi tiết" từ API (vật tư phụ)
  ///
  /// Điều kiện:
  /// - vatTu.nhomVatTu.vatTuChinh == false
  /// - duocXem == false
  List<Map<String, Object>> get _detailItems {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! TronGoiDto) return [];

    final TronGoiDto tronGoi = args;
    final allItems = tronGoi.vatTuTronGois;

     

    final otherMaterials = allItems.where((e) {
      final bool laVatTuPhu = e.vatTu.nhomVatTu.vatTuChinh == false;
      final bool khongDuocXem = e.duocXem == false;
      return laVatTuPhu && khongDuocXem;
    }).toList();

    return List.generate(otherMaterials.length, (index) {
      final item = otherMaterials[index];

      final String name = item.vatTu.ten;
      final String donVi = item.vatTu.donVi;
      final String soLuongText = _formatQuantity(item.soLuong);

      final String qty = [
        soLuongText,
        if (donVi.isNotEmpty) donVi,
      ].join(' ');

      return {
        'index': index + 1, // 1,2,3,...
        'name': name,
        'qty': qty,
      };
    });
  }

  /// Format số lượng bỏ số 0 dư sau dấu phẩy
  String _formatQuantity(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    String s = value.toStringAsFixed(2);
    s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }

  Future<void> _saveToGallery(Uint8List bytes) async {
    try {
      await _saveImageChannel.invokeMethod('saveImage', bytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu ảnh vào Thư viện (Photos)')),
      );
    } on PlatformException catch (e) {
      debugPrint('Lưu ảnh lỗi: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lưu ảnh thất bại')));
    }
  }

  Future<void> _captureFullPage() async {
    setState(() => _isCapturing = true);

    // Chờ 1 frame để Offstage layout xong
    await Future.delayed(const Duration(milliseconds: 50));

    final boundary =
        _captureKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;

    if (boundary == null) {
      setState(() => _isCapturing = false);
      return;
    }

    try {
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes == null) {
        setState(() => _isCapturing = false);
        return;
      }

      setState(() {
        _isCapturing = false;
        _imageBytes = pngBytes;
      });

      // Lưu thẳng vào Photos (native iOS)
      await _saveToGallery(pngBytes);
    } catch (e) {
      setState(() => _isCapturing = false);
      debugPrint('Lỗi chụp ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tronGoi = ModalRoute.of(context)!.settings.arguments as TronGoiDto;
    final detailItems = _detailItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureFullPage,
        child: const Icon(Icons.camera_alt),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // ===== BẢN NGƯỜI DÙNG THẤY (CÓ SCROLL) =====
            Column(
              children: [
                _buildTopHeader(context),
                SizedBox(height: _scale(context, 12)),
                _buildBackAndTitle(context),
                SizedBox(height: _scale(context, 8)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDeviceList(context, tronGoi),
                        SizedBox(height: _scale(context, 16)),
                        _buildComboBanner(
                          context,
                          'assets/images/banner-thietbi.png',
                        ),
                        SizedBox(height: _scale(context, 8)),
                        _buildDetailSection(context, detailItems),
                        SizedBox(height: _scale(context, 24)),
                      ],
                    ),
                  ),
                ),

                // Nếu muốn xem preview ảnh chụp thì mở comment đoạn này:
                // if (_imageBytes != null)
                //   SizedBox(
                //     height: _scale(context, 160),
                //     child: Image.memory(_imageBytes!, fit: BoxFit.contain),
                //   ),
              ],
            ),

            // ===== BẢN ẨN ĐỂ CHỤP FULL (KHÔNG SCROLL, CAO HƠN MÀN HÌNH) =====
            Offstage(
              offstage: !_isCapturing,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: double.infinity,
                child: RepaintBoundary(
                  key: _captureKey,
                  child: Container(
                    color: const Color(0xFFF8F8F8),
                    width: MediaQuery.of(context).size.width,
                    child: _buildCaptureContent(context, detailItems),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== CÁC PHẦN UI DÙNG LẠI ==================

  Widget _buildTopHeader(BuildContext context) {
    final scale = _scale;

    return Container(
      width: double.infinity,
      height: scale(context, 55.78),
      padding: EdgeInsets.symmetric(
        horizontal: scale(context, 16),
        vertical: scale(context, 12),
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
          SizedBox(
            width: scale(context, 123.16),
            height: scale(context, 31.78),
            child: Image.asset(
              'assets/images/iconapp.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: scale(context, 12),
              vertical: scale(context, 4),
            ),
            child: Text(
              'BẬT ĐỂ TIẾT KIỆM ĐIỆN',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                fontSize: scale(context, 14),
                height: 20 / 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackAndTitle(BuildContext context) {
    final scale = _scale;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale(context, 14)),
      child: SizedBox(
        width: scale(context, 402),
        height: scale(context, 48),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: scale(context, 40),
                height: scale(context, 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
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
                    fontSize: scale(context, 18),
                    height: 24 / 18,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ),
            ),
            SizedBox(width: scale(context, 40)), // cân với nút back
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(BuildContext context, TronGoiDto tronGoi) {
    final scale = _scale;
    final List<VatTuTronGoiDto> filtered = tronGoi.vatTuTronGois.where((e) {
      final vatTu = e.vatTu;

      final bool laVatTuChinh = vatTu.nhomVatTu.vatTuChinh == true;
      final bool duocXem = e.duocXem == true || e.duocXem == null;

      return laVatTuChinh && duocXem;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale(context, 14)),
      child: SizedBox(
        width: scale(context, 402),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final vt in filtered) ...[
              DeviceHorizontalItemCard.fromVatTuTronGoi(vt),
              SizedBox(height: scale(context, 12)),
            ],
          ],
        ),
      ),
    );
  }
//
  Widget _buildComboBanner(BuildContext context, String imageUrl) {
    final scale = _scale;

    return SizedBox(
      width: scale(context, 430),
      height: scale(context, 180),
      child: ClipRRect(
        child: Image.asset(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    List<Map<String, Object>> detailItems,
  ) {
    final scale = _scale;

    return Container(
      width: scale(context, 430),
      padding: EdgeInsets.only(
        top: scale(context, 16),
        left: scale(context, 16),
        right: scale(context, 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: scale(context, 16),
              height: 24 / 16,
              color: const Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(context, 12)),
          Column(
            children: detailItems.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: scale(context, 6)),
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

  // Layout dành riêng cho chụp ảnh (full chiều dài, không scroll)
  Widget _buildCaptureContent(
    BuildContext context,
    List<Map<String, Object>> detailItems,
  ) {
    final width = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Column(
        children: [
          _buildTopHeader(context),
          SizedBox(height: _scale(context, 12)),
          _buildBackAndTitle(context),
          SizedBox(height: _scale(context, 8)),
          _buildDeviceList(
            context,
            ModalRoute.of(context)!.settings.arguments as TronGoiDto,
          ),
          SizedBox(height: _scale(context, 16)),
          _buildComboBanner(context, 'assets/images/banner-thietbi.png'),
          SizedBox(height: _scale(context, 8)),
          _buildDetailSection(context, detailItems),
          SizedBox(height: _scale(context, 24)),
        ],
      ),
    );
  }
}



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
