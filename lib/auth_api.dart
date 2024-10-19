import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static const String baseUrl = 'http://192.168.124.222:8000';
  static const String tokenKey = 'auth_token';

  // Get the stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Save the token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    print('Token saved: $token'); // Print token to terminal
  }

  // Remove the token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response body to get the token
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? token =
            responseData['token']; // Adjust key based on your API response

        if (token != null) {
          await saveToken(token);
          return true;
        } else {
          print('No token received in response');
          return false;
        }
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> signUp(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If signup returns a token, save it
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? token =
            responseData['token']; // Adjust key based on your API response

        if (token != null) {
          await saveToken(token);
        }
        return true;
      } else {
        print('Sign up failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $token', // Add token to logout request if required
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await removeToken(); // Clear stored token on successful logout
        return true;
      } else {
        print('Logout failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
