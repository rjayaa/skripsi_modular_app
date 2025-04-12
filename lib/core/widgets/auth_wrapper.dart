import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_shell.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Show different screens based on auth status
    switch (authProvider.status) {
      case AuthStatus.initial:
      case AuthStatus.authenticating:
        return const SplashPage();

      case AuthStatus.authenticated:
        return const AppShell();

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const LoginPage();
    }
  }
}
