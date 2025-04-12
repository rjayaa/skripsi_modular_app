import 'package:modular_skripsi_app/core/config/app_config.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_exception.dart';

import '../../../../core/utils/storage_service.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthService({
    required ApiClient apiClient,
    required StorageService storageService,
  }) : _apiClient = apiClient,
       _storageService = storageService;

  // Login user
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        AppConfig.loginEndpoint,
        body: {'email': email, 'password': password},
        requireAuth: false,
      );

      print(response);

      // Extract the data field from response
      final data = response['data'];

      // Now access fields from the data object
      await _storageService.setAuthToken(data['accessToken']);
      await _storageService.setRefreshToken(data['refreshToken']);

      // Create and save user
      final user = UserModel.fromJson(data['user']);
      await _storageService.setUser(user.toJson());

      return user;
    } catch (e) {
      if (e is UnauthorizedException) {
        throw ApiException('Invalid email or password');
      }
      rethrow;
    }
  }

  // Register user
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post(
        AppConfig.registerEndpoint,
        body: {'name': name, 'email': email, 'password': password},
        requireAuth: false,
      );

      // Save tokens
      await _storageService.setAuthToken(response['accessToken']);
      await _storageService.setRefreshToken(response['refreshToken']);

      // Create and save user
      final user = UserModel.fromJson(response['user']);
      await _storageService.setUser(user.toJson());

      return user;
    } catch (e) {
      if (e is BadRequestException) {
        throw ApiException('Registration failed. Email may already be in use.');
      }
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      // Optional: Call logout endpoint to invalidate token on server
      await _apiClient.post(AppConfig.logoutEndpoint);
    } catch (e) {
      // Continue with local logout even if server request fails
    } finally {
      // Clear local auth data
      await _storageService.clearAuthData();
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storageService.isLoggedIn();
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final userData = await _storageService.getUser();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _apiClient.post(
        AppConfig.refreshTokenEndpoint,
        body: {'refreshToken': refreshToken},
        requireAuth: false,
      );

      await _storageService.setAuthToken(response['accessToken']);

      // Optional: update refresh token if returned by server
      if (response.containsKey('refreshToken')) {
        await _storageService.setRefreshToken(response['refreshToken']);
      }

      return true;
    } catch (e) {
      // If refresh fails, log the user out
      await _storageService.clearAuthData();
      return false;
    }
  }
}
