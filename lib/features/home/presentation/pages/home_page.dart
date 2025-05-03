// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:modular_skripsi_app/features/billing/presentation/pages/billing_page.dart';
import 'package:modular_skripsi_app/features/home/presentation/widgets/news_carousel.dart';
import 'package:modular_skripsi_app/features/notification/presentation/pages/notification_page.dart';
import 'package:modular_skripsi_app/features/notification/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/promotions_carousel.dart';
import '../widgets/section_header.dart';
import '../../data/repositories/dummy_home_repository.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = DummyHomeRepository();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: () async {
          // Simulate refresh - in real app, this would fetch new data
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child:
            !connectivityProvider.isConnected
                ? _buildNoConnectionView()
                : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(user?.name),
                    SliverToBoxAdapter(child: _buildSearchBar()),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            SectionHeader(
                              title: 'Special Offers',
                              onSeeAllPressed: () {
                                // Navigate to all promotions page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All Promotions Page'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            PromotionsCarousel(repository: _repository),

                            const SizedBox(height: 32),
                            SectionHeader(
                              title: 'Latest News',
                              onSeeAllPressed: () {
                                // Navigate to all news page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All News Page'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            NewsCarousel(repository: _repository),

                            const SizedBox(height: 32),
                            _buildQuickAccessSection(),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildAppBar(String? userName) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome${userName != null ? "," : ""}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            if (userName != null)
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
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
              // Add some decoration elements
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
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate to notifications page
                    Navigator.pushNamed(context, NotificationPage.routeName);
                  },
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            // Handle help
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Help Center'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for plans, news, support...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) {
          // Handle search
        },
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Access'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickAccessItem(Icons.wifi, 'My Plan', Colors.blue[700]!),
            _buildQuickAccessItem(
              Icons.payment,
              'Billing',
              Colors.orange[700]!,
            ),
            _buildQuickAccessItem(
              Icons.speed,
              'Speed Test',
              Colors.green[700]!,
            ),
            _buildQuickAccessItem(
              Icons.support_agent,
              'Support',
              Colors.purple[700]!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessItem(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        // Navigate to specific page based on label
        switch (label) {
          case 'Billing':
            Navigator.pushNamed(context, BillingPage.routeName);
            break;
          case 'My Plan':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('My Plan page coming soon!')),
            );
            break;
          case 'Speed Test':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Speed Test coming soon!')),
            );
            break;
          case 'Support':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Support page coming soon!')),
            );
            break;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoConnectionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.wifi_off, size: 64, color: Colors.red[300]),
          ),
          const SizedBox(height: 24),
          Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Please check your connection settings and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              _refreshKey.currentState?.show();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Connection'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
