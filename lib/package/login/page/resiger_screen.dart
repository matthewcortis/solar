import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes.dart';
import '../../api/api_service.dart';
import '../../utils/location_region_service.dart';

class LoginWithRegisterScreen extends StatefulWidget {
  const LoginWithRegisterScreen({super.key});

  @override
  State<LoginWithRegisterScreen> createState() =>
      _LoginWithRegisterScreenState();
}

class _LoginWithRegisterScreenState extends State<LoginWithRegisterScreen> {
  bool _obscure = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final region = await LocationRegionService.getRegionForRegister();

      final body = {
        "sdt": _userController.text.trim(),
        "matKhau": _passController.text.trim(),
        "hoVaTen": _nameController.text.trim(),
        "maCoSo": region, // HN hoặc HCM
      };

      final res = await ApiService.post("/basic-api/nguoi-dung/register", body);

      if (res is Map && (res['status'] == 200 || res['success'] == true)) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công')));
        Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
      } else {
        final msg = (res is Map && res['message'] != null)
            ? res['message'].toString()
            : 'Đăng ký không thành công.';

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Hàm dùng chung cho các ô nhập
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String prefixIconAsset,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return SizedBox(
      width: 398.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              height: 20 / 16,
              color: const Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 398.w,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
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
                SvgPicture.asset(
                  prefixIconAsset,
                  width: 24.w,
                  height: 24.h,
                  color: const Color(0xFF4F4F4F),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    obscureText: isPassword ? _obscure : false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        height: 24 / 16,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 24 / 16,
                      color: const Color(0xFF1A1A1A),
                    ),
                    validator: validator,
                  ),
                ),
                if (isPassword)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF848484),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lưu ý: cần có ScreenUtilInit ở root app
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16.w,
                0,
                16.w,
                MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      // Nút back
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.welcomeScreen,
                          );
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1FD1D1D1),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Color(0xFF4F4F4F),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // Hình illustration
                      Center(
                        child: SizedBox(
                          width: 398.w,
                          height: 260.h,
                          child: SvgPicture.asset(
                            'assets/icons/login.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Tiêu đề
                      SizedBox(
                        width: 398.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                height: 25 / 20,
                                color: const Color(0xFF4F4F4F),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Nhập thông tin để tạo tài khoản mới.',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                height: 24 / 16,
                                color: const Color(0xFF848484),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // FORM
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Họ tên
                            _buildInputField(
                              label: 'Họ tên',
                              controller: _nameController,
                              hintText: 'Nhập họ tên',
                              prefixIconAsset: 'assets/icons/user.svg',
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Vui lòng nhập họ tên';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.h),

                            // Tên đăng nhập
                            _buildInputField(
                              label: 'Tên đăng nhập',
                              controller: _userController,
                              hintText: 'Số điện thoại',
                              prefixIconAsset: 'assets/icons/user.svg',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) {
                                  return 'Vui lòng nhập tài khoản';
                                }
                                if (v.length < 9) {
                                  return 'Số điện thoại không hợp lệ';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.h),

                            // Mật khẩu
                            _buildInputField(
                              label: 'Mật khẩu',
                              controller: _passController,
                              hintText: 'Mật khẩu của bạn',
                              prefixIconAsset: 'assets/icons/lock.svg',
                              keyboardType: TextInputType.text,
                              isPassword: true,
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                if (v.length < 3) {
                                  return 'Mật khẩu tối thiểu 3 ký tự';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),

                      const Spacer(),

                      /// Nút Đăng ký
                      SizedBox(
                        width: 398.w,
                        height: 48.h,
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleRegister,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEE4037),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x26D1D1D1),
                                  blurRadius: 34,
                                  offset: Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro Display',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        height: 20 / 16,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
