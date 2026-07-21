import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact_model.dart';

class ContactService {
  static const String baseUrl = "https://5bzcjq5x-8000.inc1.devtunnels.ms";

  static Future<List<ContactModel>> fetchContacts(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/contacts/$userId"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => ContactModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load contacts");
    }
  }

  static Future<bool> addContact({
    required int userId,
    required String name,
    required String phone,
    required String relation,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/contacts/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "name": name,
        "phone": phone,
        "relation_type": relation,
      }),
    );

    return response.statusCode == 200;
  }
}
