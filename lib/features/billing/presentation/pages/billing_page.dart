// lib/features/billing/presentation/pages/billing_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/billing_model.dart';
import '../providers/billing_provider.dart';
import 'billing_detail_page.dart';

class BillingPage extends StatefulWidget {
  static const routeName = '/billing';

  const BillingPage({Key? key}) : super(key: key);

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BillingProvider>().loadBills();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildOverviewCard()),
          SliverFillRemaining(
            child: Column(
              children: [
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildUnpaidTab(), _buildPaidTab()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: const Text(
          'Billing & Payments',
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
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Billing Help Center')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    return Consumer<BillingProvider>(
      builder: (context, billingProvider, child) {
        if (billingProvider.isLoading) {
          return Container(
            height: 120,
            margin: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final currencyFormat = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Unpaid Amount',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormat.format(billingProvider.totalUnpaid),
                            style: TextStyle(
                              color:
                                  billingProvider.totalUnpaid == 0
                                      ? Colors.green[700]
                                      : Theme.of(context).primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (billingProvider.nextPaymentDue != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            billingProvider.nextPaymentDue!,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Next Payment Due',
                              style: TextStyle(
                                color: _getStatusColor(
                                  billingProvider.nextPaymentDue!,
                                ),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'd MMM yyyy',
                              ).format(billingProvider.nextPaymentDue!),
                              style: TextStyle(
                                color: _getStatusColor(
                                  billingProvider.nextPaymentDue!,
                                ),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (billingProvider.totalUnpaid > 0)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Icon(
                      Icons.payment,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text(
                      'Pay Now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Settle your outstanding bills'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                    onTap: () {
                      // Navigate to payment screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment feature coming soon!'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(DateTime dueDate) {
    final now = DateTime.now();
    final daysUntil = dueDate.difference(now).inDays;

    if (daysUntil < 0) return Colors.red;
    if (daysUntil <= 3) return Colors.orange;
    return Colors.green;
  }

  Widget _buildTabBar() {
    return Material(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[500],
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        tabs: const [Tab(text: 'Unpaid'), Tab(text: 'History')],
      ),
    );
  }

  Widget _buildUnpaidTab() {
    return Consumer<BillingProvider>(
      builder: (context, billingProvider, child) {
        if (billingProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (billingProvider.error != null) {
          return Center(child: Text('Error: ${billingProvider.error}'));
        }

        final unpaidBills = billingProvider.unpaidBills;

        if (unpaidBills.isEmpty) {
          return _buildEmptyState(
            'No pending bills',
            Icons.check_circle_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: unpaidBills.length,
          itemBuilder: (context, index) {
            final bill = unpaidBills[index];
            return _buildBillCard(bill);
          },
        );
      },
    );
  }

  Widget _buildPaidTab() {
    return Consumer<BillingProvider>(
      builder: (context, billingProvider, child) {
        if (billingProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (billingProvider.error != null) {
          return Center(child: Text('Error: ${billingProvider.error}'));
        }

        final paidBills = billingProvider.paidBills;

        if (paidBills.isEmpty) {
          return _buildEmptyState('No payment history', Icons.history);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: paidBills.length,
          itemBuilder: (context, index) {
            final bill = paidBills[index];
            return _buildBillCard(bill, isPaid: true);
          },
        );
      },
    );
  }

  Widget _buildBillCard(BillingModel bill, {bool isPaid = false}) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (bill.status) {
      case BillingStatus.paid:
        statusColor = Colors.green;
        statusText = 'PAID';
        statusIcon = Icons.check_circle;
        break;
      case BillingStatus.pending:
        statusColor = bill.isLate ? Colors.red : Colors.orange;
        statusText = bill.isLate ? 'OVERDUE' : 'PENDING';
        statusIcon = bill.isLate ? Icons.warning : Icons.access_time;
        break;
      case BillingStatus.overdue:
        statusColor = Colors.red;
        statusText = 'OVERDUE';
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'UNKNOWN';
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
                builder: (context) => BillingDetailPage(billId: bill.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.packageName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bill.invoiceNumber,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          currencyFormat.format(bill.amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bill.status == BillingStatus.paid
                              ? 'Paid Date'
                              : 'Due Date',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          DateFormat('d MMM yyyy').format(
                            bill.status == BillingStatus.paid
                                ? bill.paidDate ?? bill.dueDate
                                : bill.dueDate,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color:
                                bill.status != BillingStatus.paid && bill.isLate
                                    ? Colors.red
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!isPaid) ...[
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to payment
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment coming soon!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Pay Now'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Everything is up to date!',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
