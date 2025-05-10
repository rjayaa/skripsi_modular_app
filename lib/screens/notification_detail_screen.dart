import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String notificationId;

  const NotificationDetailScreen({Key? key, required this.notificationId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Mencari notifikasi berdasarkan ID
    final notification = notificationProvider.notifications.firstWhere(
      (notif) => notif.id == notificationId,
      orElse:
          () =>
              throw Exception(
                'Notification not found',
              ), // Ini akan menangani kasus jika notifikasi tidak ditemukan
    );

    // Mark as read jika belum dibaca
    if (!notification.isRead) {
      notificationProvider.markAsRead(notificationId);
    }

    // Menentukan tipe notifikasi (ini contoh sederhana, bisa disesuaikan)
    String notificationType = 'Notification';
    IconData typeIcon = Icons.notifications_outlined;
    Color typeColor = Colors.blue;

    // Menentukan tipe berdasarkan judul
    if (notification.title.toLowerCase().contains('selamat')) {
      notificationType = 'Welcome';
      typeIcon = Icons.celebration_outlined;
      typeColor = Colors.green;
    } else if (notification.title.toLowerCase().contains('pembaruan')) {
      notificationType = 'System Update';
      typeIcon = Icons.update_outlined;
      typeColor = Colors.blue;
    } else if (notification.title.toLowerCase().contains('pengumuman')) {
      notificationType = 'Announcement';
      typeIcon = Icons.campaign_outlined;
      typeColor = Colors.orange;
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationCard(
                    context,
                    notification,
                    notificationType,
                    typeIcon,
                    typeColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: const Text(
          'Notification Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    dynamic notification,
    String notificationType,
    IconData typeIcon,
    Color typeColor,
  ) {
    final formatter = DateFormat('EEEE, MMMM d, yyyy HH:mm');
    final formattedDate = formatter.format(notification.timestamp);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type icon and badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(typeIcon, color: typeColor, size: 28),
              ),
              const SizedBox(width: 16),
              Text(
                notificationType,
                style: TextStyle(
                  color: typeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      notification.isRead
                          ? Colors.grey[300]
                          : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  notification.isRead ? 'Read' : 'New',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            notification.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Date
          Text(
            formattedDate,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Message
          Text(
            notification.message,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // Additional information or buttons can be added here
          _buildActionSection(context),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Notifications'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
