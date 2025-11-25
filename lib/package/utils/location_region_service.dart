import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRegionService {
  static const _kRegionKey = 'user_region_vn';

  static Future<String> getRegionForRegister() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_kRegionKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final region = await _detectFastRegion();

    await prefs.setString(_kRegionKey, region);
    return region;
  }

  static Future<String?> getCachedRegion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRegionKey);
  }

  static Future<void> clearRegion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRegionKey);
  }

  static Future<String> _detectFastRegion() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Không bật location -> chọn mặc định HN
      return "HN";
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "HN";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "HN";
    }

    // Dùng vị trí cũ để tránh block main thread
    final position = await Geolocator.getLastKnownPosition();

    if (position == null) {
      return "HN";
    }

    final double lat = position.latitude;
    return lat >= 17.0 ? "HN" : "HCM";
  }
}
