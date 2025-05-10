import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../main.dart'; // Import untuk mengakses global messaging service

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _accessToken != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      if (response['success'] == true) {
        final userData = response['data']['user'];
        _user = User.fromJson(userData);
        _accessToken = response['data']['accessToken'];
        _refreshToken = response['data']['refreshToken'];

        // Save tokens and user data to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _accessToken!);
        await prefs.setString('refreshToken', _refreshToken!);
        await prefs.setString('userData', jsonEncode(userData));

        // Update FCM token ke server setelah login berhasil
        try {
          // Pastikan messagingService sudah diinisialisasi
          await messagingService.updateTokenToServer();
          debugPrint('FCM token updated after successful login');
        } catch (e) {
          debugPrint('Error updating FCM token after login: $e');
          // Tidak perlu return false karena login tetap berhasil meskipun
          // update token FCM gagal
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _accessToken = null;
    _refreshToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userData');

    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('accessToken');
      _refreshToken = prefs.getString('refreshToken');

      if (_accessToken != null) {
        // Load user data from SharedPreferences
        final userDataString = prefs.getString('userData');
        if (userDataString != null) {
          final userData = jsonDecode(userDataString);
          _user = User.fromJson(userData);
        }

        // Check if token is expired by decoding JWT
        // This is a simple check - in production you'd want a more robust solution
        bool isTokenValid = _isTokenValid(_accessToken!);

        if (!isTokenValid && _refreshToken != null) {
          // Here you would implement refresh token logic
          // For now we'll just log out if token is expired
          await logout();
          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Update FCM token ke server jika user sudah login
        try {
          await messagingService.updateTokenToServer();
          debugPrint('FCM token updated after session restored');
        } catch (e) {
          debugPrint('Error updating FCM token after session restored: $e');
          // Tidak perlu return false karena login check tetap berhasil
        }
      }

      _isLoading = false;
      notifyListeners();
      return _accessToken != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Simple JWT token validation
  bool _isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      // Decode the payload
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(decoded);

      // Check expiration
      if (payloadMap['exp'] != null) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(
          payloadMap['exp'] * 1000,
        );
        return expiry.isAfter(DateTime.now());
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
