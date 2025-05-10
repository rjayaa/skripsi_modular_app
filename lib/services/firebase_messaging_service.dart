import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import 'api_service.dart';

// Handler untuk pesan background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling background message: ${message.messageId}');
  // Background handler tidak bisa mengakses provider, jadi kita hanya log pesan
}

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final NotificationProvider _notificationProvider;
  final ApiService _apiService;
  String? _fcmToken;

  // Channel untuk notifikasi lokal
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'MESSAGE_CHANNEL', // ID yang sama dengan server (lihat notification.service.js)
    'High Importance Notifications', // title
    description: 'Channel untuk notifikasi penting', // description
    importance: Importance.high,
  );

  FirebaseMessagingService(this._notificationProvider, this._apiService);

  Future<void> initialize() async {
    // Mendaftarkan handler pesan background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Mengkonfigurasi notifikasi lokal
    await _setupLocalNotifications();

    // Mengkonfigurasi handler pesan foreground
    _setupForegroundHandlers();

    // Meminta izin notifikasi
    await _requestPermissions();

    // Token listener untuk auto-update jika token berubah
    _setupTokenRefreshListener();

    // Mendapatkan token FCM (tapi tidak kirim ke server dulu - akan kirim setelah login)
    await getToken();
  }

  Future<void> _setupLocalNotifications() async {
    // Inisialisasi pengaturan notifikasi untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Inisialisasi pengaturan notifikasi untuk iOS
    final DarwinInitializationSettings
    initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      //   // Handle iOS local notification
      // },
    );

    // Menggabungkan pengaturan untuk semua platform
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handler saat notifikasi di-tap
        if (details.payload != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(details.payload!);
            // Navigasi ke layar yang sesuai berdasarkan data notifikasi
            // TODO: implementasi navigasi berdasarkan notification type
          } catch (e) {
            debugPrint('Error parsing notification payload: $e');
          }
        }
      },
    );

    // Membuat channel notifikasi untuk Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _setupForegroundHandlers() {
    // Handler untuk pesan yang diterima saat aplikasi dibuka (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got foreground message: ${message.notification?.title}');

      // Ekstrak data notifikasi
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = notification?.android;

      // Jika platform Android dan data notifikasi valid
      if (notification != null && android != null) {
        // Tampilkan notifikasi lokal
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon ?? '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          payload: jsonEncode(message.data),
        );
      }

      // Tambahkan notifikasi ke provider
      if (notification != null) {
        final notifItem = NotificationItem(
          id:
              message.messageId ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: notification.title ?? 'Notifikasi Baru',
          message: notification.body ?? '',
          timestamp: DateTime.now(),
          isRead: false,
        );
        _notificationProvider.addNotification(notifItem);
      }
    });

    // Handler untuk tap notifikasi saat aplikasi sedang ditutup
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped in background: ${message.messageId}');
      // TODO: Navigasi ke layar yang sesuai berdasarkan data notifikasi
    });
  }

  // Setup listener untuk refresh token otomatis
  void _setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      debugPrint('FCM token refreshed automatically: $token');
      _fcmToken = token;

      // Update token ke server jika berbeda dari token sebelumnya
      await updateTokenToServer();
    });
  }

  Future<void> _requestPermissions() async {
    // Meminta izin notifikasi
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    debugPrint('User notification permission: ${settings.authorizationStatus}');
  }

  Future<String?> getToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> updateTokenToServer() async {
    try {
      // Dapatkan token jika belum ada
      if (_fcmToken == null) {
        _fcmToken = await getToken();
      }

      if (_fcmToken != null) {
        // Kirim token ke server
        final result = await _apiService.updateFcmToken(_fcmToken!);
        if (result['success'] == true) {
          debugPrint('FCM token updated on server successfully');
        } else {
          debugPrint('Server responded with error: ${result['message']}');
        }
      }
    } catch (e) {
      debugPrint('Error updating FCM token to server: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  // Untuk debugging - cek apakah token diperbaharui
  Future<void> forceTokenRefresh() async {
    await _messaging.deleteToken();
    final newToken = await getToken();
    debugPrint('Force refreshed FCM token: $newToken');
    await updateTokenToServer();
  }

  void dispose() {
    // Kosongkan resource jika diperlukan
  }
}
