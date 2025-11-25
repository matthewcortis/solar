import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import '../../controllers/login/login_controller.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    final controller = Provider.of<LoginController>(context, listen: false);

    final role = await controller.login(
      context,
      _userController.text,
      _passController.text,
    );

    if (!context.mounted) return;

    if (role != null) {
      switch (role) {
        case "admin":
        case "sale":
        case "agent":
        case "customer":
        case "guest":
        default:
          Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                // chừa chỗ cho bàn phím
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
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

                      SizedBox(height: 24.h),

                      // Hình minh họa
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

                      // Tiêu đề + mô tả
                      Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          height: 25 / 20,
                          color: const Color(0xFF4F4F4F),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Bạn đã sẵn sàng! Đăng nhập để bắt đầu trải nghiệm.',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          height: 24 / 16,
                          color: const Color(0xFF848484),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // FORM
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tên đăng nhập
                            const Text(
                              'Tên đăng nhập',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.4,
                                color: Color(0xFF4F4F4F),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 48.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/user.svg',
                                    width: 20.w,
                                    height: 20.w,
                                    color: const Color(0xFF030303),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _userController,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Số điện thoại',
                                        hintStyle: TextStyle(
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Color(0xFFBDBDBD),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập tài khoản';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Mật khẩu
                            const Text(
                              'Mật khẩu',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.4,
                                color: Color(0xFF4F4F4F),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 48.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/lock.svg',
                                    width: 20.w,
                                    height: 20.w,
                                    color: const Color(0xFF030303),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _passController,
                                      obscureText: _obscure,
                                      style: const TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '**********',
                                        hintStyle: TextStyle(
                                          color: Color(0xFFBDBDBD),
                                          fontFamily: 'SF Pro',
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập mật khẩu';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
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

                            SizedBox(height: 8.h),

                            // Quên mật khẩu
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Quên mật khẩu?',
                                style: const TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF848484),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Đẩy nút xuống đáy khi đủ chiều cao
                      const Spacer(),

                      // Error message
                      Consumer<LoginController>(
                        builder: (context, controller, child) {
                          if (controller.errorMessage == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              controller.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),

                      // Nút đăng nhập
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: Consumer<LoginController>(
                          builder: (context, controller, child) {
                            if (controller.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFED1C24),
                                ),
                              );
                            }

                            return ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFED1C24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 16.h),
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
