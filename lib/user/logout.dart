import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_aware.dart';
import '../network/network_status.dart';
import '../network/offline.dart';
import 'login.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  LogoutPageState createState() => LogoutPageState();
}

class LogoutPageState extends State<Logout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        initialData: NetworkStatus.Online,
        child: NetworkAwareWidget(
            onlineChild: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                    body: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          gradient: LinearGradient(
                              colors: [AppColours.blue, AppColours.orange],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(0.0, 1.0),
                              stops: const [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                            child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.12,
                              left: 15,
                              right: 15),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.white30),
                          //color: Colors.white,
                          // child:Card(
                          //   color: Colors.white,
                          //   child:
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              Card(
                                color: Colors.white38,
                                shape: const RoundedRectangleBorder(
                                    // side:new  BorderSide(color: Colors.white38), //the outline color
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(70))),
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(70)),
                                      border: Border.all(
                                          color: Colors.white38, width: 10)),
                                  child: const Icon(
                                    Icons.logout_outlined,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              const Text(
                                'Logout?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              const Text(
                                'Are you sure, you want to Logout?',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Colors.white60))),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white38),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'No',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 20,
                                              )
                                            ]),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            // side: BorderSide(color: Colors.red)
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColours.orange
                                                      .withOpacity(0.7)),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          String? userN = prefs.getString(
                                              SessionManager().kUserName);
                                          String? userPsw = prefs.getString(
                                              SessionManager().kPassword);

                                          bool keepFlag = await SessionManager()
                                              .getKeepSignedIn();

                                          await SessionManager().clearSession();

                                          await prefs.setString(
                                              SessionManager().kUserName,
                                              userN!);
                                          await prefs.setString(
                                              SessionManager().kPassword,
                                              userPsw!);

                                          SessionManager()
                                              .setKeepSignedIn(keepFlag);

                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const LoginPage(),
                                            ),
                                            (Route route) => false,
                                          );


                                        },
                                        child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Yes',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 20,
                                              )
                                            ]),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ))))),
            offlineChild: Offline()));
  }
}
