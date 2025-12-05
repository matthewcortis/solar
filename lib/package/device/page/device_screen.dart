import 'package:flutter/material.dart';

import '../model/category.dart';
import '../repository/load_all_category.dart';
import '../widgets/device_widgets.dart';
import '../page/all_device_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../model/tron_goi_models.dart'; // VatTuDto

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  late Future<CategoryModel> futureCategory1;
  late Future<CategoryModel> futureCategory2;
  late Future<CategoryModel> futureCategory3;

  bool _showAllProducts = false;
  String _currentTitle = '';
  List<VatTuDto> _currentProducts = [];

  @override
  void initState() {
    super.initState();
    futureCategory1 = loadCategoryById(1);
    futureCategory2 = loadCategoryById(2);
    futureCategory3 = loadCategoryById(3);
  }

  void _openAllProducts(String title, List<VatTuDto> products) {
    setState(() {
      _showAllProducts = true;
      _currentTitle = title;
      _currentProducts = products;
    });
  }

  void _goBack() {
    setState(() {
      _showAllProducts = false;
      _currentTitle = '';
      _currentProducts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    if (_showAllProducts) {
      return AllProductDeviceScreen(
        title: _currentTitle,
        products: _currentProducts, // List<VatTuDto>
        onBack: _goBack,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: scale(0),
              vertical: scale(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Danh sách thiết bị',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    fontSize: scale(20),
                    height: 25 / 20,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
                SizedBox(height: scale(24)),

                // --- Danh mục 1: Tấm quang năng ---
                FutureBuilder<CategoryModel>(
                  future: futureCategory1,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DeviceWidgetSection(
                      category: snapshot.data!,
                      onShowAll: _openAllProducts, // (String, List<VatTuDto>)
                    );
                  },
                ),
                SizedBox(height: scale(32)),

                // --- Danh mục 2: Biến tần ---
                FutureBuilder<CategoryModel>(
                  future: futureCategory2,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DeviceWidgetSection(
                      category: snapshot.data!,
                      onShowAll: _openAllProducts,
                    );
                  },
                ),
                SizedBox(height: scale(32)),

                // --- Danh mục 3: Pin Lithium ---
                FutureBuilder<CategoryModel>(
                  future: futureCategory3,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return _buildShimmerSection(scale);
                    }
                    return DeviceWidgetSection(
                      category: snapshot.data!,
                      onShowAll: _openAllProducts,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerSection(double Function(double) scale) {
    return Shimmer(
      duration: const Duration(milliseconds: 1200),
      interval: const Duration(milliseconds: 400),
      color: Colors.grey.shade300,
      colorOpacity: 0.4,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: scale(200), height: scale(18), color: Colors.white),
          SizedBox(height: scale(12)),
          Container(width: scale(120), height: scale(26), color: Colors.white),
          SizedBox(height: scale(12)),

          // SỬA Ở ĐÂY
          SizedBox(
            height: scale(260),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: EdgeInsets.only(right: scale(12)),
                    width: scale(220),
                    height: scale(260),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(scale(20)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
