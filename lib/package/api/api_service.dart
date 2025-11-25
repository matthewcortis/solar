import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://v2.slmglobal.vn/api";

  static Future<Map<String, String>> _headers() async {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  // ---- GET ----
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    final headers = await _headers();

    final res = await http.get(url, headers: headers);

    final utf8Body = utf8.decode(res.bodyBytes);   // FIX UTF-8

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8Body);
    } else {
      throw Exception("GET $endpoint failed: ${res.statusCode}");
    }
  }

  // ---- POST ----
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    final headers = await _headers();

    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final utf8Body = utf8.decode(res.bodyBytes);   // FIX UTF-8

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8Body);
    } else {
      throw Exception("POST $endpoint failed: ${res.statusCode}");
    }
  }

  // ---- PUT ----
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    final headers = await _headers();

    final res = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final utf8Body = utf8.decode(res.bodyBytes);   // FIX UTF-8

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8Body);
    } else {
      throw Exception("PUT $endpoint failed: ${res.statusCode}");
    }
  }

  // ---- DELETE ----
  static Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    final headers = await _headers();

    final res = await http.delete(url, headers: headers);

    final utf8Body = utf8.decode(res.bodyBytes);   // FIX UTF-8

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8Body);
    } else {
      throw Exception("DELETE $endpoint failed: ${res.statusCode}");
    }
  }
}
