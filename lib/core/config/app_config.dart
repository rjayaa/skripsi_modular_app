import 'dart:io';

enum Environment { dev, staging, prod }

class AppConfig {
  static late Environment _environment;

  // Base API URL based on environment
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.dev:
        // Check platform to determine the correct local URL
        if (Platform.isAndroid) {
          return 'http://10.0.2.2:3000/api'; // For Android emulator (host machine)
        } else if (Platform.isIOS) {
          return 'http://localhost:3000/api'; // For iOS simulator
        } else {
          return 'http://localhost:3000/api'; // For web or desktop
        }
      case Environment.staging:
        return 'https://staging-api.yourdomain.com/api';
      case Environment.prod:
        return 'https://api.yourdomain.com/api';
    }
  }

  // API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String userProfileEndpoint = '/user/profile';
  static const String refreshTokenEndpoint = '/auth/refresh-token';

  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';

  // Initialize app config
  static void init(Environment env) {
    _environment = env;
  }

  // Check if running in development
  static bool get isDev => _environment == Environment.dev;

  // Check if running in staging
  static bool get isStaging => _environment == Environment.staging;

  // Check if running in production
  static bool get isProd => _environment == Environment.prod;
}
