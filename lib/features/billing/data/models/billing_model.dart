// lib/features/billing/data/models/billing_model.dart
enum BillingStatus { paid, pending, overdue, canceled }

enum PaymentMethod { creditCard, bankTransfer, eWallet }

class BillingModel {
  final String id;
  final String invoiceNumber;
  final double amount;
  final DateTime billingDate;
  final DateTime dueDate;
  final BillingStatus status;
  final String packageName;
  final String packageSpeed;
  final PaymentMethod? paymentMethod;
  final DateTime? paidDate;
  final List<BillingItem> items;

  BillingModel({
    required this.id,
    required this.invoiceNumber,
    required this.amount,
    required this.billingDate,
    required this.dueDate,
    required this.status,
    required this.packageName,
    required this.packageSpeed,
    this.paymentMethod,
    this.paidDate,
    this.items = const [],
  });

  bool get isLate {
    if (status == BillingStatus.paid) return false;
    return DateTime.now().isAfter(dueDate);
  }

  int get daysUntilDue {
    if (status == BillingStatus.paid) return 0;
    return dueDate.difference(DateTime.now()).inDays;
  }
}

class BillingItem {
  final String description;
  final double amount;
  final String unit;
  final int quantity;

  BillingItem({
    required this.description,
    required this.amount,
    required this.unit,
    required this.quantity,
  });

  double get total => amount * quantity;
}
