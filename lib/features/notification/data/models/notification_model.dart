// lib/features/notification/data/models/notification_model.dart
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'system', 'offer', 'billing', 'maintenance'
  final DateTime createdAt;
  final bool isRead;
  final String?
  actionRoute; // Optional route to navigate when notification is tapped
  final Map<String, dynamic>? actionData; // Optional data for navigation

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionRoute,
    this.actionData,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? actionData,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      actionData: actionData ?? this.actionData,
    );
  }
}
