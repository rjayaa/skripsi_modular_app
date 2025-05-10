import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import 'notification_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _isConnected = true; // Simplified connectivity state

  // Dummy data untuk carousel promotions
  final List<Map<String, dynamic>> _promotions = [
    {
      'id': '1',
      'title': 'Bundle 50 Mbps + TV',
      'description':
          'Get high-speed internet with 50 Mbps and premium TV channels in one package.',
      'price': 450000,
      'discountPrice': 399000,
      'validUntil': DateTime.now().add(const Duration(days: 30)),
    },
    {
      'id': '2',
      'title': 'Gaming Package 100 Mbps',
      'description':
          'Ultimate gaming experience with low latency and 100 Mbps download speed.',
      'price': 650000,
      'discountPrice': 599000,
      'validUntil': DateTime.now().add(const Duration(days: 15)),
    },
    {
      'id': '3',
      'title': 'Work From Home 25 Mbps',
      'description':
          'Reliable connection for your home office needs with 25 Mbps speed.',
      'price': 299000,
      'validUntil': DateTime.now().add(const Duration(days: 45)),
    },
  ];

  // Dummy data untuk news
  final List<Map<String, dynamic>> _news = [
    {
      'id': '1',
      'title': 'Planned Maintenance on March 15',
      'summary':
          'Important information about upcoming network maintenance that may affect your service.',
      'publishDate': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'Updates',
    },
    {
      'id': '2',
      'title': 'New Speed Tiers Available in Your Area',
      'summary':
          'We\'ve upgraded our network infrastructure to support higher speeds in selected areas.',
      'publishDate': DateTime.now().subtract(const Duration(days: 7)),
      'category': 'Network Updates',
    },
    {
      'id': '3',
      'title': 'Customer Support Hours Extended',
      'summary':
          'Our support team is now available 24/7 to better assist you with any technical issues.',
      'publishDate': DateTime.now().subtract(const Duration(days: 14)),
      'category': 'Customer Service',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
          setState(() {}); // Refresh UI
        },
        child:
            !_isConnected
                ? _buildNoConnectionView()
                : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(user?.name, notificationProvider),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            _buildSectionHeader('Special Offers', () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All Promotions Page'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            _buildPromotionsCarousel(),

                            const SizedBox(height: 32),
                            _buildSectionHeader('Latest News', () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All News Page'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            _buildNewsCarousel(),

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
      drawer: _buildDrawer(context, authProvider),
    );
  }

  Widget _buildAppBar(
    String? userName,
    NotificationProvider notificationProvider,
  ) {
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
        // Notification icon with badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
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
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
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

  Widget _buildSectionHeader(String title, VoidCallback? onSeeAllPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: Row(
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPromotionsCarousel() {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return SizedBox(
      height: 220,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _promotions.length,
        itemBuilder: (context, index) {
          final promotion = _promotions[index];
          final discountPrice = promotion['discountPrice'];
          final price = promotion['price'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Card(
              elevation: 6,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background as placeholder for image
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.6, 0.75, 1.0],
                          ),
                        ),
                      ),
                      // Content overlay
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Discount badge if available
                            if (discountPrice != null)
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${(((price - discountPrice) / price) * 100).round()}% OFF',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            const Spacer(),
                            // Title
                            Text(
                              promotion['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Description
                            Text(
                              promotion['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Price row
                            Row(
                              children: [
                                if (discountPrice != null) ...[
                                  Text(
                                    currencyFormat.format(price),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    currencyFormat.format(discountPrice),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ] else
                                  Text(
                                    currencyFormat.format(price),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const Spacer(),
                                // Validity period
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Until ${DateFormat('d MMM').format(promotion['validUntil'])}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsCarousel() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          final news = _news[index];
          final newsCategory = news['category'] as String;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Card(
              elevation: 6,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background as placeholder for image
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getCategoryColor(newsCategory),
                              _getCategoryColor(newsCategory).withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.6, 0.75, 1.0],
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Category and date at the top
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(
                                      newsCategory,
                                    ).withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    newsCategory,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Title
                            Text(
                              news['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Summary
                            Text(
                              news['summary'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Publish date and author
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat(
                                    'd MMM yyyy',
                                  ).format(news['publishDate']),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'updates':
        return Colors.blue;
      case 'network updates':
        return Colors.green;
      case 'customer service':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label page coming soon!')));
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

  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    authProvider.user?.name?.substring(0, 1).toUpperCase() ??
                        'U',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  authProvider.user?.name ?? 'User',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  authProvider.user?.email ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile page coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Billing'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Billing page coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Support'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support page coming soon!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings page coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
