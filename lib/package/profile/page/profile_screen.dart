import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../../controllers/login/auth_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, String?>> _loadProfile() async {
    final role = await AuthStorage.getRole();
    final fullName = await AuthStorage.getFullName();
    return {
      'role': role,
      'fullName': fullName,
    };
  }

  String _mapRoleToDisplay(String? role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'sale':
        return 'SALE';
      case 'agent':
        return 'AGENT';
      case 'customer':
        return 'Khách hàng';
      default:
        return 'Khách vãng lai';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: FutureBuilder<Map<String, String?>>(
          future: _loadProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data ?? {};
            final role = data['role'];
            final fullName = data['fullName'];

            final isGuest = role == null || role == 'guest';
            final displayName =
                (fullName != null && fullName.trim().isNotEmpty)
                    ? fullName
                    : 'Xin chào !';
            final displayRole = _mapRoleToDisplay(role);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ĐÃ ĐĂNG NHẬP (không phải guest)
                  if (!isGuest) ...[
                    ProfileHeader(
                      avatarUrl:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9VGV6Xyj-5_ZyotLIuuTGTfLHe0f2w44rQ&s', // tạm thời dùng local asset
                      fullName: displayName,
                      role: displayRole,
                    ),
                    const SizedBox(height: 8),
                    const ProfileSettingsTopSection(),
                  ],

                  // Phần setting chung
                  const ProfileSettingsSection(),

                  // Nút đăng xuất chỉ hiển thị khi đã đăng nhập
                  if (!isGuest) ...[
                    const ProfileLogoutSection(),
                  ],

                  // KHÁCH VÃNG LAI (chưa login hoặc role guest)
                  if (isGuest) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Bạn đang ở chế độ khách vãng lai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Đăng nhập để xem đầy đủ thông tin hồ sơ.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
