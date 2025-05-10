// class NotificationItem {
//   final String id;
//   final String title;
//   final String message;
//   final DateTime timestamp;
//   final bool isRead;

//   NotificationItem({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.timestamp,
//     this.isRead = false,
//   });
// }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String?
  type; // Optional: untuk menentukan jenis notifikasi (system, promo, billing, dll)
  final Map<String, dynamic>?
  data; // Optional: untuk data tambahan yang dibutuhkan

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type,
    this.data,
  });

  // Method untuk membuat salinan NotificationItem dengan nilai yang diubah
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  // Factory method untuk membuat NotificationItem dari JSON data (berguna untuk Firebase)
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp:
          json['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
              : DateTime.now(),
      isRead: json['isRead'] ?? false,
      type: json['type'],
      data: json['data'],
    );
  }

  // Method untuk mengubah NotificationItem menjadi JSON (berguna untuk penyimpanan lokal)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
    };
  }
}
