import 'dart:convert';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/makepayment/paynow.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPaid extends StatefulWidget {
  const PostPaid({super.key});

  @override
  PostPaidState createState() => PostPaidState();
}

class PostPaidState extends State<PostPaid> {
  List? IPD;
  bool load = false;
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
  FocusNode fto = FocusNode();
  List<bool>? selected;
  double? amount = 0.0;
  List<dynamic>? submit;
  String? current;

  String? title = 'Patient Id';
  List<String> item = [
    "Patient Id",
    "Patient Name",
    "Patient Mobile",
    "Patient Aadhar",
    "Patient Emirates ID",
    "Patient Passport",
    "Patient Visa"
  ];


  @override
  void initState() {
    setState(() {
      load = true;
    });
    current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fromdate.text = current!;
    todate.text = current!;

    getuser();
    //fetchPostpaid();

    super.initState();
  }

  Map<String, dynamic>? decode;


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
                                const Text(
                                  'Make Payment',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
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
                            child: Column(children: [
                              Card(
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(

                                      // side:new  BorderSide(color: Color(0xFF2A8068)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    //margin: EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  child: TextFormField(
                                                    onEditingComplete: () =>
                                                        FocusScope.of(context)
                                                            .nextFocus(),
                                                    focusNode: ffrom,
                                                    // autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: fromdate,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    validator: (value) {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return "From Date can not be empty";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    onTap: () async {
                                                      DateTime? pickedDate =
                                                          await showDatePicker(
                                                        context: context,
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              colorScheme:
                                                                  const ColorScheme
                                                                      .light(
                                                                primary: Colors
                                                                    .indigo,
                                                                // <-- SEE HERE
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                                // <-- SEE HERE
                                                                onSurface: Colors
                                                                    .indigo, // <-- SEE HERE
                                                              ),
                                                              textButtonTheme:
                                                                  TextButtonThemeData(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .indigo, // button text color
                                                                ),
                                                              ),
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                        initialDate:
                                                            DateTime.now(),
                                                        //get today's date
                                                        firstDate:
                                                            DateTime(1900),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate: DateTime.now()
                                                            .add(const Duration(
                                                                days: 0)),
                                                      );
                                                      if (pickedDate != null) {
                                                        //get the picked date in the format => 2022-07-04 00:00:00.000
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                        debugPrint(
                                                            formattedDate); //formatted date output using intl package =>  2022-07-04
                                                        //You can format date as per your need

                                                        setState(() {
                                                          fromdate.text =
                                                              formattedDate;
                                                        });
                                                      } else {
                                                        debugPrint(
                                                            "From Date is not selected");
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white10,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ),

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: const TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'From Date',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // labelText: 'Password',
                                                      // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(height: 20,),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                  child: TextFormField(
                                                    onEditingComplete: () =>
                                                        FocusScope.of(context)
                                                            .nextFocus(),
                                                    focusNode: fto,
                                                    //  autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: todate,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    validator: (value) {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return "To Date can not be empty";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    onTap: () async {
                                                      DateTime? pickedDate =
                                                          await showDatePicker(
                                                        context: context,
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              colorScheme:
                                                                  const ColorScheme
                                                                      .light(
                                                                primary: Colors
                                                                    .indigo,
                                                                // <-- SEE HERE
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                                // <-- SEE HERE
                                                                onSurface: Colors
                                                                    .indigo, // <-- SEE HERE
                                                              ),
                                                              textButtonTheme:
                                                                  TextButtonThemeData(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .indigo, // button text color
                                                                ),
                                                              ),
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                        initialDate:
                                                            DateTime.now(),
                                                        //get today's date
                                                        firstDate:
                                                            DateTime(1900),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate: DateTime.now()
                                                            .add(const Duration(
                                                                days: 0)),
                                                      );
                                                      if (pickedDate != null) {
                                                        //get the picked date in the format => 2022-07-04 00:00:00.000
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                        debugPrint(
                                                            formattedDate); //formatted date output using intl package =>  2022-07-04
                                                        //You can format date as per your need

                                                        setState(() {
                                                          todate.text =
                                                              formattedDate;
                                                        });
                                                      } else {
                                                        debugPrint(
                                                            "To Date is not selected");
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white10,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ),

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: const TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'To Date',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // labelText: 'Password',
                                                      // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        //SizedBox(height: 10,),
                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.38,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                side: const BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    AppColours
                                                                        .orange),
                                                      ),
                                                      onPressed: () async {
                                                        fetchPostpaid(
                                                            fromdate.text,
                                                            todate.text);
                                                      },
                                                      child: const Row(
                                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Search Results',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .search_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            )
                                                          ]),
                                                    )))),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  child: load
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.indigo,
                                          ),
                                        )
                                      : IPD!.isEmpty
                                          ? const Center(child: DataNotFound())
                                          : // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                                          smartReport(context)),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  color: Colors.white,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.money),
                                        const Text(
                                          'Total Amount:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          amount.toString(),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromRGBO(
                                                              21, 115, 175, 1),
                                                          Color.fromRGBO(
                                                              236, 106, 56, 0.7)
                                                        ],
                                                        begin: FractionalOffset(
                                                            1.0, 0.0),
                                                        end: FractionalOffset(
                                                            0.0, 0.0),
                                                        stops: [0.0, 1.0],
                                                        tileMode:
                                                            TileMode.clamp),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.28,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.045,
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      // side: BorderSide(color: Colors.red)
                                                    )),
                                                    //  backgroundColor:
                                                    // MaterialStateProperty.all<Color>(
                                                    //     Colors.deepOrange
                                                    //         .withOpacity(0.9)),
                                                  ),
                                                  onPressed: () async {
                                                    showModalBottomSheet<void>(
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.7),
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.4),

                                                        // context and builder are
                                                        // required properties in this widget
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return PayNow(
                                                              amount.toString(),
                                                              '0');
                                                        });
                                                  },
                                                  child: const Row(
                                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Pay Now',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                        Icon(
                                                          Icons.currency_rupee,
                                                          color: Colors.white,
                                                          size: 15,
                                                        )
                                                      ]),
                                                ))),
                                      ]))
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  smartReport(BuildContext context) {
    return ListView.builder(
        itemCount: IPD!.length,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = IPD![index];

          return Card(
              child: Container(
                //margin: EdgeInsets.only(: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade200)),
                height: MediaQuery.of(context).size.height * 0.19,
                width: MediaQuery.of(context).size.width,
                child: CheckboxListTile(
                    activeColor: AppColours.blue,
                    checkColor: Colors.white,
                    //fillColor: MaterialStateColor.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    controlAffinity: ListTileControlAffinity.trailing,
                    dense: true,
                    //isThreeLine: true,
                    title: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //SizedBox(width: 10,),

                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.tag,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Icon(
                                      Icons.money,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                  ]),
                            ),
                            //SizedBox(width: 10,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Invoice ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                                Text(
                                  g['invoiceId'].toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                //SizedBox(height: 10,),

                                //SizedBox(width: 20,),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Invoice From Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                                Text(
                                  g['fromDate'].toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Amount',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                                Text(
                                  g['totalInvoiceAmount'].toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),

                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.01,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 0,
                                  top: MediaQuery.of(context).size.height * 0.01),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //SizedBox(height: 10,),

                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 0,
                                  top: MediaQuery.of(context).size.height * 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Generated Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy, HH:mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            g['createdDateTime'])),
                                    style: const TextStyle(fontSize: 10),
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Invoice To Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                  Text(
                                    g['toDate'].toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  //SizedBox(height: 10,),

                                  //SizedBox(width: 20,),

                                  //
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    value: selected![index],
                    onChanged: (value) {
                      selected![index] == false
                          ? {
                        setState(() {
                          amount = amount! + g['totalInvoiceAmount'];
                          selected![index] = true;
                          submit!.add(index);
                        }),
                      }
                          : {
                        setState(() {
                          amount = amount! - g['totalInvoiceAmount'];
                          selected![index] = false;
                          submit!.removeAt(index);
                        }),
                      };
                    }),
              ));
        });
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      fetchPostpaid('2023-01-01', DateTime.now().toString().substring(0, 10));
    });
  }

  fetchPostpaid(fromdate, todate) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.POSTPAID_DATA}?unitId=${decode!['unitMasterId']}&userFromDate=$fromdate&userToDate=$todate&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&startIndex=0&userType=${decode!['userType']}');
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
        IPD = value['lstbusinesscustomerinvoice'];
        selected = List.generate(IPD!.length, (index) => false);
        submit = List.generate(IPD!.length, (index) => []);
        load = false;
      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }

}
