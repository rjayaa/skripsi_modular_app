import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
    : _authService = authService;

  // Login with email and password
  Future<UserModel> login(String email, String password) {
    return _authService.login(email, password);
  }

  // Register new user
  Future<UserModel> register(String name, String email, String password) {
    return _authService.register(name, email, password);
  }

  // Logout current user
  Future<void> logout() {
    return _authService.logout();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() {
    return _authService.isAuthenticated();
  }

  // Get current user
  Future<UserModel?> getCurrentUser() {
    return _authService.getCurrentUser();
  }

  // Refresh token
  Future<bool> refreshToken() {
    return _authService.refreshToken();
  }
}
