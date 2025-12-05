import 'package:flutter/material.dart';

import '../../home/services/product_category_model.dart';
import '../services/load_product.dart';

import '../widgets/app_bar_home.dart';
// Nếu SolarHeaderFullCard nằm ở file khác, bạn nhớ import đúng file đó.
// import '../widgets/solar_header_full_card.dart';
import './customer_screen.dart';
import '../widgets/list_product.dart';
import '../widgets/warranty_price.dart';
import '../widgets/bank_contract_info.dart';

import '../../controllers/login/auth_storage.dart';

import '../repository/hot_combo_repo.dart';
import '../repository/hop_dong_repo.dart';
import '../repository/khach_hang_repo.dart';

import '../../news/pages/news_screen.dart';

import '../../model/hop_dong_model.dart';
import '../../model/tron_goi_models.dart';

import '../../utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sản phẩm
  late final Future<ProductCategoryModel> _futureProducts;

  // Hợp đồng giới thiệu (cho admin / sale / agent)
  final HopDongRepository _hopDongRepository = HopDongRepository();
  late Future<List<HopDongModel>> _futureHopDong;

  // Hợp đồng của chính user đăng nhập (cho customer)
  final HopDongCuaToiRepository _repoHopDong = HopDongCuaToiRepository();
  late Future<List<HopDongModel>> _futureHopDongCuaToi;

  // Combo bán chạy
  final TronGoiRepository _tronGoiRepository = TronGoiRepository();
  late final Future<List<TronGoiDto>> _futureBestSeller;

  // Khách hàng
  final repo = KhachHangRepository();

  // Thông tin auth
  String userRole = 'guest';
  String? bankNameFromAuth;
  String? bankAccountFromAuth;
  String? fullName;
  String? avatarUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9VGV6Xyj-5_ZyotLIuuTGTfLHe0f2w44rQ&s';

  @override
  void initState() {
    super.initState();

    _futureProducts = loadAllProducts();
    _futureBestSeller = _tronGoiRepository.getDanhSachBanChay();

    _futureHopDong = _hopDongRepository.getHopDongGioiThieu();
    _futureHopDongCuaToi = _repoHopDong.getHopDongCuaUserDangNhap();

    _loadRole();
    _loadBankInfo();
  }

  Future<void> _loadRole() async {
    final role = await AuthStorage.getRole();
    debugPrint('HomeScreen _loadRole -> $role');
    setState(() {
      userRole = role ?? 'guest';
    });
  }

  Future<void> _loadBankInfo() async {
    bankNameFromAuth = await AuthStorage.getBankName();
    bankAccountFromAuth = await AuthStorage.getBankAccount();
    fullName = await AuthStorage.getFullName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HomeScreen build userRole = $userRole');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: FutureBuilder<ProductCategoryModel>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  // Header tổng
                  SolarHeaderFullCard(
                    userName: fullName ?? 'Không tên',
                    roleTitle: AppUtils().mapRoleToDisplay(userRole),
                    avatarImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                        ? NetworkImage(avatarUrl!)
                        : const AssetImage('assets/images/avatar.jpg'),
                    roleCode: userRole,
                  ),
                  const SizedBox(height: 14),

                  // ================== PHÂN QUYỀN THEO ROLE ==================
                  if (userRole == "guest") ...[
                    const SizedBox.shrink(),
                  ] else if (userRole == "customer") ...[
                    FutureBuilder<List<HopDongModel>>(
                      future: _futureHopDongCuaToi,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ContractValueCardShimmer();
                        }

                        if (snapshot.hasError) {
                          debugPrint(
                            'Lỗi tải hợp đồng (của tôi): ${snapshot.error}',
                          );
                        }

                        final list = snapshot.data ?? [];
                        HopDongModel? hopDong = list.isNotEmpty
                            ? list.first
                            : null;

                        String handoverDateText = '';
                        double tongGia = 0;
                        if (hopDong != null) {
                          handoverDateText = hopDong.taoLuc != null
                              ? AppUtils.date(hopDong.taoLuc!)
                              : '';
                          tongGia = hopDong.tongGia ?? 0;
                        }

                        if (hopDong == null) {
                          return const SizedBox.shrink();
                        }

                        return ContractValueCard(
                          deliveryDate: handoverDateText,
                          totalValue: AppUtils.currency(tongGia),
                          onView: () {
                            Navigator.of(
                              context,
                            ).pushNamed('/warranty', arguments: hopDong.id);
                          },
                        );
                      },
                    ),
                  ] else if (userRole == "admin" ||
                      userRole == "sale" ||
                      userRole == "agent") ...[
                    FutureBuilder<List<dynamic>>(
                      future: Future.wait([
                        _futureHopDong, // [0] Hợp đồng giới thiệu
                        _futureHopDongCuaToi, // [1] Hợp đồng của chính user
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const BankContractCardShimmer();
                        }

                        if (snapshot.hasError) {
                          return Text('Lỗi tải hợp đồng: ${snapshot.error}');
                        }

                        final results = snapshot.data;
                        if (results == null || results.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        // Ép kiểu 2 danh sách
                        final List<HopDongModel> listGioiThieu =
                            (results[0] as List<HopDongModel>?) ?? [];
                        final List<HopDongModel> listCuaToi =
                            (results[1] as List<HopDongModel>?) ?? [];

                        final HopDongModel? hopDongGioiThieu =
                            listGioiThieu.isNotEmpty
                            ? listGioiThieu.first
                            : null;
                        final HopDongModel? hopDongCuaToi =
                            listCuaToi.isNotEmpty ? listCuaToi.first : null;

                        // Nếu không có hợp đồng giới thiệu thì không hiển thị card
                        if (hopDongGioiThieu == null) {
                          return const SizedBox.shrink();
                        }

                        final nguoi = hopDongGioiThieu.nguoiGioiThieu;

                        // Thông tin ngân hàng vẫn lấy từ người giới thiệu / Auth
                        final bankName =
                            (nguoi?.nganHang != null &&
                                (nguoi!.nganHang!.isNotEmpty))
                            ? nguoi.nganHang!
                            : (bankNameFromAuth ?? '');

                        final accountNumber =
                            (nguoi?.maNganHang != null &&
                                (nguoi!.maNganHang!.isNotEmpty))
                            ? nguoi.maNganHang!
                            : (bankAccountFromAuth ?? '');

                        String handoverDateText = '';

                        if (hopDongCuaToi?.taoLuc != null) {
                          handoverDateText = AppUtils.date(
                            hopDongCuaToi!.taoLuc!,
                          );
                        }

                        final double tongGia = hopDongCuaToi?.tongGia ?? 0;

                        final String customerCount =
                            (nguoi?.khachHangs.length ?? 0).toString();

                        final String totalCommission = AppUtils.currency(
                          nguoi?.tongHoaHong ?? 0,
                        );

                        return BankContractCard(
                          bankName: bankName,
                          accountNumber: accountNumber,
                          handoverDateText: handoverDateText,
                          totalContractValue: AppUtils.currency(tongGia),
                          customerCount: customerCount,
                          totalCommission: totalCommission,
                          hopDongId: hopDongCuaToi?.id ?? 0,
                          onTapCustomerList: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerListScreen(
                                  customersDisplay: repo
                                      .getCustomersOfCurrentUser(),
                                  totalCommission: totalCommission,
                                  customerCount: customerCount,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],

                  // ================== END PHÂN QUYỀN ==================
                  const SizedBox(height: 12),

                  // Combo bán chạy
                  FutureBuilder<List<TronGoiDto>>(
                    future: _futureBestSeller,
                    builder: (context, bestSnapshot) {
                      // === LOADING → SHIMMER ===
                      if (bestSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ComboShimmerList();
                      }

                      // === ERROR ===
                      if (bestSnapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Không thể tải combo bán chạy: ${bestSnapshot.error}',
                          ),
                        );
                      }

                      // === DATA ===
                      final bestSellers = bestSnapshot.data ?? [];
                      if (bestSellers.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return BestSellerSection(combos: bestSellers);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Tin tức
                  const NewsHomeHeader(),
                  const NewsEmbeddedSection(height: 400),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
