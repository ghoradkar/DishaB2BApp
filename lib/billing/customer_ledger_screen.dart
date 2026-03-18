import 'dart:convert';

import 'package:dishabtob/Billing/customer_receipt_details.dart';
import 'package:dishabtob/Billing/filter_customer_ledger.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/app_colors.dart';
import '../global/custom_message.dart';
import '../network/network_aware.dart';
import '../network/network_status.dart';

class CustomerLedgerScreen extends StatefulWidget {
  final List<dynamic>? data;
  final String? fromD;
  final String? toD;

  const CustomerLedgerScreen(this.data, {super.key, this.fromD, this.toD});

  @override
  CustomerLedgerScreenState createState() => CustomerLedgerScreenState();
}

class CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  List customerLedgerList = [];
  bool load = false;
  TextEditingController fromdate = TextEditingController();

  TextEditingController todate = TextEditingController();

  List<dynamic> data = [];
  Map<String, dynamic>? decode;
  double? advance;
  double? consume;
  double? remain;
  List<dynamic>? consumption;

  @override
  void initState() {
    getUser();
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
                body: load
                    ?  Center(
                        child: CircularProgressIndicator(
                        color: AppColours.blue,
                      ))
                    : SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(children: [
                          Container(
                              padding: const EdgeInsets.only(
                                bottom: 6,
                              ),
                              decoration:  BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      AppColours.blue,
                                      AppColours.blue,
                                      AppColours.orange.withOpacity(0.8)
                                    ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                    stops: const [0.0, 0.6, 1.0]

                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Column(
                                children: [
                                  data.isNotEmpty
                                      ? const SizedBox(
                                          height: 30,
                                        )
                                      : const SizedBox(
                                          height: 50,
                                        ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
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
                                        const Text(
                                          'Customer Ledger Details',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.7),
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.4),
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const FilterCustomerLedger();
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.filter_alt,
                                              color: Colors.white,
                                            ))
                                      ]),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  data.isNotEmpty
                                      ? const SizedBox(
                                          height: 4,
                                        )
                                      : const SizedBox.shrink(),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      //margin: EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          border:
                                              Border.all(color: Colors.white60),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Name : ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,fontFamily: "Nunito Sans"),
                                            ),
                                            Text(
                                              decode?['userAccesBeanList']
                                                          ['customerName'] !=
                                                      null
                                                  ? decode!['userAccesBeanList']
                                                      ['customerName']
                                                  : "",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,fontFamily: "Nunito Sans"),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Type : ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,fontFamily: "Nunito Sans"),
                                            ),
                                            Text(
                                              decode?['userAccesBeanList'][
                                                          'customerTypeName'] !=
                                                      null
                                                  ? decode!['userAccesBeanList']
                                                      ['customerTypeName']
                                                  : "",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,fontFamily: "Nunito Sans"),
                                            ),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                  "assets/advanced.png"),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$advance ₹",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,fontFamily: "Nunito Sans"),
                                                  ),
                                                  const Text(
                                                    "Advance Amount",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,fontFamily: "Nunito Sans"),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: const BorderSide(color: Colors.white)
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          AppColours.orange
                                                              .withOpacity(
                                                                  0.9)),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CustomerReceiptDetails()),
                                                  );
                                                },
                                                child: const Text(
                                                  'Receipt Payment Details',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 10,fontFamily: "Nunito Sans"),
                                                ),
                                              )
                                            ]),
                                        Row(children: [
                                          Image.asset("assets/consumed.png"),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "$consume ₹",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,fontFamily: "Nunito Sans"),
                                              ),
                                              const Text(
                                                "Consumed Amount",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,fontFamily: "Nunito Sans"),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Image.asset("assets/remaining.png"),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "$remain ₹",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,fontFamily: "Nunito Sans"),
                                              ),
                                              const Text(
                                                "Remaining Amount ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,fontFamily: "Nunito Sans"),
                                              )
                                            ],
                                          ),
                                        ])
                                      ]))
                                ],
                              )),
                          data.isNotEmpty
                              ? Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.04,

                                  child: Container(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height -
                                          MediaQuery.of(context).size.height *
                                              0.38,
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                                margin: const EdgeInsets.only(
                                                    bottom: 6, top: 20),
                                                elevation: 3,
                                                color: const Color.fromRGBO(
                                                    237, 245, 250, 1),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5,
                                                          left: 20,
                                                          right: 20,
                                                          top: 0),
                                                  decoration: BoxDecoration(
                                                      color: const Color
                                                          .fromRGBO(
                                                          237, 245, 250, 1),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .shade200)),
                                                  height:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.28,
                                                  width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: Column(
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Row(children: [
                                                          const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Date",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                data[index]
                                                                    ['date'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14,fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Image.asset(
                                                            "assets/hash.png",
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Patient ID",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                        'patientId']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Row(children: [
                                                          const Icon(
                                                            Icons.perm_identity,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Patient Name",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                    'patientName'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Row(children: [
                                                          const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  "Test Name",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10,fontFamily: "Nunito Sans"),
                                                                ),
                                                                Text(
                                                                  data[index][
                                                                      'testName'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          10,fontFamily: "Nunito Sans"),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Row(children: [
                                                          const Icon(
                                                            Icons.money,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Opening Balance",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                        'openingBal']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Row(children: [
                                                          const Icon(
                                                            Icons.money,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Transaction Amount",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                        'amount']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          const Icon(
                                                            Icons.money,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "Closing Amount ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                        'closingBal']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          })))
                              : Positioned(
                                  bottom: 2,
                                  child: SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height -
                                          MediaQuery.of(context).size.height *
                                              0.38,
                                      width: MediaQuery.of(context).size.width,
                                      child: const DataNotFound()))
                        ]))),
            offlineChild: Offline()));
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    fetchAmountCount(decode);

    if (widget.data!.isNotEmpty) {
      data = widget.data ?? [];
    } else {
      await fetchCustomerLedger(
          decode,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
    }

    setState(() {});
  }

  fetchCustomerLedger(decode, fromdate, todate) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.CUSTOMERLEDGERLIST}?customerId=${decode['customerId']}&openingBalance=0&fromDate=$fromdate&toDate=$todate');
    debugPrint(uri.path);

    final response = await ioClient.post(uri, headers: headers, body: null);
    debugPrint(response.body);
    Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      data = value['listCustomerLedgerDetailsDto'];
      load = false;
    } else {
      load = false;
      CustomMessage.toast('Failed to load');
    }
    setState(() {});
  }

  fetchAmountCount(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.CONSUMPTIONAVAILABLEAMT}?userType=${decode!['userType']}&callFrom=&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}');
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

    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      consumption = value['lstPrepaidCustomerDto'];
      Map<String, dynamic> t = consumption!.first;

      advance = t['availableAmount'];

      consume = t['billConsumeAmount'];
      remain = t['billRemainAmount'];

      setState(() {});
    } else {
      CustomMessage.toast("something went wrong");
    }
  }
}
