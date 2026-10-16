import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../network/network_info.dart';
import 'app_logger.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  final NetworkInfo _networkInfo;
  final Connectivity _connectivity;

  final RxBool isOnline = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService({
    NetworkInfo? networkInfo,
    Connectivity? connectivity,
  })  : _networkInfo = networkInfo ?? NetworkInfoImpl(),
        _connectivity = connectivity ?? Connectivity();

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _checkInitialConnectivity() async {
    final connected = await _networkInfo.isConnected;
    isOnline.value = connected;
    AppLogger.info('Initial connectivity check: isOnline=$connected');
  }

  void _listenToConnectivityChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.none) && results.length == 1) {
        isOnline.value = false;
        AppLogger.warning('Network disconnected: no interface');
      } else {
        // Double check real reachability
        final hasRealInternet = await _networkInfo.isConnected;
        isOnline.value = hasRealInternet;
        AppLogger.info('Network state changed: isOnline=$hasRealInternet');
      }
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
