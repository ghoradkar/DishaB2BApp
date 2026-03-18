import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DataNotFound extends StatefulWidget {
  const DataNotFound({super.key});

  @override
  DataNotFoundState createState() => DataNotFoundState();
}

class DataNotFoundState extends State<DataNotFound> {
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
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          gradient: LinearGradient(
                              colors: [
                                // AppColours.blue,
                                // AppColours.orange

                                AppColours.blue,
                                AppColours.blue.withOpacity(0.8),
                                AppColours.orange.withOpacity(0.6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              stops: const [0.0, 0.6, 1.0]
                              // begin: FractionalOffset(0.0, 0.0),
                              // end: FractionalOffset(0.0, 1.0),
                              // stops: [0.0, 1.0],
                              // tileMode: TileMode.clamp
                          ),
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              left: 15,
                              right: 15,
                              bottom: 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.white30),

                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                              ),
                              Card(
                                color: Colors.white38,
                                shape: const RoundedRectangleBorder(
                                    // side:new  BorderSide(color: Colors.white38), //the outline color
                                    borderRadius:  BorderRadius.all(
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
                                    Icons.folder_off_rounded,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              const Text(
                                'Data Not Found',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              const Text(
                                'May go back and try \n different keyword? ',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
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
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Go Back?',
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
