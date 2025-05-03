// lib/features/notification/data/repositories/dummy_notification_repository.dart
import '../models/notification_model.dart';

class NotificationRepository {
  final List<NotificationModel> _notifications = [];

  NotificationRepository() {
    _initializeDummyNotifications();
  }

  void _initializeDummyNotifications() {
    _notifications.addAll([
      NotificationModel(
        id: '1',
        title: 'Network Maintenance Alert',
        message:
            'Scheduled maintenance on March 15, 2025 from 2:00 AM to 5:00 AM will affect your service temporarily.',
        type: 'maintenance',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Special Offer for You!',
        message:
            'Get 50% off on the Family Bundle package. Limited time offer expires in 3 days.',
        type: 'offer',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        actionRoute: '/promotion-detail',
        actionData: {'promotionId': '1'},
      ),
      NotificationModel(
        id: '3',
        title: 'Your Bill is Ready',
        message:
            'Your March 2025 bill is now available. Total amount due: Rp 450,000.',
        type: 'billing',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Service Upgrade Complete',
        message:
            'Your internet speed has been upgraded to 100 Mbps. Enjoy faster browsing!',
        type: 'system',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'New Feature Available',
        message:
            'Our app now supports real-time speed test. Try it out from the Speed Test menu.',
        type: 'system',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isRead: true,
      ),
    ]);
  }

  // Get all notifications
  Future<List<NotificationModel>> getNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_notifications);
  }

  // Get unread notifications count
  Future<int> getUnreadCount() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _notifications.where((n) => !n.isRead).length;
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
  }

  // Get notification by ID
  Future<NotificationModel?> getNotificationById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }
}
