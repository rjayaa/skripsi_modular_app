import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://103.148.197.182:9989/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Method untuk refresh token (bisa diimplementasikan sesuai API)
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  // Method untuk request API dengan authorization
  Future<dynamic> getWithAuth(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Token expired, try to refresh
      final refreshTokenStr = prefs.getString('refreshToken');
      if (refreshTokenStr != null) {
        try {
          final refreshResponse = await refreshToken(refreshTokenStr);
          if (refreshResponse['success'] == true) {
            // Save new tokens
            await prefs.setString(
              'accessToken',
              refreshResponse['data']['accessToken'],
            );
            await prefs.setString(
              'refreshToken',
              refreshResponse['data']['refreshToken'],
            );

            // Retry the request with new token
            return getWithAuth(endpoint);
          }
        } catch (e) {
          // If refresh fails, clear tokens and throw error
          await prefs.remove('accessToken');
          await prefs.remove('refreshToken');
          throw Exception('Session expired. Please login again.');
        }
      }
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Request failed: ${response.body}');
    }
  }
}
