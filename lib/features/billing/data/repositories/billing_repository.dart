// lib/features/billing/data/repositories/dummy_billing_repository.dart
import '../models/billing_model.dart';

class BillingRepository {
  final List<BillingModel> _bills = [];

  BillingRepository() {
    _initializeDummyBills();
  }

  void _initializeDummyBills() {
    _bills.addAll([
      BillingModel(
        id: '1',
        invoiceNumber: 'INV-2025-03-001',
        amount: 550000,
        billingDate: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: BillingStatus.pending,
        packageName: 'Gaming Package 100 Mbps',
        packageSpeed: '100 Mbps',
        items: [
          BillingItem(
            description: 'Internet Package',
            amount: 450000,
            unit: 'month',
            quantity: 1,
          ),
          BillingItem(
            description: 'Premium TV Channels',
            amount: 100000,
            unit: 'month',
            quantity: 1,
          ),
        ],
      ),
      BillingModel(
        id: '2',
        invoiceNumber: 'INV-2025-02-002',
        amount: 450000,
        billingDate: DateTime.now().subtract(const Duration(days: 35)),
        dueDate: DateTime.now().subtract(const Duration(days: 15)),
        status: BillingStatus.paid,
        packageName: 'Internet Package 75 Mbps',
        packageSpeed: '75 Mbps',
        paymentMethod: PaymentMethod.bankTransfer,
        paidDate: DateTime.now().subtract(const Duration(days: 20)),
        items: [
          BillingItem(
            description: 'Internet Package',
            amount: 450000,
            unit: 'month',
            quantity: 1,
          ),
        ],
      ),
      BillingModel(
        id: '3',
        invoiceNumber: 'INV-2025-01-003',
        amount: 600000,
        billingDate: DateTime.now().subtract(const Duration(days: 65)),
        dueDate: DateTime.now().subtract(const Duration(days: 45)),
        status: BillingStatus.paid,
        packageName: 'Business Package 150 Mbps',
        packageSpeed: '150 Mbps',
        paymentMethod: PaymentMethod.eWallet,
        paidDate: DateTime.now().subtract(const Duration(days: 50)),
        items: [
          BillingItem(
            description: 'Internet Package',
            amount: 500000,
            unit: 'month',
            quantity: 1,
          ),
          BillingItem(
            description: 'Static IP',
            amount: 100000,
            unit: 'month',
            quantity: 1,
          ),
        ],
      ),
      BillingModel(
        id: '4',
        invoiceNumber: 'INV-2024-12-004',
        amount: 800000,
        billingDate: DateTime.now().subtract(const Duration(days: 95)),
        dueDate: DateTime.now().subtract(const Duration(days: 75)),
        status: BillingStatus.overdue,
        packageName: 'Premium Package 200 Mbps',
        packageSpeed: '200 Mbps',
        items: [
          BillingItem(
            description: 'Internet Package',
            amount: 700000,
            unit: 'month',
            quantity: 1,
          ),
          BillingItem(
            description: 'Cloud Storage 100GB',
            amount: 100000,
            unit: 'month',
            quantity: 1,
          ),
        ],
      ),
    ]);
  }

  // Get all bills
  Future<List<BillingModel>> getBills() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_bills);
  }

  // Get bill by ID
  Future<BillingModel?> getBillById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _bills.firstWhere((bill) => bill.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get total unpaid amount
  Future<double> getTotalUnpaid() async {
    await Future.delayed(const Duration(milliseconds: 500));
    double total = 0.0;
    for (var bill in _bills) {
      if (bill.status != BillingStatus.paid) {
        total += bill.amount;
      }
    }
    return total;
  }

  // Get next payment due date
  Future<DateTime?> getNextPaymentDue() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final unpaidBills =
        _bills.where((bill) => bill.status != BillingStatus.paid).toList();

    if (unpaidBills.isEmpty) return null;

    unpaidBills.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return unpaidBills.first.dueDate;
  }

  // Simulate payment
  Future<bool> payBill(String billId, PaymentMethod method) async {
    await Future.delayed(const Duration(seconds: 2));

    final index = _bills.indexWhere((bill) => bill.id == billId);
    if (index != -1 && _bills[index].status != BillingStatus.paid) {
      _bills[index] = BillingModel(
        id: _bills[index].id,
        invoiceNumber: _bills[index].invoiceNumber,
        amount: _bills[index].amount,
        billingDate: _bills[index].billingDate,
        dueDate: _bills[index].dueDate,
        status: BillingStatus.paid,
        packageName: _bills[index].packageName,
        packageSpeed: _bills[index].packageSpeed,
        paymentMethod: method,
        paidDate: DateTime.now(),
        items: _bills[index].items,
      );
      return true;
    }
    return false;
  }
}
