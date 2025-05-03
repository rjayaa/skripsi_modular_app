// lib/features/support/data/repositories/dummy_support_repository.dart
import '../models/ticket_model.dart';

class SupportRepository {
  final List<TicketModel> _tickets = [];
  final List<FAQItem> _faqs = [];
  int _ticketCounter = 100001;

  SupportRepository() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _tickets.addAll([
      TicketModel(
        id: '1',
        ticketNumber: '#100001',
        subject: 'Internet Slow Connection',
        description:
            'My internet connection has been very slow for the past 3 days. Download speed is only 10Mbps while my package is 100Mbps.',
        category: TicketCategory.technical,
        status: TicketStatus.inProgress,
        priority: TicketPriority.high,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
        adminResponse:
            'We have identified a technical issue in your area. Our team is working on it.',
        updates: [
          TicketUpdate(
            content: 'We have identified a technical issue in your area.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isFromAdmin: true,
          ),
          TicketUpdate(
            content: 'Our team is working on it and will resolve it soon.',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isFromAdmin: true,
          ),
        ],
      ),
      TicketModel(
        id: '2',
        ticketNumber: '#100002',
        subject: 'Double Billing Charge',
        description:
            'I received two bills for the same month (March 2025). Please help me check.',
        category: TicketCategory.billing,
        status: TicketStatus.resolved,
        priority: TicketPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        adminResponse:
            'This was a system error. Your payment has been refunded.',
        updates: [
          TicketUpdate(
            content: 'We are checking your billing history.',
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
            isFromAdmin: true,
          ),
          TicketUpdate(
            content: 'This was a system error. Your payment has been refunded.',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            isFromAdmin: true,
          ),
        ],
      ),
    ]);

    _faqs.addAll([
      FAQItem(
        id: '1',
        question: 'How can I restart my modem?',
        answer:
            '1. Unplug the power cable from your modem\n2. Wait for 30 seconds\n3. Plug the power cable back in\n4. Wait for the lights to stabilize\n5. Test your connection',
        category: 'Technical',
        tags: ['modem', 'restart', 'troubleshooting'],
      ),
      FAQItem(
        id: '2',
        question: 'How to check my bill payment status?',
        answer:
            'You can check your bill payment status by going to the Billing section in the app. All your past and current bills are listed there with their payment status.',
        category: 'Billing',
        tags: ['billing', 'payment', 'status'],
      ),
      FAQItem(
        id: '3',
        question: 'How to upgrade my internet package?',
        answer:
            'To upgrade your package:\n1. Go to "My Plan" section\n2. Click on "Upgrade Package"\n3. Choose a new package\n4. Confirm your selection',
        category: 'Service',
        tags: ['upgrade', 'package', 'plan'],
      ),
      FAQItem(
        id: '4',
        question: 'What is the customer service hours?',
        answer:
            'Our customer service is available 24/7.\nPhone: (021) 555-0123\nWhatsApp: +62 812-3456-7890\nEmail: support@ispprovider.com',
        category: 'General',
        tags: ['customer service', 'hours', 'contact'],
      ),
    ]);
  }

  // Get all tickets
  Future<List<TicketModel>> getTickets() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_tickets);
  }

  // Get active tickets
  Future<List<TicketModel>> getActiveTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _tickets.where((ticket) => ticket.isActive).toList();
  }

  // Get ticket by ID
  Future<TicketModel?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  // Create new ticket
  Future<TicketModel> createTicket({
    required String subject,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final ticketNumber = '#${_ticketCounter++}';
    final newTicket = TicketModel(
      id: (_tickets.length + 1).toString(),
      ticketNumber: ticketNumber,
      subject: subject,
      description: description,
      category: category,
      status: TicketStatus.open,
      priority: priority,
      createdAt: DateTime.now(),
    );

    _tickets.insert(0, newTicket);
    return newTicket;
  }

  // Get FAQs
  Future<List<FAQItem>> getFAQs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_faqs);
  }

  // Search FAQs
  Future<List<FAQItem>> searchFAQs(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lowercaseQuery = query.toLowerCase();
    return _faqs
        .where(
          (faq) =>
              faq.question.toLowerCase().contains(lowercaseQuery) ||
              faq.answer.toLowerCase().contains(lowercaseQuery) ||
              faq.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)),
        )
        .toList();
  }
}
