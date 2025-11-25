import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _kRole = 'role';
  static const _kToken = 'token';
  static const _kUserId = 'userid';
  static const _kFullName = 'fullname';
  static const _kBankName = 'bank_name';
  static const _kBankAccount = 'bank_account';

  /// LƯU TOÀN BỘ THÔNG TIN USER ĐĂNG NHẬP
  static Future<void> save({
    required String role,
    required String userId,
    required String fullName,
    required String bankName,
    required String bankAccount,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kRole, role);
    await p.setString(_kUserId, userId);
    await p.setString(_kFullName, fullName);
    await p.setString(_kBankName, bankName);
    await p.setString(_kBankAccount, bankAccount);
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

  /// CLEAR ALL
  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kRole);
    await p.remove(_kToken);
    await p.remove(_kUserId);
    await p.remove(_kFullName);
    await p.remove(_kBankName);
    await p.remove(_kBankAccount);
  }
}
