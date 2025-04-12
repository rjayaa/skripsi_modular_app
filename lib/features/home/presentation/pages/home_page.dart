// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:modular_skripsi_app/features/home/presentation/widgets/news_carousel.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/promotions_carousel.dart';
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
                  slivers: [
                    _buildAppBar(user?.name),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PromotionsCarousel(repository: _repository),
                            const SizedBox(height: 24),
                            NewsCarousel(
                              repository: _repository,
                            ), // Add this line
                            // We'll add Recommendations carousel later
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
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Welcome${userName != null ? ", $userName" : ""}!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    );
  }

  Widget _buildNoConnectionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _refreshKey.currentState?.show();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
