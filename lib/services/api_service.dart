import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://103.148.197.182:9989/api/v1';

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

  // Metode untuk update FCM token ke server
  Future<Map<String, dynamic>> updateFcmToken(String fcmToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No access token found');
      }

      // Dapatkan info device
      final deviceName = await _getDeviceInfo();

      final response = await http.post(
        Uri.parse('$baseUrl/notifications/token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fcmToken': fcmToken, 'deviceName': deviceName}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
      // Return empty map if error
      return {'success': false, 'message': e.toString()};
    }
  }

  // Mendapatkan informasi perangkat
  Future<String> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        return 'Android Device';
      } else if (Platform.isIOS) {
        return 'iOS Device';
      } else {
        return 'Unknown Device';
      }
    } catch (e) {
      return 'Device';
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
