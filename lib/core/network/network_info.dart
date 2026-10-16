import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants/app_constants.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none) && results.length == 1) {
      return false;
    }

    // Real reachability check
    return _checkRealReachability();
  }

  Future<bool> _checkRealReachability() async {
    try {
      final socket = await Socket.connect(
        AppConstants.reachabilityHost,
        AppConstants.reachabilityPort,
        timeout: AppConstants.reachabilityTimeout,
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}
