import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
class AccountModel {
  final String userid;
  final String taikhoan;
  final String matkhau;
  final String role;

  AccountModel({
    required this.userid,
    required this.taikhoan,
    required this.matkhau,
    required this.role,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      userid: json['userid'],
      taikhoan: json['taikhoan'],
      matkhau: json['matkhau'],
      role: json['role'],
    );
  }
}
class AccountService {
  static Future<AccountModel?> login(String username, String password) async {
    final jsonString = await rootBundle.loadString('assets/data/accounts.json');
    final data = json.decode(jsonString);
    final List accounts = data['accounts'];

    for (final a in accounts) {
      if (a['taikhoan'] == username && a['matkhau'] == password) {
        return AccountModel.fromJson(a);
      }
    }
    return null;
  }
}