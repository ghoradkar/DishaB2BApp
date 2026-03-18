import 'dart:convert';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerReceiptDetails extends StatefulWidget {
  const CustomerReceiptDetails({super.key});

  @override
  State<CustomerReceiptDetails> createState() => CustomerReceiptDetailsState();
}

class CustomerReceiptDetailsState extends State<CustomerReceiptDetails> {
  bool load = false;

  var decode;

  var data;

  List<Map<String, dynamic>>? dataList;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
                                const Text(
                                  'Customer Receipt Payment\nDetails',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ])),
                      Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.018,
                          child: Container(
                              height: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 20, top: 10),
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
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: dataList?.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Card(
                                              margin: const EdgeInsets.only(
                                                  bottom: 20, top: 20),
                                              elevation: 3,
                                              color: const Color.fromRGBO(
                                                  237, 245, 250, 1),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10,
                                                    top: 10),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        237, 245, 250, 1),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200)),
                                                // height: MediaQuery.of(context)
                                                //         .size
                                                //         .height *
                                                //     0.28,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 4),
                                                        child: Image.asset(
                                                          "assets/hash.png",
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Receipt Id",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    "Nunito Sans"),
                                                          ),
                                                          Text(
                                                            dataList?[index][
                                                                        'billReceiptId'] !=
                                                                    null
                                                                ? dataList![index]
                                                                        [
                                                                        'billReceiptId']
                                                                    .toString()
                                                                : "-",
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    "Nunito Sans"),
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                          onPressed: () {
                                                            debugPrint(
                                                                'tapped');
                                                            dataList?[index][
                                                                        'billReceiptId'] !=
                                                                    null
                                                                ? printReport(
                                                                    dataList?[
                                                                            index]
                                                                        [
                                                                        'billReceiptId'])
                                                                : null;
                                                          },
                                                          icon: Icon(
                                                            Icons.save_alt,
                                                            color: AppColours
                                                                .orange,
                                                          )),
                                                    ]),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .perm_identity,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Amount",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['prepaidAmount'] !=
                                                                              null
                                                                          ? dataList![index]['prepaidAmount']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .perm_identity,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Discount",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['discPer'] !=
                                                                              null
                                                                          ? dataList![index]['discPer']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .perm_identity,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Paid",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['totalPaid'] !=
                                                                              null
                                                                          ? dataList![index]['totalPaid']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .perm_identity,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Remain",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['remainAmount'] !=
                                                                              null
                                                                          ? dataList![index]['remainAmount']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .perm_identity,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Pay Mode",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['payModeStr'] !=
                                                                              null
                                                                          ? dataList![index]['payModeStr']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .perm_identity,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Transaction ID",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['onlineTransactionId'] !=
                                                                              null
                                                                          ? dataList![index]['onlineTransactionId']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              4),
                                                                  child: Icon(
                                                                    Icons
                                                                        .calendar_month,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Voucher No",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['voucher'] !=
                                                                              null
                                                                          ? dataList![index]['voucher']
                                                                              .toString()
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              4),
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/hash.png",
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
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
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                    Text(
                                                                      dataList?[index]['createdDateTime'] !=
                                                                              null
                                                                          ? formatDate(
                                                                              dataList![index]['createdDateTime'].toString())
                                                                          : '',
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Nunito Sans"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  ],
                                                ),
                                              )),
                                        );
                                      })))
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
    fetchCustomerLedger(decode);

    setState(() {});
  }

  fetchCustomerLedger(decode) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.CUSTOMERRECEIPTPAYMENTDET}?callFrom=current');
    debugPrint(uri.path);
    var body;
    if (FlavorConfig.instance.name != "B2BLifenity") {
      body = {
        "customerType": int.parse(decode!['customerType']),
        "customerId": int.parse(decode!['customerId']),
        "unitId": int.parse(decode!['unitMasterId']),
        "createdBy": decode!['userId']
      };
    } else {
      body = {
        "customerId": int.parse(decode!['customerId']),
        "unitId": int.parse(decode!['unitMasterId']),
      };
    }

    final response =
        await ioClient.post(uri, headers: headers, body: jsonEncode(body));
    debugPrint(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      load = false;

      final List<dynamic> responseData = jsonDecode(response.body);

      // Cast to List<Map<String, dynamic>> if each item is a Map
      dataList = List<Map<String, dynamic>>.from(responseData);
    } else {
      load = false;
      CustomMessage.toast('Failed to load');
    }
    setState(() {});
  }

  Future<void> printReport(billReceiptId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMap = prefs.getString('user');

    if (encodedMap == null) {
      CustomMessage.toast('User not found');
      return;
    }

    var decode = json.decode(encodedMap);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.DOWNLOADCUSTOMERREPORT}?billReceiptId=$billReceiptId&unitId=${decode['unitMasterId']}&customerType=${decode['customerType']}&customerId=${decode['customerId']}');

    try {
      final response = await ioClient.post(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('result') &&
            responseBody['result'] is List &&
            responseBody['result'].isNotEmpty) {
          Map<String, dynamic> report = responseBody['result'].first;

          // await launchUrl(apiUrl);
          await launch(report['url']);
        } else {
          CustomMessage.toast('Unexpected response format.');
        }
      } else {
        CustomMessage.toast(
            'Failed to load report data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      CustomMessage.toast('An error occurred.');
    }
  }

  String formatDate(String dateTimeString) {
    // Parse the original date-time string
    DateTime dateTime = DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateTimeString);

    // Format it to only display the date
    String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);

    return formattedDate;
  }
}
