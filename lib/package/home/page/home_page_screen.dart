import 'package:flutter/material.dart';
import '../../home/services/product_category_model.dart';
import '../services/load_product.dart';
import '../widgets/app_bar_home.dart';
import '../widgets/list_product.dart';
import '../widgets/warranty_price.dart';
import '../widgets/bank_contract_info.dart';
import '../../controllers/login/auth_storage.dart';
import '../repository/hot_combo_repo.dart';
import '../../news/pages/news_screen.dart';
import './customer_screen.dart';
import '../repository/hop_dong_repo.dart';
import '../repository/khach_hang_repo.dart';
import '../../model/hop_dong_model.dart';
import '../../utils/app_utils.dart';
import '../../model/tron_goi_models.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<ProductCategoryModel> _futureProducts;

  final HopDongRepository _hopDongRepository = HopDongRepository();
  late Future<List<HopDongModel>> _futureHopDong;

  late final Future<List<TronGoiDto>> _futureBestSeller;
  final TronGoiRepository _tronGoiRepository = TronGoiRepository();

  final repo = KhachHangRepository();

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
    _futureHopDong = _hopDongRepository.getHopDongCuaUserDangNhap();

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

                  if (userRole == "guest") ...[
                    const SizedBox.shrink(),
                  ] else if (userRole == "customer") ...[
                    FutureBuilder<List<HopDongModel>>(
                      future: _futureHopDong,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          debugPrint('Lỗi tải hợp đồng: ${snapshot.error}');
                        }

                        final list = snapshot.data ?? [];

                        HopDongModel? hopDong;
                        if (list.isNotEmpty) {
                          hopDong = list.first;
                        }
                        String handoverDateText = '';
                        double tongGia = 0;
                        if (hopDong != null) {
                          handoverDateText = hopDong.taoLuc != null
                              ? AppUtils.date(hopDong.taoLuc!)
                              : '';
                          tongGia = hopDong.tongGia ?? 0;
                        }

                        return ContractValueCard(
                          // Luôn truyền, có thể là '' và 0
                          deliveryDate: handoverDateText,
                          totalValue: AppUtils.currency(tongGia),
                          // onView: () {
                          //   // Nếu muốn: chỉ cho vào màn bảo hành khi có hợp đồng
                          //   if (hopDong != null) {
                          //     Navigator.of(
                          //       context,
                          //     ).pushNamed(AppRoutes.warrantyDeviceScreen);
                          //   } else {
                          //     // Không có hợp đồng mà vẫn bấm: tùy bạn xử lý
                          //     // ví dụ: showSnackBar, dialog, hoặc không làm gì
                          //   }
                          // },
                        );
                      },
                    ),
                  ] else if (userRole == "admin" ||
                      userRole == "sale" ||
                      userRole == "agent") ...[
                    // ADMIN, SALE, AGENT: luôn hiển thị BankContractCard
                    FutureBuilder<List<HopDongModel>>(
                      future: _futureHopDong,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Lỗi tải hợp đồng: ${snapshot.error}');
                        }

                        final list = snapshot.data ?? [];

                        // Có thể không có hợp đồng
                        final HopDongModel? hopDong = list.isNotEmpty
                            ? list.first
                            : null;

                        // Có thể không có người giới thiệu
                        final nguoi = hopDong?.nguoiGioiThieu;

                        // Ưu tiên lấy trong hợp đồng, nếu không có thì fallback sang dữ liệu login (AuthStorage)
                        final bankName =
                            (nguoi?.nganHang != null &&
                                nguoi!.nganHang!.isNotEmpty)
                            ? nguoi.nganHang!
                            : (bankNameFromAuth ?? '');

                        final accountNumber =
                            (nguoi?.maNganHang != null &&
                                nguoi!.maNganHang!.isNotEmpty)
                            ? nguoi.maNganHang!
                            : (bankAccountFromAuth ?? '');

                        // Nếu không có hợp đồng -> ngày, giá trị, khách hàng, hoa hồng = mặc định
                        final handoverDateText = hopDong?.taoLuc != null
                            ? AppUtils.date(hopDong!.taoLuc)
                            : '';

                        final tongGia = hopDong?.tongGia ?? 0;
                        final phanTram = nguoi?.phanTramHoaHong ?? 0;

                        final totalContractValue = AppUtils.currency(
                          tongGia * (phanTram / 100),
                        );

                        final customerCount = (nguoi?.khachHangs.length ?? 0)
                            .toString();

                        final totalCommission = AppUtils.currency(
                          nguoi?.tongHoaHong ?? 0,
                        );

                        return BankContractCard(
                          bankName: bankName,
                          accountNumber: accountNumber,
                          handoverDateText: handoverDateText,
                          totalContractValue: totalContractValue,
                          customerCount: customerCount,
                          totalCommission: totalCommission,
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
                      if (bestSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (bestSnapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Không thể tải combo bán chạy: ${bestSnapshot.error}',
                          ),
                        );
                      }

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
                  const NewsEmbeddedSection(height: 400,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
