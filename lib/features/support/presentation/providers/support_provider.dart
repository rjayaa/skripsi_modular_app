// lib/features/support/presentation/providers/support_provider.dart
import 'package:flutter/foundation.dart';
import '../../data/models/ticket_model.dart';
import '../../data/repositories/support_repository.dart';

class SupportProvider extends ChangeNotifier {
  final SupportRepository _repository;

  List<TicketModel> _tickets = [];
  List<FAQItem> _faqs = [];
  bool _isLoading = false;
  String? _error;

  SupportProvider({required SupportRepository repository})
    : _repository = repository;

  // Getters
  List<TicketModel> get tickets => _tickets;
  List<FAQItem> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get active tickets
  List<TicketModel> get activeTickets =>
      _tickets.where((ticket) => ticket.isActive).toList();

  // Load tickets
  Future<void> loadTickets() async {
    _setLoading(true);
    try {
      _tickets = await _repository.getTickets();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load FAQs
  Future<void> loadFAQs() async {
    _setLoading(true);
    try {
      _faqs = await _repository.getFAQs();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Create ticket
  Future<TicketModel?> createTicket({
    required String subject,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  }) async {
    try {
      final ticket = await _repository.createTicket(
        subject: subject,
        description: description,
        category: category,
        priority: priority,
      );
      await loadTickets(); // Reload tickets
      return ticket;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Get ticket by ID
  Future<TicketModel?> getTicketById(String id) async {
    try {
      return await _repository.getTicketById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Search FAQs
  Future<List<FAQItem>> searchFAQs(String query) async {
    try {
      return await _repository.searchFAQs(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
