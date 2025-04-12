import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../services/connectivity_service.dart';

class ConnectivityProvider with ChangeNotifier {
  final ConnectivityService _connectivityService;
  bool _isConnected = true;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityProvider({required ConnectivityService connectivityService})
    : _connectivityService = connectivityService {
    _init();
  }

  bool get isConnected => _isConnected;

  Future<void> _init() async {
    await _checkConnectivity();
    _subscription = _connectivityService.connectivityStream.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.isConnected();
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final isConnected = result != ConnectivityResult.none;
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
