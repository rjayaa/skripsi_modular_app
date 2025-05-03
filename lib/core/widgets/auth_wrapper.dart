// Update file lib/core/widgets/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/notification/presentation/providers/notification_provider.dart';
import 'app_shell.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Add this debug print
    print("AuthWrapper build called with status: ${authProvider.status}");

    // Show different screens based on auth status
    switch (authProvider.status) {
      case AuthStatus.initial:
      case AuthStatus.authenticating:
        return const SplashPage();

      case AuthStatus.authenticated:
        print("Routing to AppShell"); // Add this
        // Load notifications when user is authenticated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<NotificationProvider>().loadNotifications();
        });
        return const AppShell();

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const LoginPage();
    }
  }
}
