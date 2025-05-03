// lib/features/billing/presentation/providers/billing_provider.dart
import 'package:flutter/foundation.dart';
import 'package:modular_skripsi_app/features/billing/data/repositories/billing_repository.dart';
import '../../data/models/billing_model.dart';

class BillingProvider extends ChangeNotifier {
  final BillingRepository _repository;

  List<BillingModel> _bills = [];
  double _totalUnpaid = 0;
  DateTime? _nextPaymentDue;
  bool _isLoading = false;
  String? _error;

  BillingProvider({required BillingRepository repository})
    : _repository = repository;

  // Getters
  List<BillingModel> get bills => _bills;
  double get totalUnpaid => _totalUnpaid;
  DateTime? get nextPaymentDue => _nextPaymentDue;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get unpaid bills
  List<BillingModel> get unpaidBills =>
      _bills.where((bill) => bill.status != BillingStatus.paid).toList();

  // Get paid bills
  List<BillingModel> get paidBills =>
      _bills.where((bill) => bill.status == BillingStatus.paid).toList();

  // Load bills
  Future<void> loadBills() async {
    _setLoading(true);
    try {
      _bills = await _repository.getBills();
      _totalUnpaid = await _repository.getTotalUnpaid();
      _nextPaymentDue = await _repository.getNextPaymentDue();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Get bill by ID
  Future<BillingModel?> getBillById(String id) async {
    try {
      return await _repository.getBillById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Pay bill
  Future<bool> payBill(String billId, PaymentMethod method) async {
    try {
      final success = await _repository.payBill(billId, method);
      if (success) {
        await loadBills(); // Reload to get updated data
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
