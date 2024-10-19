import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';
import 'user.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.124.222:8000';

  Future<User> fetchUser() async {
    String? token = await AuthApi().getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
