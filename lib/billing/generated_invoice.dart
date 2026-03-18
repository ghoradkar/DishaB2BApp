import 'dart:convert';
import 'package:dishabtob/billing/filter_postpaid.dart';
import 'package:dishabtob/billing/generated_invoice_textfield.dart';
import 'package:dishabtob/billing/model/generated_invoice_list.dart';
import 'package:dishabtob/billing/model/generated_invoice_model.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/makepayment/model/order_detail_resp_model.dart';
import 'package:dishabtob/makepayment/model/strip_payment_resp.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneratedInvoice extends StatefulWidget {
  final List<GeneratedInvoiceList>? generatedInvoiceListFromFilter;
  final String decryptedKeyIdRazorPay;
  final String decryptedKeySecretRazorPay;

  const GeneratedInvoice(this.generatedInvoiceListFromFilter,
      {super.key,
      required this.decryptedKeyIdRazorPay,
      required this.decryptedKeySecretRazorPay});

  @override
  GeneratedInvoiceState createState() => GeneratedInvoiceState();
}

class GeneratedInvoiceState extends State<GeneratedInvoice> {
  List<GeneratedInvoiceList> generatedInvoiceList = [];
  bool load = false;
  Map<String, dynamic>? decode;
  double selectedAmountSum = 0.0;
  String? unitcode;
  Razorpay? _razorpay;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? unitName;
  OrderDetailRespModel? orderDetailRespModel;
  List<PaymentDetailsModel> slectedData = [];
  List<TextEditingController> controllers = [];
  var mobile;
  List<GeneratedInvoiceList> invoiceList = [];
  var email;

  StripPaymentResp? stripPaymentResp;

  @override
  void initState() {
    if (widget.generatedInvoiceListFromFilter != null) {
      invoiceList = List<GeneratedInvoiceList>.from(
          widget.generatedInvoiceListFromFilter!);
    }
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getuser();
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  'Generated Invoice',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                          barrierColor: Colors.black
                                              .withValues(alpha: 0.7),
                                          backgroundColor: Colors.grey
                                              .withValues(alpha: 0.4),

                                          // context and builder are
                                          // required properties in this widget
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FilterPostpaid(
                                              decryptedKeyIdRazorPay:
                                                  widget.decryptedKeyIdRazorPay,
                                              decryptedKeySecretRazorPay: widget
                                                  .decryptedKeySecretRazorPay,
                                            );
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
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Form(
                              key: formKey,
                              child: Column(children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 6, 0, 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // Background color
                                    borderRadius: BorderRadius.circular(16),
                                    // Rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.4),
                                        // Shadow color with opacity
                                        spreadRadius: 2,
                                        // Spread radius
                                        blurRadius: 3,
                                        // Blur radius
                                        offset: const Offset(0,
                                            3), // Offset in x and y direction
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
                                            child: Text(decode?[
                                                            'userAccesBeanList']
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
                                          Text(decode?['userAccesBeanList']
                                                      ['customerTypeName'] !=
                                                  null
                                              ? decode!['userAccesBeanList']
                                                  ['customerTypeName']
                                              : ""),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: load
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColours.blue,
                                            ),
                                          )
                                        : generatedInvoiceList.isEmpty &&
                                                invoiceList.isEmpty
                                            ? const DataNotFound()
                                            :
                                            // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                                            invoiceList.isEmpty
                                                ? generatedInvoiceCard(context,
                                                    generatedInvoiceList)
                                                : generatedInvoiceCard(
                                                    context, invoiceList)),

                                ///dont remove
                                // Row(children: [
                                //   const Icon(Icons.money),
                                //   const SizedBox(
                                //     width: 4,
                                //   ),
                                //   const Text(
                                //     'Total Amount:',
                                //     style:
                                //         TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                //   Text(
                                //     // selectedAmountSum.toString(),
                                //     selectedAmountSum.toStringAsFixed(2),
                                //     style: const TextStyle(
                                //         color: Colors.green,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                //   const SizedBox(
                                //     width: 8,
                                //   ),
                                //   const Spacer(),
                                //
                                //   Container(
                                //       padding: const EdgeInsets.all(5),
                                //       decoration: BoxDecoration(
                                //           gradient: LinearGradient(
                                //               colors: [
                                //                 AppColours.orange,
                                //                 AppColours.blue
                                //               ],
                                //               begin: const FractionalOffset(
                                //                   1.0, 0.0),
                                //               end: const FractionalOffset(
                                //                   0.0, 0.0),
                                //               stops: const [0.0, 1.0],
                                //               tileMode: TileMode.clamp),
                                //           borderRadius: const BorderRadius.all(
                                //               Radius.circular(15))),
                                //       width: MediaQuery.of(context).size.width *
                                //           0.28,
                                //       height:
                                //           MediaQuery.of(context).size.height *
                                //               0.045,
                                //       child: TextButton(
                                //         style: ButtonStyle(
                                //           shape: WidgetStateProperty.all<
                                //                   RoundedRectangleBorder>(
                                //               RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(20.0),
                                //             // side: BorderSide(color: Colors.red)
                                //           )),
                                //         ),
                                //         onPressed: () async {
                                //           if (formKey.currentState!
                                //               .validate()) {
                                //             // if (selectedCards
                                //             //     .any((item) => item)) {
                                //             if (FlavorConfig.instance.name ==
                                //                     'B2BMobileBeta' ||
                                //                 FlavorConfig.instance.name ==
                                //                     'B2BMobile' ||
                                //                 FlavorConfig.instance.name ==
                                //                     "B2BLifenity") {
                                //               createOrder(selectedAmountSum);
                                //             } else {
                                //               createPaymentIntentStrip(
                                //                   selectedAmountSum.toInt(),
                                //                   "AED");
                                //             }
                                //             // }
                                //             // else {
                                //             //   CustomMessage.toast(
                                //             //       "Please select at least one checkbox");
                                //             // }
                                //           }
                                //         },
                                //         child: const Row(
                                //             // crossAxisAlignment: CrossAxisAlignment.end,
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               Text(
                                //                 'Pay Now',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.bold,
                                //                     color: Colors.white,
                                //                     fontSize: 10),
                                //               ),
                                //               Icon(
                                //                 Icons.currency_rupee,
                                //                 color: Colors.white,
                                //                 size: 15,
                                //               )
                                //             ]),
                                //       )),
                                // ])
                                //
                              ]),
                            ),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  generatedInvoiceCard(
      BuildContext context, List<GeneratedInvoiceList>? generatedInvoiceList) {
    return ListView.builder(
      itemCount: generatedInvoiceList?.length,
      padding: const EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        GeneratedInvoiceList? g = generatedInvoiceList?[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: g?.status == "paid"
                  ? const Color(0xffE2FFDF).withValues(alpha: 0.6)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Checkbox for unpaid status
                // if (g['status'] != "paid")
                //   Align(
                //     alignment: Alignment.centerRight,
                //     child: Checkbox(
                //       activeColor: AppColours.orange,
                //       value: selectedCards[index],
                //       onChanged: (value) {
                //         setState(() {
                //           selectedCards[index] = value!;
                //         });
                //         updateSelectedAmountSum();
                //       },
                //     ),
                //   ),

                Row(
                  children: [
                    Expanded(
                      child: _buildInvoiceRow(
                        icon: Icons.tag,
                        title: 'Invoice Id',
                        value: g?.invoiceId.toString() ?? '',
                      ),
                    ),
                    Expanded(
                      child: _buildInvoiceRow(
                        icon: Icons.calendar_month,
                        title: 'Generated Date',
                        value: g?.fromDate.toString() ?? "",
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildInvoiceRow(
                        icon: Icons.calendar_month,
                        title: 'Invoice From Date',
                        value: g?.fromDate.toString() ?? "",
                      ),
                    ),
                    Expanded(
                      child: _buildInvoiceRow(
                        icon: Icons.calendar_month,
                        title: 'Invoice To Date',
                        value: g?.toDate.toString() ?? "",
                      ),
                    ),
                  ],
                ),

                //Amount
                Row(
                  children: [
                    Expanded(
                      child: _buildInvoiceRow(
                        icon: Icons.money,
                        title: 'Bill Amount',
                        value: g?.totalAmount.toString() ?? '',
                      ),
                    ),
                    Expanded(
                      child: _buildInvoiceRow(
                        icon: Icons.calendar_month,
                        title: 'Remaining Amount',
                        value: g?.totalRemain.toString() ?? "",
                      ),
                    ),
                  ],
                ),

                Visibility(
                  visible: g?.status != "paid",
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GeneratedInvoiceTextfield(
                      controller: controllers[index],
                      totalRemain: g?.totalAmount ?? 0.0,
                      onChanged: (String value) {
                        try {
                          g?.totalRemain = g.totalAmount - double.parse(value);
                          g?.controllerValue = double.parse(value);
                        } catch (e) {
                          g?.totalRemain = g.totalAmount;
                          g?.controllerValue = 0.0;

                          debugPrint("Enter valid num $e");
                        }

                        updateTotalAmount();
                      },
                      readOnly: true, //for now we set this to true
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (g?.status == "paid")
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColours.txt_green),
                          child: const Text(
                            'Paid',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      _buildActionButton(
                        text: "Summary Print",
                        onTap: () => summaryReport(g?.invoiceId),
                      ),
                      _buildActionButton(
                        text: "Detailed Print",
                        onTap: () => detailReport(g?.invoiceId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper Widgets
  Widget _buildInvoiceRow({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Nunito Sans'),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 12, fontFamily: 'Nunito Sans'),
              ),
            ],
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing,
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: FlavorConfig.instance.name == "DubaiB2B"
                ? [AppColours.blue, AppColours.orange]
                : [AppColours.orange, AppColours.orange],
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.file_download_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      unitcode = prefs.getString("UnitCode");
      unitName = prefs.getString("Unitname");

      debugPrint('hjghh$decode');

      if (invoiceList.isEmpty) {
        fetchInvoiceList(DateTime.now().toString().substring(0, 10),
            DateTime.now().toString().substring(0, 10));
      } else {
        // selectedCards = List.generate(
        //     widget.invoiceList!.length, (index) => false);

        controllers = List.generate(
            invoiceList.length,
            (index) => TextEditingController(
                text: invoiceList[index].totalRemain.toString()));

        selectedAmountSum = invoiceList.fold(
            0.0, (sum, invoice) => sum + (invoice.totalRemain));
        // selectedAmountSum = 0.0;
      }
    });
  }

  void updateTotalAmount() {
    setState(() {
      // Calculate sum from text field values
      selectedAmountSum = controllers.fold(0.0, (sum, controller) {
        if (controller.text.isNotEmpty) {
          return sum + (double.tryParse(controller.text) ?? 0.0);
        }
        return sum;
      });
    });
  }

  String decryptAES(String encryptedValue, encryption.Key key) {
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final decrypted =
        encrypter.decrypt64(encryptedValue, iv: IV.fromLength(16));
    return decrypted;
  }

  detailReport(invoiceId) async {
    load = true;

    setState(() {});
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.DETAILED_Print}?invoiceId=$invoiceId&unitId=${decode!["unitMasterId"]}&unitCode=$unitcode&uName=${decode!["userName"]}&uId=${decode!["userId"]}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
    );

    Map<String, dynamic> value = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List t = value['result'];
      Map<String, dynamic> report = t.first;
      launchUrl(Uri.parse(report['url']));

      load = false;
      setState(() {});
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Failed to load');
    }
  }

  summaryReport(invoiceId) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.SUMMARY_Print}?invoiceId=$invoiceId&unitId=${decode!["unitMasterId"]}&uName=${decode!["userName"]}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
    );

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      load = false;

      List t = value['result'];
      Map<String, dynamic> report = t.first;
      launchUrl(Uri.parse(report['url']));

      setState(() {});
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Failed to load');
    }
  }

  fetchInvoiceList(fromdate, todate) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.GENERATED_INVOICE}?unitId=${decode!['unitMasterId']}&userFromDate=$fromdate&userToDate=$todate&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&startIndex=0&userType=${decode!['userType']}');
    debugPrint(uri.path);

    final response = await ioClient.get(
      uri,
      headers: headers,
    );

    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);

      GeneratedInvoiceList data = GeneratedInvoiceList.fromJson(value);
      generatedInvoiceList = data.lstbusinesscustomerinvoice ?? [];
      load = false;
      setState(() {});
      if (generatedInvoiceList.isNotEmpty) {
        controllers = List.generate(
            generatedInvoiceList.length,
            (index) => TextEditingController(
                text: generatedInvoiceList[index].totalRemain.toString()));
        // selectedCards =
        //     List.generate(generatedInvoiceList.length, (index) => false);
        selectedAmountSum = generatedInvoiceList.fold(
            0.0, (sum, invoice) => sum + (invoice.totalRemain));

        // selectedAmountSum = 0.0;
      }
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  Future<void> createOrder(double amount) async {
    // Correct Authorization
    // String auth = 'Basic ' + base64Encode(utf8.encode('$keyId:$secritKey'));

    String auth =
        'Basic ${base64Encode(utf8.encode('${widget.decryptedKeyIdRazorPay}:${widget.decryptedKeySecretRazorPay}'))}';

    // Headers
    var headers = {'Content-Type': 'application/json', 'Authorization': auth};

    // Body (Ensure `amount` is converted to paise)
    var requestBody = jsonEncode({
      "amount": (amount * 100).toInt(),
      "currency": "INR",
      "receipt": "order_rcptid_${DateTime.now().millisecondsSinceEpoch}",
      "payment_capture": 1
    });

    // Sending Request (Use `http.post()` Instead of `http.Request()`)
    var response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/orders'),
      headers: headers,
      body: requestBody,
    );

    // Handling Response
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      print("Order Created Successfully: ${data["id"]}");
      // print(await response.stream.bytesToString());
      // var data = jsonEncode(response.stream.bytesToString());
      orderDetailRespModel = OrderDetailRespModel.fromJson(data);
      openCheckout(amount, orderDetailRespModel!.id!);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  }

  void openCheckout(double amount, String orderId) {
    var options = {
      'key': widget.decryptedKeyIdRazorPay,
      'amount': (amount * 100).toInt(),
      // Amount in smallest currency unit (e.g., 100 INR = 10000 paise)
      'name': unitName,
      'description': decode!['userAccesBeanList']['customerName'],
      'order_id': orderId,
      'prefill': {
        'contact': mobile,
        'email': email,
      },
      'config': {
        'display': {
          'hide': [
            {'method': 'paylater'},
            {'method': 'emi'}
          ],
          'preferences': {'show_default_blocks': true}
        }
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  savePaymentDetailsToBacked(String payment_id, String order_id,
      String? signature, String masterBulkId) async {
    load = true;
    setState(() {});
    String selectedItemsString = '';

    if (generatedInvoiceList.isNotEmpty) {
      selectedItemsString = [
        for (int i = 0; i < generatedInvoiceList.length; i++)
          if (generatedInvoiceList[i].status != "paid")
            generatedInvoiceList[i].invoiceId
      ].join(',');
    } else {
      selectedItemsString = [
        for (int i = 0; i < invoiceList.length; i++)
          if (invoiceList[i].status != "paid") invoiceList[i].invoiceId
      ].join(',');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);
    var uri;
    if (FlavorConfig.instance.name != "B2BLifenity") {
      uri = Uri.parse(
          '${url.baseurl}${url.SAVEPAYMENTDATA}?payment_id=$payment_id&order_id=$order_id&amount=${(selectedAmountSum.toInt()).toString()}&customer_name=$unitName&signature=$signature&invoiceid=$selectedItemsString&customerId=${decode!['customerId']}');
    } else {
      uri = Uri.parse(
          '${url.baseurl}${url.SAVEPAYMENTDATA}?paymentId=$payment_id&orderId=$order_id&amount=${(selectedAmountSum.toInt()).toString()}&customerName=$unitName&signature=$signature&receiptId=$masterBulkId&customerId=${decode!['customerId']}');
    }

    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      load = false;
      setState(() {});
      slectedData.clear();
      invoiceList.clear();
      generatedInvoiceList.clear();
      CustomMessage.toast(value['message']);
      await fetchInvoiceList(DateTime.now().toString().substring(0, 10),
          DateTime.now().toString().substring(0, 10));
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(value['message']);
    }
    ;
  }

  generatebuilMasterId(
      String payment_id, String order_id, String? signature) async {
    load = true;
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (generatedInvoiceList.isNotEmpty) {
      for (int i = 0; i < generatedInvoiceList.length; i++) {
        if (generatedInvoiceList[i].status != "paid") {
          slectedData.add(
            PaymentDetailsModel(
                invoiceId: generatedInvoiceList[i].invoiceId.toString(),
                customerType: int.parse(decode?['customerType']),
                customerId: int.parse(decode?['customerId']),
                unitId: generatedInvoiceList[i].unitId,
                payMode: '15',
                paidAmt: generatedInvoiceList[i].controllerValue.toString(),
                createdBy: decode!['userId'].toString()),
          );
        }
        print(slectedData);
      }
    } else {
      for (int i = 0; i < invoiceList.length; i++) {
        if (invoiceList[i].status == "paid") {
          slectedData.add(
            PaymentDetailsModel(
                invoiceId: invoiceList[i].invoiceId.toString(),
                customerType: int.parse(decode?['customerType']),
                customerId: int.parse(decode?['customerId']),
                unitId: invoiceList[i].unitId,
                payMode: '15',
                paidAmt: invoiceList[i].controllerValue.toString(),
                createdBy: decode!['userId'].toString()),
          );
        }
      }
      print(slectedData);
    }

    var body = {
      "customerType": decode!['customerType'],
      "customerId": decode!['customerId'],
      "unitId": decode!['unitMasterId'],
      "createdBy": decode!['userId'].toString(),
      "payMode": "15",
      "unitCode": prefs.getString("UnitCode"),
      "listBulkSettlementSlave": slectedData
    };

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.GENERATEMASTERBULKID}');

    debugPrint(jsonEncode(body));
    debugPrint(uri.path);

    final response =
        await ioClient.post(uri, headers: headers, body: jsonEncode(body)
            //encoding: encoding,
            );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      load = false;
      setState(() {});
      CustomMessage.toast(value['message']);
      await savePaymentDetailsToBacked(
          payment_id, order_id, signature, value['bulk_master_id'].toString());
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(value['message']);
    }
  }

  fetchClientDetails() async {
    load = true;
    setState(() {});
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.GETEMAILANDMOBILE}?id=${decode!['customerId']}');
    debugPrint(uri.path);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    response.statusCode == 200
        ? {
            setState(() {
              mobile = value['businessMasterGeneralInfoDto'][0]['mobile'];
              email = value['businessMasterGeneralInfoDto'][0]['mail'];
              // countryId = businessMasterGeneralInfoDto[0]['countryId'];
              load = false;
              //debugPrint(IPD!.first);
            }),
          }
        : {
            load = false,
            setState(() {}),
            CustomMessage.toast('Failed to load')
          };
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await generatebuilMasterId(response.orderId.toString(),
        response.paymentId.toString(), response.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Failed: ${response.code} - ${response.message}',
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  createPaymentIntentStrip(int amount, String currency) async {
    // 'Basic ${base64Encode(utf8.encode('${decryptedKeyIdRazorPay}:${decryptedKeySecretRazorPay}'))}';

    String auth =
        'Basic ${base64Encode(utf8.encode(widget.decryptedKeySecretRazorPay))}';

    // Headers
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': auth
    };

    // Body (Ensure `amount` is converted to paise)
    var requestBody = {
      "amount": (amount * 100).toString(),
      "currency": currency,
      "automatic_payment_methods[enabled]": "true",
    };

    // Sending Request (Use `http.post()` Instead of `http.Request()`)
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: headers,
      body: requestBody,
    );

    // Handling Response
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      stripPaymentResp = StripPaymentResp.fromJson(data);
      // stripe.PaymentSheetPaymentOption? resp =
      await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
              customFlow: true,
              allowsDelayedPaymentMethods: true,
              paymentIntentClientSecret: stripPaymentResp?.clientSecret,
              merchantDisplayName: unitName,
              customerId: stripPaymentResp?.id,
              billingDetails: stripe.BillingDetails(
                  email: email,
                  phone: mobile,
                  address: const stripe.Address(
                    country: 'AE',
                    city: '',
                    line1: '',
                    line2: '',
                    state: '',
                    postalCode: '',
                  )),
              googlePay: stripe.PaymentSheetGooglePay(
                merchantCountryCode: "AE",
                currencyCode: "AED",
                // testEnv: true,
                amount: (amount * 100).toString(),
              )));

      await displayPaymentSheet(stripPaymentResp?.clientSecret);
    } else {
      var data = jsonDecode(response.body);

      print("Error: ${response.statusCode} - ${response.body}");
      CustomMessage.toast(data['error']['message']);
    }
  }

  displayPaymentSheet(clientSecret) async {
    load = true;
    setState(() {});
    try {
      // stripe.PaymentSheetPaymentOption? resp =
      await stripe.Stripe.instance.presentPaymentSheet().then((value) async {
        await stripe.Stripe.instance.confirmPaymentSheetPayment();
        var paymentDet =
            await stripe.Stripe.instance.retrievePaymentIntent(clientSecret);

        if (paymentDet.status.name == 'Succeeded') {
          await generatebuilMasterId(
              paymentDet.id, paymentDet.clientSecret, "");
        } else {
          CustomMessage.toast(paymentDet.status.name);
        }

        return value;
      });
      load = false;
      setState(() {});

      generatedInvoiceList.clear();
      invoiceList.clear();
      await fetchInvoiceList(DateTime.now().toString().substring(0, 10),
          DateTime.now().toString().substring(0, 10));
    } on stripe.StripeException catch (e) {
      load = false;
      setState(() {});
      debugPrint(e.toString());
    } catch (e) {
      load = false;
      setState(() {});
      debugPrint(e.toString());
    }
  }
}
