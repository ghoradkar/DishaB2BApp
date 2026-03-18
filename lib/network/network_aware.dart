import 'dart:async';
import 'package:dishabtob/global/custom_message.dart';
import 'package:flutter/material.dart';

import 'network_status.dart';


class NetworkAwareWidget extends StatefulWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget(
      {Key? key, required this.onlineChild, required this.offlineChild})
      : super(key: key);

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  final NetworkStatusService _networkStatusService = NetworkStatusService();
  StreamSubscription<NetworkStatus>? _networkSubscription;
  NetworkStatus _networkStatus = NetworkStatus.Online;

  @override
  void initState() {
    super.initState();
    _networkSubscription = _networkStatusService.networkStatusController.stream
        .listen((status) {
      if (!mounted) return;
      setState(() {
        _networkStatus = status;
      });
    });
    _syncNetworkStatus();
  }

  Future<void> _syncNetworkStatus() async {
    final status = await _networkStatusService.currentStatus();
    if (!mounted) return;
    setState(() {
      _networkStatus = status;
    });
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_networkStatus == NetworkStatus.Online) {
      return widget.onlineChild;
    } else {
      _showToastMessage("Offline");
      return widget.offlineChild;
    }
  }

  void _showToastMessage(String message){
    CustomMessage.toast(message);}
}
