import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../model/customer_model.dart';

class CustomerService {
  /// Load toàn bộ danh sách từ assets/data/customer.json
  static Future<List<CustomerModel>> loadCustomers() async {
    final raw = await rootBundle.loadString('assets/data/customer.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = (data['customers'] as List<dynamic>? ?? []);
    return list.map((e) => CustomerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  ///filter theo trạng thái
  static Future<List<CustomerModel>> loadByStatus(String status) async {
    final all = await loadCustomers();
    return all.where((c) => c.trangThai.toLowerCase() == status.toLowerCase()).toList();
  }
}
