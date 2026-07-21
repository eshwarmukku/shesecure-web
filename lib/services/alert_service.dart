import 'dart:convert';
import 'package:http/http.dart' as http;

class AlertService {
  static const String baseUrl = "https://5bzcjq5x-8000.inc1.devtunnels.ms";

  static Future<Map<String, dynamic>> triggerAlert(int userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/alerts/trigger"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "alert_type": "manual"}),
    );

    return jsonDecode(response.body);
  }
}
