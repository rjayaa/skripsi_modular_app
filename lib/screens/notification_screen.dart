import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notification_provider.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notifications';

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.notifications.isEmpty) {
                return const SliverFillRemaining(
                  child: _EmptyNotificationsView(),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final notification =
                      notificationProvider.notifications[index];
                  return _buildNotificationItem(
                    context,
                    notification,
                    notificationProvider,
                  );
                }, childCount: notificationProvider.notifications.length),
              );
            },
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
          'Notifications',
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
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            if (notificationProvider.unreadCount > 0) {
              return TextButton.icon(
                onPressed: () {
                  notificationProvider.markAllAsRead();
                },
                icon: const Icon(Icons.done_all, color: Colors.white),
                label: const Text(
                  'Mark All as Read',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    dynamic notification,
    NotificationProvider provider,
  ) {
    String formattedTime = _formatDate(notification.timestamp);
    bool isUnread = !notification.isRead;

    // Menentukan warna dan ikon berdasarkan tipe notifikasi
    IconData typeIcon = Icons.notifications_outlined;
    Color typeColor = Colors.grey;

    // Misalkan ini adalah contoh untuk menentukan tipe notifikasi berdasarkan judul
    if (notification.title.toLowerCase().contains('selamat')) {
      typeIcon = Icons.celebration_outlined;
      typeColor = Colors.green;
    } else if (notification.title.toLowerCase().contains('pembaruan')) {
      typeIcon = Icons.update_outlined;
      typeColor = Colors.blue;
    } else if (notification.title.toLowerCase().contains('pengumuman')) {
      typeIcon = Icons.campaign_outlined;
      typeColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isUnread ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => NotificationDetailScreen(
                      notificationId: notification.id,
                    ),
              ),
            );

            if (isUnread) {
              provider.markAsRead(notification.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification type icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight:
                                    isUnread
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                fontSize: 16,
                                color:
                                    isUnread ? Colors.black : Colors.grey[800],
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: isUnread ? Colors.grey[800] : Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: isUnread ? Colors.grey[700] : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE, HH:mm').format(date);
    } else {
      return DateFormat('d MMM yyyy, HH:mm').format(date);
    }
  }
}

class _EmptyNotificationsView extends StatelessWidget {
  const _EmptyNotificationsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You don\'t have any notifications yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
