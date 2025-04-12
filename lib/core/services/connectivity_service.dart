import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _controller =
      StreamController.broadcast();

  Stream<ConnectivityResult> get connectivityStream => _controller.stream;
  bool _isInitialized = false;

  ConnectivityService() {
    if (!_isInitialized) {
      init();
    }
  }

  Future<void> init() async {
    _isInitialized = true;

    // Check initial connectivity
    final results = await _connectivity.checkConnectivity();
    // Use the first result or NONE if the list is empty
    _controller.add(results.isNotEmpty ? results.first : ConnectivityResult.none);

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      // Use the first result or NONE if the list is empty
      _controller.add(results.isNotEmpty ? results.first : ConnectivityResult.none);
    });
  }

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    // Consider connected if any result is not NONE
    return results.any((result) => result != ConnectivityResult.none);
  }

  void dispose() {
    _controller.close();
  }
}
