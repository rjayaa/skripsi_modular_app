// Update file lib/core/config/app_router.dart

import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../widgets/app_shell.dart';
import '../widgets/auth_wrapper.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case SplashPage.routeName:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case LoginPage.routeName:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RegisterPage.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case HomePage.routeName:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case ProfilePage.routeName:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case NotificationPage.routeName:
        return MaterialPageRoute(builder: (_) => const NotificationPage());

      case AppShell.routeName:
        return MaterialPageRoute(builder: (_) => const AppShell());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
