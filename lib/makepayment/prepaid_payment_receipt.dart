import 'dart:convert';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/makepayment/billing_table.dart';
import 'package:dishabtob/makepayment/prepaid.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PrepaidPaymentReceipt extends StatefulWidget {
  final String decryptedKeyIdRazorPay;
  final String decryptedKeySecretRazorPay;

  const PrepaidPaymentReceipt(
      {super.key,
      required this.decryptedKeyIdRazorPay,
      required this.decryptedKeySecretRazorPay});

  @override
  PrepaidPaymentReceiptState createState() => PrepaidPaymentReceiptState();
}

class PrepaidPaymentReceiptState extends State<PrepaidPaymentReceipt>
    with SingleTickerProviderStateMixin {
  // List<dynamic> IPD = [];
  bool load = false;
  TabController? controller;
  List<Map<String, dynamic>>? currentCycleList;
  List<Map<String, dynamic>>? previousCycleList;

  // Map<String, dynamic>? decode;
  final mediaStorePlugin = MediaStore();
  TextEditingController firstNameOrIdController = TextEditingController();
  String? title;
  List<String> item = ["Patient Id", "Patient Name"];
  var paymentStat;

  // final PagingController<int, dynamic> pagingController;
  static const pageSize = 10;
  int? currentIndex;

  String? selectedMode;
  String? fromDate;
  String? toDate;
  String? firstNameOrId;
  var decode;
  List<dynamic>? consumption;
  double? consume;
  double? remain;
  String? userPaymentType;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    controller?.addListener(() {
      currentIndex = controller?.index;
      setState(() {});
    });

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                //  SizedBox(width: 5,),
                                const Text(
                                  'Prepaid Payment Receipts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Prepaid(
                                                decryptedKeyIdRazorPay: widget
                                                    .decryptedKeyIdRazorPay,
                                                decryptedKeySecretRazorPay: widget
                                                    .decryptedKeySecretRazorPay,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 9),
                                    decoration: BoxDecoration(
                                        color: AppColours.orange,
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Pay Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.currency_rupee,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                              ])),
                      Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          child: Container(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // Background color
                                  borderRadius: BorderRadius.circular(16),
                                  // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      // Shadow color with opacity
                                      spreadRadius: 2,
                                      // Spread radius
                                      blurRadius: 3,
                                      // Blur radius
                                      offset: const Offset(
                                          0, 3), // Offset in x and y direction
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Business Type :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                              decode?['userAccesBeanList']
                                                          ['customerName'] !=
                                                      null
                                                  ? decode!['userAccesBeanList']
                                                      ['customerName']
                                                  : ""),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Customer Name :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(decode?[
                                                          'userAccesBeanList']
                                                      ['customerTypeName'] !=
                                                  null
                                              ? decode!['userAccesBeanList']
                                                  ['customerTypeName']
                                              : ""),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Consumed Amount ; ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          consume == null
                                              ? '0'
                                              : consume.toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Remaining Amount : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          remain == null
                                              ? '0'
                                              : remain.toString(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    border: Border.all(color: Colors.grey)),
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                // width: MediaQuery.of(context).size.width * 0.98,
                                child: TabBar(
                                  indicatorPadding: const EdgeInsets.all(0),
                                  labelPadding: const EdgeInsets.all(0),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  //dividerColor: Colors.red,
                                  labelColor: Colors.white,
                                  controller: controller,
                                  unselectedLabelColor: Colors.black54,
                                  indicator: BoxDecoration(
                                      color: AppColours.blue,
                                      borderRadius: BorderRadius.only(
                                          topLeft: controller?.index == 0
                                              ? const Radius.circular(30)
                                              : const Radius.circular(0),
                                          bottomLeft: controller?.index == 0
                                              ? const Radius.circular(30)
                                              : const Radius.circular(0),
                                          bottomRight: controller?.index == 0
                                              ? const Radius.circular(0)
                                              : const Radius.circular(30),
                                          topRight: controller?.index == 0
                                              ? const Radius.circular(0)
                                              : const Radius.circular(30))),
                                  // indicatorColor: Colors.blue,
                                  tabs: const [
                                    Tab(child: Text('Current Cycle Receipts')),
                                    Tab(child: Text('Previous Cycle Receipts')),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller,
                                  children: [
                                    load
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColours.blue,
                                            ),
                                          )
                                        : BillingTable(
                                            l1: List.generate(
                                                currentCycleList
                                                        ?.reversed.length ??
                                                    0,
                                                (index) =>
                                                    (index + 1).toString()),
                                            l2: currentCycleList?.reversed
                                                    .toList()
                                                    .map((item) =>
                                                        item['billReceiptId'] !=
                                                                null
                                                            ? item['billReceiptId']
                                                                .toString()
                                                            : '-')
                                                    .toList() ??
                                                [],
                                            l3: currentCycleList?.reversed
                                                    .toList()
                                                    .map((item) =>
                                                        item['totalPaid']
                                                            .toString())
                                                    .toList() ??
                                                [],
                                            l4: currentCycleList?.reversed
                                                    .toList()
                                                    .map((item) =>
                                                        item['payModeStr'] ??
                                                        '-')
                                                    .toList() ??
                                                [],
                                            l5: currentCycleList?.reversed
                                                    .toList()
                                                    .map((item) =>
                                                        item[
                                                            'createdDateTime'] ??
                                                        '-')
                                                    .toList() ??
                                                [],
                                            tableHeader: const [
                                              "Sr. No",
                                              "Receipt ID",
                                              "Amount Paid",
                                              "Pay Mode",
                                              "Date\n",
                                              "Action\n"
                                            ],
                                            onButtonPressed: (index) async {
                                              print(
                                                  'Button pressed in row ${index + 1}');

                                              await printReport(currentCycleList
                                                      ?.reversed
                                                      .toList()[index]
                                                  ['billReceiptId']);
                                            },
                                          ),
                                    // : SmartReport(context),
                                    load
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColours.blue,
                                            ),
                                          )
                                        : BillingTable(
                                            l1: List.generate(
                                                previousCycleList?.length ?? 0,
                                                (index) =>
                                                    (index + 1).toString()),
                                            l2: previousCycleList
                                                    ?.map((item) =>
                                                        item['billReceiptId'] !=
                                                                null
                                                            ? item['billReceiptId']
                                                                .toString()
                                                            : '-')
                                                    .toList() ??
                                                [],
                                            l3: previousCycleList
                                                    ?.map((item) => item[
                                                                'postpaidAmount'] !=
                                                            null
                                                        ? item['postpaidAmount']
                                                            .toString()
                                                        : '-')
                                                    .toList() ??
                                                [],
                                            l4: previousCycleList
                                                    ?.map((item) =>
                                                        item['payModeStr'] ??
                                                        '-')
                                                    .toList() ??
                                                [],
                                            l5: previousCycleList
                                                    ?.map((item) =>
                                                        item[
                                                            'createdDateTime'] ??
                                                        '-')
                                                    .toList() ??
                                                [],
                                            tableHeader: const [
                                              "Sr. No",
                                              "Receipt ID",
                                              "Amount Paid",
                                              "Pay Mode",
                                              "Date\n",
                                              "Action\n"
                                            ],
                                            onButtonPressed: (index) async {
                                              print(
                                                  'Button pressed in row ${index + 1}');

                                              await printReport(currentCycleList
                                                      ?.reversed
                                                      .toList()[index]
                                                  ['billReceiptId']);
                                            },
                                          )
                                  ],
                                ),
                              ),
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  handleButtonPress(int index) {
    // Perform action based on the index
    if (index == 0) {
      debugPrint('Button pressed at index: $index');
    } else if (index == 1) {
      debugPrint('Button pressed at index: $index');
    }
  }

  fetchConsumption(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.CONSUMPTION}?customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&unitId=${decode!['unitMasterId']}');
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
      userPaymentType = value['lstPrePostConsumtionDto'][0]['paymentFlag'];
      if (userPaymentType == "prepaid") {
        await fetchAmountCount(decode);
      } else {
        consumption = value['lstPrePostConsumtionDto'];
        Map<String, dynamic> t = consumption!.first;
        consume = t['billConsumeAmount'];
        remain = t['billRemainAmount'];
      }

      setState(() {});
    } else {
      CustomMessage.toast("someting went wrong");
    }
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

      consume = t['billConsumeAmount'];
      remain = t['billRemainAmount'];

      setState(() {});
    } else {
      CustomMessage.toast("someting went wrong");
    }
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    await fetchCurrentCycle(decode);
    await fetchPreviousCycle(decode);
    await fetchConsumption(decode);
  }

  fetchCurrentCycle(decode) async {
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
    var body = {
      "customerType": int.parse(decode!['customerType']),
      "customerId": int.parse(decode!['customerId']),
      "unitId": int.parse(decode!['unitMasterId']),
      "createdBy": decode!['userId']
    };

    final response =
        await ioClient.post(uri, headers: headers, body: jsonEncode(body));
    debugPrint(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      load = false;

      final List<dynamic> responseData = jsonDecode(response.body);

      // Cast to List<Map<String, dynamic>> if each item is a Map
      currentCycleList = List<Map<String, dynamic>>.from(responseData);
    } else {
      load = false;
      CustomMessage.toast('Failed to load');
    }
    setState(() {});
  }

  fetchPreviousCycle(decode) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.CUSTOMERRECEIPTPAYMENTDET}?callFrom=previous');
    debugPrint(uri.path);
    var body = {
      "customerType": int.parse(decode!['customerType']),
      "customerId": int.parse(decode!['customerId']),
      "unitId": int.parse(decode!['unitMasterId']),
      "createdBy": decode!['userId']
    };

    final response =
        await ioClient.post(uri, headers: headers, body: jsonEncode(body));
    debugPrint(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      load = false;

      final List<dynamic> responseData = jsonDecode(response.body);

      // Cast to List<Map<String, dynamic>> if each item is a Map
      previousCycleList = List<Map<String, dynamic>>.from(responseData);
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
}
