import 'dart:convert';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  final Map<String, dynamic>? decode;

  const Profile(this.decode, {super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<Profile> {
  Map<String, dynamic>? decode;

  @override
  void initState() {
    getuser();
    super.initState();
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      decode = json.decode(encodedMap!);
    });
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
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text(
                                    'My Profile',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                              Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(70)),
                                    border: Border.all(
                                        color: Colors.white, width: 7)),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Text(
                                '${decode?['firstName']} ${decode?['lastName']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'Designation: ${decode?['userType']}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              side: const BorderSide(
                                                  color: Colors.white60))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white30),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const Logout()),
                                      );
                                    },
                                    child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Logout',
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
                          ),
                        )))),
            offlineChild: Offline()));
  }
}
