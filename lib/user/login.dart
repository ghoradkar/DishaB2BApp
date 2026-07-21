import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/session_manager.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/runner_boy/runnerboy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import '../dashboard/homescreen.dart';
import '../global/custom_message.dart';
import '../global/url.dart';
import '../network/network_status.dart';

enum UnitFetchStatus { success, invalidUsername, noInternet, failure }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _obscured = true;
  String area = '';
  String? unitname;
  String? labid;
  bool load = false;
  List<dynamic> lablist = [];
  bool complete = false;
  List unit = [];
  List hospital = [];
  String? userid;
  final formKey = GlobalKey<FormState>();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  FocusNode femail = FocusNode();
  FocusNode fpassword = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // FocusNode fusername = FocusNode();
  FocusNode button = FocusNode();
  TextEditingController username = TextEditingController();
  String? current;
  String? unitcode;
  String? unitid;
  String? runnerboy;
  String? fetchedUnitForUsername;
  List<dynamic>? user;
  Map<String, dynamic> hospitaldetails = {};
  Map<String, dynamic>? getunit;
  Map<String, dynamic>? decode;
  var userData;
  Upgrader? upgrader;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  String? decryptedKeyIdRazorPay;

  String? decryptedKeySecretRazorPay;

  String connectivityCheck(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      return "You are now connected to wifi";
    } else if (result == ConnectivityResult.mobile) {
      return "You are now connected to mobile data";
    } else if (result == ConnectivityResult.ethernet) {
      return "You are now connected to ethernet";
    } else if (result == ConnectivityResult.bluetooth) {
      return "You are now connected to bluetooth";
    } else if (result == ConnectivityResult.none) {
      return "No connection available";
    } else {
      return "No Connection!!";
    }
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_debugPrint
    debugPrint('Connectivity changed: $_connectionStatus');
  }

  @override
  void initState() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    initUpgrader().then((_) {
      setState(() {
        upgrader = Upgrader(debugLogging: true);
      });
    });

    current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      complete = true;
    });

    femail.addListener(() {
      print(femail.hasFocus);
    });
    fpassword.addListener(() {
      print(fpassword.hasFocus);
    });
    isKeepMeSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (upgrader == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return UpgradeAlert(
      shouldPopScope: () => false,
      showIgnore: false,
      showLater: false,
      dialogStyle: UpgradeDialogStyle.material,
      upgrader: upgrader!,
      child: StreamProvider<NetworkStatus>(
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          initialData: ConnectivityResult == 'none'
              ? NetworkStatus.Offline
              : NetworkStatus.Online,
          child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Scaffold(
                      backgroundColor: Colors.white,
                      body: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                load == false
                                    ? unitname != null
                                        ? Visibility(
                                            visible: FlavorConfig
                                                        .instance.name !=
                                                    'B2BLondon' &&
                                                FlavorConfig.instance.name !=
                                                    'B2BLifenity',
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.15),
                                                child: Image.network(
                                                  '$baseurl${hospitaldetails["filePath"]}',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                )),
                                          )
                                        : const SizedBox()
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                Visibility(
                                    visible: FlavorConfig.instance.name ==
                                        'B2BLondon',
                                    child: Center(
                                      child: Image.asset(
                                        "assets/logo.png",
                                        width: 100,
                                      ),
                                    )),
                                Visibility(
                                    visible: FlavorConfig.instance.name ==
                                        'B2BLifenity',
                                    child: Center(
                                      child: Image.asset(
                                        "assets/logo_lifenity.png",
                                        width: 100,
                                      ),
                                    )),
                                Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              AppColours.blue,
                                              BlendMode.dst,
                                            ),
                                            image: const AssetImage(
                                              'assets/bg.png',
                                            ),
                                            fit: BoxFit.fitWidth)),
                                    height: MediaQuery.of(context).size.height *
                                        0.74,
                                    //color:Colurs.blue.withOpacity(0.9),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                          ),

                                          const Text(
                                            'Sign In',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Welcome! Enter username & password to continue',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),

                                          //SizedBox(height: 5,),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          Center(
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    onTapOutside: (event) {
                                                      if (username
                                                          .text.isNotEmpty) {
                                                        setState(() {
                                                          load = true;
                                                          unitName(username.text
                                                              .trim());
                                                        });
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      }
                                                    },
                                                    onEditingComplete: () {
                                                      if (username
                                                          .text.isNotEmpty) {
                                                        setState(() {
                                                          load = true;
                                                          unitName(username.text
                                                              .trim());
                                                        });
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      if (username
                                                          .text.isNotEmpty) {
                                                        setState(() {
                                                          load = true;
                                                          unitName(username.text
                                                              .trim());
                                                        });
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },

                                                    // focusNode: fusername,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: username,

                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    cursorColor: Colors.white,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.white60,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap:
                                                              _toggleObscured,
                                                          child: const Icon(
                                                            Icons
                                                                .person_outline_sharp,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),

                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: const TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Username ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                            ),
                                                            TextSpan(
                                                              text: '*',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // labelText: 'Password',
                                                      // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  )
                                                  // ),  onFocusChange: (hasFocus) {
                                                  //   if (hasFocus) {
                                                  //     Unitname(username.text);
                                                  //   }
                                                  )),

                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              child: TextFormField(
                                                onTap: () {
                                                  if (username
                                                      .text.isNotEmpty) {
                                                    setState(() {
                                                      load = true;
                                                    });
                                                    unitName(
                                                        username.text.trim());
                                                  }
                                                },
                                                focusNode: fpassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller: password,
                                                //focusNode: fpassword,
                                                obscureText: _obscured,
                                                // validator: (value) {
                                                //   if (value!.isEmpty) {
                                                //     return "Password can not be empty";
                                                //   } else {
                                                //     return null;
                                                //   }
                                                // },
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.transparent,

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.white60,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.white60,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  prefixIcon: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 4, 0),
                                                    child: GestureDetector(
                                                      onTap: _toggleObscured,
                                                      child: const Icon(
                                                        Icons.lock_outlined,
                                                        size: 24,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),

                                                  //hintText: 'Enter Password',
                                                  label: RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Password ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                        TextSpan(
                                                          text: '*',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // labelText: 'Password',
                                                  // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          load
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Center(
                                                  child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white60,
                                                      ),
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: DropdownButton(
                                                    hint: RichText(
                                                      text: const TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Select Unit',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    autofocus: true,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    isExpanded: true,
                                                    dropdownColor: Colors.grey,
                                                    iconEnabledColor:
                                                        Colors.white,
                                                    value: unitname,
                                                    items: unit.map((country) {
                                                      return DropdownMenuItem(
                                                        value:
                                                            country['unitName'],
                                                        child: Text(
                                                          country['unitName'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (country) {
                                                      setState(() {
                                                        unitname =
                                                            country as String?;

                                                        //widget.district!.indexOf(country);

                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      });
                                                    },
                                                  ),
                                                )),

                                          Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(children: [
                                                  Checkbox(
                                                    activeColor:
                                                        AppColours.orange,
                                                    value: complete,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      setState(() {
                                                        complete =
                                                            newValue ?? false;
                                                      });
                                                      SessionManager()
                                                          .setKeepSignedIn(
                                                              complete);
                                                    },
                                                  ),
                                                  const Text(
                                                    'Keep Me Sign In',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )
                                                ]),
                                              )),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          ),
                                          Center(
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                      shape: WidgetStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        // side: BorderSide(color: Colors.red)
                                                      )),
                                                      backgroundColor: FlavorConfig
                                                                  .instance
                                                                  .name ==
                                                              "B2BLifenity"
                                                          ? WidgetStateProperty
                                                              .all<Color>(
                                                                  AppColours
                                                                      .white)
                                                          : WidgetStateProperty
                                                              .all<
                                                                      Color>(
                                                                  AppColours
                                                                      .orange),
                                                    ),
                                                    onPressed: () async {
                                                      // if (username
                                                      //         .text.isNotEmpty &&
                                                      //     password
                                                      //         .text.isNotEmpty) {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        final enteredUsername =
                                                            username.text
                                                                .trim();

                                                        final shouldFetchUnit =
                                                            unitname == null ||
                                                                unitid ==
                                                                    null ||
                                                                unitcode ==
                                                                    null ||
                                                                fetchedUnitForUsername !=
                                                                    enteredUsername;

                                                        if (shouldFetchUnit) {
                                                          setState(() {
                                                            load = true;
                                                          });
                                                          final unitFetchStatus =
                                                              await unitName(
                                                              enteredUsername);

                                                          if (unitFetchStatus ==
                                                              UnitFetchStatus
                                                                  .noInternet) {
                                                            CustomMessage.toast(
                                                                'Internet not available');
                                                            return;
                                                          }

                                                          if (unitFetchStatus ==
                                                              UnitFetchStatus
                                                                  .invalidUsername) {
                                                            CustomMessage.toast(
                                                                'Unit details not available. Please check username');
                                                            return;
                                                          }

                                                          if (unitFetchStatus ==
                                                              UnitFetchStatus
                                                                  .failure) {
                                                            CustomMessage.toast(
                                                                'Unable to fetch unit details. Please try again');
                                                            return;
                                                          }
                                                        }

                                                        if (unitname != null &&
                                                            unitid != null &&
                                                            unitcode != null) {
                                                          await login(
                                                            enteredUsername
                                                                .toString(),
                                                            password.text
                                                                .toString(),
                                                            unitid,
                                                            unitcode,
                                                            unitname,
                                                            runnerboy,
                                                            userid,
                                                          );
                                                        } else {
                                                          CustomMessage.toast(
                                                              'Unit details not available. Please check username');
                                                        }
                                                      } else {
                                                        CustomMessage.toast(
                                                            'Username and password are required');
                                                      }
                                                      // }
                                                      // else {
                                                      //   CustomMessage.toast(
                                                      //       'Invalid Username or Password');
                                                      // }
                                                    },
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Text(
                                                                'Sign In',
                                                                style: TextStyle(
                                                                    color: FlavorConfig.instance.name ==
                                                                            "B2BLifenity"
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                    fontSize:
                                                                        14),
                                                              )),
                                                          Icon(
                                                            Icons.arrow_forward,
                                                            color: FlavorConfig
                                                                        .instance
                                                                        .name ==
                                                                    "B2BLifenity"
                                                                ? Colors.black
                                                                : Colors.white,
                                                            size: 20,
                                                          )
                                                        ]))),
                                          ),
                                        ],
                                      ),
                                    )),
                                load == false
                                    ? unitname == null
                                        ? const SizedBox()
                                        : Center(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //SizedBox(height: 10,),
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: AppColours.blue,
                                                    size: 20,
                                                  ),
                                                  //SizedBox(height: 10,),
                                                  Text(
                                                    hospitaldetails == null
                                                        ? ''
                                                        : hospitaldetails[
                                                                'hospitalName'] ??
                                                            "",
                                                    style: TextStyle(
                                                        color: AppColours.blue,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6,
                                                        horizontal: 6),
                                                    child: Text(
                                                      '${hospitaldetails == null ? '' : hospitaldetails['hospitalAddress'] ?? ""}${hospitaldetails['hospitalCity'] ?? ""}-${hospitaldetails['hospitalZip'] ?? ""} ',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),

                                                  Text(
                                                    '${hospitaldetails == null ? '' : hospitaldetails['hospitalEmail'] ?? ""} | ${hospitaldetails['hospitalContact'] ?? ""}',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10),
                                                  ),
                                                  // SizedBox(height: 10,)
                                                ]),
                                          )
                                    : const SizedBox(),
                              ])))))),
    );
  }

  Future<void> initUpgrader() async {
    await Upgrader.clearSavedSettings();
    setState(() {
      upgrader = Upgrader(
        debugLogging: true,
      );
    });
  }

  isKeepMeSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = await SessionManager().getKeepSignedIn();
    if (isLoggedIn) {
      username.text = prefs.getString(SessionManager().kUserName)!;

      password.text = prefs.getString(SessionManager().kPassword)!;
      String? userN = prefs.getString(SessionManager().kUserName);
      unitName(userN);
    }
  }

  login(
      username, password, unitid, unitcode, unitname, runnerboy, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.LOGIN}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "userName": username,
      "password": password,
      "uId": unitid,
      "uname": unitname,
      "unitCode": unitcode,
      "runnerBoy": runnerboy,
      "userId": userId
    };
    final jsonbody = json.encode(body);
    print(jsonbody);
    try {
      final response = await ioClient
          .post(uri, headers: headers, body: jsonbody)
          .timeout(const Duration(seconds: 20));
      debugPrint(response.body);

      Map<String, dynamic> value = jsonDecode(response.body);
      debugPrint(value['message']);

      if (value['status'] == 'success') {
        CustomMessage.toast('Login Successful !! ');
        complete == true
            ? prefs.setBool("isLoggedIn", true)
            : prefs.setBool("isLoggedIn", false);

        // Get user data from response
        userData = value['result'].first;

        // Extract first value from `customerType` and `customerId`
        userData['customerType'] = userData['customerType'].split(',').first;
        userData['customerId'] = userData['customerId'].split(',').first;

        // Set user data
        await setUser(userData);

        var userName = userData['userName'];
        var userPassword = userData['password'];

        // Store values in SharedPreferences
        await prefs.setString(SessionManager().kUserName, userName);
        await prefs.setString(SessionManager().kPassword, userPassword);
        await prefs.setString("Unitname", unitname!);
        await prefs.setString("UnitId", unitid!);
        await prefs.setString("UnitCode", unitcode!);
        await prefs.setString("runnerboy", runnerboy);
        // await setUp();
        // Navigate based on user type
        if (userData['userType'] == 'Runner Boy') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const RunnerBoy(0, [], [], [])),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage('Today', current!, current!, userData)),
          );
        }
      } else {
        CustomMessage.toast(value['message']);
      }
    } on SocketException catch (e) {
      debugPrint('Login SocketException: $e');
      CustomMessage.toast('Internet not available');
    } on ClientException catch (e) {
      debugPrint('Login ClientException: $e');
      CustomMessage.toast('Internet not available');
    } on TimeoutException catch (e) {
      debugPrint('Login TimeoutException: $e');
      CustomMessage.toast('Internet not available');
    } catch (e) {
      debugPrint('Login Error: $e');
      CustomMessage.toast('Unable to sign in. Please try again');
    }
  }

  Future<UnitFetchStatus> unitName(username) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);
    final enteredUsername = username.toString().trim();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final uri =
          Uri.parse('${url.baseurl}${url.UNIT}?ulogin=$enteredUsername');
      debugPrint("b2bMobilefetchUnitList ${uri.path}");

      final response = await ioClient.post(
        uri,
        headers: headers,
      );

        debugPrint(response.body);
      Map<String, dynamic> value = jsonDecode(response.body);
      debugPrint(response.body);

      if (response.statusCode == 200 && value['lstUnit'].isNotEmpty) {
        load = false;

        unit = value['lstUnit'];
        getunit = unit.first;
        load = false;
        unitname = getunit!['unitName'];
        unitcode = getunit!['unitCode'];
        unitid = getunit!['unitId'].toString();
        runnerboy = getunit!['runnerBoy'];
        userid = getunit!['userId'].toString();
        fetchedUnitForUsername = enteredUsername;
        await hospitalDetails(unitid);

        setState(() {});
        return UnitFetchStatus.success;
      } else {
        setState(() {
          load = false;
          fetchedUnitForUsername = null;
          unitname = null;
          unitcode = null;
          unitid = null;
          runnerboy = null;
          userid = null;
        });
        return UnitFetchStatus.invalidUsername;
      }
    } on SocketException catch (e) {
      debugPrint('unitName SocketException: $e');
      setState(() {
        load = false;
        fetchedUnitForUsername = null;
        unitname = null;
        unitcode = null;
        unitid = null;
        runnerboy = null;
        userid = null;
      });
      return UnitFetchStatus.noInternet;
    } on ClientException catch (e) {
      debugPrint('unitName ClientException: $e');
      setState(() {
        load = false;
        fetchedUnitForUsername = null;
        unitname = null;
        unitcode = null;
        unitid = null;
        runnerboy = null;
        userid = null;
      });
      return UnitFetchStatus.noInternet;
    } on TimeoutException catch (e) {
      debugPrint('unitName TimeoutException: $e');
      setState(() {
        load = false;
        fetchedUnitForUsername = null;
        unitname = null;
        unitcode = null;
        unitid = null;
        runnerboy = null;
        userid = null;
      });
      return UnitFetchStatus.noInternet;
    } catch (e) {
      debugPrint('unitName Error: $e');
      setState(() {
        load = false;
        fetchedUnitForUsername = null;
        unitname = null;
        unitcode = null;
        unitid = null;
        runnerboy = null;
        userid = null;
      });
      return UnitFetchStatus.failure;
    }
  }

  hospitalDetails(unitid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri =
        Uri.parse('${url.baseurl}${url.HOSPITAL}?corporateId=0&unitId=$unitid');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(response.body);
    Map<String, dynamic> value = {};
    //debugPrint(value);

    if (response.statusCode == 200) {
      hospital = jsonDecode(response.body);
      value = hospital.first;
      setState(() {
        load = false;
        hospitaldetails = value;
      });
    } else {
      CustomMessage.toast(value['exception']);
    }
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (fpassword.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      fpassword.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      decode = json.decode(encodedMap!);
    });
  }

  setUser(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encode = json.encode(result);

    prefs.setString('user', encode);
  }
}
