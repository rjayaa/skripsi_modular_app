import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/firebase_messaging_service.dart';

// Instance global dari FirebaseMessagingService
late FirebaseMessagingService messagingService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiService _apiService = ApiService();
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    _notificationProvider = NotificationProvider();

    // Inisialisasi Firebase Messaging Service setelah widget dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMessaging();
    });
  }

  // Inisialisasi dan setup Firebase Cloud Messaging
  Future<void> _initializeMessaging() async {
    messagingService = FirebaseMessagingService(
      _notificationProvider,
      _apiService,
    );
    await messagingService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider.value(value: _notificationProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
