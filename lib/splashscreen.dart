import 'package:dishabtob/dashboard/homescreen.dart';
import 'package:dishabtob/runner_boy/runnerboy.dart';
import 'package:dishabtob/user/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? version;

  String? buildNumber;

  @override
  void initState() {
    getVersionName();
    _navigateToNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            Center(
              child: Image.asset(
                (FlavorConfig.instance.name == 'DubaiB2B' ||
                        FlavorConfig.instance.name == 'B2BLifenity')
                    ? "assets/logo_lifenity.png"
                    : 'assets/logo.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (version != null) ? "Version : $version" : '',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userData = prefs.getString('user');
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (isLoggedIn && userData != null) {
      Map<String, dynamic> user = json.decode(userData);
      Widget destination = user['userType'] == 'Runner Boy'
          ? const RunnerBoy(0, [], [], [])
          : HomePage('Today', currentDate, currentDate, user);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }
}

// import 'package:dishabtob/dashboard/homescreen.dart';
// import 'package:dishabtob/runner_boy/runnerboy.dart';
// import 'package:dishabtob/user/login.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// import 'package:upgrader/upgrader.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   SplashScreenState createState() => SplashScreenState();
// }
//
// class SplashScreenState extends State<SplashScreen> {
//   bool isFirstTimeUser = true;
//   Map<String, dynamic> decode = {};
//   String? current;
//
//   @override
//   void initState() {
//     // isFirstTime();
//
//     // getuser();
//
//     current = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     Future.delayed(const Duration(seconds: 2), () async {
//       await checkLoginStatus();
//     });
//     // isFirstTimeUser == false
//     //     ? const LoginPage()
//     //     : decode['userType'] == 'Runner Boy'
//     //         ? RunnerBoy(0, [], [], [])
//     //         : HomePage('Today', current!, current!, decode);
//
//     super.initState();
//   }
//
//   Future<void> checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     String userData = prefs.getString('user') ?? '';
//
//     if (userData.isNotEmpty) {
//       decode = json.decode(userData);
//     }
//
//     if (!mounted) return;
//
//     Widget nextPage;
//     if (!isLoggedIn) {
//       nextPage = const LoginPage();
//     } else if (decode['userType'] == 'Runner Boy') {
//       nextPage = RunnerBoy(0, [], [], []);
//     } else {
//       nextPage = HomePage('Today', current!, current!, decode);
//     }
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UpgradeAlert(
//           showIgnore: false,
//           showReleaseNotes: true,
//           upgrader: Upgrader(),
//           child: nextPage,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       decoration: const BoxDecoration(
//           // image: DecorationImage(
//           //     image: AssetImage(
//           //       'assets/Background.png',
//           //     ),
//           //     fit: BoxFit.fill)
//           ),
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Center(
//         child: Image.asset(
//           'assets/logo.png',
//           width: MediaQuery.of(context).size.width * 0.7,
//         ),
//       ),
//     ));
//   }
//
// }
