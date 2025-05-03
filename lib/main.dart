// Update file lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'core/config/app_config.dart';
import 'core/config/app_router.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/services/connectivity_service.dart';
import 'core/utils/storage_service.dart';
import 'core/widgets/no_connection_banner.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/notification/data/repositories/notification_repository.dart';
import 'features/notification/presentation/providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app config
  AppConfig.init(Environment.dev);

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final connectivityService = ConnectivityService();
  await connectivityService.init();

  runApp(
    MyApp(
      storageService: storageService,
      connectivityService: connectivityService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final ConnectivityService connectivityService;

  const MyApp({
    Key? key,
    required this.storageService,
    required this.connectivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ConnectivityService>(create: (_) => connectivityService),

        // API Client
        Provider<ApiClient>(
          create: (_) => ApiClient(storageService: storageService),
        ),

        // Services
        Provider<AuthService>(
          create:
              (context) => AuthService(
                apiClient: context.read<ApiClient>(),
                storageService: storageService,
              ),
        ),

        // Repositories
        Provider<AuthRepository>(
          create:
              (context) =>
                  AuthRepository(authService: context.read<AuthService>()),
        ),

        // Providers
        ChangeNotifierProvider<ConnectivityProvider>(
          create:
              (context) => ConnectivityProvider(
                connectivityService: context.read<ConnectivityService>(),
              ),
        ),

        ChangeNotifierProvider<AuthProvider>(
          create:
              (context) =>
                  AuthProvider(authRepository: context.read<AuthRepository>()),
        ),

        // Notification provider
        Provider<NotificationRepository>(
          create: (_) => NotificationRepository(),
        ),

        ChangeNotifierProvider<NotificationProvider>(
          create:
              (context) => NotificationProvider(
                repository: context.read<NotificationRepository>(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Modular App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          return Column(
            children: [const NoConnectionBanner(), Expanded(child: child!)],
          );
        },
      ),
    );
  }
}
