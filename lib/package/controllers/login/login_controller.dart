import 'package:flutter/material.dart';
import '../../api/api_service.dart';
import '../../controllers/login/auth_storage.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<String?> login(
    BuildContext context,
    String sdt,
    String matKhau,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final body = {"sdt": sdt, "matKhau": matKhau};

      final res = await ApiService.post("/basic-api/nguoi-dung/login", body);

      final status = res["status"] as int?;
      if (status == 200 && res["data"] != null) {
        final data = res["data"] as Map<String, dynamic>;
        final phanQuyenRaw = (data["phanQuyen"] ?? "").toString();

        final role = _mapRoleFromPhanQuyen(phanQuyenRaw);
        final userId = data["id"]?.toString() ?? "";
        final fullName = data["hoVaTen"]?.toString() ?? "";
        final bankName = data["nganHang"]?.toString() ?? "";
        final bankAccount = data["maNganHang"]?.toString() ?? "";
        debugPrint('Login phanQuyen="$phanQuyenRaw" -> role="$role"');

        await AuthStorage.save(
          role: role,
          userId: userId,
          fullName: fullName,
          bankName: bankName,
          bankAccount: bankAccount,
        );

        isLoading = false;
        errorMessage = null;
        notifyListeners();

        return role;
      } else {
        errorMessage =
            res["message"]?.toString() ?? "Đăng nhập không thành công";
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = "Lỗi kết nối, vui lòng thử lại.";
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  String _mapRoleFromPhanQuyen(String phanQuyenRaw) {
    final value = phanQuyenRaw.trim().toUpperCase();

    switch (value) {
      case "ADMIN":
        return "admin";
      case "SALE":
        return "sale";
      case "AGENT":
        return "agent";
      case "CUSTOMER":
        return "customer";
      default:
        return "guest";
    }
  }
}
