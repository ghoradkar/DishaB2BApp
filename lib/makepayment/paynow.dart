import 'dart:convert';
import 'package:dishabtob/Global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PayNow extends StatefulWidget {
  final String? payable;
  final String? remain;

  const PayNow(this.payable, this.remain, {super.key});

  @override
  PayNowState createState() => PayNowState();
}

class PayNowState extends State<PayNow> {

  List<dynamic>? paymentmodes;
  String? paymentmode;
  FocusNode fvoucher = FocusNode();
  TextEditingController voucher = TextEditingController();
  FocusNode fpayable = FocusNode();
  TextEditingController payable = TextEditingController();
  FocusNode fnow = FocusNode();
  TextEditingController now_pay = TextEditingController();
  FocusNode fremark = FocusNode();
  TextEditingController remark = TextEditingController();
   Razorpay? _razorpay;
  Map<String, dynamic>? decode;
  String? unit;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // Paymentmode();
    getuser();
    payable.text = widget.payable.toString();

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
            onlineChild: SingleChildScrollView(
                child: Container(
              decoration: const BoxDecoration(
                  //color: Colors.black.withAlpha(1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.95,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              'Pay Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ))),

                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ))
                      ]),
                  Center(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        // height: MediaQuery.of(context).size.height*0.07,
                        color: Colors.white10,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: DropdownButton(
                      underline: Container(
                        color: Colors.white,
                      ),
                      hint: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Payment Mode',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      autofocus: true,
                      padding: const EdgeInsets.all(5),
                      isExpanded: true,
                      dropdownColor: Colors.grey.shade500,
                      iconEnabledColor: Colors.white,
                      value: paymentmode,
                      items: paymentmodes?.map((country) {
                        return DropdownMenuItem(
                          value: country['payName'],
                          child: Text(
                            country['payName'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (country) {
                        setState(() {
                          paymentmode = country as String;
                          FocusScope.of(context).nextFocus();
                        });
                      },
                    ),
                  )),
                  const SizedBox(
                    height: 15,
                  ),

                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        //  Unitname(username.text);},
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        // Unitname(username.text);},

                        focusNode: fpayable,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: payable,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Payable can not be empty";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Payable',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        //  Unitname(username.text);},
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        // Unitname(username.text);},

                        focusNode: fnow,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: now_pay,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Now Pay can not be empty";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Now Pay',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        //  Unitname(username.text);},
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        // Unitname(username.text);},

                        focusNode: fvoucher,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: voucher,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Voucher can not be empty";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Voucher',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        //  Unitname(username.text);},
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        // Unitname(username.text);},

                        focusNode: fremark,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: remark,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Remark can not be empty";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Remark',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
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
                  Center(
                    child: Text('Bill Test Remaining Amount ${widget.remain}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        openCheckout(10);
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColours.orange,
                            border: Border.all(color: Colors.white30),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Pay Now',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            )),
            offlineChild: Offline()));
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    decode = json.decode(encodedMap!);
    unit = prefs.getString('Unitname');
    setState(() {});
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_CJx254P4pwEOhG',
      // Use test key from Razorpay Dashboard
      'amount': (amount * 100).toInt(),
      // Amount in smallest currency unit (e.g., 100 INR = 10000 paise)
      'name': unit,
      'description': decode!['userAccesBeanList']['customerName'],
      'prefill': {
        'contact': '8830378568',
        'email': 'kiranghoradkar55@gmail.com',
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
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

  Paymentmode() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.PAYMENTMODE}');
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
    Map<String, dynamic> value = jsonDecode(response.body);
    response.statusCode == 200
        ? {
      paymentmodes = value['listPay'],
      // CustomMessage.toast('OTP SENT TO YOUR EMAIL ID !! '),
      //Navigator.pop(context),
    }
        : CustomMessage.toast(value['exception']);
  }
}
