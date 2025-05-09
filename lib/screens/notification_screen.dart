import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (notificationProvider.hasUnread)
            TextButton(
              onPressed: () {
                notificationProvider.markAllAsRead();
              },
              child: const Text(
                'Tandai semua dibaca',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body:
          notifications.isEmpty
              ? const Center(child: Text('Tidak ada notifikasi'))
              : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final formatter = DateFormat('dd MMM yyyy, HH:mm');
                  final formattedTime = formatter.format(
                    notification.timestamp,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    elevation: notification.isRead ? 1 : 3,
                    color:
                        notification.isRead
                            ? null
                            : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            notification.isRead
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight:
                              notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(notification.message),
                          const SizedBox(height: 5),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        if (!notification.isRead) {
                          notificationProvider.markAsRead(notification.id);
                        }
                      },
                    ),
                  );
                },
              ),
    );
  }
}
