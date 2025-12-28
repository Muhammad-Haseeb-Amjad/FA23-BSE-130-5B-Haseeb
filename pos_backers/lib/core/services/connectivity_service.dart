import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _controller.stream;

  Future<bool> get isOnline async {
    final status = await _connectivity.checkConnectivity();
    return _isOnline(status);
  }

  Future<void> init() async {
    final status = await _connectivity.checkConnectivity();
    _controller.add(_isOnline(status));
    _connectivity.onConnectivityChanged.listen((event) {
      _controller.add(_isOnline(event));
    });
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi || r == ConnectivityResult.ethernet || r == ConnectivityResult.vpn);
  }

  void dispose() {
    _controller.close();
  }
}
