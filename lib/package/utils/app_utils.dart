import 'package:intl/intl.dart';

class AppUtils {
  static String formatVND(double number) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  static String formatVNDNUM(num number) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', decimalDigits: 0);
    return formatter.format(number.toDouble());
  }

  // bao hanh
  static String convertMonthToYearAndMonth(double months) {
    final totalMonths = months.isFinite ? months.ceil() : 0;
    final years = totalMonths ~/ 12;
    final remainMonths = totalMonths % 12;

    if (years > 0 && remainMonths > 0) {
      return '$years năm $remainMonths tháng';
    } else if (years > 0) {
      return '$years năm';
    } else {
      return '$remainMonths tháng';
    }
  }

  static String timeAgo(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return "";

    final now = DateTime.now();
    final diff = now.difference(dt);

    // Giờ
    if (diff.inHours < 24) {
      if (diff.inHours <= 0) return "Vừa xong";
      return "${diff.inHours} giờ trước";
    }

    // Ngày
    if (diff.inDays < 7) {
      return "${diff.inDays} ngày trước";
    }

    // Tuần
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return weeks <= 1 ? "1 tuần trước" : "$weeks tuần trước";
    }

    // Tháng
    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return months <= 1 ? "1 tháng trước" : "$months tháng trước";
    }

    // Năm
    final years = (diff.inDays / 365).floor();
    return years <= 1 ? "1 năm trước" : "$years năm trước";
  }

  static String currency(dynamic value, {String suffix = 'đ'}) {
    if (value == null) return '0$suffix';

    num number;

    if (value is String) {
      number = num.tryParse(value) ?? 0;
    } else if (value is num) {
      number = value;
    } else {
      return '0$suffix';
    }

    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );

    return formatter.format(number).trim() + suffix;
  }

  static String date(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';

    try {
      DateTime dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  static String dateTime(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';

    try {
      DateTime dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  String mapRoleToDisplay(String? roleCode) {
    switch (roleCode) {
      case "admin":
        return "Admin";
      case "sale":
        return "Sale";
      case "agent":
        return "Agent";
      case "customer":
        return "Khách hàng";
      case "guest":
      default:
        return "Đăng nhập để tiếp tục!";
    }
  }
}
