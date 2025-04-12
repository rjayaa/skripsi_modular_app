import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modular_skripsi_app/core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  late SharedPreferences _prefs;
  bool _initialized = false;

  StorageService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Authentication token management
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: AppConfig.authTokenKey);
  }

  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: AppConfig.authTokenKey, value: token);
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: AppConfig.authTokenKey);
  }

  // Refresh token management
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConfig.refreshTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: AppConfig.refreshTokenKey, value: token);
  }

  Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: AppConfig.refreshTokenKey);
  }

  // User data management
  Future<Map<String, dynamic>?> getUser() async {
    await init();
    final userStr = _prefs.getString(AppConfig.userKey);
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> setUser(Map<String, dynamic> user) async {
    await init();
    await _prefs.setString(AppConfig.userKey, jsonEncode(user));
  }

  Future<void> clearUser() async {
    await init();
    await _prefs.remove(AppConfig.userKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all authentication data
  Future<void> clearAuthData() async {
    await clearAuthToken();
    await clearRefreshToken();
    await clearUser();
  }
}
