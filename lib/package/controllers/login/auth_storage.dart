import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _kRole = 'role';
  static const _kToken = 'token';
  static const _kUserId = 'userid';
  static const _kFullName = 'fullname';
  static const _kBankName = 'bank_name';
  static const _kBankAccount = 'bank_account';

  // NEW: thêm key về khu vực – theo dữ liệu login
  static const _kBranchId = 'branch_id';                // coSo.id
  static const _kBranchCode = 'branch_code';            // coSo.ma (HN/HCM)
  static const _kOfficeAddress = 'office_address';      // dcVanPhong
  static const _kWarehouseAddress = 'warehouse_address';// dcKho

  /// LƯU TOÀN BỘ THÔNG TIN USER ĐĂNG NHẬP
  static Future<void> save({
    required String role,
    required String userId,
    required String fullName,
    required String bankName,
    required String bankAccount,

    // NEW: thêm các tham số để lưu khu vực
    String? branchId,
    String? branchCode,
    String? officeAddress,
    String? warehouseAddress,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kRole, role);
    await p.setString(_kUserId, userId);
    await p.setString(_kFullName, fullName);
    await p.setString(_kBankName, bankName);
    await p.setString(_kBankAccount, bankAccount);

    // NEW: lưu thêm khu vực vào bộ nhớ
    if (branchId != null) {
      await p.setString(_kBranchId, branchId);
    }
    if (branchCode != null) {
      await p.setString(_kBranchCode, branchCode);
    }
    if (officeAddress != null) {
      await p.setString(_kOfficeAddress, officeAddress);
    }
    if (warehouseAddress != null) {
      await p.setString(_kWarehouseAddress, warehouseAddress);
    }
  }

  /// GETTERS
  static Future<String?> getRole() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kRole);
  }

  static Future<String?> getUserId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kUserId);
  }

  static Future<String?> getFullName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kFullName);
  }

  static Future<String?> getBankName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kBankName);
  }

  static Future<String?> getBankAccount() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kBankAccount);
  }

  // --- NEW GETTERS cho khu vực (HN/HCM) ---
  static Future<String?> getBranchId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kBranchId);
  }

  static Future<String?> getBranchCode() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kBranchCode);
  }

  static Future<String?> getOfficeAddress() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kOfficeAddress);
  }

  static Future<String?> getWarehouseAddress() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kWarehouseAddress);
  }

  // NEW: Helper check nhanh user thuộc HN hay HCM
  static Future<bool> isHN() async {
    final code = await getBranchCode();
    return code == 'HN';
  }

  static Future<bool> isHCM() async {
    final code = await getBranchCode();
    return code == 'HCM';
  }

  /// CLEAR ALL
  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kRole);
    await p.remove(_kToken);
    await p.remove(_kUserId);
    await p.remove(_kFullName);
    await p.remove(_kBankName);
    await p.remove(_kBankAccount);

    // NEW: clear luôn dữ liệu khu vực
    await p.remove(_kBranchId);
    await p.remove(_kBranchCode);
    await p.remove(_kOfficeAddress);
    await p.remove(_kWarehouseAddress);
  }
}
