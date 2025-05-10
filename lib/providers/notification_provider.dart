import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  // Daftar notifikasi (hardcoded untuk contoh)
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Network Maintenance Alert',
      message:
          'Scheduled maintenance on March 15, 2025 from 2:00 AM to 5:00 AM will affect your service temporarily.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Special Offer for You!',
      message:
          'Get 50% off on the Family Bundle package. Limited time offer expires in 3 days.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Your Bill is Ready',
      message:
          'Your March 2025 bill is now available. Total amount due: Rp 450,000.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Service Upgrade Complete',
      message:
          'Your internet speed has been upgraded to 100 Mbps. Enjoy faster browsing!',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  // Getter untuk mendapatkan semua notifikasi (sorted by date, unread first)
  List<NotificationItem> get notifications {
    final List<NotificationItem> sorted = List.from(_notifications);
    sorted.sort((a, b) {
      // Urutkan berdasarkan status read/unread terlebih dahulu
      if (a.isRead != b.isRead) {
        return a.isRead ? 1 : -1; // Unread first
      }
      // Jika status sama, urutkan berdasarkan waktu (terbaru dulu)
      return b.timestamp.compareTo(a.timestamp);
    });
    return sorted;
  }

  // Getter untuk menghitung jumlah notifikasi yang belum dibaca
  int get unreadCount => _notifications.where((notif) => !notif.isRead).length;

  // Getter untuk cek apakah ada notifikasi yang belum dibaca
  bool get hasUnread => unreadCount > 0;

  // Method untuk menambahkan notifikasi baru (biasanya dipanggil dari FCM service)
  void addNotification(NotificationItem notification) {
    // Cek jika notifikasi dengan ID yang sama sudah ada
    final existingIndex = _notifications.indexWhere(
      (n) => n.id == notification.id,
    );

    if (existingIndex != -1) {
      // Update notifikasi yang sudah ada
      _notifications[existingIndex] = notification;
    } else {
      // Tambahkan notifikasi baru ke awal list
      _notifications.insert(0, notification);
    }

    notifyListeners();
  }

  // Method untuk menandai notifikasi sebagai telah dibaca
  void markAsRead(String id) {
    final index = _notifications.indexWhere((notif) => notif.id == id);

    if (index != -1 && !_notifications[index].isRead) {
      // Buat instance baru dari notifikasi dengan isRead = true
      _notifications[index] = NotificationItem(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        isRead: true,
      );

      notifyListeners();
    }
  }

  // Method untuk menandai semua notifikasi sebagai telah dibaca
  void markAllAsRead() {
    bool hasChanges = false;

    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = NotificationItem(
          id: _notifications[i].id,
          title: _notifications[i].title,
          message: _notifications[i].message,
          timestamp: _notifications[i].timestamp,
          isRead: true,
        );
        hasChanges = true;
      }
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  // Method untuk menghapus notifikasi
  void deleteNotification(String id) {
    final initialLength = _notifications.length;
    _notifications.removeWhere((notif) => notif.id == id);

    if (_notifications.length != initialLength) {
      notifyListeners();
    }
  }

  // Method untuk menghapus semua notifikasi
  void clearAllNotifications() {
    if (_notifications.isNotEmpty) {
      _notifications.clear();
      notifyListeners();
    }
  }
}
