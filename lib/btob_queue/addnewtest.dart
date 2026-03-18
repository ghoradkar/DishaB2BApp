import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/btob_queue/addtest.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'addnewpackage.dart';

class AddNewTest extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final Map<String, dynamic>? selectedTest;
  final List<dynamic>? testList;
  final List? savedTestPackageList;
  final dynamic patientDet;
  final dynamic samples;
  final bool? fromAddPackagePage;

  const AddNewTest(this.patient, this.selectedTest, this.testList, this.samples,
      {super.key,
      this.fromAddPackagePage,
      this.savedTestPackageList,
      this.patientDet});

  @override
  AddNewTestState createState() => AddNewTestState();
}

class AddNewTestState extends State<AddNewTest> {
  bool load = false;
  String? docName;
  List<dynamic>? refDoc;
  String? sampleId;
  Map<String, dynamic>? decode;
  String? unitCode;
  String? sample_id;
  List<dynamic>? part;
  var samples;
  List<dynamic>? consumption;
  double? advance;
  double? consume;
  double? remain;
  List<dynamic> billing = [];
  String? title = 'MR.';
  List<String> item = ["MR.", "MRS.", "MS."];
  TextEditingController sampleName = TextEditingController();
  FocusNode fpart = FocusNode();
  TextEditingController parti = TextEditingController();
  FocusNode fbarcode = FocusNode();
  TextEditingController barcode = TextEditingController();
  TextEditingController test = TextEditingController();
  FocusNode frate = FocusNode();
  TextEditingController rate = TextEditingController();
  FocusNode fquantity = FocusNode();
  TextEditingController quantity = TextEditingController();
  FocusNode famount = FocusNode();
  TextEditingController amount = TextEditingController();
  FocusNode fremark = FocusNode();
  TextEditingController remark = TextEditingController();
  FocusNode fdate = FocusNode();
  TextEditingController date = TextEditingController();
  FocusNode fcollection_time = FocusNode();
  TextEditingController collection_time = TextEditingController();
  TimeOfDay selectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  String? _hour, _minute, _time;
  String? Particular;
  List<dynamic> part_list = [];

  final stt.SpeechToText speech = stt.SpeechToText();
  bool _isListening = false;

  String? userPaymentType;
  String? prepaidReceiptId;
  List<Map<String, String>>? testDetailsList;

  @override
  void initState() {
    getuser();

    debugPrint('samples');

    _hour = TimeOfDay.now().hour.toString();
    _minute = TimeOfDay.now().minute.toString();
    _time = _minute!.length == 1
        ? '${_hour!}:0${_minute!}'
        : '${_hour!}:${_minute!}';
    // _time = _hour! + ':' + _minute!;
    collection_time.text = _time!;

    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    date.text = formattedDate;

    debugPrint('dhhbvf');

    super.initState();
    initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        initialData: NetworkStatus.Online,
        child: NetworkAwareWidget(
            onlineChild: Scaffold(
                //resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: [
                              Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          AppColours.blue,
                                          AppColours.orange
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(0.0, 1.0),
                                        stops: const [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddTest(
                                                                  widget
                                                                      .patient,
                                                                  widget
                                                                      .testList)));
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Add New Test',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ])),
                              load
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Positioned(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          child: Form(
                                              child: SingleChildScrollView(
                                            child: Column(children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              widget.selectedTest == null
                                                  ? TypeAheadField<dynamic>(
                                                      controller: parti,
                                                      suggestionsCallback:
                                                          (pattern) async {
                                                        if (!widget
                                                            .fromAddPackagePage!) {
                                                          await fetchInitialList(
                                                              pattern);
                                                          return part_list
                                                              .where((item) => item[
                                                                      'categoryName']
                                                                  .toLowerCase()
                                                                  .contains(pattern
                                                                      .toLowerCase()))
                                                              .toList();
                                                        }
                                                        return [];
                                                      },
                                                      itemBuilder: (context,
                                                          suggestion) {
                                                        return ListTile(
                                                          title: Text(suggestion[
                                                              'categoryName']),
                                                        );
                                                      },
                                                      onSelected: (suggestion) {
                                                        Particular = suggestion[
                                                            'categoryName'];
                                                        parti.text = suggestion[
                                                            'categoryName'];
                                                        String serviceName =
                                                            suggestion[
                                                                'serviceName'];

                                                        if (serviceName
                                                                .trim() ==
                                                            'Pathology') {
                                                          checkTest(suggestion);
                                                        } else {
                                                          checkPackage(
                                                              suggestion);
                                                        }
                                                        setState(() {});
                                                      },
                                                      builder: (context,
                                                          controller,
                                                          focusNode) {
                                                        return SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.08,
                                                          child: TextFormField(
                                                            controller:
                                                                controller,
                                                            focusNode:
                                                                focusNode,
                                                            readOnly: widget
                                                                .fromAddPackagePage!,
                                                            autofocus: true,
                                                            onChanged: (value) {
                                                              if (!widget
                                                                  .fromAddPackagePage!) {
                                                                fetchInitialList(
                                                                    value);
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                    _isListening
                                                                        ? Icons
                                                                            .mic
                                                                        : Icons
                                                                            .mic_none),
                                                                onPressed: _isListening
                                                                    ? stopListening
                                                                    : startListening,
                                                              ),
                                                              prefixIcon:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            4),
                                                                child: Icon(
                                                                    Icons
                                                                        .perm_contact_cal,
                                                                    color: Colors
                                                                        .black87),
                                                              ),
                                                              label: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'Particular',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87
                                                                            .withOpacity(0.7),
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                    const TextSpan(
                                                                      text: '*',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .transparent,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )

                                                  // TypeAheadField<dynamic>(
                                                  //         controller: parti,
                                                  //         // autoFlipMinHeight: 100,
                                                  //         suggestionsCallback:
                                                  //             (pattern) {
                                                  //           if (widget
                                                  //                   .fromAddPackagePage! ==
                                                  //               false) {
                                                  //             fetchInitialList(
                                                  //                 pattern);
                                                  //             return part_list
                                                  //                 .where((country) => country[
                                                  //                         'categoryName']
                                                  //                     .toLowerCase()
                                                  //                     .contains(pattern
                                                  //                         .toLowerCase()))
                                                  //                 .toList();
                                                  //           }
                                                  //         },
                                                  //         builder: (context,
                                                  //             controller,
                                                  //             focusNode) {
                                                  //           return SizedBox(
                                                  //               width: MediaQuery.of(
                                                  //                           context)
                                                  //                       .size
                                                  //                       .width *
                                                  //                   0.8,
                                                  //               height: MediaQuery.of(
                                                  //                           context)
                                                  //                       .size
                                                  //                       .height *
                                                  //                   0.08,
                                                  //               child:
                                                  //                   TextFormField(
                                                  //                 readOnly: widget
                                                  //                         .fromAddPackagePage!
                                                  //                     ? true
                                                  //                     : false,
                                                  //                 decoration:
                                                  //                     InputDecoration(
                                                  //                   suffixIcon:
                                                  //                       IconButton(
                                                  //                     icon: Icon(_isListening
                                                  //                         ? Icons
                                                  //                             .mic
                                                  //                         : Icons
                                                  //                             .mic_none),
                                                  //                     onPressed: _isListening
                                                  //                         ? stopListening
                                                  //                         : startListening,
                                                  //                   ),
                                                  //                   prefixIcon:
                                                  //                       Padding(
                                                  //                     padding:
                                                  //                         const EdgeInsets
                                                  //                             .fromLTRB(
                                                  //                             0,
                                                  //                             0,
                                                  //                             4,
                                                  //                             0),
                                                  //                     child:
                                                  //                         GestureDetector(
                                                  //                       //   onTap: _toggleObscured,
                                                  //                       child: Icon(
                                                  //                         Icons
                                                  //                             .perm_contact_cal,
                                                  //                         color: Colors
                                                  //                             .black87
                                                  //                             .withOpacity(
                                                  //                                 0.7),
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                   label: RichText(
                                                  //                     text:
                                                  //                         TextSpan(
                                                  //                       children: [
                                                  //                         TextSpan(
                                                  //                           text:
                                                  //                               'Particular',
                                                  //                           style: TextStyle(
                                                  //                               color:
                                                  //                                   Colors.black87.withOpacity(0.7),
                                                  //                               fontSize: 14),
                                                  //                         ),
                                                  //                         const TextSpan(
                                                  //                           text:
                                                  //                               '*',
                                                  //                           style: TextStyle(
                                                  //                               color:
                                                  //                                   Colors.red),
                                                  //                         ),
                                                  //                       ],
                                                  //                     ),
                                                  //                   ),
                                                  //                   filled: true,
                                                  //                   fillColor: Colors
                                                  //                       .transparent,
                                                  //                   focusedBorder:
                                                  //                       OutlineInputBorder(
                                                  //                     borderRadius:
                                                  //                         BorderRadius
                                                  //                             .circular(
                                                  //                                 8.0),
                                                  //                     borderSide:
                                                  //                         const BorderSide(
                                                  //                       color: Colors
                                                  //                           .grey,
                                                  //                     ),
                                                  //                   ),
                                                  //                   disabledBorder:
                                                  //                       OutlineInputBorder(
                                                  //                     borderRadius:
                                                  //                         BorderRadius
                                                  //                             .circular(
                                                  //                                 8.0),
                                                  //                     borderSide:
                                                  //                         const BorderSide(
                                                  //                       color: Colors
                                                  //                           .grey,
                                                  //                       width: 1.0,
                                                  //                     ),
                                                  //                   ),
                                                  //                   enabledBorder:
                                                  //                       OutlineInputBorder(
                                                  //                     borderRadius:
                                                  //                         BorderRadius
                                                  //                             .circular(
                                                  //                                 8.0),
                                                  //                     borderSide:
                                                  //                         const BorderSide(
                                                  //                       color: Colors
                                                  //                           .grey,
                                                  //                       width: 1.0,
                                                  //                     ),
                                                  //                   ),
                                                  //                 ),
                                                  //                 onChanged:
                                                  //                     (value) {
                                                  //                   if (widget
                                                  //                           .fromAddPackagePage! ==
                                                  //                       false) {
                                                  //                     fetchInitialList(
                                                  //                         value);
                                                  //                   }
                                                  //                 },
                                                  //                 controller:
                                                  //                     controller,
                                                  //                 focusNode:
                                                  //                     focusNode,
                                                  //                 autofocus: true,
                                                  //               ));
                                                  //         },
                                                  //         itemBuilder:
                                                  //             (context, city) {
                                                  //           return ListTile(
                                                  //             title: Text(city[
                                                  //                 'categoryName']),
                                                  //             // subtitle: Text(city.country),
                                                  //           );
                                                  //         },
                                                  //         onSelected: (city) {
                                                  //           setState(() {
                                                  //             Particular = city[
                                                  //                     'categoryName']
                                                  //                 as String;
                                                  //             parti.text = city[
                                                  //                 'categoryName'];
                                                  //             //Particular = country;
                                                  //             city['serviceName'] ==
                                                  //                     'Pathology'
                                                  //                 ? checkTest(city)
                                                  //                 : checkPackage(
                                                  //                     city);
                                                  //             // Fetchlist(Particular);
                                                  //           });
                                                  //         },
                                                  //       )
                                                  : Center(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                        child: TextFormField(
                                                          onEditingComplete:
                                                              () {
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          },
                                                          //  Unitname(username.text);},
                                                          onFieldSubmitted:
                                                              (value) {
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          },
                                                          focusNode: fpart,
                                                          autofocus: true,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          controller: parti,

                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          cursorColor:
                                                              Colors.black,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,

                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            disabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                            ),

                                                            hintStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),
                                                            label: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Particular',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87
                                                                            .withOpacity(
                                                                                0.7),
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  const TextSpan(
                                                                    text: '*',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // labelText: 'Password',
                                                            // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                            floatingLabelStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              // SizedBox(
                                              //   height: MediaQuery.of(context)
                                              //           .size
                                              //           .height *
                                              //       0.01,
                                              // ),
                                              Visibility(
                                                visible: false,
                                                child: Center(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                    child: TextFormField(
                                                      readOnly: widget
                                                              .fromAddPackagePage!
                                                          ? true
                                                          : false,
                                                      onEditingComplete: () {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      },
                                                      //  Unitname(username.text);},
                                                      onFieldSubmitted:
                                                          (value) {
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      },
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            14),
                                                      ],
                                                      // Unitname(username.text);},

                                                      focusNode: fbarcode,
                                                      autofocus: true,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      controller: barcode,
                                                      //focusNode: fpassword,
                                                      //obscureText: _obscured,
                                                      // validator: (value) {
                                                      //   if (va) {
                                                      //     return "Username can not be empty";
                                                      //   } else {
                                                      //     return null;
                                                      //   }
                                                      // },
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      cursorColor: Colors.black,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.transparent,

                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
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
                                                          child:
                                                              GestureDetector(
                                                            //   onTap: _toggleObscured,
                                                            child: Icon(
                                                              Icons
                                                                  .document_scanner_outlined,
                                                              color: Colors
                                                                  .black87
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                          ),
                                                        ),

                                                        //hintText: 'Enter Username',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14),
                                                        label: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Barcode No',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87
                                                                        .withOpacity(
                                                                            0.7),
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              const TextSpan(
                                                                text: '*',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // labelText: 'Password',
                                                        // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                        floatingLabelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: sampleName,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade300,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      disabledBorder:
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
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Sample Type',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.7),
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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

                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    onEditingComplete: () =>
                                                        FocusScope.of(context)
                                                            .nextFocus(),
                                                    focusNode: fdate,

                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: date,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    validator: (value) {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return "Date can not be empty";
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
                                                                  ColorScheme
                                                                      .light(
                                                                primary:
                                                                    AppColours
                                                                        .blue,
                                                                // <-- SEE HERE
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                                // <-- SEE HERE
                                                                onSurface:
                                                                    AppColours
                                                                        .blue, // <-- SEE HERE
                                                              ),
                                                              textButtonTheme:
                                                                  TextButtonThemeData(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      AppColours
                                                                          .blue, // button text color
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
                                                                days: 365)),
                                                      );
                                                      if (pickedDate != null) {
                                                        //get the picked date in the format => 2022-07-04 00:00:00.000
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(
                                                                    pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                        debugPrint(
                                                            formattedDate); //formatted date output using intl package =>  2022-07-04
                                                        //You can format date as per your need

                                                        setState(() {
                                                          date.text =
                                                              formattedDate;

                                                          // var year1 =
                                                          //     pickedDate.year;
                                                          // var year2 =
                                                          //     DateTime.now().year;
                                                          int months, days;
                                                          int totalDays =
                                                              DateTime.now()
                                                                  .difference(
                                                                      pickedDate)
                                                                  .inDays;
                                                          int years =
                                                              totalDays ~/ 365;

                                                          // int totalDays = DateTime.now().difference(pickedDate).inDays;

                                                          //int years = totalDays ~/ 365;
                                                          months = (totalDays -
                                                                  years *
                                                                      365) ~/
                                                              30;
                                                          days = totalDays -
                                                              years * 365 -
                                                              months * 30;
                                                          // months = (totalDays-years*365) ~/ 31,
                                                          //days = totalDays-years*365-months*32,
                                                          // dob(DateTime.now(), pickedDate);
                                                          debugPrint(DateTime
                                                                  .now()
                                                              .difference(
                                                                  pickedDate)
                                                              .inDays
                                                              .toString());

                                                          // yearvalue=year.text.toString().split(' ').first;
                                                          // monthvalue=month.text.toString().split(' ').first;
                                                          // dayvalue=day.text.toString().split(' ').first;

                                                          // age.text = date
                                                          //     .toString();
                                                          //set foratted date to TextField value.
                                                        });
                                                      } else {
                                                        debugPrint(
                                                            "Date is not selected");
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade300,

                                                      enabled: false,

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
                                                      disabledBorder:
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
                                                      suffixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: const Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.7),
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
                                                              text: 'Date ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
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
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    onEditingComplete: () =>
                                                        FocusScope.of(context)
                                                            .nextFocus(),
                                                    focusNode: fcollection_time,

                                                    autofocus: true,
                                                    enabled: false,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: collection_time,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    validator: (value) {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return "Time can not be empty";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    onTap: () async {
                                                      final TimeOfDay? picked =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            selectedTime,
                                                        // context: context,
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              colorScheme:
                                                                  ColorScheme
                                                                      .light(
                                                                primary:
                                                                    AppColours
                                                                        .blue,
                                                                // <-- SEE HERE
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                                // <-- SEE HERE
                                                                onSurface:
                                                                    AppColours
                                                                        .blue, // <-- SEE HERE
                                                              ),
                                                              textButtonTheme:
                                                                  TextButtonThemeData(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      AppColours
                                                                          .blue, // button text color
                                                                ),
                                                              ),
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                      );
                                                      if (picked != null) {
                                                        setState(() {
                                                          selectedTime = picked;
                                                          _hour = selectedTime
                                                              .hour
                                                              .toString();
                                                          _minute = selectedTime
                                                              .minute
                                                              .toString();
                                                          // _time = _hour! +
                                                          //     ' : ' +
                                                          //     _minute!;
                                                          _time = _minute!
                                                                      .length ==
                                                                  1
                                                              ? '${_hour!}:0${_minute!}'
                                                              : '${_hour!}:${_minute!}';
                                                          collection_time.text =
                                                              _time!;
                                                        });
                                                      }
                                                    },

                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      //fillColor: Colors.white,
                                                      fillColor:
                                                          Colors.grey.shade300,

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
                                                      disabledBorder:
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
                                                      suffixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: const Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.7),
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
                                                              text: 'Time',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
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
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    enabled: false,

                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    //  Unitname(username.text);},
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    focusNode: frate,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: rate,

                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      disabledBorder:
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

                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 4, 0),
                                                        child: GestureDetector(
                                                          //   onTap: _toggleObscured,
                                                          child: Icon(
                                                            Icons.money,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ),

                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Rate',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.7),
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
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    //  Unitname(username.text);},
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    // Unitname(username.text);},

                                                    focusNode: fquantity,
                                                    enabled: false,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: quantity,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    // validator: (value) {
                                                    //   if (va) {
                                                    //     return "Username can not be empty";
                                                    //   } else {
                                                    //     return null;
                                                    //   }
                                                    // },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      //fillColor: Colors.transparent,
                                                      fillColor:
                                                          Colors.grey.shade300,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      disabledBorder:
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
                                                          //   onTap: _toggleObscured,
                                                          child: Icon(
                                                            Icons
                                                                .check_box_outline_blank_rounded,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ),

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Quantity',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.7),
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
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    enabled: false,

                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    //  Unitname(username.text);},
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    // Unitname(username.text);},

                                                    focusNode: famount,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: amount,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    // validator: (value) {
                                                    //   if (va) {
                                                    //     return "Username can not be empty";
                                                    //   } else {
                                                    //     return null;
                                                    //   }
                                                    // },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      //fillColor: Colors.transparent,
                                                      fillColor:
                                                          Colors.grey.shade300,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      disabledBorder:
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
                                                          //   onTap: _toggleObscured,
                                                          child: Icon(
                                                            Icons.money,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ),

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Amount',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.7),
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
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                  child: TextFormField(
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    //  Unitname(username.text);},
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .nextFocus();
                                                    },
                                                    // Unitname(username.text);},

                                                    focusNode: fremark,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: remark,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    // validator: (value) {
                                                    //   if (va) {
                                                    //     return "Username can not be empty";
                                                    //   } else {
                                                    //     return null;
                                                    //   }
                                                    // },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,

                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      disabledBorder:
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
                                                          //   onTap: _toggleObscured,
                                                          child: Icon(
                                                            Icons.receipt,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                      ),

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Remark',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.7),
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
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.38,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05,
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
                                                                          .grey))),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .white30),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color:
                                                                    Colors.grey,
                                                                size: 20,
                                                              )
                                                            ]),
                                                      )),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.38,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            // side: BorderSide(color: Colors.red)
                                                          )),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<
                                                                      Color>(
                                                                  AppColours
                                                                      .orange
                                                                      .withOpacity(
                                                                          0.9)),
                                                        ),
                                                        onPressed: load
                                                            ? null
                                                            : () async {
                                                                if (widget
                                                                        .fromAddPackagePage ==
                                                                    false) {
                                                                  if (Particular ==
                                                                          null ||
                                                                      Particular!
                                                                          .isEmpty) {
                                                                    CustomMessage
                                                                        .toast(
                                                                            'Please Select Test Name');
                                                                  } else {
                                                                    fetchBarcode(
                                                                        Particular,
                                                                        barcode
                                                                            .text,
                                                                        sampleId,
                                                                        sampleName
                                                                            .text,
                                                                        docName,
                                                                        test
                                                                            .text,
                                                                        date
                                                                            .text,
                                                                        collection_time
                                                                            .text,
                                                                        rate
                                                                            .text,
                                                                        quantity
                                                                            .text,
                                                                        amount
                                                                            .text,
                                                                        remark
                                                                            .text,
                                                                        samples);
                                                                  }
                                                                } else {
                                                                  addTest(
                                                                      widget.samples[
                                                                          "categoryName"],
                                                                      "-",
                                                                      sample_id,
                                                                      widget
                                                                          .testList,
                                                                      docName,
                                                                      test.text,
                                                                      date.text,
                                                                      collection_time
                                                                          .text,
                                                                      rate.text,
                                                                      quantity
                                                                          .text,
                                                                      widget.samples[
                                                                          'categorycharges'],
                                                                      remark
                                                                          .text,
                                                                      widget
                                                                          .samples);
                                                                }
                                                              },
                                                        child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Save',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              )
                                                            ]),
                                                      )),
                                                ],
                                              )
                                            ]),
                                          ))))
                            ]))))),
            offlineChild: Offline()));
  }

  getuser() async {
    debugPrint('dashboard');
    debugPrint(jsonEncode(widget.savedTestPackageList));
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    unitCode = prefs.getString("UnitCode");
    billing = decode!['userAccesBeanList']["subModuleViewHashSet"];

    if (widget.fromAddPackagePage! == false) {
      fetchConsumption(decode);

      fetchInitialList('b');
    } else {
      if (widget.fromAddPackagePage!) {
        barcode.text = "-";
        quantity.text = '1';
        parti.text = widget.samples['categoryName'];
        Particular = widget.samples['categoryName'];
        sampleName.text = widget.samples['serviceName'];
        fetchRate(widget.samples['categoryid'], "0");
      }
    }

    setState(() {});
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
    );
    debugPrint(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      userPaymentType = value['lstPrePostConsumtionDto'][0]['paymentFlag'];
      prepaidReceiptId =
          value['lstPrePostConsumtionDto'][0]['prepaidReceiptId'].toString();
      if (userPaymentType == "prepaid") {
        fetchAmountCount(decode);
      } else {
        consumption = value['lstPrePostConsumtionDto'];
        Map<String, dynamic> t = consumption!.first;
        advance = t['postpaidAmount'];

        consume = t['billConsumeAmount'];
        remain = t['billRemainAmount'];
      }

      setState(() {});
    } else {
      CustomMessage.toast("Something went wrong");
    }
  }

  void initSpeech() async {
    await speech.initialize();
  }

  void startListening() async {
    if (!_isListening && await speech.initialize()) {
      setState(() => _isListening = true);
      speech.listen(onResult: (result) {
        setState(() {
          parti.text = result.recognizedWords;
        });
      });
    }
  }

  void stopListening() {
    setState(() => _isListening = false);
    speech.stop();
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

      advance = t['availableAmount'];

      consume = t['billConsumeAmount'];
      remain = t['billRemainAmount'];

      setState(() {});
    } else {
      CustomMessage.toast("something went wrong");
    }
  }

  fetchBarcode(particular, barcode, sample_id, sample, doctor, test, date, time,
      rate, quantity, amount, remark, samples) async {
    addTest(particular, barcode, sample_id, sample, doctor, test, date, time,
        rate, quantity, amount, remark, samples);
  }

  addTest(particular, barcode, sample_id, sample, doctor, test, date, time,
      rate, quantity, amount, remark, samples) async {
    load = true;

    setState(() {});

    // var sampleN;
    var sampleTypeIds;
    if (samples['serviceName'] == "Package") {
      // sampleN = removeLastPart(samples['categoryName']);

      sampleTypeIds = widget.testList!
          .where((element) => element['sampleName'] == samples['serviceName'])
          .toList()
          .first;

      if (widget.savedTestPackageList != null) {
        testDetailsList = [];
        for (var item in widget.savedTestPackageList!) {
          int sampleId = item["sampleId"];
          List<String> masterIds;
          if (FlavorConfig.instance.name == "B2BLifenity") {
            masterIds = item["masterIdNew"].split(",");
          } else {
            masterIds = item["masterId"].split(",");
          }
          for (var subServiceId in masterIds) {
            testDetailsList!.add({
              "subServiceId": subServiceId,
              "sampleTypeId": sampleId.toString(),
              "barCode": "-"
            });
          }
        }
        print(testDetailsList);
      } else {
        testDetailsList = null;
      }
    } else {
      // sampleTypeIds = widget.testList!.firstWhere(
      //     (element) => element['profileName'] == samples['categoryName']);

      sampleTypeIds = widget.testList!.firstWhere(
          (element) => element['subServiceId'] == samples['categoryid']);

      testDetailsList = null;
    }

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.ADDTEST}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "billtDetails": {
        "patienttId": widget.patient!['patientId'],
        "billDetailsId": "0",
        "serviceId": samples['serviceid'].toString(),
        "doctorId": 0,
        "treatmentId": widget.patient!['treatmentId'],
        "departmentId": widget.patient!['departmentId'],
        "billId": widget.patient!['billId'],
        "sourceTypeId": "0",
        "rate": rate,
        "concession": "0",
        "quantity": quantity,
        "amount": rate,
        "remark": remark,
        "pay": rate,
        "coPay": rate,
        "subServiceId": samples['categoryid'],
        "unitId": decode!['unitMasterId'],
        "createdDateTime": DateTime.now().toIso8601String(),
        "recSlaveId": "0",
        "callfrom": "N",
        "masterReceiptId": "0",
        "subservicesname": samples['categoryName'],
        "urgentflag": "N",
        "sponsorId": 0,
        "chargesSlaveId": 0,
        "otherRate": rate,
        "otherAmount": rate,
        "otherCoPay": rate,
        "otherPay": rate,
        "otherConcession": "0.00",
        "concessionOnPerc": "0",
        "iscombination": samples['serviceName'] == "Package" ? "Y" : "N",
        "receiptOf": "general",
        "narrationid": "-",
        "narrationidBill": "-",
        "accountStatusOpdDiagno": "N",
        "emrPer": "0",
        "sndToLabFlag": "N",
        "sndToRisFlag": "N",
        "drdeskflag": "N",
        "sampleTypeId": sampleTypeIds['sampleId'],
        "barCode": samples['serviceName'] == "Package" ? "NA" : '-',
        "inOutHouse": samples['serviceName'] == "Package" ? "0" : "1",
        "histopathLab": "N",
        "businessType": widget.patient!['businessType'],
        "customerId": samples['serviceName'] == "Package"
            ? widget.patientDet[0]['customerId']
            : decode!['customerId'],
        "customerType": samples['serviceName'] == "Package"
            ? widget.patientDet[0]['customerType']
            : decode!['customerType'],
        "invoiceRemainAmount": rate,
        "prepaidReceiptId": prepaidReceiptId ?? '0',
        "collectionDate": date,
        "collectionTime": time,
        "regRefDocId": 0,
        "templateWise": samples['templateWise'],
        "b2bNowPay": rate,
        "b2bDisocunt": "0",
        "b2bDisocuntPer": "0",
        "b2bAuthorizedBy": "0",
        "parentUtilizationAmount": "0",
        "b2bPaymentFlag": "N",
      },
      "queryType": "insert",
      "module": samples['serviceName'] == "Package" ? "0" : "1",
      "callfrom": "N",
      if (samples['serviceName'] == "Package")
        "sampleWiseBarcodes": testDetailsList,
      "usertype": decode!['userType'],
      "userId": decode!['userId'],
      "unitCode": unitCode
    };

    debugPrint(body.toString());

    final jsonbody = json.encode(body);
    debugPrint(jsonbody);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody

        //encoding: encoding,
        );
    debugPrint(jsonbody);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      load = false;

      setState(() {});
      if (response.body == "1") {
        CustomMessage.toast('Test Added Successfully!');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "2") {
        CustomMessage.toast('Test Updated Successfully!');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "3") {
        CustomMessage.toast('Package is not configure');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "4") {
        CustomMessage.toast('Package is not configure for sponsor');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "6") {
        CustomMessage.toast('Package is out of date');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "21") {
        CustomMessage.toast('Duplicate radiation test cannot be added');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "7") {
        CustomMessage.toast('Please enter barcode');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "30") {
        CustomMessage.toast('Duplicate tests are not allowed');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      }else if (response.body == "5") {
        CustomMessage.toast('You have insufficient balance');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddTest(widget.patient, widget.testList)));
      } else if (response.body == "0") {
        CustomMessage.toast('Getting 0 in response');
      }

      // Navigator.pop(context),
    } else {
      load = false;

      setState(() {});
      CustomMessage.toast('Failed To add Test');
    }
  }

  checkSample() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    String sampleName = removeLastPart(samples['categoryName']);

    var t = widget.testList!
        .where((element) => element['profileName'] == sampleName);

    final uri = Uri.parse(
        '${url.baseurl}${url.SAME_SAMPLE}?patientId=${widget.patient!['patientId']}&treatmentId=${widget.patient!['treatmentId']}&sampleTypeId=${t.first['sampleId']}&inOutHouse=1');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.get(
      uri,
      headers: headers,
    );
    debugPrint(response.body);
    Map<String, dynamic> g = jsonDecode(response.body);

    g['message'] == 'barcode fetch successfully'
        ? {
            setState(() {
              barcode.text = g['result'];
            }),
          }
        : {
            CustomMessage.toast(g['message']),
          };
  }

  checkTest(particular) async {
    debugPrint('part');
    // debugPrint(particular);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.DUPLICATE_TEST}?callfrom=ABC&unitId=${decode!['unitMasterId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "patientId": widget.patient!['patientId'],
      "treatmentId": widget.patient!['treatmentId'],
      "serviceId": particular['serviceid'],
      "subServiceId": particular['categoryid']
    };
    var jsonbody = json.encode(body);
    final response = await ioClient.post(uri, headers: headers, body: jsonbody

        //encoding: encoding,
        );
    Map<String, dynamic> g = jsonDecode(response.body);

    g['status'] == 'failed'
        ? {
            CustomMessage.toast(g['response']),
            setState(() {
              Particular = '';
              parti.text = '';
            }),
          }
        : {
            //CustomMessage.toast(g['response']),
            fetchList(particular['categoryName'])
          };
  }

  checkPackage(particular) async {
    debugPrint('part');
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.DUPLICATE_PACKAGE}?serviceId=${particular['serviceid']}&subServiceId=${particular['categoryid']}&unitId=${decode!['unitMasterId']}&businessType=${widget.patient!['businessType']}&patientId=${widget.patient!['patientId']}&treatmentId=${widget.patient!['treatmentId']}&billDetailsId=0');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.post(
      uri,
      headers: headers,
      // body: jsonbody

      //encoding: encoding,
    );
    Map<String, dynamic> g = jsonDecode(response.body);

    (g['status'] == 'duplicate' || g['status'] == 'Failed')
        ? {
            CustomMessage.toast(g['response']),
            setState(() {
              Particular = '';
              parti.text = '';
            }),
          }
        : {
            //CustomMessage.toast(g['response']),
            fetchList(particular['categoryName'])
          };
  }

  fetchInitialList(name) async {
    debugPrint(name);
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.GET_SERVICES}?unit=${decode!['unitMasterId']}&depdocdeskid=1&findingName=$name&unitlist=0&querytype=all&serviceid=0&userId=${decode!['userId']}&customerId=${decode!['customerId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var response;
    if (FlavorConfig.instance.name != "B2BLifenity") {
      response = await ioClient.post(
        uri,
        headers: headers,
      );
    } else {
      response = await ioClient.get(
        uri,
        headers: headers,
      );
    }

    debugPrint(response.body);
    Map<String, dynamic> g = jsonDecode(response.body);

    response.statusCode == 200
        ? {
            setState(() {
              part_list = g['lstService'];
              debugPrint('jhgfgh');

              load = false;
            }),
          }
        : CustomMessage.toast('Invalid ');
  }

  fetchRate(subserviceid, callFrom) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);
    var uri;
    if (FlavorConfig.instance.name == "B2BLifenity") {
      uri = Uri.parse(
          '${url.baseurl}${url.GET_RATE}?subserviceid=$subserviceid&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&customerTypeName=B2B&callFrom=0&unitId=${decode!['unitMasterId']}');
    } else {
      uri = Uri.parse(
          '${url.baseurl}${url.GET_RATE}?subserviceid=$subserviceid&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&customerTypeName=B2B&callFrom=0');
    }

    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(response.body);

    if (response.statusCode == 200) {
      setState(() {
        rate.text = response.body;
        amount.text = response.body;
      });
    } else {
      CustomMessage.toast('failed geeting rate ');
    }
  }

  fetchList(String particular) async {
    await fetchConsumption(decode);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.GET_SERVICES}?unit=${decode!['unitMasterId']}&depdocdeskid=1&findingName=$particular&unitlist=0&querytype=all&serviceid=0&userId=${decode!['userId']}&customerId=${decode!['customerId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response;
    if (FlavorConfig.instance.name != "B2BLifenity") {
      response = await ioClient.post(
        uri,
        headers: headers,
      );
    } else {
      response = await ioClient.get(
        uri,
        headers: headers,
      );
    }

    debugPrint(response.body);
    debugPrint(uri.path);
    Map<String, dynamic> g = jsonDecode(response.body);
    String pert = particular;
    if (response.statusCode == 200) {
      part = g['lstService'];

      samples = part?.firstWhere((e) => e['categoryName'] == pert);
      Map<String, dynamic>? d;
      if (samples['serviceName'] == 'Package') {
        await fetchRate(g['lstService'][0]['categoryid'].toString(), "1");
      } else {
        await fetchRate(g['lstService'][0]['categoryid'].toString(), "0");
      }

      if (samples['serviceName'] == 'Package') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                //Addnewtest(g,null,sample)));
                NewPackage(
                  widget.patient,
                  samples,
                  widget.testList,
                )));
      } else {
        var selectedSampleData =
            part?.firstWhere((e) => e['categoryName'] == pert);

        debugPrint('sampledata');

        quantity.text = '1';
        sample_id = removeLastPart(selectedSampleData['categoryName']);
        var categoryid = selectedSampleData['categoryid'];
        debugPrint(sample_id);
        d = widget.testList!
            .where((element) => element['subServiceId'] == categoryid!)
            .first;
        sampleId = d!['sampleId'].toString();
        sampleName.text = d['sampleName'];
      }
      setState(() {});
    } else {
      CustomMessage.toast('Invalid ');
    }
  }

  String removeLastPart(String input) {
    int lastIndex = input.lastIndexOf('-');
    if (lastIndex != -1) {
      return input.substring(0, lastIndex).trim();
    }
    return input;
  }

  String getFirstPart(String subServiceId) {
    if (subServiceId.contains(',')) {
      return subServiceId.split(',')[0]; // Split by ',' and take the first part
    } else {
      return subServiceId; // Take the string as is
    }
  }
}
