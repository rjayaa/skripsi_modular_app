import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String notificationId;

  const NotificationDetailScreen({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;
    final notification = notifications.firstWhere(
      (notif) => notif.id == notificationId,
      orElse: () => NotificationItem(
        id: '0',
        title: 'Notifikasi tidak ditemukan',
        message: 'Maaf, notifikasi yang Anda cari tidak ditemukan',
        timestamp: DateTime.now(),
      ),
    );

    // Tandai notifikasi sebagai telah dibaca
    if (!notification.isRead) {
      notificationProvider.markAsRead(notificationId);
    }

    final formatter = DateFormat('dd MMMM yyyy, HH:mm');
    final formattedTime = formatter.format(notification.timestamp);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Notifikasi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan ikon
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Judul notifikasi
            Center(
              child: Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Waktu notifikasi
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            
            // Isi pesan
            const Text(
              'Pesan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                notification.message,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Status notifikasi
            Row(
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Colors.green.shade100
                        : Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: notification.isRead
                          ? Colors.green.shade400
                          : Colors.amber.shade400,
                    ),
                  ),
                  child: Text(
                    notification.isRead ? 'Telah dibaca' : 'Belum dibaca',
                    style: TextStyle(
                      color: notification.isRead
                          ? Colors.green.shade800
                          : Colors.amber.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}