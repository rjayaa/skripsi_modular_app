// lib/features/support/data/models/ticket_model.dart
enum TicketStatus { open, inProgress, resolved, closed }

enum TicketCategory { billing, technical, service, other }

enum TicketPriority { low, medium, high }

class TicketModel {
  final String id;
  final String ticketNumber;
  final String subject;
  final String description;
  final TicketCategory category;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
  final DateTime? lastUpdated;
  final String? adminResponse;
  final List<TicketUpdate> updates;

  TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.lastUpdated,
    this.adminResponse,
    this.updates = const [],
  });

  bool get isActive => status != TicketStatus.closed;
}

class TicketUpdate {
  final String content;
  final DateTime timestamp;
  final bool isFromAdmin;

  TicketUpdate({
    required this.content,
    required this.timestamp,
    this.isFromAdmin = false,
  });
}

class FAQItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final List<String> tags;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.tags = const [],
  });
}
