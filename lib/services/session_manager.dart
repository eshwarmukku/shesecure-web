import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveUserSession({
    required int userId,
    required String fullName,
    required String email,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("user_id", userId);
    await prefs.setString("full_name", fullName);
    await prefs.setString("email", email);
    await prefs.setString("token", token);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id");
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("full_name");
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
