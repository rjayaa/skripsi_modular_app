import 'package:flutter/foundation.dart';

import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.authenticated;

  // Initialize the auth state - call this when app starts
  Future<void> initAuth() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final isAuthenticated = await _authRepository.isAuthenticated();

      if (isAuthenticated) {
        final user = await _authRepository.getCurrentUser();

        if (user != null) {
          _user = user;
          _status = AuthStatus.authenticated;
        } else {
          // Token exists but no user data - try to refresh token
          final refreshed = await _authRepository.refreshToken();

          if (refreshed) {
            final refreshedUser = await _authRepository.getCurrentUser();
            if (refreshedUser != null) {
              _user = refreshedUser;
              _status = AuthStatus.authenticated;
            } else {
              _status = AuthStatus.unauthenticated;
            }
          } else {
            _status = AuthStatus.unauthenticated;
          }
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = 'Failed to initialize authentication: ${e.toString()}';
    }

    notifyListeners();
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.login(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Register user
  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.register(name, email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
