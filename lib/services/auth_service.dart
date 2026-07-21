import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Android emulator local backend
  // Use 10.0.2.2 instead of localhost
  static const String baseUrl = "https://5bzcjq5x-8000.inc1.devtunnels.ms";

  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "password": password,
        "phone": phone,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }
}
