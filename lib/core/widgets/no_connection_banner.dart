import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/connectivity_provider.dart';

class NoConnectionBanner extends StatelessWidget {
  const NoConnectionBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    if (connectivityProvider.isConnected) {
      return const SizedBox();
    }

    return Container(
      color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'No internet connection',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checking connectivity...')),
              );
            },
            child: const Text('RETRY', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
