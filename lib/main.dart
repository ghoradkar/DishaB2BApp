import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dishabtob/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool isFirstTimeUser = true;
  Map<String, dynamic> decode = {};
  String? userdecode;
  String? current;
  // final upgrader = Upgrader();

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    debugPrint(FlavorConfig.instance.name);
    getUser();
    isFirstTime();
    current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlavorConfig.instance.name ?? "",
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
      home: const SplashScreen(),
    );
  }

  getUser() async {
    String encodedMap;
    debugPrint('dashboard');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    encodedMap = prefs.getString('user') ?? "";

    if (encodedMap.isNotEmpty) {
      setState(() {
        decode = json.decode(encodedMap);
      });
    }
  }

  isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTimeUser = prefs.getBool('isLoggedIn') ?? false;
    print('isFirstTimeUser $isFirstTimeUser');
    setState(() {
      isFirstTimeUser;
    });
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    debugPrint('Connectivity changed: $_connectionStatus');
  }
}


