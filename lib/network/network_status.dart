import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';


enum NetworkStatus { Online, Offline }

class NetworkStatusService {
  NetworkStatusService._internal() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_emitNetworkStatus);
    refreshStatus();
  }

  static final NetworkStatusService _instance = NetworkStatusService._internal();

  factory NetworkStatusService() => _instance;

  final StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<void> refreshStatus() async {
    final statusList = await Connectivity().checkConnectivity();
    await _emitNetworkStatus(statusList);
  }

  Future<NetworkStatus> currentStatus() async {
    final statusList = await Connectivity().checkConnectivity();
    final status = await _getNetworkStatus(statusList);
    networkStatusController.add(status);
    return status;
  }

  Future<void> _emitNetworkStatus(List<ConnectivityResult> statusList) async {
    final status = await _getNetworkStatus(statusList);
    networkStatusController.add(status);
  }

  Future<NetworkStatus> _getNetworkStatus(
      List<ConnectivityResult> statusList) async {
    final hasConnection =
        statusList.any((status) => status != ConnectivityResult.none);
    if (!hasConnection) {
      return NetworkStatus.Offline;
    }

    final hasInternetAccess = await _hasInternetAccess();
    return hasInternetAccess ? NetworkStatus.Online : NetworkStatus.Offline;
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final socket = await Socket.connect(
        '1.1.1.1',
        53,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } catch (_) {}

    try {
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } catch (_) {}

    return false;
  }
}
