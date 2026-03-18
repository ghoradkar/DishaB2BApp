import 'package:dishabtob/global/app_colors.dart';
import 'package:flutter/material.dart';

import 'network_status.dart';

class Offline extends StatelessWidget {
  NetworkStatusService ns =  NetworkStatusService();

  Offline({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                      gradient: LinearGradient(
                          colors: [AppColours.blue, AppColours.orange],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.0, 1.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: 15,
                          right: 15,
                          bottom: 20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white30),
                      //color: Colors.white,
                      // child:Card(
                      //   color: Colors.white,
                      //   child:
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
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
                                Icons.wifi_off_outlined,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Text(
                            'Oh No!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Center(
                              child: Text(
                            '                No Internet Found \n Check Your Connection or Try again. ',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.38,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // side: BorderSide(color: Colors.red)
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColours.orange),
                                ),
                                onPressed: () async {
                                  await ns.currentStatus();
                                },
                                child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Retry',
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
                    )))));
  }
}
