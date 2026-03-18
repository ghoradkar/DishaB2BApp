import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/makepayment/model/order_detail_resp_model.dart';
import 'package:dishabtob/makepayment/model/strip_payment_resp.dart';
import 'package:dishabtob/makepayment/prepaid_payment_receipt.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:encrypt/encrypt.dart' as encryption;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Prepaid extends StatefulWidget {
  final String decryptedKeyIdRazorPay;
  final String decryptedKeySecretRazorPay;

  const Prepaid(
      {super.key,
      required this.decryptedKeyIdRazorPay,
      required this.decryptedKeySecretRazorPay});

  @override
  PrepaidState createState() => PrepaidState();
}

class PrepaidState extends State<Prepaid> {
  bool load = false;
  TextEditingController payable = TextEditingController();
  Map<String, dynamic>? decode;
  String? remain;
  TextEditingController fromD = TextEditingController();
  TextEditingController toD = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  String? unitCode;
  Razorpay? _razorpay;
  String? unitName;
  var mobile;
  var email;
  OrderDetailRespModel? orderDetailRespModel;
  StripPaymentResp? stripPaymentResp;
  String? userPaymentType;
  var consumption;
  var consume;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getuser();
    super.initState();
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
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
                child: Stack(
                  children: [
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
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Make Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.11,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.042,
                                        child: TextButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      side: const BorderSide(
                                                          color:
                                                              Colors.white))),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(AppColours.orange),
                                            ),
                                            onPressed: () {
                                              selectDateRange(context);
                                              // printDetailed(fromD,toD);
                                            },
                                            child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Payment Summary Report',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                  Icon(
                                                    Icons.download,
                                                    color: Colors.white,
                                                    size: 15,
                                                  )
                                                ]))),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        //margin: EdgeInsets.only(top: 10),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              //SizedBox(height: 20,),

                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    //SizedBox(width: 10,),

                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                          const EdgeInsets.only(
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
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            consumption != null
                                                                ? consumption[0]
                                                                        [
                                                                        'fixedAdvance']
                                                                    .toString()
                                                                : "",
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
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            consumption != null
                                                                ? consumption[0]
                                                                        [
                                                                        'currentAmount']
                                                                    .toString()
                                                                : "",
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
                                                                fontSize: 12),
                                                          ),
                                                          Row(children: [
                                                            Text(
                                                              consume ?? "",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors.red,
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
                                                                consumption !=
                                                                        null
                                                                    ? consumption[0]
                                                                            [
                                                                            'usableAmount']
                                                                        .toString()
                                                                    : "",
                                                                style:
                                                                    const TextStyle(
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
                                                              Row(children: [
                                                                Text(
                                                                  remain ?? "",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_upward,
                                                                  color: Colors
                                                                      .green,
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
                                  const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Pay Amount',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: TextFormField(
                                        onEditingComplete: () {
                                          FocusScope.of(context).nextFocus();
                                        },
                                        //  Unitname(username.text);},
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(context).nextFocus();
                                        },

                                        keyboardType: TextInputType.number,
                                        autofocus: true,
                                        textInputAction: TextInputAction.done,
                                        controller: payable,
                                        //focusNode: fpassword,
                                        //obscureText: _obscured,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Payable can not be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: const TextStyle(
                                            color: Colors.black),
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 4, 0),
                                            child: GestureDetector(
                                              //   onTap: _toggleObscured,
                                              child: Icon(
                                                Icons.money,
                                                color: Colors.black87
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white10,

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          //floatingLabelBehavior: FloatingLabelBehavior.never,

                                          //hintText: 'Enter Username',
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          label: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Amount',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // labelText: 'Password',
                                          // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                          floatingLabelStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Note : ',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Pay Amount’ should not be more than ‘Fixed Advance.’',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        margin: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Row(
                          children: [
                            const Icon(Icons.money),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              payable.text.toString(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColours.blue,
                                      AppColours.orange
                                    ],
                                    begin: const FractionalOffset(1.0, 0.0),
                                    end: const FractionalOffset(0.0, 0.0),
                                    stops: const [0.0, 1.0],
                                    tileMode: TileMode.clamp,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.28,
                                height:
                                    MediaQuery.of(context).size.height * 0.045,
                                child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    double? enteredValue =
                                        double.tryParse(payable.text);
                                    if (enteredValue == null) {
                                      CustomMessage.toast('Invalid number');
                                    } else if (enteredValue <= 0) {
                                      CustomMessage.toast(
                                          'Pay Amount should be greater than 0');
                                    } else if (enteredValue >
                                        consumption[0]['fixedAdvance']) {
                                      CustomMessage.toast(
                                          'Pay Amount should not be more than Fixed Advance');
                                    } else {
                                      if (FlavorConfig.instance.name ==
                                              'B2BMobileBeta' ||
                                          FlavorConfig.instance.name ==
                                              'B2BMobile' ||  FlavorConfig.instance.name ==
                                          'B2BLifenity') {
                                        await createOrderRazorPay(
                                            double.parse(payable.text));
                                      } else {
                                        await createPaymentIntentStrip(
                                            int.parse(payable.text), 'AED');
                                      }
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Pay Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Icon(
                                        Icons.currency_rupee,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            offlineChild: Offline()));
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    unitCode = prefs.getString("UnitCode");
    unitName = prefs.getString("Unitname");
    await fetchClientDetails();
    await fetchConsumption(decode);
  }

  String decryptAES(String encryptedValue, encryption.Key key) {
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final decrypted =
        encrypter.decrypt64(encryptedValue, iv: IV.fromLength(16));
    return decrypted;
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
    );
    debugPrint(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      consumption = value['lstPrepaidCustomerDto'];
      Map<String, dynamic> t = consumption!.first;

      consume = t['billConsumeAmount'].toString();
      remain = t['billRemainAmount'].toString();

      setState(() {});
    } else {
      CustomMessage.toast("something went wrong");
    }
  }

  Future<void> createOrderRazorPay(double amount) async {
    String auth =
        'Basic ${base64Encode(utf8.encode('${widget.decryptedKeyIdRazorPay}:${widget.decryptedKeySecretRazorPay}'))}';

    var headers = {'Content-Type': 'application/json', 'Authorization': auth};

    var requestBody = jsonEncode({
      "amount": (amount * 100).toInt(),
      "currency": "INR",
      "receipt": "order_rcptid_${DateTime.now().millisecondsSinceEpoch}",
      "payment_capture": 1
    });

    var response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/orders'),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      print("Order Created Successfully: ${data["id"]}");

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
    print(options);
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }

    // RazorpayTotalxsoftware.pay(
    //   context,
    //   amount: amount,
    //   saveInFirebase: false,
    //   rzpKey: widget.decryptedKeyIdRazorPay,
    //   razorpayKeySecret: widget.decryptedKeySecretRazorPay,
    //   appName: unitName!,
    //   // itemName: , // optional
    //
    //   userProfile: RzpUserProfile(
    //     uid: decode!['userId'].toString(),
    //     name: decode!['userAccesBeanList']['customerName'],
    //     email: email,
    //     phoneNumber: mobile,
    //   ),
    //   success: (response) async{
    //     print(response.toString());
    //     print('payment success');
    //      await getReceiptId(
    //           'Razor Pay',
    //           decode!['userId'].toString(),
    //           response.orderId.toString(),
    //           response.paymentId.toString(),
    //           response.signature);
    //   },
    //   failure: (response) {
    //     print(response.toString());
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //             'Payment Failed: ${response.code} - ${response.message}',
    //           ),
    //         ),
    //       );
    //   },
    //   error: (response) {
    //     print(response.toString());
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //             'Payment Failed: $response',
    //           ),
    //         ),
    //       );
    //   },
    // );
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    getReceiptId(
        'Razor Pay',
        decode!['userId'].toString(),
        response.orderId.toString(),
        response.paymentId.toString(),
        response.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Failed: ${response.code} - ${response.message}');
    debugPrint('Error details: ${response.error.toString()}');

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

  Future<void> selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10), // Minimum selectable date
      lastDate: DateTime(now.year + 10), // Maximum selectable date
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : null,
    );

    if (pickedRange != null) {
      setState(() {
        fromDate = pickedRange.start;
        toDate = pickedRange.end;
      });
      fromD.text = DateFormat("yyyy-MM-dd").format(fromDate!);
      toD.text = DateFormat("yyyy-MM-dd").format(toDate!);
    }
    await printDetailed(fromD.text, toD.text);
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
      "customerType": decode!['customerType'],
      "customerId": decode!['customerId'],
      "unitId": decode!['unitMasterId'],
      "userId": decode!['userId'],
      "unitCode": unitCode,
      "fromDate": from,
      "toDate": to,
      "callFrom": "detailed"
    };
    final jsonbody = json.encode(body);
    debugPrint(jsonbody);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody);

    Map<String, dynamic> value = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List t = value['result'];
      Map<String, dynamic> report = t.first;
      launch(report['url']);
      load = false;
      setState(() {});
    } else {
      CustomMessage.toast('Failed to load');
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
    );

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      mobile = value['businessMasterGeneralInfoDto'][0]['mobile'];
      email = value['businessMasterGeneralInfoDto'][0]['mail'];

      load = false;
      setState(() {});
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Failed to load');
    }
  }

  fetchPrepaid() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);
    var data;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var uri;

    if (FlavorConfig.instance.name != "B2BLifenity") {
      uri = Uri.parse(
          '${url.baseurl}${url.PREPAID_DATA}?callFrom=all&startIndex=0&userType=${decode?['userType']}');
    } else {
      uri = Uri.parse(
          '${url.baseurl}${url.PREPAID_DATA}?customerId=0&customerType=0callFrom=all&startIndex=0&userType=${decode?['userType']}&unitId=${decode!['unitMasterId']}');
    }

    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
    );

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      var IPD = value['lstPrepaidCustomerDto'];
      IPD!.length > 1
          ? data = IPD!.first
          : CustomMessage.toast('No Data Found');
      remain = "${data?['remainAmount']}";

      load = false;
      setState(() {});
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  getReceiptId(String callFrom, String userId, String payment_id,
      String order_id, String? signature) async {
    load = true;
    setState(() {});
    final headers = {
      'Content-Type': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.GETRECEIPTID}?callFrom=$callFrom&userId=$userId');
    debugPrint(uri.path);

    var body;
    // if (FlavorConfig.instance.name != "B2BLifenity") {
      body = {
        "receiptCount": 0,
        "businessType": 1,
        "customerType": decode!['customerType'],
        "customerId": decode!['customerId'],
        "cycleId": 0,
        "unitId": decode!['unitMasterId'],
        "carryAmt": double.parse(payable.text),
        "totalAmt": double.parse(payable.text),
        "discPer": 0.0,
        "totalDisc": 0.0,
        "discReason": "",
        "discRemark": "",
        "totalPayable": double.parse(payable.text),
        "totalPaid": double.parse(payable.text),
        "refundFlag": "N",
        "totalRefund": 0.0,
        "totalRemain": 0.0,
        "creditFlag": "N",
        "billSettledFlag": "N",
        "receiptStatus": "paid",
        "payMode": 15,
        "bNumber": "0",
        "batchNumber": "0",
        "chequeBarcode": "",
        "chequeAddress": "",
        "approvedFlag": 0,
        "bName": "0",
        "againstId": 0,
        "deleted": "N",
        "createdBy": userId,
        "updatedBy": userId,
        "onlineTransactionId": "",
        "uni_remark": "",
        "voucher": "",
        "consumedPrepaidCreditAmount": consumption.first['prepaidCreditAmount'],
        "callFrom": "Razor Pay"
      };
    // } else {
    //   body = {
    //     "customerId": 61,
    //     "unitId": 21,
    //     "totalPaid": double.parse(payable.text),
    //     "onlineTransactionId": "",
    //     "receiptStatus": "paid",
    //     "customerType": 3,
    //     "totalAmt": double.parse(payable.text),
    //     "totalPayable": double.parse(payable.text)
    //   };
    // }
    final response =
        await ioClient.post(uri, headers: headers, body: jsonEncode(body));

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      load = false;
      setState(() {});

      CustomMessage.toast(value['message']);

      await savePaymentDetailsToBacked(
          payment_id, order_id, signature, value['receipt_id'].toString());
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(value['message']);
    }
    ;
  }

  savePaymentDetailsToBacked(String payment_id, String order_id,
      String? signature, String? receiptId) async {
    load = true;
    setState(() {});
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.SAVEPAYMENTDATA}?payment_id=$payment_id&order_id=$order_id&amount=${payable.text}&customer_name=$unitName&signature=$signature&receipt_id=&customerId=${decode!['customerId']}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
    );

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      load = false;
      setState(() {});
      CustomMessage.toast(value['message']);
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PrepaidPaymentReceipt(
                decryptedKeyIdRazorPay: widget.decryptedKeyIdRazorPay,
                decryptedKeySecretRazorPay: widget.decryptedKeySecretRazorPay,
              )));
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(value['message']);
    }
    ;
  }

  createPaymentIntentStrip(int amount, String currency) async {
    String auth =
        'Basic ${base64Encode(utf8.encode(widget.decryptedKeySecretRazorPay))}';

    // Headers
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': auth
    };

    var requestBody = {
      "amount": (amount * 100).toString(),
      "currency": currency,
      "automatic_payment_methods[enabled]": "true",
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: headers,
      body: requestBody,
    );

    // Handling Response
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      stripPaymentResp = StripPaymentResp.fromJson(data);
      stripe.PaymentSheetPaymentOption? resp = await stripe.Stripe.instance
          .initPaymentSheet(
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
                      testEnv: true,
                      amount: (amount * 100).toString(),
                      buttonType: stripe.PlatformButtonType.googlePayMark)));

      await displayPaymentSheet();
    } else {
      var data = jsonDecode(response.body);

      print("Error: ${response.statusCode} - ${response.body}");
      CustomMessage.toast(data['error']['message']);
    }
  }

  displayPaymentSheet() async {
    try {
      stripe.PaymentSheetPaymentOption? resp = await stripe.Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
        await stripe.Stripe.instance.confirmPaymentSheetPayment();
        return value;
      });

      debugPrint(resp?.label ?? '');
      CustomMessage.toast("Payment Success");

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PrepaidPaymentReceipt(
            decryptedKeyIdRazorPay: widget.decryptedKeyIdRazorPay,
            decryptedKeySecretRazorPay: widget.decryptedKeySecretRazorPay,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } on stripe.StripeException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
