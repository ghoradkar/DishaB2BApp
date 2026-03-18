import 'dart:convert';

import 'package:dishabtob/billing/filter_advance_report.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/app_colors.dart';
import '../global/custom_message.dart';
import '../network/network_aware.dart';
import '../network/network_status.dart';

class AdvanceUtilization extends StatefulWidget {
  final Map<String, dynamic>? data;
  final String? fromD;
  final String? toD;

  const AdvanceUtilization(this.data, {super.key, this.fromD, this.toD});

  @override
  AdvanceUtilizationState createState() => AdvanceUtilizationState();
}

class AdvanceUtilizationState extends State<AdvanceUtilization> {
  List IPD = [];
  bool load = false;
  TextEditingController fromD = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController toD = TextEditingController();
  FocusNode fto = FocusNode();
  FocusNode fpayable = FocusNode();
  TextEditingController payable = TextEditingController();
  Map<String, dynamic>? data;
  Map<String, dynamic>? decode;
  String? userPaymentType;
  List<dynamic>? consumption;
  double? advance;
  double? consume;
  double? remain;



  @override
  void initState() {
    setState(() {
      widget.data!.isEmpty || widget.data == null || widget.data == {}
          ? load = true
          : load = false;
    });
    debugPrint(widget.data.toString());
    getuser();

    // fetchPrepaid();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        initialData: NetworkStatus.Online,
        child: NetworkAwareWidget(
            onlineChild: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: [
                      Container(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [AppColours.blue, AppColours.orange],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.0, 1.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  width: 5,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Advance Utilization Report',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                          barrierColor:
                                              Colors.black.withOpacity(0.7),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.4),

                                          // context and builder are
                                          // required properties in this widget
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const FilterAdvance();
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.filter_alt,
                                      color: Colors.white,
                                    ))
                              ])),

                      Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          child: Container(
                              height: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: load
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: AppColours.blue,
                                    ))
                                  : Column(children: [

                                      Card(
                                        elevation: 3,
                                        shape: const RoundedRectangleBorder(

                                            // side:new  BorderSide(color: Color(0xFF2A8068)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
                                            //margin: EdgeInsets.only(top: 10),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  //SizedBox(height: 20,),

                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        //SizedBox(width: 10,),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Icon(
                                                                  Icons.money,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Icon(
                                                                  Icons.money,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Icon(
                                                                  Icons.money,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                              ]),
                                                        ),
                                                        //SizedBox(width: 10,),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              const Text(
                                                                'Fixed Advance',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                '${data!['fixedAdvance']
                                                                    .toString()} ₹',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              //SizedBox(height: 10,),

                                                              //SizedBox(width: 20,),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              const Text(
                                                                'Advance Amount',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                '${data!['lastAdvanceAmount']
                                                                    .toString()} ₹',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              const Text(
                                                                'Consumed Amount',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Row(children: [
                                                                Text(
                                                                  '${data!['consumedAmount']
                                                                      .toString()} ₹',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_downward,
                                                                  color: Colors
                                                                      .red,
                                                                )
                                                              ]),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // SizedBox(
                                                        //   width: MediaQuery.of(context).size.width * 0.01,
                                                        // ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 0,
                                                              top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.01),
                                                          child: Column(
                                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                                              //mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 35,
                                                                ),
                                                                Icon(
                                                                  Icons.money,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Icon(
                                                                  Icons.money,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ]),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 0,
                                                                top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.0),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 40,
                                                                  ),
                                                                  const Text(
                                                                    'Usable Amount',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Text(
                                                                    '${data!['usableAmount']
                                                                        .toString()} ₹',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const Text(
                                                                    'Remaining Amount',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Row(
                                                                      children: [
                                                                        Text(
                                                                          '${data!['remainAmount']
                                                                              .toString()} ₹',
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.green,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        const Icon(
                                                                          Icons
                                                                              .arrow_upward,
                                                                          color:
                                                                              Colors.green,
                                                                        )
                                                                      ]),
                                                                ]))
                                                      ])

                                                  //SizedBox(height: 20,),
                                                ])),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        elevation: 3,
                                        shape: const RoundedRectangleBorder(

                                            // side:new  BorderSide(color: Color(0xFF2A8068)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Container(
                                            height: MediaQuery.of(context).size.height *
                                                0.2,
                                            width: MediaQuery.of(context).size.width *
                                                0.95,
                                            //margin: EdgeInsets.only(top: 10),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  //SizedBox(height: 20,),

                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        //SizedBox(width: 10,),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Icon(
                                                                  Icons.money,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                              ]),
                                                        ),
                                                        //SizedBox(width: 10,),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              const Text(
                                                                'Total Patients',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                data!['totalPatient']
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              //SizedBox(height: 10,),

                                                              //SizedBox(width: 20,),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              const Text(
                                                                'Consumed Amount',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                data!['consumedAmount']
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              // SizedBox(
                                                              //   height: 5,
                                                              // ),
                                                              // Text(
                                                              //   'Consumed Amount',
                                                              //   style: TextStyle(
                                                              //       fontWeight: FontWeight.bold,
                                                              //       fontSize: 12),
                                                              // ),
                                                              // Row(children:[Text(
                                                              //   data!['consumedAmount'].toString(),
                                                              //   style: TextStyle(fontSize: 14,color: Colors.red,fontWeight: FontWeight.bold),
                                                              // ),
                                                              //   Icon(Icons.arrow_downward,color: Colors.red,)
                                                              // ]),
                                                              // SizedBox(
                                                              //   height: 5,
                                                              // ),
                                                            ],
                                                          ),
                                                        ),

                                                        // SizedBox(
                                                        //   width: MediaQuery.of(context).size.width * 0.01,
                                                        // ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 0,
                                                              top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.01),
                                                          child: Column(
                                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                                              //mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                // SizedBox(height: 35,),

                                                                Icon(
                                                                  Icons.science,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                              ]),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 0,
                                                                top: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.0),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  //SizedBox(height: 40,),
                                                                  const Text(
                                                                    'Total Tests',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Text(
                                                                    data!['totalTest']
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),

                                                                  // SizedBox(height: 10,),
                                                                  // Text(
                                                                  //   'Remaining Amount',
                                                                  //   style: TextStyle(
                                                                  //       fontWeight: FontWeight.bold,
                                                                  //       fontSize: 12),
                                                                  // ),
                                                                  // Row(children:[Text(
                                                                  //   data!['remainAmount'].toString(),
                                                                  //   style: TextStyle(fontSize: 14,color: Colors.green,fontWeight: FontWeight.bold),
                                                                  // ),
                                                                  //   Icon(Icons.arrow_upward,color: Colors.green,)
                                                                  // ]),
                                                                ]))
                                                      ]),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.32,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.042,
                                                          child: TextButton(
                                                              style:
                                                                  ButtonStyle(
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  // side: BorderSide(color: Colors.red)
                                                                )),
                                                                backgroundColor: MaterialStateProperty.all<
                                                                        Color>(
                                                                    AppColours
                                                                        .orange
                                                                        .withOpacity(
                                                                            0.9)),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // debugPrint(DateTime.now().month);
                                                                debugPrint(
                                                                    '${DateTime.now().year}-${DateTime.now().month}-01');

                                                                var t = DateTime
                                                                        .now()
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10);
                                                                if (widget
                                                                        .fromD !=
                                                                    null) {
                                                                  printDetailed(
                                                                      widget
                                                                          .fromD,
                                                                      widget
                                                                          .toD);
                                                                } else {
                                                                  printDetailed(
                                                                      '${DateTime.now().toString().substring(0, 8)}01',
                                                                      t);
                                                                }
                                                              },
                                                              child: const Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Detailed Print',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .download,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    )
                                                                  ]))),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),

                                                  //SizedBox(height: 20,),
                                                ])),
                                      ),
                                    ])))


                    ]))),
            offlineChild: Offline()));
  }

  printDetailed(from, to) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse('${url.baseurl}${url.ADVANCE_UTILIZATION_PDF}');
    debugPrint(uri.path);
    final body = {
      "callFrom": "other",
      "fromDate": from,
      "toDate": to,
      "customerType": decode!['customerType'],
      "customerId": decode!['customerId'],
      "unitId": decode!['unitMasterId']
    };
    final jsonbody = json.encode(body);
    debugPrint(jsonbody);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATE_RECEIPT}/18402/0');
    // debugPrint(uri);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);

    response.statusCode == 200
        ? {
      setState(() {
        List t = value['result'];
        Map<String, dynamic> report = t.first;
        launch(report['url']);
        load = false;
      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      widget.data!.isEmpty || widget.data == null || widget.data == {}
          ? fetchInvoiceList(decode, currentDate, currentDate)
          : setState(() {
        data = widget.data;
      });
    });
  }

  fetchInvoiceList(decode, fromdate, todate) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.ADVANCE_UTILIZATION}?callFrom=btnSearch&fromDate=$fromdate&toDate=$todate');
    debugPrint(uri.path);
    final body = {
      "customerType": decode!['customerType'],
      "customerId": decode!['customerId'],
      "unitId": decode!['unitMasterId']
    };
    var jsonbody = json.encode(body);
    debugPrint(jsonbody);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATE_RECEIPT}/18402/0');
    // debugPrint(uri);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody

      //encoding: encoding,
    );
    debugPrint(response.body);
    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(value);
    response.statusCode == 200
        ? {
      setState(() {
        data = value;
        load = false;
        // Navigator.pop(context);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => Generated_invoice(IPD)));
      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }

}
