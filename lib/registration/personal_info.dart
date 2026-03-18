import 'dart:async';
import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/registration/model/ref_doctor_list_model.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:age_calculator/age_calculator.dart';
import 'package:dishabtob/btob_queue/b2bqueue.dart';
import 'package:dishabtob/registration/add_doctor.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get_patient.dart';

class PersonalInfo extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final dynamic details;
  final String? access;

  const PersonalInfo(this.patient, this.details, this.access, {super.key});

  @override
  PersonalInfoState createState() => PersonalInfoState();
}

class PersonalInfoState extends State<PersonalInfo> {
  Map<String, dynamic>? user;
  TimeOfDay selectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  String? _hour, _minute, _time;
  bool load = false;
  bool pre = false;
  Map<String, dynamic>? decode;
  bool c = false;
  bool doc = false;
  List<LstDocDetailsDto>? Refdoc;
  String? customertype;
  String? customertypename;
  List<dynamic>? IPD;
  bool _switchValue = false;
  String? title;

  String? nation = 'Country';
  String? gen;

  bool visible = false;

  String? specialcase;
  List<dynamic>? countrycode;
  Map<String, dynamic>? countri;
  List<String> speciallist = [
    "Pregnancy",
    "First Trimester",
    "Second Trimester",
    "Third Trimester",
  ];

  List<dynamic>? statelist = [];
  List<dynamic>? districtlist = [];
  List<dynamic>? item;
  List<dynamic>? nationality;

  // List<String> gender = ["Male", "Female", "Transgender"];
  FocusNode fusername = FocusNode();
  TextEditingController username = TextEditingController();

  // FocusNode ffirst = FocusNode();
  // TextEditingController firstname = TextEditingController();
  FocusNode fgender = FocusNode();
  TextEditingController gender = TextEditingController();
  FocusNode fmiddle = FocusNode();
  TextEditingController middlename = TextEditingController();
  FocusNode flastname = FocusNode();
  TextEditingController lastname = TextEditingController();
  FocusNode femail = FocusNode();
  TextEditingController email = TextEditingController();
  FocusNode fcontact = FocusNode();
  TextEditingController contact = TextEditingController();
  FocusNode fage = FocusNode();
  TextEditingController age = TextEditingController();
  FocusNode fyear = FocusNode();
  TextEditingController year = TextEditingController();
  FocusNode fmonth = FocusNode();
  TextEditingController month = TextEditingController();
  FocusNode fday = FocusNode();
  TextEditingController day = TextEditingController();
  FocusNode faddress = FocusNode();
  TextEditingController address = TextEditingController();
  FocusNode fpincode = FocusNode();
  TextEditingController pincode = TextEditingController();
  FocusNode frefdoc_no = FocusNode();
  TextEditingController ref_docno = TextEditingController();
  FocusNode fexpid = FocusNode();
  TextEditingController extpatid = TextEditingController();
  FocusNode fb2bid = FocusNode();
  TextEditingController b2bpatid = TextEditingController();
  FocusNode flmpdate = FocusNode();
  TextEditingController lmpdate = TextEditingController();
  FocusNode fpathistory = FocusNode();
  TextEditingController pat_history = TextEditingController();
  FocusNode fcollection_date = FocusNode();
  TextEditingController collection_date = TextEditingController();
  FocusNode fcollection_time = FocusNode();
  TextEditingController collection_time = TextEditingController();
  FocusNode fstate = FocusNode();
  TextEditingController state = TextEditingController();
  FocusNode fdistrict = FocusNode();
  TextEditingController district = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? unitname;

  var businessMasterGeneralInfoDto;
  var businessMasterAddressInfoDto;

  TextEditingController firstName = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  bool isListeningLastName = false;

  TextEditingController ref_doc = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isListening = false;

  var patientList;

  @override
  void initState() {
    // debugPrint('detsildef');

    // getUser();
    // setState(() {
    //   load = true;
    //   doc = true;
    //   c = true;
    //   pre = true;
    // });
    // fetchPrefix();
    // // FetchGender();
    // _hour = TimeOfDay.now().hour.toString();
    // _minute = TimeOfDay.now().minute.toString();
    // _time = _minute!.length == 1
    //     ? '${_hour!}:0${_minute!}'
    //     : '${_hour!}:${_minute!}';
    //
    // widget.details == null
    //     ? setState(() {
    //         user = {};
    //         collection_time.text = _time!;
    //         collection_date.text =
    //             DateFormat('dd/MM/yyyy').format(DateTime.now());
    //       })
    //     : setState(() {
    //         user = widget.details;
    //       });
    // var t;
    //
    // Future.delayed(const Duration(seconds: 3), () {
    //
    //   if (widget.details != null) {
    //     debugPrint('user');
    //
    //     t = user!['country_code'] == 0
    //         ? null
    //         : countrycode!.where(
    //             (element) => element['idCountryPK'] == user!['country_code']);
    //
    //     // setState(() {
    //
    //     _switchValue = user!['emergencyFlag'] == 'Y' ? true : false;
    //     final prefixExists = item?.any((i) =>
    //             i['lookupDetDescEn']?.toString().trim() ==
    //             user!['prefix']?.toString().trim()) ??
    //         false;
    //
    //     title = prefixExists ? user!['prefix'] : null;
    //     // firstName.text = FlavorConfig.instance.name == "B2BLifenity"
    //     //     ? user!['fname'] ?? ''
    //     //     : user!['fName'] ?? '';
    //     firstName.text = user!['fName'] ?? '';
    //     // middlename.text = FlavorConfig.instance.name == "B2BLifenity"
    //     //     ? user!['mname']
    //     //     : user!['mName'];
    //     // middlename.text = user!['mName'];
    //     //   lastname.text = FlavorConfig.instance.name == "B2BLifenity"
    //     //       ? user!['lname']
    //     //       : user!['lName'];
    //     middlename.text = user!['mName'] ?? "";
    //     lastname.text = user!['lName'] ?? "";
    //     // email.text = user!['emailId'] ?? "";
    //     // contact.text = user!['mobile'] ?? "";
    //     gender.text = user!['gender'] ?? "";
    //     age.text = user!['dob'] ?? "";
    //     year.text = user!['age'] != null ? user!['age'].toString() : "0";
    //     month.text =
    //         user!['ageMonths'] != null ? user!['ageMonths'].toString() : "0";
    //     day.text = user!['ageDays'] != null ? user!['ageDays'].toString() : '0';
    //     username.text = t == null ? "" : t.first['countryCode'].toString();
    //     nation = t == null ? "" : t.first['countryName'].toString();
    //     address.text = user!['address'];
    //     pincode.text =
    //         user!['txtPincode'] != null ? user!['txtPincode'].toString() : "";
    //     // state.text = user!['stateId'] == 0 || user!['stateId'] == null
    //     //     ? ''
    //     //     : statelist![user!['stateId']].toString();
    //     // district.text = user!['districtId'] == 0
    //     //     ? ''
    //     //     : districtlist![user!['districtId']];
    //
    //     ref_doc.text =
    //         (user!['refDoctorName'] != '' && user!['refDoctorName'] != null)
    //             ? user!['refDoctorName']
    //             : '';
    //     // ref_docno.text =FlavorConfig.instance.name == "B2BLifenity"
    //     //     ? user!['doctorMobileNumber']
    //     //     :  user!['doctorMobileNo'].toString();
    //     ref_docno.text = user!['doctorMobileNo'].toString();
    //
    //     extpatid.text = user!['externalPatientId'].toString();
    //     // specialcase=user!['specialCase'];
    //     lmpdate.text = user!['lmpDate'] ?? '';
    //     // b2bpatid.text = FlavorConfig.instance.name == "B2BLifenity"
    //     //     ? user!['b2bPatientId']
    //     //     : user!['b2b_patient_id'].toString();
    //
    //     b2bpatid.text = user!['b2b_patient_id'].toString();
    //
    //     pat_history.text = user!['patientHistory'].toString();
    //     collection_date.text =
    //         widget.access == 'view' || widget.access == 'edit'
    //             ? user!['collectionDate'].toString()
    //             : DateFormat('dd-MM-yyyy').format(DateTime.now());
    //     collection_time.text =
    //         widget.access == 'view' || widget.access == 'edit'
    //             ? user!['collectionTime'].toString()
    //             : _time!;
    //     setState(() {});
    //   }
    // });
    super.initState();
    _initializeData();
    year.addListener(_updateDobFromFields);
    month.addListener(_updateDobFromFields);
    day.addListener(_updateDobFromFields);

    // _initializeSpeechRecognition();
  }

  @override
  void dispose() {
    super.dispose();
    _speech
        .stop(); // Ensure to stop speech recognition when the widget is disposed
  }

  Future<void> _initializeData() async {
    setState(() {
      load = true;
      doc = true;
      c = true;
      pre = true;
    });

    // Initialize time
    _hour = TimeOfDay.now().hour.toString();
    _minute = TimeOfDay.now().minute.toString();
    _time = _minute!.length == 1
        ? '${_hour!}:0${_minute!}'
        : '${_hour!}:${_minute!}';

    try {
      // Load ALL required data FIRST - wait for everything to complete
      // await Future.wait([
      //   getUser(),
      //   fetchPrefix(),
      //   fetchRefDoctor(),
      //   // Add any other fetch methods here like:
      //   // fetchCountryCode(),
      //   // fetchGender(),
      // ]);

      await Future.wait<void>([
        getUser(),
        fetchPrefix(),
      ]);

      // NOW set the form values after all data is loaded
      if (widget.details == null) {
        // New patient
        setState(() {
          user = {};
          collection_time.text = _time!;
          collection_date.text =
              DateFormat('dd/MM/yyyy').format(DateTime.now());
        });
      } else {
        // Editing existing patient
        _populateFormData();
      }
    } catch (e) {
      debugPrint('Error initializing data: $e');
      // Show error to user
      CustomMessage.toast('Error loading data');
    } finally {
      // Always turn off loading indicators
      setState(() {
        load = false;
        doc = false;
        c = false;
        pre = false;
      });
    }

    await _initializeSpeechRecognition();
  }

  void _populateFormData() {
    setState(() {
      user = widget.details;
    });

    if (user == null) return;

    // var t = user!['country_code'] == 0
    //     ? null
    //     : countrycode!.where(
    //         (element) => element['idCountryPK'] == user!['country_code']);

    _switchValue = user!['emergencyFlag'] == 'Y' ? true : false;

    // ✅ SAFE PREFIX SETTING - Only set if it exists in the list
    final prefixValue = user!['prefix']?.toString().trim() ?? "";
    final prefixExists = item?.any(
            (i) => i['lookupDetDescEn']?.toString().trim() == prefixValue) ??
        false;

    title = prefixExists ? prefixValue : null;

    // Set all other fields
    firstName.text = user!['fName'] ?? '';
    middlename.text = user!['mName'] ?? "";
    lastname.text = user!['lName'] ?? "";
    gender.text = user!['gender'] ?? "";
    age.text = user!['dob'] ?? "";
    year.text = user!['age']?.toString() ?? "0";
    month.text = user!['ageMonths']?.toString() ?? "0";
    day.text = user!['ageDays']?.toString() ?? '0';

    username.text = countri!['countryCode'].toString();

    nation = countri!['countryName'].toString();
    address.text = (user!['address'] == null || user!['address'] == '')
        ? businessMasterAddressInfoDto[0]['address']
        : user!['address'] ?? '';
    pincode.text = user!['txtPincode']?.toString() ?? "";

    ref_doc.text =
        (user!['refDoctorName'] != '' && user!['refDoctorName'] != null)
            ? user!['refDoctorName']
            : '';
    ref_docno.text = user!['doctorMobileNo']?.toString() ?? "";
    extpatid.text = user!['externalPatientId']?.toString() ?? "";
    lmpdate.text = user!['lmpDate'] ?? '';
    b2bpatid.text = user!['b2b_patient_id']?.toString() ?? "";
    pat_history.text = user!['patientHistory']?.toString() ?? "";

    collection_date.text = (widget.access == 'view' || widget.access == 'edit')
        ? user!['collectionDate']?.toString() ??
            DateFormat('dd/MM/yyyy').format(DateTime.now())
        : DateFormat('dd/MM/yyyy').format(DateTime.now());

    collection_time.text = (widget.access == 'view' || widget.access == 'edit')
        ? user!['collectionTime']?.toString() ?? _time!
        : _time!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensures taps are detected everywhere
      onTap: dismissKeyboard,
      child: StreamProvider<NetworkStatus>(
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          initialData: NetworkStatus.Online,
          child: NetworkAwareWidget(
              onlineChild: Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                      child: doc && load && c && pre
                          ? Padding(
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: AppColours.blue,
                              )))
                          : Container(
                              color: Colors.white,
                              child: Form(
                                  key: _formKey,
                                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 4),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                  // Shadow color with opacity
                                                  spreadRadius: 2,
                                                  // Spread radius
                                                  blurRadius: 3,
                                                  // Blur radius
                                                  offset: const Offset(0,
                                                      3), // Offset in x and y direction
                                                ),
                                              ]),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // Aligns text properly
                                            children: [
                                              Expanded(
                                                // Allows text to use available space
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // Prevents text cutoff
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Name : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Flexible(
                                                          // Ensures text wraps
                                                          child: Text(
                                                            customertypename!,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            // Ensures multi-line wrapping
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Type : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            customertype!,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Unit : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 11),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            unitname!.trim(),
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  const Text(
                                                    'Emergency',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                  Row(children: [
                                                    const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10),
                                                    ),
                                                    CupertinoSwitch(
                                                      value: _switchValue,
                                                      activeColor:
                                                          AppColours.blue,
                                                      onChanged: (value) {
                                                        widget.access == 'view'
                                                            ? {}
                                                            : setState(() {
                                                                _switchValue =
                                                                    value;
                                                              });
                                                      },
                                                    ),
                                                    Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color:
                                                              AppColours.blue,
                                                          fontSize: 10),
                                                    ),
                                                  ])
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Card(
                                            child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            gradient: LinearGradient(
                                                colors: [
                                                  AppColours.blue,
                                                  AppColours.orange
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 0.0),
                                                stops: const [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: ExpansionTile(
                                            clipBehavior: Clip.none,
                                            initiallyExpanded: true,
                                            onExpansionChanged: (value) {
                                              setState(() {
                                                visible = true;
                                              });
                                            },
                                            iconColor: Colors.white,
                                            collapsedIconColor: Colors.white,
                                            shape: const Border(
                                                top: BorderSide(
                                                    color: Colors.white),
                                                bottom: BorderSide(
                                                    color: Colors.white)),
                                            // collapsedShape:  RoundedRectangleBorder(
                                            //     side:new  BorderSide(color:Colors.white), //the outline color
                                            //     borderRadius:  BorderRadius.all( Radius.circular(20))),
                                            // collapsedBackgroundColor: Colors.white,

                                            title: const Text(
                                              "Personal Details ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.85,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                          child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            10))),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                        child: DropdownButton(
                                                          underline: Container(
                                                            color: Colors.white,
                                                          ),
                                                          hint: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Prefix',
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
                                                          autofocus: true,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          isExpanded: true,
                                                          dropdownColor:
                                                              Colors.white,
                                                          iconEnabledColor:
                                                              Colors.black54,
                                                          // value: title,
                                                          value: (item?.any((i) =>
                                                                      i['lookupDetDescEn'] ==
                                                                      title) ??
                                                                  false)
                                                              ? title
                                                              : null,
                                                          items: item?.map(
                                                                  (country) {
                                                                return DropdownMenuItem(
                                                                  value: country[
                                                                      'lookupDetDescEn'],
                                                                  child: Text(
                                                                    country[
                                                                        'lookupDetDescEn'],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                );
                                                              }).toList() ??
                                                              [],
                                                          onChanged:
                                                              (selectedTitle) {
                                                            if (widget.access ==
                                                                'view') {
                                                            } else {
                                                              title = selectedTitle !=
                                                                      null
                                                                  ? selectedTitle
                                                                      .toString()
                                                                  : "";
                                                              fetchGender(
                                                                  title);
                                                              FocusScope.of(
                                                                      context)
                                                                  .nextFocus();
                                                              setState(() {});
                                                            }
                                                            // widget.access == 'view'
                                                            //     ? {}
                                                            //     : {
                                                            //         setState(() {
                                                            //           title = country
                                                            //               as String?;
                                                            //           FetchGender(
                                                            //               title);
                                                            //           FocusScope.of(
                                                            //                   context)
                                                            //               .nextFocus();
                                                            //         }),
                                                            //       };
                                                          },
                                                        ),
                                                      )),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      Center(
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          // height: MediaQuery.of(context).size.height *
                                                          //     0.07,
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                firstName.text =
                                                                    value;
                                                              });
                                                            },
                                                            enabled:
                                                                widget.access ==
                                                                        'view'
                                                                    ? false
                                                                    : true,
                                                            controller:
                                                                firstName,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .characters,
                                                            //focusNode: fpassword,
                                                            //obscureText: _obscured,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .trim()
                                                                      .isEmpty) {
                                                                return "First Name can not be empty";
                                                              } else {
                                                                return null;
                                                              }
                                                            },

                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            cursorColor:
                                                                Colors.black,
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              isDense: true,
                                                              fillColor: Colors
                                                                  .transparent,
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  _isListening
                                                                      ? Icons
                                                                          .mic
                                                                      : Icons
                                                                          .mic_none,
                                                                  color: _isListening
                                                                      ? Colors
                                                                          .green
                                                                      : null,
                                                                  size: 24,
                                                                ),
                                                                onPressed: () {
                                                                  if (_isListening) {
                                                                    stopListening();
                                                                  } else {
                                                                    startListeningFirstName();
                                                                  }
                                                                },
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0,
                                                                ),
                                                              ),

                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .grey,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                              prefixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        4,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  //   onTap: _toggleObscured,
                                                                  child: Icon(
                                                                    Icons
                                                                        .person_outline_sharp,
                                                                    color: Colors
                                                                        .black87
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
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
                                                                          'First Name',
                                                                      style: TextStyle(
                                                                          color: Colors.black87.withOpacity(
                                                                              0.7),
                                                                          fontSize:
                                                                              14),
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
                                                              // labelText: 'Password',
                                                              // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .auto,

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
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      Center(
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
                                                              0.07,
                                                          child: TextFormField(
                                                            enabled:
                                                                widget.access ==
                                                                        'view'
                                                                    ? false
                                                                    : true,
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
                                                            // Unitname(username.text);},

                                                            focusNode: fmiddle,
                                                            autofocus: true,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            controller:
                                                                middlename,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .characters,

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
                                                                  color: Colors
                                                                      .grey,
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
                                                                  color: Colors
                                                                      .grey,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                              prefixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        4,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  //   onTap: _toggleObscured,
                                                                  child: Icon(
                                                                    Icons
                                                                        .person_outline_sharp,
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
                                                                      fontSize:
                                                                          14),
                                                              label: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'Middle Name',
                                                                      style: TextStyle(
                                                                          color: Colors.black87.withOpacity(
                                                                              0.7),
                                                                          fontSize:
                                                                              14),
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
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      Center(
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
                                                              0.07,
                                                          child: TextFormField(
                                                            enabled:
                                                                widget.access ==
                                                                        'view'
                                                                    ? false
                                                                    : true,
                                                            // onEditingComplete: () {
                                                            //   FocusScope.of(context)
                                                            //       .nextFocus();
                                                            // },
                                                            // //  Unitname(username.text);},
                                                            // onFieldSubmitted:
                                                            //     (value) {
                                                            //   FocusScope.of(context)
                                                            //       .nextFocus();
                                                            // },
                                                            // Unitname(username.text);},

                                                            // focusNode: flastname,
                                                            // autofocus: true,
                                                            // textInputAction:
                                                            //     TextInputAction.done,
                                                            controller:
                                                                lastname,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .characters,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                lastname.text =
                                                                    value;
                                                              });
                                                            },
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            cursorColor:
                                                                Colors.black,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  isListeningLastName
                                                                      ? Icons
                                                                          .mic
                                                                      : Icons
                                                                          .mic_none,
                                                                  color: isListeningLastName
                                                                      ? Colors
                                                                          .green
                                                                      : null,
                                                                ),
                                                                onPressed: () {
                                                                  if (isListeningLastName) {
                                                                    stopListening();
                                                                  } else {
                                                                    startListeningLastName();
                                                                  }
                                                                },
                                                              ),

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
                                                                  color: Colors
                                                                      .grey,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                              prefixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        4,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  //   onTap: _toggleObscured,
                                                                  child: Icon(
                                                                    Icons
                                                                        .person_outline_sharp,
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
                                                                      fontSize:
                                                                          14),
                                                              label: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'Last Name',
                                                                      style: TextStyle(
                                                                          color: Colors.black87.withOpacity(
                                                                              0.7),
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    const TextSpan(
                                                                      text:
                                                                      ' *',
                                                                      style: TextStyle(
                                                                          color: Colors.red,
                                                                          fontSize:
                                                                          14),
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
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Center(
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.38,
                                                                  // height: MediaQuery.of(context).size.height *
                                                                  //     0.07,
                                                                  child:
                                                                      TextFormField(
                                                                    enabled: widget.access ==
                                                                            'view'
                                                                        ? false
                                                                        : true,
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
                                                                    // Unitname(username.text);},

                                                                    focusNode:
                                                                        fgender,
                                                                    autofocus:
                                                                        true,
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .done,
                                                                    controller:
                                                                        gender,
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .characters,
                                                                    //focusNode: fpassword,
                                                                    //obscureText: _obscured,
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .trim()
                                                                              .isEmpty) {
                                                                        return "Gender can not be empty";
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      errorMaxLines:
                                                                          1,
                                                                      isDense:
                                                                          true,
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .transparent,

                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.grey,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.red,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      disabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.grey,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                      prefixIcon:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            4,
                                                                            0),
                                                                        child:
                                                                            GestureDetector(
                                                                          //   onTap: _toggleObscured,
                                                                          child:
                                                                              Icon(
                                                                            Icons.male,
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //hintText: 'Enter Username',
                                                                      hintStyle:
                                                                          const TextStyle(
                                                                              fontSize: 14),
                                                                      label:
                                                                          RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                              text: 'Gender',
                                                                              style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 14),
                                                                            ),
                                                                            const TextSpan(
                                                                              text: '*',
                                                                              style: TextStyle(color: Colors.red),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // labelText: 'Password',
                                                                      // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                      floatingLabelBehavior:
                                                                          FloatingLabelBehavior
                                                                              .auto,

                                                                      floatingLabelStyle: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.38,
                                                                  // height: MediaQuery.of(context).size.height*0.074 ,
                                                                  child: DropdownSearch<
                                                                      dynamic>(
                                                                    items: countrycode
                                                                            ?.map((country) {
                                                                          return country['countryName']
                                                                              .toString();
                                                                        }).toList() ??
                                                                        [],
                                                                    popupProps:
                                                                        const PopupProps
                                                                            .menu(
                                                                      showSearchBox:
                                                                          true,
                                                                    ),
                                                                    dropdownButtonProps:
                                                                        const DropdownButtonProps(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    dropdownDecoratorProps:
                                                                        DropDownDecoratorProps(
                                                                      textAlignVertical:
                                                                          TextAlignVertical
                                                                              .center,
                                                                      dropdownSearchDecoration:
                                                                          InputDecoration(
                                                                              border: OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey.shade800),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      )),
                                                                    ),
                                                                    onChanged:
                                                                        (country) {
                                                                      setState(
                                                                          () {
                                                                        nation =
                                                                            country
                                                                                as String;
                                                                        debugPrint(
                                                                            nation);
                                                                        List demo = countrycode!
                                                                            .where((element) =>
                                                                                element['countryName'] ==
                                                                                nation)
                                                                            .toList();

                                                                        countri =
                                                                            demo.first;

                                                                        // List demo=countrycode!.where(
                                                                        //         (x) => x.contains(nation)
                                                                        // ).toList();
                                                                        // debugPrint(demo);
                                                                        // countri=demo.first;
                                                                        FocusScope.of(context)
                                                                            .nextFocus();
                                                                      });
                                                                    },
                                                                    selectedItem:
                                                                        nation,
                                                                  )),
                                                            ]),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                c
                                                                    ? const CircularProgressIndicator(
                                                                        color: Colors
                                                                            .indigo,
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.28,
                                                                          height:
                                                                              MediaQuery.of(context).size.height * 0.07,
                                                                          child:
                                                                              TextFormField(
                                                                            enabled:
                                                                                false,
                                                                            focusNode:
                                                                                fusername,
                                                                            autofocus:
                                                                                true,
                                                                            textInputAction:
                                                                                TextInputAction.done,
                                                                            controller:
                                                                                username,
                                                                            style:
                                                                                const TextStyle(color: Colors.black),
                                                                            cursorColor:
                                                                                Colors.black,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              filled: true,
                                                                              fillColor: Colors.transparent,

                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                borderSide: const BorderSide(
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                borderSide: const BorderSide(
                                                                                  color: Colors.red,
                                                                                  width: 1.0,
                                                                                ),
                                                                              ),
                                                                              disabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                borderSide: const BorderSide(
                                                                                  color: Colors.grey,
                                                                                  width: 1.0,
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
                                                                              // prefixIcon: Padding(
                                                                              //   padding:
                                                                              //   const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                                                              //   child: GestureDetector(
                                                                              //     //   onTap: _toggleObscured,
                                                                              //     child: Icon(
                                                                              //       Icons.mail_outline,
                                                                              //       color:Colors.black87.withOpacity(0.7),
                                                                              //     ),
                                                                              //   ),
                                                                              // ),

                                                                              //hintText: 'Enter Username',
                                                                              hintStyle: const TextStyle(fontSize: 14),
                                                                              label: RichText(
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    TextSpan(
                                                                                      text: countri != null ? '${countri!['countryCode']}-${countri!['countryName']}' : 'Country Code',
                                                                                      style: const TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              // labelText: 'Password',
                                                                              // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                              floatingLabelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5,
                                                                    // height: MediaQuery.of(context)
                                                                    //         .size
                                                                    //         .height *
                                                                    //     0.07,
                                                                    child:
                                                                        TextFormField(
                                                                      onEditingComplete:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .nextFocus();
                                                                      },
                                                                      enabled: widget.access ==
                                                                              'view'
                                                                          ? false
                                                                          : true,
                                                                      //  Unitname(username.text);},
                                                                      onFieldSubmitted:
                                                                          (value) {
                                                                        FocusScope.of(context)
                                                                            .nextFocus();
                                                                      },
                                                                      // Unitname(username.text);},

                                                                      focusNode:
                                                                          fcontact,
                                                                      autofocus:
                                                                          true,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .done,
                                                                      controller:
                                                                          contact,

                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      inputFormatters: <TextInputFormatter>[
                                                                        LengthLimitingTextInputFormatter(
                                                                            10),
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp("[0-9]")),
                                                                      ],
                                                                      //focusNode: fpassword,
                                                                      //obscureText: _obscured,
                                                                      validator:
                                                                          (value) {
                                                                        if (value == null ||
                                                                            value
                                                                                .trim()
                                                                                .isEmpty ||
                                                                            RegExp(r"^\+?0[0-9]{10}$").hasMatch(
                                                                                value) ||
                                                                            value ==
                                                                                "" ||
                                                                            value.length <
                                                                                10) {
                                                                          return "Contact Number can not be empty";
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                      cursorColor:
                                                                          Colors
                                                                              .black,

                                                                      decoration:
                                                                          InputDecoration(
                                                                        // errorMaxLines: 2,
                                                                        //   errorStyle: TextStyle(fontSize: 7),
                                                                        isDense:
                                                                            true,
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.transparent,
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.red,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),

                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        disabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.grey,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.grey,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                        //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                        prefixIcon:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              4,
                                                                              0),
                                                                          child:
                                                                              GestureDetector(
                                                                            //   onTap: _toggleObscured,
                                                                            child:
                                                                                Icon(
                                                                              Icons.phone_android,
                                                                              color: Colors.black87.withOpacity(0.7),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        //hintText: 'Enter Username',
                                                                        hintStyle:
                                                                            const TextStyle(fontSize: 14),
                                                                        label:
                                                                            RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: 'Mobile',
                                                                                style: TextStyle(color: Colors.black87.withOpacity(0.7), fontSize: 14),
                                                                              ),
                                                                              const TextSpan(
                                                                                text: '*',
                                                                                style: TextStyle(color: Colors.red),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        // labelText: 'Password',
                                                                        // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                        floatingLabelStyle: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ])),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      Center(
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: TextFormField(
                                                            enabled:
                                                                widget.access ==
                                                                        'view'
                                                                    ? false
                                                                    : true,
                                                            controller: email,
                                                            validator: (value) {
                                                              if (value!
                                                                      .isEmpty ||
                                                                  !(RegExp(
                                                                          r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$')
                                                                      .hasMatch(
                                                                          value))) {
                                                                return "Enter Proper format ";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12),
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
                                                                  color: Colors
                                                                      .grey,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              isDense: true,
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                              prefixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        4,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  //   onTap: _toggleObscured,
                                                                  child: Icon(
                                                                    Icons
                                                                        .mail_outline,
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
                                                                      fontSize:
                                                                          14),
                                                              label: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'Email Id',
                                                                      style: TextStyle(
                                                                          color: Colors.black87.withOpacity(
                                                                              0.7),
                                                                          fontSize:
                                                                              14),
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
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      Center(
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: TextFormField(
                                                            onEditingComplete: () =>
                                                                FocusScope.of(
                                                                        context)
                                                                    .nextFocus(),
                                                            focusNode: fage,
                                                            enabled:
                                                                widget.access ==
                                                                        'view'
                                                                    ? false
                                                                    : true,
                                                            autofocus: true,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            controller: age,
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            onTap: () async {
                                                              DateTime?
                                                                  pickedDate =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context,
                                                                        child) {
                                                                  return Theme(
                                                                    data: Theme.of(
                                                                            context)
                                                                        .copyWith(
                                                                      colorScheme:
                                                                          ColorScheme
                                                                              .light(
                                                                        primary:
                                                                            AppColours.blue,
                                                                        // <-- SEE HERE
                                                                        onPrimary:
                                                                            Colors.white,
                                                                        // <-- SEE HERE
                                                                        onSurface:
                                                                            AppColours.blue, // <-- SEE HERE
                                                                      ),
                                                                      textButtonTheme:
                                                                          TextButtonThemeData(
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              AppColours.blue, // button text color
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        child!,
                                                                  );
                                                                },
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                //get today's date
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                //DateTime.now() - not to allow to choose before today.
                                                                lastDate: DateTime
                                                                        .now()
                                                                    .add(const Duration(
                                                                        days:
                                                                            0)),
                                                              );
                                                              if (pickedDate !=
                                                                  null) {
                                                                // Get the picked date in the format => 2022-07-04
                                                                String
                                                                    formattedDate =
                                                                    DateFormat(
                                                                            'dd-MM-yyyy')
                                                                        .format(
                                                                            pickedDate);
                                                                debugPrint(
                                                                    formattedDate);

                                                                setState(() {
                                                                  age.text =
                                                                      formattedDate;

                                                                  // Calculate the total days difference
                                                                  int totalDays = DateTime
                                                                          .now()
                                                                      .difference(
                                                                          pickedDate)
                                                                      .inDays;

                                                                  // Ensure the days logic is handled for today and yesterday
                                                                  int years =
                                                                      totalDays ~/
                                                                          365;
                                                                  int months =
                                                                      (totalDays %
                                                                              365) ~/
                                                                          30;
                                                                  int days =
                                                                      (totalDays %
                                                                              365) %
                                                                          30;

                                                                  // If the picked date is today, set days to 1
                                                                  if (totalDays ==
                                                                      0) {
                                                                    years = 0;
                                                                    months = 0;
                                                                    days = 1;
                                                                  }

                                                                  // If the picked date is yesterday, set days to 2
                                                                  else if (totalDays ==
                                                                      1) {
                                                                    years = 0;
                                                                    months = 0;
                                                                    days = 2;
                                                                  }

                                                                  // For all other dates, use the calculated totalDays logic
                                                                  else {
                                                                    days = totalDays %
                                                                        30; // Keep the standard day calculation for other cases
                                                                  }

                                                                  // Use AgeCalculator for proper year/month differences in case of larger date differences
                                                                  DateDuration
                                                                      duration =
                                                                      AgeCalculator
                                                                          .dateDifference(
                                                                    fromDate: DateTime(
                                                                        pickedDate
                                                                            .year,
                                                                        pickedDate
                                                                            .month,
                                                                        pickedDate
                                                                            .day),
                                                                    toDate:
                                                                        DateTime
                                                                            .now(),
                                                                  );

                                                                  // Update the fields with the calculated age
                                                                  year.text = years
                                                                      .toString();
                                                                  month.text =
                                                                      months
                                                                          .toString();
                                                                  day.text = days
                                                                      .toString();

                                                                  // If the calculated years are less than 0, handle as an invalid date
                                                                  if (years <
                                                                      0) {
                                                                    CustomMessage
                                                                        .toast(
                                                                            'Age cannot be less than 0');
                                                                    year.clear();
                                                                    month
                                                                        .clear();
                                                                    day.clear();
                                                                    age.clear();
                                                                  }
                                                                });
                                                              } else {
                                                                debugPrint(
                                                                    "Date is not selected");
                                                              }
                                                            },
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            cursorColor:
                                                                Colors.black,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,

                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .red,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
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
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                              suffixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        4,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {},
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ),
                                                              prefixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        4,
                                                                        0),
                                                                child:
                                                                    GestureDetector(
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
                                                                      fontSize:
                                                                          14),
                                                              label: RichText(
                                                                text:
                                                                    const TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          'DOB',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    TextSpan(
                                                                      text: '*',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // labelText: 'Password',
                                                              // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                              floatingLabelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.225,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              onEditingComplete: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .nextFocus(),
                                                              focusNode: fyear,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller: year,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .red,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                //hintText: 'Enter Username',
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      const TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Years',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.225,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              onEditingComplete: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .nextFocus(),
                                                              focusNode: fmonth,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller: month,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              //focusNode: fpassword,
                                                              //obscureText: _obscured,
                                                              // validator: (value) {
                                                              //   if (value!.trim().isEmpty) {
                                                              //     return "Month can not be empty";
                                                              //   } else {
                                                              //     return null;
                                                              //   }
                                                              // },
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                //hintText: 'Enter Username',
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      const TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Months',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.225,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              onEditingComplete: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .nextFocus(),
                                                              focusNode: fday,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller: day,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              //focusNode: fpassword,
                                                              //obscureText: _obscured,
                                                              // validator: (value) {
                                                              //   if (value!.trim().isEmpty) {
                                                              //     return "Days can not be empty";
                                                              //   } else {
                                                              //     return null;
                                                              //   }
                                                              // },
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                //hintText: 'Enter Username',
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      const TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Days',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                        Card(
                                            child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            gradient: LinearGradient(
                                                colors: [
                                                  AppColours.blue,
                                                  AppColours.orange
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 0.0),
                                                stops: const [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: ExpansionTile(
                                            iconColor: Colors.white,
                                            collapsedIconColor: Colors.white,
                                            shape: const Border(
                                                top: BorderSide(
                                                    color: Colors.white),
                                                bottom: BorderSide(
                                                    color: Colors.white)),
                                            // collapsedShape:  RoundedRectangleBorder(
                                            //     side:new  BorderSide(color:Colors.white), //the outline color
                                            //     borderRadius:  BorderRadius.all( Radius.circular(20))),
                                            // collapsedBackgroundColor: Colors.white,

                                            title: const Text(
                                              "Residential Address",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.29,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
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
                                                            0.09,
                                                        child: TextFormField(
                                                          enabled:
                                                              widget.access ==
                                                                      'view'
                                                                  ? false
                                                                  : true,
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
                                                          // Unitname(username.text);},

                                                          focusNode: faddress,
                                                          autofocus: true,
                                                          maxLines: null,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          controller: address,
                                                          //focusNode: fpassword,
                                                          //obscureText: _obscured,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value
                                                                    .trim()
                                                                    .isEmpty) {
                                                              return "Address can not be empty";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13),
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
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.red,
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
                                                            //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                            prefixIcon: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      4,
                                                                      0),
                                                              child:
                                                                  GestureDetector(
                                                                //   onTap: _toggleObscured,
                                                                child: Icon(
                                                                  Icons
                                                                      .location_on_outlined,
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
                                                                    fontSize:
                                                                        14),
                                                            label: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Address',
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
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.002,
                                                    ),
                                                    Center(
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
                                                            0.07,
                                                        child: TextFormField(
                                                          enabled:
                                                              widget.access ==
                                                                      'view'
                                                                  ? false
                                                                  : true,
                                                          onEditingComplete:
                                                              () {
                                                            //FetchStateDistrict(pincode.text);
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          },
                                                          //  Unitname(username.text);},
                                                          onFieldSubmitted:
                                                              (value) {
                                                            //  FetchStateDistrict(pincode.text);
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          },
                                                          // Unitname(username.text);},

                                                          focusNode: fpincode,
                                                          autofocus: true,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          controller: pincode,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            LengthLimitingTextInputFormatter(
                                                                6),
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    "[0-9]")),
                                                          ],
                                                          // validator: (value) {
                                                          //   if (
                                                          //       RegExp(r"^\+?0[0-9]{6}$")
                                                          //           .hasMatch(value!) ||
                                                          //       value.length < 6) {
                                                          //     return "Pincode is not Valid";
                                                          //   } else {
                                                          //     return null;
                                                          //   }
                                                          // },
                                                          //focusNode: fpassword,
                                                          //obscureText: _obscured,
                                                          // validator: (value) {
                                                          //   if (va) {
                                                          //     return "Username can not be empty";
                                                          //   } else {
                                                          //     return null;
                                                          //   }
                                                          // },
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
                                                            //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                            prefixIcon: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      0,
                                                                      4,
                                                                      0),
                                                              child:
                                                                  GestureDetector(
                                                                //   onTap: _toggleObscured,
                                                                child: Icon(
                                                                  Icons.tag,
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
                                                                    fontSize:
                                                                        14),
                                                            label: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Pincode',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87
                                                                            .withOpacity(
                                                                                0.7),
                                                                        fontSize:
                                                                            14),
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
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          const SizedBox(),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.38,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              // maxLines: 4,
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              onEditingComplete:
                                                                  () {
                                                                // FetchStateDistrict(pincode.text);
                                                                FocusScope.of(
                                                                        context)
                                                                    .nextFocus();
                                                              },
                                                              //  Unitname(username.text);},
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                // FetchStateDistrict(pincode.text);
                                                                FocusScope.of(
                                                                        context)
                                                                    .nextFocus();
                                                              },
                                                              // Unitname(username.text);},

                                                              focusNode: fstate,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller: state,

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
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14),
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                //hintText: 'Enter Username',
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'State',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
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
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.38,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
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
                                                              // Unitname(username.text);},

                                                              focusNode:
                                                                  fdistrict,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  district,

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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                //hintText: 'Enter Username',
                                                                hintStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'District',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
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
                                                          const SizedBox()
                                                        ]),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                        Card(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      AppColours.blue,
                                                      AppColours.orange
                                                    ],
                                                    begin:
                                                        const FractionalOffset(
                                                            0.0, 0.0),
                                                    end: const FractionalOffset(
                                                        1.0, 0.0),
                                                    stops: const [0.0, 1.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: ExpansionTile(
                                                  iconColor: Colors.white,
                                                  collapsedIconColor:
                                                      Colors.white,
                                                  shape: const Border(
                                                      top: BorderSide(
                                                          color: Colors.white),
                                                      bottom: BorderSide(
                                                          color: Colors.white)),
                                                  // collapsedShape:  RoundedRectangleBorder(
                                                  //     side:new  BorderSide(color:Colors.white), //the outline color
                                                  //     borderRadius:  BorderRadius.all( Radius.circular(20))),
                                                  // collapsedBackgroundColor: Colors.white,

                                                  title: const Text(
                                                    "References",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.52,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade200),
                                                          color: Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          15))),
                                                      child: Column(children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets
                                                        //       .symmetric(
                                                        //       horizontal: 27,
                                                        //       vertical: 6),
                                                        //   child: TypeAheadField<
                                                        //       LstDocDetailsDto>(
                                                        //     controller: ref_doc,
                                                        //     focusNode: focusNode,
                                                        //     builder: (context,
                                                        //         controller,
                                                        //         focusNode) {
                                                        //       return TextFormField(
                                                        //         readOnly: false,
                                                        //         // Prevent manual typing, only allow selection & mic
                                                        //         controller:
                                                        //             controller,
                                                        //         autofocus: true,
                                                        //         focusNode:
                                                        //             focusNode,
                                                        //         decoration:
                                                        //             InputDecoration(
                                                        //           prefixIcon:
                                                        //               Image.asset(
                                                        //             'assets/stethoscope.png',
                                                        //             color: Colors
                                                        //                 .black,
                                                        //           ),
                                                        //           suffixIcon: Row(
                                                        //             mainAxisSize:
                                                        //                 MainAxisSize
                                                        //                     .min,
                                                        //             children: [
                                                        //               IconButton(
                                                        //                 icon: Icon(isListening
                                                        //                     ? Icons
                                                        //                         .mic
                                                        //                     : Icons
                                                        //                         .mic_none),
                                                        //                 onPressed:
                                                        //                     () {
                                                        //                   if (isListening) {
                                                        //                     ref_doc
                                                        //                         .clear();
                                                        //                     stopListening();
                                                        //                   } else {
                                                        //                     ref_doc
                                                        //                         .clear();
                                                        //                     startListening();
                                                        //                   }
                                                        //                 },
                                                        //               ),
                                                        //               const Icon(Icons
                                                        //                   .arrow_drop_down),
                                                        //             ],
                                                        //           ),
                                                        //           hintText:
                                                        //               "Select Ref. Doctor",
                                                        //           hintStyle:
                                                        //               const TextStyle(
                                                        //                   color: Colors
                                                        //                       .grey),
                                                        //           border:
                                                        //               OutlineInputBorder(
                                                        //             borderSide:
                                                        //                 const BorderSide(
                                                        //                     color: Colors
                                                        //                         .grey),
                                                        //             borderRadius:
                                                        //                 BorderRadius
                                                        //                     .circular(
                                                        //                         8),
                                                        //           ),
                                                        //           contentPadding:
                                                        //               const EdgeInsets
                                                        //                   .all(12),
                                                        //         ),
                                                        //         onTap: () {
                                                        //           ref_doc.clear();
                                                        //           showSuggestions(
                                                        //               context);
                                                        //         },
                                                        //       );
                                                        //     },
                                                        //     suggestionsCallback:
                                                        //         (pattern) {
                                                        //       if (pattern.isEmpty)
                                                        //         return Refdoc ?? [];
                                                        //
                                                        //       List<LstDocDetailsDto>?
                                                        //           suggestions =
                                                        //           Refdoc?.where((element) => element
                                                        //               .dName!
                                                        //               .toLowerCase()
                                                        //               .contains(pattern
                                                        //                   .toLowerCase())).toList();
                                                        //
                                                        //       if (suggestions ==
                                                        //               null ||
                                                        //           suggestions
                                                        //               .isEmpty) {
                                                        //         // Show "No Doctor Found" message but don't clear text field
                                                        //         return [
                                                        //           LstDocDetailsDto(
                                                        //               dName:
                                                        //                   "No Doctor Found")
                                                        //         ];
                                                        //       }
                                                        //
                                                        //       // Prioritize exact match first
                                                        //       suggestions
                                                        //           .sort((a, b) {
                                                        //         if (a.dName!
                                                        //                 .toLowerCase() ==
                                                        //             pattern
                                                        //                 .toLowerCase())
                                                        //           return -1;
                                                        //         if (b.dName!
                                                        //                 .toLowerCase() ==
                                                        //             pattern
                                                        //                 .toLowerCase())
                                                        //           return 1;
                                                        //         return 0;
                                                        //       });
                                                        //
                                                        //       return suggestions;
                                                        //     },
                                                        //     itemBuilder: (context,
                                                        //         suggestion) {
                                                        //       if (suggestion
                                                        //               .dName ==
                                                        //           "No Doctor Found") {
                                                        //         return const ListTile(
                                                        //           title: Text(
                                                        //             "No Doctor Found",
                                                        //             style: TextStyle(
                                                        //                 color: Colors
                                                        //                     .red),
                                                        //           ),
                                                        //         );
                                                        //       }
                                                        //       return ListTile(
                                                        //         title: Text(
                                                        //             suggestion
                                                        //                     .dName ??
                                                        //                 ''),
                                                        //       );
                                                        //     },
                                                        //     onSelected:
                                                        //         (suggestion) {
                                                        //       if (suggestion
                                                        //               .dName ==
                                                        //           "No Doctor Found") {
                                                        //         ref_doc.clear();
                                                        //         return;
                                                        //       }
                                                        //
                                                        //       setState(() {
                                                        //         ref_doc.text =
                                                        //             suggestion
                                                        //                     .dName ??
                                                        //                 '';
                                                        //
                                                        //         var selectedObjmm =
                                                        //             Refdoc
                                                        //                 ?.firstWhere(
                                                        //           (e) =>
                                                        //               e.dName ==
                                                        //               suggestion
                                                        //                   .dName!,
                                                        //           orElse: () =>
                                                        //               LstDocDetailsDto(),
                                                        //         );
                                                        //
                                                        //         ref_docno.text =
                                                        //             selectedObjmm
                                                        //                     ?.mob ??
                                                        //                 '';
                                                        //       });
                                                        //     },
                                                        //   ),
                                                        // ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      27,
                                                                  vertical: 6),
                                                          child: Focus(
                                                            onFocusChange:
                                                                (hasFocus) {
                                                              if (!hasFocus &&
                                                                  !_isValidDoctor(
                                                                      ref_doc
                                                                          .text)) {
                                                                // Don't clear if user manually types something
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            100),
                                                                    () {
                                                                  if (ref_doc
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      !Refdoc!.any((doctor) =>
                                                                          doctor
                                                                              .dName!
                                                                              .toLowerCase() ==
                                                                          ref_doc
                                                                              .text
                                                                              .toLowerCase())) {
                                                                    ref_doc
                                                                        .clear();
                                                                  }
                                                                });
                                                              }
                                                            },
                                                            child: TypeAheadField<
                                                                LstDocDetailsDto>(
                                                              controller:
                                                                  ref_doc,
                                                              // Main controller
                                                              focusNode:
                                                                  focusNode,
                                                              builder: (context,
                                                                  textEditingController,
                                                                  focusNode) {
                                                                return TextFormField(
                                                                  controller:
                                                                      textEditingController,
                                                                  // Use the main controller to allow typing
                                                                  focusNode:
                                                                      focusNode,
                                                                  autofocus:
                                                                      true,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    prefixIcon:
                                                                        Image
                                                                            .asset(
                                                                      'assets/stethoscope.png',
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    suffixIcon:
                                                                        Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        IconButton(
                                                                          icon: Icon(isListening
                                                                              ? Icons.mic
                                                                              : Icons.mic_none),
                                                                          onPressed:
                                                                              () {
                                                                            if (isListening) {
                                                                              ref_doc.clear();
                                                                              stopListening();
                                                                            } else {
                                                                              ref_doc.clear();
                                                                              startListening();
                                                                            }
                                                                          },
                                                                        ),
                                                                        const Icon(
                                                                            Icons.arrow_drop_down),
                                                                      ],
                                                                    ),
                                                                    hintText:
                                                                        "Select Ref. Doctor",
                                                                    hintStyle: const TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.grey),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            12),
                                                                  ),
                                                                  onTap: () {
                                                                    // Show all suggestions on tap
                                                                    textEditingController
                                                                        .clear();
                                                                    showSuggestions(
                                                                        context);
                                                                  },
                                                                  onFieldSubmitted:
                                                                      (value) {
                                                                    if (!_isValidDoctor(
                                                                        value)) {
                                                                      ref_doc
                                                                          .clear();
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                              suggestionsCallback:
                                                                  (pattern) {
                                                                if (pattern
                                                                    .isEmpty) {
                                                                  return Refdoc ??
                                                                      [];
                                                                }

                                                                List<LstDocDetailsDto>?
                                                                    suggestions =
                                                                    Refdoc?.where((element) => element
                                                                        .dName!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            pattern.toLowerCase())).toList();

                                                                if (suggestions ==
                                                                        null ||
                                                                    suggestions
                                                                        .isEmpty) {
                                                                  return [
                                                                    LstDocDetailsDto(
                                                                        dName:
                                                                            "No Doctor Found")
                                                                  ];
                                                                }

                                                                return suggestions;
                                                              },
                                                              itemBuilder:
                                                                  (context,
                                                                      suggestion) {
                                                                if (suggestion
                                                                        .dName ==
                                                                    "No Doctor Found") {
                                                                  return ListTile(
                                                                    onTap: () {
                                                                      ref_doc
                                                                          .clear();
                                                                    },
                                                                    title:
                                                                        const Text(
                                                                      "No Doctor Found",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  );
                                                                }
                                                                return ListTile(
                                                                  title: Text(
                                                                      suggestion
                                                                              .dName ??
                                                                          ''),
                                                                );
                                                              },
                                                              onSelected:
                                                                  (suggestion) {
                                                                if (suggestion
                                                                        .dName ==
                                                                    "No Doctor Found") {
                                                                  ref_doc
                                                                      .clear();
                                                                  return;
                                                                }

                                                                setState(() {
                                                                  ref_doc.text =
                                                                      suggestion
                                                                              .dName ??
                                                                          '';

                                                                  var selectedObjmm =
                                                                      Refdoc
                                                                          ?.firstWhere(
                                                                    (e) =>
                                                                        e.dName ==
                                                                        suggestion
                                                                            .dName!,
                                                                    orElse: () =>
                                                                        LstDocDetailsDto(),
                                                                  );

                                                                  ref_docno
                                                                          .text =
                                                                      selectedObjmm
                                                                              ?.mob ??
                                                                          '';
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Center(
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
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: <TextInputFormatter>[
                                                                LengthLimitingTextInputFormatter(
                                                                    10),
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        "[0-9]")),
                                                              ],
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  ref_docno,
                                                              style: const TextStyle(
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    //   onTap: _toggleObscured,
                                                                    child: Icon(
                                                                      Icons
                                                                          .medical_information,
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Ref.Doctor No.',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                floatingLabelStyle: const TextStyle(
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
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Center(
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
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
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
                                                              // Unitname(username.text);},

                                                              focusNode: fexpid,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  extpatid,

                                                              style: const TextStyle(
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    //   onTap: _toggleObscured,
                                                                    child: Icon(
                                                                      Icons.tag,
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'External Patient Id',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
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
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Center(
                                                            child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              10))),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                          child: DropdownButton(
                                                            underline:
                                                                Container(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            hint: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Special Case',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87
                                                                            .withOpacity(
                                                                                0.7),
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            autofocus: true,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            isExpanded: true,
                                                            dropdownColor:
                                                                Colors.white,
                                                            iconEnabledColor:
                                                                Colors.black54,
                                                            value: specialcase,
                                                            items: speciallist
                                                                .map((country) {
                                                              return DropdownMenuItem(
                                                                value: country,
                                                                child: Text(
                                                                  country,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (country) {
                                                              widget.access ==
                                                                      'view'
                                                                  ? {}
                                                                  : {
                                                                      setState(
                                                                          () {
                                                                        specialcase =
                                                                            country;
                                                                        FocusScope.of(context)
                                                                            .nextFocus();
                                                                      })
                                                                    };
                                                            },
                                                          ),
                                                        )),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Center(
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
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              onEditingComplete: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .nextFocus(),
                                                              focusNode:
                                                                  flmpdate,
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  lmpdate,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              //focusNode: fpassword,
                                                              //obscureText: _obscured,
                                                              // validator: (value) {
                                                              //   if (value!.trim().isEmpty) {
                                                              //     return "LMP Date can not be empty";
                                                              //   } else {
                                                              //     return null;
                                                              //   }
                                                              // },
                                                              onTap: () async {
                                                                DateTime?
                                                                    pickedDate =
                                                                    await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context,
                                                                          child) {
                                                                    return Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        colorScheme:
                                                                            ColorScheme.light(
                                                                          primary:
                                                                              AppColours.blue,
                                                                          // <-- SEE HERE
                                                                          onPrimary:
                                                                              Colors.white,
                                                                          // <-- SEE HERE
                                                                          onSurface:
                                                                              AppColours.blue, // <-- SEE HERE
                                                                        ),
                                                                        textButtonTheme:
                                                                            TextButtonThemeData(
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            foregroundColor:
                                                                                AppColours.blue, // button text color
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          child!,
                                                                    );
                                                                  },
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  //get today's date
                                                                  firstDate:
                                                                      DateTime(
                                                                          1900),
                                                                  //DateTime.now() - not to allow to choose before today.
                                                                  lastDate: DateTime
                                                                          .now()
                                                                      .add(const Duration(
                                                                          days:
                                                                              365)),
                                                                );
                                                                if (pickedDate !=
                                                                    null) {
                                                                  //get the picked date in the format => 2022-07-04 00:00:00.000
                                                                  String
                                                                      formattedDate =
                                                                      DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(
                                                                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                                  debugPrint(
                                                                      formattedDate); //formatted date output using intl package =>  2022-07-04
                                                                  //You can format date as per your need

                                                                  setState(() {
                                                                    lmpdate.text =
                                                                        formattedDate;

                                                                    var year1 =
                                                                        pickedDate
                                                                            .year;
                                                                    var year2 =
                                                                        DateTime.now()
                                                                            .year;
                                                                    int months,
                                                                        days;
                                                                    int totalDays = DateTime
                                                                            .now()
                                                                        .difference(
                                                                            pickedDate)
                                                                        .inDays;
                                                                    int years =
                                                                        totalDays ~/
                                                                            365;
                                                                    DateDuration
                                                                        duration;
                                                                    // int totalDays = DateTime.now().difference(pickedDate).inDays;
                                                                    // int years = totalDays ~/ 365;

                                                                    //int years = totalDays ~/ 365;

                                                                    // months = (totalDays-years*365) ~/ 31,
                                                                    //days = totalDays-years*365-months*32,
                                                                    // dob(DateTime.now(), pickedDate);

                                                                    duration =
                                                                        AgeCalculator
                                                                            .dateDifference(
                                                                      fromDate: DateTime(
                                                                          pickedDate
                                                                              .year,
                                                                          pickedDate
                                                                              .month,
                                                                          pickedDate
                                                                              .day),
                                                                      toDate: DateTime(
                                                                          DateTime.now()
                                                                              .year,
                                                                          DateTime.now()
                                                                              .month,
                                                                          DateTime.now()
                                                                              .day),
                                                                    );
                                                                    //debugPrint(year2 - year1);

                                                                    //  agevalue=date.toString().split(' ').first;

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
                                                                  color: Colors
                                                                      .black),
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                suffixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                ),
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      const TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'LMP Date',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8,
                                                                    right: 16,
                                                                    bottom: 8),
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
                                                                    0.04,
                                                                child:
                                                                    TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                      // side: BorderSide(color: Colors.red)
                                                                    )),
                                                                    backgroundColor: MaterialStateProperty.all<
                                                                            Color>(
                                                                        AppColours
                                                                            .orange),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    debugPrint(
                                                                        'user');
                                                                    debugPrint(
                                                                        username
                                                                            .text);

                                                                    showModalBottomSheet<
                                                                            void>(
                                                                        isScrollControlled:
                                                                            true,
                                                                        barrierColor: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.7),
                                                                        backgroundColor: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.4),
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child:
                                                                                AddDoctor(
                                                                              callB: () async {
                                                                                await fetchRefDoctor();
                                                                              },
                                                                            ),
                                                                          );
                                                                        });
                                                                  },
                                                                  child: const Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Add Doctor',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.white,
                                                                              fontSize: 12),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .add_box_outlined,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              18,
                                                                        )
                                                                      ]),
                                                                )),
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  ])),
                                        ),
                                        Card(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      AppColours.blue,
                                                      AppColours.orange
                                                    ],
                                                    begin:
                                                        const FractionalOffset(
                                                            0.0, 0.0),
                                                    end: const FractionalOffset(
                                                        1.0, 0.0),
                                                    stops: const [0.0, 1.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: ExpansionTile(
                                                  onExpansionChanged:
                                                      (value) {},
                                                  iconColor: Colors.white,
                                                  collapsedIconColor:
                                                      Colors.white,
                                                  shape: const Border(
                                                      top: BorderSide(
                                                          color: Colors.white),
                                                      bottom: BorderSide(
                                                          color: Colors.white)),
                                                  // collapsedShape:  RoundedRectangleBorder(
                                                  //     side:new  BorderSide(color:Colors.white), //the outline color
                                                  //     borderRadius:  BorderRadius.all( Radius.circular(20))),
                                                  // collapsedBackgroundColor: Colors.white,

                                                  title: const Text(
                                                    "Details From Lab",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.38,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade200),
                                                          color: Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          15))),
                                                      child: Column(children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
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
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
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
                                                              // Unitname(username.text);},

                                                              focusNode: fb2bid,
                                                              autofocus: true,

                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  b2bpatid,
                                                              //focusNode: fpassword,
                                                              //obscureText: _obscured,
                                                              // validator: (value) {
                                                              //   if (value == null ||
                                                              //       value.trim().isEmpty) {
                                                              //     return "B2B ID can not be empty";
                                                              //   } else {
                                                              //     return null;
                                                              //   }
                                                              // },
                                                              style: const TextStyle(
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    //   onTap: _toggleObscured,
                                                                    child: Icon(
                                                                      Icons.tag,
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'B2B Patient Id',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
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
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Center(
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
                                                                0.09,
                                                            child:
                                                                TextFormField(
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
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
                                                              // Unitname(username.text);},

                                                              focusNode:
                                                                  fpathistory,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  pat_history,
                                                              // validator: (value) {
                                                              //   if (value!.contains(" ") ||
                                                              //       value!.trim().isEmpty) {
                                                              //     return "Patient History is not Valid";
                                                              //   } else {
                                                              //     return null;
                                                              //   }
                                                              // },
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
                                                                    color: Colors
                                                                        .grey,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    //   onTap: _toggleObscured,
                                                                    child: Icon(
                                                                      Icons
                                                                          .history,
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Patient History',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black87.withOpacity(0.7),
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
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
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                        ),
                                                        Center(
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
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              onEditingComplete: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .nextFocus(),
                                                              focusNode:
                                                                  fcollection_date,
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  collection_date,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              //focusNode: fpassword,
                                                              //obscureText: _obscured,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .trim()
                                                                    .isEmpty) {
                                                                  return "Collection Date can not be empty";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                              onTap: () async {
                                                                DateTime?
                                                                    pickedDate =
                                                                    await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context,
                                                                          child) {
                                                                    return Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        colorScheme:
                                                                            ColorScheme.light(
                                                                          primary:
                                                                              AppColours.blue,
                                                                          // <-- SEE HERE
                                                                          onPrimary:
                                                                              Colors.white,
                                                                          // <-- SEE HERE
                                                                          onSurface:
                                                                              AppColours.blue, // <-- SEE HERE
                                                                        ),
                                                                        textButtonTheme:
                                                                            TextButtonThemeData(
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            foregroundColor:
                                                                                AppColours.blue, // button text color
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          child!,
                                                                    );
                                                                  },
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  //get today's date
                                                                  firstDate:
                                                                      DateTime(
                                                                          1900),
                                                                  //DateTime.now() - not to allow to choose before today.
                                                                  lastDate: DateTime
                                                                          .now()
                                                                      .add(const Duration(
                                                                          days:
                                                                              0)),
                                                                );
                                                                if (pickedDate !=
                                                                    null) {
                                                                  //get the picked date in the format => 2022-07-04 00:00:00.000
                                                                  String
                                                                      formattedDate =
                                                                      DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(
                                                                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                                  debugPrint(
                                                                      formattedDate); //formatted date output using intl package =>  2022-07-04
                                                                  //You can format date as per your need

                                                                  setState(() {
                                                                    collection_date
                                                                            .text =
                                                                        formattedDate;
                                                                  });

                                                                  var year1 =
                                                                      pickedDate
                                                                          .year;
                                                                  var year2 =
                                                                      DateTime.now()
                                                                          .year;
                                                                  int months,
                                                                      days;
                                                                  int totalDays = DateTime
                                                                          .now()
                                                                      .difference(
                                                                          pickedDate)
                                                                      .inDays;
                                                                  int years =
                                                                      totalDays ~/
                                                                          365;
                                                                  DateDuration
                                                                      duration;
                                                                  // int totalDays = DateTime.now().difference(pickedDate).inDays;
                                                                  // int years = totalDays ~/ 365;

                                                                  months = (totalDays -
                                                                          years *
                                                                              365) ~/
                                                                      30;
                                                                  days = totalDays -
                                                                      years *
                                                                          365 -
                                                                      months *
                                                                          30;
                                                                  // months = (totalDays-years*365) ~/ 31,
                                                                  //days = totalDays-years*365-months*32,
                                                                  // dob(DateTime.now(), pickedDate);

                                                                  duration =
                                                                      AgeCalculator
                                                                          .dateDifference(
                                                                    fromDate: DateTime(
                                                                        pickedDate
                                                                            .year,
                                                                        pickedDate
                                                                            .month,
                                                                        pickedDate
                                                                            .day),
                                                                    toDate: DateTime(
                                                                        DateTime.now()
                                                                            .year,
                                                                        DateTime.now()
                                                                            .month,
                                                                        DateTime.now()
                                                                            .day),
                                                                  );
                                                                  //debugPrint(year2 - year1);

                                                                  //  agevalue=date.toString().split(' ').first;
                                                                }
                                                              },
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                suffixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                ),
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      const TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Collection Date',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Center(
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
                                                                0.07,
                                                            child:
                                                                TextFormField(
                                                              onEditingComplete: () =>
                                                                  FocusScope.of(
                                                                          context)
                                                                      .nextFocus(),
                                                              focusNode:
                                                                  fcollection_time,
                                                              enabled:
                                                                  widget.access ==
                                                                          'view'
                                                                      ? false
                                                                      : true,
                                                              autofocus: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller:
                                                                  collection_time,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              //focusNode: fpassword,
                                                              //obscureText: _obscured,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .trim()
                                                                    .isEmpty) {
                                                                  return "Collection Time can not be empty";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                              onTap: () async {
                                                                final TimeOfDay?
                                                                    picked =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      selectedTime,
                                                                  // context: context,
                                                                  builder:
                                                                      (context,
                                                                          child) {
                                                                    return Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        colorScheme:
                                                                            ColorScheme.light(
                                                                          primary:
                                                                              AppColours.blue,
                                                                          // <-- SEE HERE
                                                                          onPrimary:
                                                                              Colors.white,
                                                                          // <-- SEE HERE
                                                                          onSurface:
                                                                              AppColours.blue, // <-- SEE HERE
                                                                        ),
                                                                        textButtonTheme:
                                                                            TextButtonThemeData(
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            foregroundColor:
                                                                                AppColours.blue, // button text color
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          child!,
                                                                    );
                                                                  },
                                                                );
                                                                if (picked !=
                                                                    null) {
                                                                  setState(() {
                                                                    selectedTime =
                                                                        picked;
                                                                    _hour = selectedTime
                                                                        .hour
                                                                        .toString();
                                                                    _minute = selectedTime
                                                                        .minute
                                                                        .toString();
                                                                    debugPrint(
                                                                        'minute');
                                                                    // debugPrint(_minute!.length==1?);
                                                                    _time = _minute!.length ==
                                                                            1
                                                                        ? '${_hour!} :0${_minute!}'
                                                                        : '${_hour!} : ${_minute!}';
                                                                    collection_time
                                                                            .text =
                                                                        _time!;
                                                                  });
                                                                }
                                                              },

                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
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
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                suffixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                ),
                                                                prefixIcon:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          4,
                                                                          0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap:
                                                                        () {},
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
                                                                        fontSize:
                                                                            14),
                                                                label: RichText(
                                                                  text:
                                                                      const TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'Collection Time',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // labelText: 'Password',
                                                                // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                floatingLabelStyle: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ])),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        widget.access != 'view'
                                            ? Row(
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
                                                        onPressed: () {},
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
                                                                if (validateDob()) {
                                                                  if (firstName
                                                                          .text
                                                                          .trim()
                                                                          .isEmpty || lastname
                                                                      .text
                                                                      .trim()
                                                                      .isEmpty ||
                                                                      title ==
                                                                          null ||
                                                                      gender ==
                                                                          null ||
                                                                      nation ==
                                                                          null ||
                                                                      contact
                                                                          .text
                                                                          .toString()
                                                                          .trim()
                                                                          .isEmpty ||
                                                                      email.text
                                                                          .toString()
                                                                          .trim()
                                                                          .isEmpty ||
                                                                      address
                                                                          .text
                                                                          .toString()
                                                                          .trim()
                                                                          .isEmpty) {
                                                                    // Display error message for mandatory fields
                                                                    CustomMessage
                                                                        .toast(
                                                                            'Please Enter All Mandatory Fields');
                                                                  } else if (_formKey
                                                                          .currentState!
                                                                          .validate() &&
                                                                      address
                                                                          .text
                                                                          .toString()
                                                                          .trim()
                                                                          .isNotEmpty) {
                                                                    String
                                                                        typedDoctor =
                                                                        ref_doc
                                                                            .text
                                                                            .trim(); // Get updated text
                                                                    if (typedDoctor
                                                                        .isNotEmpty) {
                                                                      bool
                                                                          isDoctorValid =
                                                                          Refdoc!
                                                                              .any(
                                                                        (doctor) =>
                                                                            doctor.dName!.toLowerCase() ==
                                                                            typedDoctor.toLowerCase(),
                                                                      );

                                                                      if (!isDoctorValid) {
                                                                        CustomMessage.toast(
                                                                            "Doctor Not Found");
                                                                        return;
                                                                      }
                                                                    }

                                                                    if (widget
                                                                            .access ==
                                                                        'edit') {
                                                                      if (FlavorConfig
                                                                              .instance
                                                                              .name !=
                                                                          "B2BLifenity") {
                                                                        await editPatient(
                                                                          title,
                                                                          firstName
                                                                              .text,
                                                                          middlename
                                                                              .text,
                                                                          lastname
                                                                              .text,
                                                                          gender
                                                                              .text,
                                                                          contact
                                                                              .text,
                                                                          age.text,
                                                                          year.text,
                                                                          month
                                                                              .text,
                                                                          day.text,
                                                                          state
                                                                              .text,
                                                                          district
                                                                              .text,
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          email
                                                                              .text,
                                                                          address
                                                                              .text,
                                                                          pincode
                                                                              .text,
                                                                          ref_doc
                                                                              .text,
                                                                          ref_docno
                                                                              .text,
                                                                          extpatid
                                                                              .text,
                                                                          specialcase,
                                                                          b2bpatid
                                                                              .text,
                                                                          pat_history
                                                                              .text,
                                                                          collection_date
                                                                              .text,
                                                                          collection_time
                                                                              .text,
                                                                          nationality
                                                                              ?.first,
                                                                          lmpdate
                                                                              .text
                                                                              .toString(),
                                                                          _switchValue,
                                                                          "insert",
                                                                        );
                                                                      } else {
                                                                        await editAndMarkvist(
                                                                          title,
                                                                          firstName
                                                                              .text,
                                                                          middlename
                                                                              .text,
                                                                          lastname
                                                                              .text,
                                                                          gender
                                                                              .text,
                                                                          contact
                                                                              .text,
                                                                          age.text,
                                                                          year.text,
                                                                          month
                                                                              .text,
                                                                          day.text,
                                                                          state
                                                                              .text,
                                                                          district
                                                                              .text,
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          email
                                                                              .text,
                                                                          address
                                                                              .text,
                                                                          pincode
                                                                              .text,
                                                                          ref_doc
                                                                              .text,
                                                                          ref_docno
                                                                              .text,
                                                                          extpatid
                                                                              .text,
                                                                          specialcase,
                                                                          b2bpatid
                                                                              .text,
                                                                          pat_history
                                                                              .text,
                                                                          collection_date
                                                                              .text,
                                                                          collection_time
                                                                              .text,
                                                                          nationality
                                                                              ?.first,
                                                                          lmpdate
                                                                              .text
                                                                              .toString(),
                                                                          _switchValue,
                                                                          "update",
                                                                        );
                                                                      }
                                                                    } else if (widget
                                                                            .access ==
                                                                        'markvisit') {
                                                                      if (FlavorConfig
                                                                              .instance
                                                                              .name !=
                                                                          "B2BLifenity") {
                                                                        await editPatient(
                                                                          title,
                                                                          firstName
                                                                              .text,
                                                                          middlename
                                                                              .text,
                                                                          lastname
                                                                              .text,
                                                                          gender
                                                                              .text,
                                                                          contact
                                                                              .text,
                                                                          age.text,
                                                                          year.text,
                                                                          month
                                                                              .text,
                                                                          day.text,
                                                                          state
                                                                              .text,
                                                                          district
                                                                              .text,
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          email
                                                                              .text,
                                                                          address
                                                                              .text,
                                                                          pincode
                                                                              .text,
                                                                          ref_doc
                                                                              .text,
                                                                          ref_docno
                                                                              .text,
                                                                          extpatid
                                                                              .text,
                                                                          specialcase,
                                                                          b2bpatid
                                                                              .text,
                                                                          pat_history
                                                                              .text,
                                                                          collection_date
                                                                              .text,
                                                                          collection_time
                                                                              .text,
                                                                          nationality
                                                                              ?.first,
                                                                          lmpdate
                                                                              .text
                                                                              .toString(),
                                                                          _switchValue,
                                                                          "markvisit",
                                                                        );
                                                                      } else {
                                                                        await editAndMarkvist(
                                                                          title,
                                                                          firstName
                                                                              .text,
                                                                          middlename
                                                                              .text,
                                                                          lastname
                                                                              .text,
                                                                          gender
                                                                              .text,
                                                                          contact
                                                                              .text,
                                                                          age.text,
                                                                          year.text,
                                                                          month
                                                                              .text,
                                                                          day.text,
                                                                          state
                                                                              .text,
                                                                          district
                                                                              .text,
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          countri![
                                                                              'idCountryPK'],
                                                                          email
                                                                              .text,
                                                                          address
                                                                              .text,
                                                                          pincode
                                                                              .text,
                                                                          ref_doc
                                                                              .text,
                                                                          ref_docno
                                                                              .text,
                                                                          extpatid
                                                                              .text,
                                                                          specialcase,
                                                                          b2bpatid
                                                                              .text,
                                                                          pat_history
                                                                              .text,
                                                                          collection_date
                                                                              .text,
                                                                          collection_time
                                                                              .text,
                                                                          nationality
                                                                              ?.first,
                                                                          lmpdate
                                                                              .text
                                                                              .toString(),
                                                                          _switchValue,
                                                                          "markvisit",
                                                                        );
                                                                      }
                                                                    } else {
                                                                      // Register a new patient
                                                                      await registerPatient(
                                                                        title,
                                                                        firstName
                                                                            .text,
                                                                        middlename
                                                                            .text,
                                                                        lastname
                                                                            .text,
                                                                        gender
                                                                            .text,
                                                                        contact
                                                                            .text,
                                                                        age.text,
                                                                        year.text,
                                                                        month
                                                                            .text,
                                                                        day.text,
                                                                        state
                                                                            .text,
                                                                        district
                                                                            .text,
                                                                        countri![
                                                                            'idCountryPK'],
                                                                        countri![
                                                                            'idCountryPK'],
                                                                        email
                                                                            .text,
                                                                        address
                                                                            .text,
                                                                        pincode
                                                                            .text,
                                                                        ref_doc
                                                                            .text,
                                                                        ref_docno
                                                                            .text,
                                                                        extpatid
                                                                            .text,
                                                                        specialcase,
                                                                        b2bpatid
                                                                            .text,
                                                                        pat_history
                                                                            .text,
                                                                        collection_date
                                                                            .text,
                                                                        collection_time
                                                                            .text,
                                                                        nationality
                                                                            ?.first,
                                                                        lmpdate
                                                                            .text
                                                                            .toString(),
                                                                        _switchValue,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    // Display error message for validation failure
                                                                    CustomMessage
                                                                        .toast(
                                                                            'Please Enter All Mandatory Fields');
                                                                  }
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
                                            : const SizedBox()
                                      ]))))),
              offlineChild: Offline())),
    );
  }

  bool _isValidDoctor(String text) {
    return Refdoc!
        .any((doctor) => doctor.dName!.toLowerCase() == text.toLowerCase());
  }

  bool validateDob() {
    // Check if DOB is selected
    bool isDobSelected = age.text.isNotEmpty;

    if (year.text.isEmpty) {
      year.text = "0";
    }
    if (month.text.isEmpty) {
      month.text = "0";
    }
    if (day.text.isEmpty) {
      day.text = "0";
    }

    // Check if year, month, or day fields are filled
    bool isYearFilled = year.text.isNotEmpty;
    bool isMonthFilled = month.text.isNotEmpty;
    bool isDayFilled = day.text.isNotEmpty;

    // If no fields are selected, prompt user
    if (!isDobSelected && !isYearFilled && !isMonthFilled && !isDayFilled) {
      CustomMessage.toast('Please enter DOB or age fields.');
      return false; // Indicate validation failed
    }

    // Validate that if day is filled, it should be at least 1

    if (isDayFilled &&
        int.tryParse(day.text) == 0 &&
        (int.tryParse(year.text)! == 0 && int.tryParse(month.text)! == 0)) {
      CustomMessage.toast('Days should be at least 1.');
      return false; // Indicate validation failed
    }

    return true; // Indicate validation passed
  }

  void startListening() {
    setState(() {
      isListening = true;
    });

    _speech.listen(
      onResult: (result) {
        setState(() {
          ref_doc.text = result.recognizedWords.toUpperCase();
        });

        // Check if the recognized words match any doctor names
        bool exists = Refdoc!.any((doctor) =>
            doctor.dName!.toLowerCase().contains(ref_doc.text.toLowerCase()));

        if (exists) {
          // Show suggestions if a match exists
          showSuggestions(context);
        } else {
          // Show "No Doctor Found" in the suggestions if no match
          showSuggestions(context); // This will show "No Doctor Found"
        }
      },
    );

    setState(() {
      isListening = false;
    });
  }

  void stopListening() {
    setState(() {
      isListening = false;
    });
  }

  // Function to manually show the dropdown when the field is tapped
  void showSuggestions(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  _initializeSpeechRecognition() async {
    bool available = await _speech.initialize();
    if (!available) {
      // Handle error if speech recognition is unavailable
      print("Speech recognition is not available.");
    }
  }

  // Start listening for speech input for First Name
  void startListeningFirstName() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          firstName.text = result.recognizedWords.toUpperCase();
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  // Start listening for speech input for Last Name
  void startListeningLastName() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          lastname.text = result.recognizedWords.toUpperCase();
        });
      },
    );
    setState(() {
      isListeningLastName = true;
    });
  }

  void dismissKeyboard() {
    if (focusNode.hasFocus) {
      focusNode.unfocus(); // Remove focus to close suggestions
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
    response.statusCode == 200
        ? {
            setState(() {
              businessMasterGeneralInfoDto =
                  value['businessMasterGeneralInfoDto'];
              businessMasterAddressInfoDto =
                  value['businessMasterAddressInfoDto'];
              contact.text = businessMasterGeneralInfoDto[0]['mobile'];
              address.text = businessMasterAddressInfoDto[0]['address'];
              email.text = businessMasterGeneralInfoDto[0]['mail'];
              pincode.text = businessMasterGeneralInfoDto[0]['pin'] ?? "";
              state.text = businessMasterGeneralInfoDto[0]['state'] ?? "";
              district.text =
                  businessMasterGeneralInfoDto[0]['districtName'] ?? "";
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

  registerPatient(
      prefix,
      firstname,
      middlename,
      lastname,
      gender,
      mobile,
      dob,
      year,
      month,
      days,
      state,
      district,
      country,
      countrycode,
      email,
      address,
      pincode,
      refdoc,
      docno,
      extpatid,
      specialcase,
      b2bid,
      history,
      collectiondate,
      time,
      nationality,
      lmp,
      switchvalue) async {
    load = true;
    setState(() {});
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.REGISTRATION}?userId=${decode!['userId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "patientDetails": {
        "prefix": prefix,
        "lookupDetIdTtl": "19",
        "fName": firstname,
        "mName": middlename,
        "lName": lastname,
        "gender": gender,
        "mobile": mobile,
        "dob": dob,
        "age": year,
        "ageMonths": month,
        "ageDays": days,
        "districtId": null,
        "stateId": null,
        "areaCode": 0,
        "unitId": decode!['unitMasterId'],
        "adharcardNo": "",
        "transSMS": "Y",
        "transEmail": "Y",
        "pramoEmail": "N",
        "pramoSMS": "N",
        "emergency": "N",
        "external": "N",
        "mrnno": "xyz",
        "address": address,
        "imageName": "patientPhoto.jpg",
        "aadharImageName": "aadhar.jpg",
        "aadharBackImageName": "aadhar.jpg",
        "passport": "",
        "visa": "",
        "hasanaID": "",
        "relationId": "0",
        "relativeName": "",
        "relativeNationalityId": "0",
        "perAddress": "",
        "pertalukaId": null,
        "pertownId": null,
        "perdistrictId": null,
        "perstateId": null,
        "percountryId": "1",
        "perareaCode": null,
        "oldPatientId": "0",
        "emailId": email,
        "maritalStatusId": "0",
        "nationalityId": "199",
        "religionId": "0",
        "languageId": "0",
        "bloodGroupId": "0",
        "identityProofId": "0",
        "identificationNumber": "",
        "annualIncomeId": "0",
        "occupation": "",
        "education": "0",
        "noOfChildren": 0,
        "flightNumber": "",
        "txtPincode": pincode,
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "country": countrycode,
        "countryCode": countrycode,
        "specArrivalDate": "",
        "specArrivalTime": "",
        "formalinDate": "",
        "clinicalDetails": "",
        "seropositiveStatus": "N",
        "provisionalDiagnosis": "",
        "previousTherapy": "",
        "previousBiopsyCytology": "",
        "intraOperativeFindings": "",
        "anomalies": "",
        "additionalRemarks": "",
        "moreInfo": "",
        "histoTest": "N",
        "specRemovalDate": "",
        "specRemovalTime": "23:16",
        "geneClinicalDetails": "",
        "genePreviousTherapy": "",
        "geneAnomalies": "",
        "geneAdditionalRemarks": "",
        "nhsNo": "",
        "lookupDetIdEthnicity": "",
        "refDoctorClnic": "",
        "patientType": null
      },
      "covidDetails": {
        "doseTypeId": 0,
        "cowinBeneficiaryId": "0",
        "typeOfVaccinationId": 0
      },
      "histoDetails": {},
      "paymentResponsibleDetails": {},
      "mlcDetails": {
        "mlcNo": "",
        "firNo": "",
        "authorityName": "",
        "mlcFirstName": "",
        "mlcLastName": "",
        "mlcCmoDoctor": 0,
        "buccleNo": "",
        "plStname": "",
        "mlcGender": "",
        "mlcMobile": "0",
        "mlcEmail": "",
        "mlcPlAddess": "",
        "mlcAge": "0",
        "mlcRelation": "0",
        "mlcAddressText": "",
        "incidentDetails": "",
        "mlcDate": null,
        "prefix3": "0"
      },
      "childrenDetails": null,
      "treatDetails": {
        "departmentId": "1",
        "doctorIdList": "",
        "appointmentId": 0,
        "token": 0,
        "tFlag": "Y",
        "unitId": decode!['unitMasterId'],
        "deleted": null,
        "createdBy": decode!['userId'],
        "createdDateTime": '',
        "updatedDateTime": null,
        "deletedBy": null,
        "deletedDateTime": null,
        "refDocId": 0,
        "caseType": 1,
        "weight": 0.0,
        "height": 0.0,
        "notes": "-",
        "empid": "",
        "count": 1,
        "trcount": "0",
        "opdipdno": "0",
        "tpaid": "-",
        "cancelNarration": "-",
        "admCancelFlag": "N",
        "refersource": "0",
        "emergencyFlag": user!['emergencyFlag'] ?? "N",
        "patientHistory": history,
        "businessType": 1,
        "customerType": decode!['customerType'],
        "customerId": decode!['customerId'],
        "specialCase": "0",
        "gestationalAge": 0,
        "urineVol": "0",
        "lmpDate": lmp,
        "tokenno": "0",
        "reqGenFormId": 0,
        "referredBy": null,
        "referredSource": 0,
        "referredSourceSlave": "",
        "referredSourceDocId": 0,
        "refDate": null,
        "sactionOrdNo": "0",
        "sanctionAmt": 0.0,
        "neisNo": "0",
        "visitNo": "0",
        "ipdOrOpd": "0",
        "treatPermited": "0",
        "diseToBeTreat": "0",
        "validUpToDate": null,
        "admissionCanDateTime": null,
        "admissionCanceledBy": null,
        "admissionDateTime": "",
        "refDoctorName": refdoc,
        "patientName": "",
        "userName": "",
        "cancelDate": null,
        "cancelTime": null,
        "radioPatientType": "C",
        "radioSelfRelative": "N",
        "radioPresentRetired": "N",
        "collectionDate": collectiondate,
        "collectionTime": time,
        "b2bPatientId": b2bid,
        "doctorMobileNo": docno,
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "patientBarcode": "",
        "registeredAt": "other",
        "networkApiChk": "N",
        "externalPatientId": "-",
        "listTreatment": null,
        "phyDateTime": null,
        "phyDisFlag": "N",
        "doctorName": "",
        "doctorSpecialisation": "",
        "doctorPerDayCharge": "",
        "doctorTotalDays": "",
        "doctorToalAmt": "",
        "doctorAttendanceDate": "",
        "doctorCheckupPatientCount": "",
        "patientTreatmentDateForDetailReport": "",
        "patientIdForDetailReport": "",
        "patientNameForDetailReport": "",
        "patientMobileForDetailReport": ""
      },
      "billMaster": {
        "departmentId": "1",
        "unitId": decode!['unitMasterId'],
        "count": "0",
        "sponsorId": 0,
        "invoiceCount": "0",
        "invoiceFlag": "N"
      },
      "billDetails": {
        "sourceTypeId": "0",
        "billId": "0",
        "unitId": decode!['unitMasterId'],
        "departmentId": "1",
        "sponsorId": "0",
        "chargesSlaveId": 0
      },
      "billDetIpd": null,
      "queryType": "insert",
      "AppId": 0,
      "preRegistrationId": 0
    };
    debugPrint(body.toString());

    final jsonbody = json.encode(body);
    debugPrint(jsonbody);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody);

    print(response.body);

    // var u;
    if (response.body.contains('Patient registered successfully.')) {
      load = false;
      setState(() {});

      CustomMessage.toast(response.body);

      // u = response.body.substring(47, 52);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const B2BQueue()));
    } else {
      load = false;
      setState(() {});

      CustomMessage.toast('Failed');
    }
  }

  editAndMarkvist(
      prefix,
      firstname,
      middleName,
      lastName,
      Gender,
      mobile,
      dob,
      Year,
      Month,
      Days,
      state,
      district,
      country,
      countrycode,
      email,
      address,
      Pincode,
      refdoc,
      docno,
      extpatid,
      specialcase,
      b2bid,
      history,
      collectiondate,
      time,
      nationality,
      lmp,
      switchvalue,
      queryType) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.REGISTRATION}?userId=${decode!['userId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "patientDetails": {
        "patientId": FlavorConfig.instance.name == "B2BLifenity"
            ? user!['patientId']
            : user!['ptId'],
        "prefix": prefix,
        "lookupDetIdTtl": "19",
        "fName": firstname,
        "mName": middleName,
        "lName": lastName,
        "gender": Gender,
        "mobile": mobile,
        "dob": dob,
        "age": Year,
        "ageMonths": Month,
        "ageDays": Days,
        "districtId": null,
        "stateId": null,
        "areaCode": 0,
        "unitId": decode!['unitMasterId'],
        "adharcardNo": "",
        "transSMS": "Y",
        "transEmail": "Y",
        "pramoEmail": "N",
        "pramoSMS": "N",
        "emergency": switchvalue == true ? 'Y' : 'N',
        "external": "N",
        "mrnno": "xyz",
        "address": address,
        "imageName": "patientPhoto.jpg",
        "aadharImageName": "aadhar.jpg",
        "aadharBackImageName": "aadhar.jpg",
        "passport": user!['passport'],
        "visa": user!['visa'],
        "hasanaID": user!['hasanaId'],
        "relationId": "0",
        "relativeName": "",
        "relativeNationalityId": "0",
        "perAddress": "",
        "pertalukaId": null,
        "pertownId": null,
        "perdistrictId": null,
        "perstateId": null,
        "percountryId": "1",
        "perareaCode": null,
        "oldPatientId": "0",
        "emailId": email,
        "maritalStatusId": "0",
        "nationalityId": "199",
        "religionId": "0",
        "languageId": "0",
        "bloodGroupId": user!['bloodgroup'] ?? "0",
        "identityProofId": "0",
        "identificationNumber": user!['identificationNumber'],
        "annualIncomeId": "0",
        "occupation": "",
        "education": "0",
        "noOfChildren": 0,
        "flightNumber": "",
        "txtPincode": Pincode,
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "country": countrycode,
        "countryCode": countrycode,
        "specArrivalDate": "",
        "specArrivalTime": "",
        "formalinDate": "",
        "clinicalDetails": "",
        "seropositiveStatus": "N",
        "provisionalDiagnosis": "",
        "previousTherapy": "",
        "previousBiopsyCytology": "",
        "intraOperativeFindings": "",
        "anomalies": "",
        "additionalRemarks": "",
        "moreInfo": "",
        "histoTest": "N",
        "specRemovalDate": "",
        "specRemovalTime": "",
        "geneClinicalDetails": "",
        "genePreviousTherapy": "",
        "geneAnomalies": "",
        "geneAdditionalRemarks": "",
        "nhsNo": "",
        "lookupDetIdEthnicity": "",
        "refDoctorClnic": "",
        "patientType": null
      },
      "covidDetails": {
        "doseTypeId": 0,
        "cowinBeneficiaryId": "0",
        "typeOfVaccinationId": 0
      },
      "histoDetails": {},
      "paymentResponsibleDetails": {},
      "mlcDetails": {
        "mlcNo": "",
        "firNo": "",
        "authorityName": "",
        "mlcFirstName": "",
        "mlcLastName": "",
        "mlcCmoDoctor": 0,
        "buccleNo": "",
        "plStname": "",
        "mlcGender": "",
        "mlcMobile": "0",
        "mlcEmail": "",
        "mlcPlAddess": "",
        "mlcAge": "0",
        "mlcRelation": "0",
        "mlcAddressText": "",
        "incidentDetails": "",
        "mlcDate": null,
        "prefix3": "0"
      },
      "childrenDetails": null,
      "treatDetails": {
        "treatmentId": user!['ttId'],
        "departmentId": "1",
        "doctorIdList": "",
        "appointmentId": 0,
        "token": 0,
        "tFlag": queryType == 'markvisit' ? "Y": user!['tFlag'],
        "unitId": decode!['unitMasterId'],
        "deleted": null,
        "createdBy": decode!['userId'],
        // "createdDateTime": collectiondate,
        // "updatedDateTime": time,
        "createdDateTime": null,
        "updatedDateTime": null,
        "deletedBy": null,
        "deletedDateTime": null,
        "refDocId": 0,
        "caseType": 1,
        "weight": user!['height'],
        "height": user!['weight'],
        "notes": "-",
        "empid": "",
        "count": 1,
        "trcount": "0",
        "opdipdno": "0",
        "tpaid": "-",
        "cancelNarration": "-",
        "admCancelFlag": "N",
        "refersource": "0",
        "emergencyFlag": user!['emergencyFlag'] ?? "N",
        "patientHistory": history,
        "businessType": 1,
        "customerType": decode!['customerType'],
        "customerId": decode!['customerId'],
        "specialCase": specialcase ?? "0",
        "gestationalAge": 0,
        "urineVol": "0",
        "lmpDate": lmp,
        "tokenno": "0",
        "reqGenFormId": 0,
        "referredBy": null,
        "referredSource": 0,
        "referredSourceSlave": "",
        "referredSourceDocId": 0,
        "refDate": null,
        "sactionOrdNo": "0",
        "sanctionAmt": 0.0,
        "neisNo": "0",
        "visitNo": "0",
        "ipdOrOpd": "0",
        "treatPermited": "0",
        "diseToBeTreat": "0",
        "validUpToDate": null,
        "admissionCanDateTime": null,
        "admissionCanceledBy": null,
        "admissionDateTime": "",
        "refDoctorName": refdoc,
        "patientName": "",
        "userName": "",
        "cancelDate": null,
        "cancelTime": null,
        "radioPatientType": "C",
        "radioSelfRelative": "N",
        "radioPresentRetired": "N",
        "collectionDate": collectiondate,
        "collectionTime": time,
        "b2bPatientId": b2bid,
        "doctorMobileNo": docno,
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "patientBarcode": "",
        "registeredAt": "other",
        "networkApiChk": "N",
        "externalPatientId": extpatid,
        "listTreatment": null,
        "phyDateTime": null,
        "phyDisFlag": "N",
        "doctorName": "",
        "doctorSpecialisation": "",
        "doctorPerDayCharge": "",
        "doctorTotalDays": "",
        "doctorToalAmt": "",
        "doctorAttendanceDate": "",
        "doctorCheckupPatientCount": "",
        "patientTreatmentDateForDetailReport": "",
        "patientIdForDetailReport": "",
        "patientNameForDetailReport": "",
        "patientMobileForDetailReport": ""
      },
      "billMaster": {
        "billId": user!['billId'],
        "departmentId": "1",
        "unitId": decode!['unitMasterId'],
        "count": user!['count'],
        "sponsorId": 0,
        "invoiceCount": user!['invoiceCount'],
        "invoiceFlag": user!['invoiceFlag'],
      },
      "billDetails": {
        "sourceTypeId": "0",
        "billId": user!['billId'],
        "unitId": decode!['unitMasterId'],
        "departmentId": "1",
        "sponsorId": "0",
        "chargesSlaveId": 0
      },
      "billDetIpd": null,
      "queryType": queryType,
      "AppId": 0,
      "preRegistrationId": 0
    };
    debugPrint(body.toString());

    final jsonbody = json.encode(body);
    debugPrint(jsonbody);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody

        //encoding: encoding,
        );
    debugPrint(response.body);
    if (response.body.contains('Patient registered successfully.')) {
      title = null;
      firstName.clear();
      middlename.clear();
      lastname.clear();
      gender.clear();
      age.clear();
      year.clear();
      month.clear();
      day.clear();
      ref_doc.clear();
      load = false;
      setState(() {});
      CustomMessage.toast(response.body);

      // await fetchIPDList();
      //
      // CustomMessage.toast(response.body);
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => GetPatient(patientList)));
    } else {
      load = false;
      setState(() {});

      CustomMessage.toast(response.body);
    }
  }

  fetchIPDList() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.MARKLIST}?unitId=${decode!['unitMasterId']}&meeshaFlow=off&userType=${decode!['userType']}&userId=${decode!['userId']}&userFor=other');
    debugPrint(uri.path);
    final response = await ioClient.post(
      uri,
      headers: headers,
    );

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      setState(() {
        patientList = value['lstRegviewDto'];
        load = false;
      });
    } else {
      load = false;
      setState(() {});

      CustomMessage.toast('Failed to load');
    }
  }

  editPatient(
      prefix,
      firstname,
      middlename,
      lastname,
      gender,
      mobile,
      dob,
      year,
      month,
      days,
      state,
      district,
      country,
      countrycode,
      email,
      address,
      pincode,
      refdoc,
      docno,
      extpatid,
      specialcase,
      b2bid,
      history,
      collectiondate,
      time,
      nationality,
      lmp,
      switchvalue,
      queryType) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.REGISTRATION}?userId=${decode!['userId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "patientDetails": {
        "patientId": FlavorConfig.instance.name == "B2BLifenity"
            ? user!['patientId']
            : user!['ptId'],
        "prefix": prefix,
        "lookupDetIdTtl": "19",
        "fName": firstname,
        "mName": middlename,
        "lName": lastname,
        "gender": gender,
        "mobile": mobile,
        "dob": dob,
        "age": year,
        "ageMonths": month,
        "ageDays": days,
        "districtId": null,
        "stateId": null,
        "areaCode": 0,
        "unitId": decode!['unitMasterId'],
        "adharcardNo": "",
        "transSMS": "Y",
        "transEmail": "Y",
        "pramoEmail": "N",
        "pramoSMS": "N",
        "emergency": switchvalue == true ? 'Y' : 'N',
        "external": "N",
        "mrnno": "xyz",
        "address": address,
        "imageName": "patientPhoto.jpg",
        "aadharImageName": "aadhar.jpg",
        "aadharBackImageName": "aadhar.jpg",
        "passport": user!['passport'],
        "visa": user!['visa'],
        "hasanaID": user!['hasanaId'],
        "relationId": "0",
        "relativeName": "",
        "relativeNationalityId": "0",
        "perAddress": "",
        "pertalukaId": null,
        "pertownId": null,
        "perdistrictId": null,
        "perstateId": null,
        "percountryId": "1",
        "perareaCode": null,
        "oldPatientId": "0",
        "emailId": email,
        "maritalStatusId": "0",
        "nationalityId": "199",
        "religionId": "0",
        "languageId": "0",
        "bloodGroupId": user!['bloodgroup'] ?? "0",
        "identityProofId": "0",
        "identificationNumber": user!['identificationNumber'],
        "annualIncomeId": "0",
        "occupation": "",
        "education": "0",
        "noOfChildren": 0,
        "flightNumber": "",
        "txtPincode": pincode,
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "country": countrycode,
        "countryCode": countrycode,
        "specArrivalDate": "",
        "specArrivalTime": "",
        "formalinDate": "",
        "clinicalDetails": "",
        "seropositiveStatus": "N",
        "provisionalDiagnosis": "",
        "previousTherapy": "",
        "previousBiopsyCytology": "",
        "intraOperativeFindings": "",
        "anomalies": "",
        "additionalRemarks": "",
        "moreInfo": "",
        "histoTest": "N",
        "specRemovalDate": "",
        "specRemovalTime": "",
        "geneClinicalDetails": "",
        "genePreviousTherapy": "",
        "geneAnomalies": "",
        "geneAdditionalRemarks": "",
        "nhsNo": "",
        "lookupDetIdEthnicity": "",
        "refDoctorClnic": "",
        "patientType": null
      },
      "covidDetails": {
        "doseTypeId": 0,
        "cowinBeneficiaryId": "0",
        "typeOfVaccinationId": 0
      },
      "histoDetails": {},
      "paymentResponsibleDetails": {},
      "mlcDetails": {
        "mlcNo": "",
        "firNo": "",
        "authorityName": "",
        "mlcFirstName": "",
        "mlcLastName": "",
        "mlcCmoDoctor": 0,
        "buccleNo": "",
        "plStname": "",
        "mlcGender": "",
        "mlcMobile": "0",
        "mlcEmail": "",
        "mlcPlAddess": "",
        "mlcAge": "0",
        "mlcRelation": "0",
        "mlcAddressText": "",
        "incidentDetails": "",
        "mlcDate": null,
        "prefix3": "0"
      },
      "childrenDetails": null,
      "treatDetails": {
        "departmentId": "1",
        "doctorIdList": "",
        "appointmentId": 0,
        "token": 0,
        "tFlag": user!['tFlag'],
        "unitId": decode!['unitMasterId'],
        "deleted": null,
        "createdBy": decode!['userId'],
        // "createdDateTime": collectiondate,
        // "updatedDateTime": time,
        "createdDateTime": null,
        "updatedDateTime": null,
        "deletedBy": null,
        "deletedDateTime": null,
        "refDocId": 0,
        "caseType": 1,
        "weight": user!['height'],
        "height": user!['weight'],
        "notes": "-",
        "empid": "",
        "count": 1,
        "trcount": "0",
        "opdipdno": "0",
        "tpaid": "-",
        "cancelNarration": "-",
        "admCancelFlag": "N",
        "refersource": "0",
        "emergencyFlag": user!['emergencyFlag'] ?? "N",
        "patientHistory": history,
        "businessType": 1,
        "customerType": decode!['customerType'],
        "customerId": decode!['customerId'],
        "specialCase": specialcase ?? "0",
        "gestationalAge": 0,
        "urineVol": "0",
        "lmpDate": lmp,
        "tokenno": "0",
        "reqGenFormId": 0,
        "referredBy": null,
        "referredSource": 0,
        "referredSourceSlave": "",
        "referredSourceDocId": 0,
        "refDate": null,
        "sactionOrdNo": "0",
        "sanctionAmt": 0.0,
        "neisNo": "0",
        "visitNo": "0",
        "ipdOrOpd": "0",
        "treatPermited": "0",
        "diseToBeTreat": "0",
        "validUpToDate": null,
        "admissionCanDateTime": null,
        "admissionCanceledBy": null,
        "admissionDateTime": "",
        "refDoctorName": refdoc,
        "patientName": "",
        "userName": "",
        "cancelDate": null,
        "cancelTime": null,
        "radioPatientType": "C",
        "radioSelfRelative": "N",
        "radioPresentRetired": "N",
        "collectionDate": collectiondate,
        "collectionTime": time,
        "b2bPatientId": b2bid,
        "doctorMobileNo": docno,
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "patientBarcode": "",
        "registeredAt": "other",
        "networkApiChk": "N",
        "externalPatientId": extpatid,
        "listTreatment": null,
        "phyDateTime": null,
        "phyDisFlag": "N",
        "doctorName": "",
        "doctorSpecialisation": "",
        "doctorPerDayCharge": "",
        "doctorTotalDays": "",
        "doctorToalAmt": "",
        "doctorAttendanceDate": "",
        "doctorCheckupPatientCount": "",
        "patientTreatmentDateForDetailReport": "",
        "patientIdForDetailReport": "",
        "patientNameForDetailReport": "",
        "patientMobileForDetailReport": ""
      },
      "billMaster": {
        "departmentId": "1",
        "unitId": decode!['unitMasterId'],
        "count": user!['count'],
        "sponsorId": 0,
        "invoiceCount": user!['invoiceCount'],
        "invoiceFlag": user!['invoiceFlag'],
      },
      "billDetails": {
        "sourceTypeId": "0",
        "billId": user!['billId'],
        "unitId": decode!['unitMasterId'],
        "departmentId": "1",
        "sponsorId": "0",
        "chargesSlaveId": 0
      },
      "billDetIpd": null,
      "queryType": queryType,
      "AppId": 0,
      "preRegistrationId": 0
    };
    debugPrint(body.toString());

    final jsonbody = json.encode(body);
    debugPrint(jsonbody);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody

        //encoding: encoding,
        );
    debugPrint(response.body);
    if (response.body.contains('Patient registered successfully.')) {
      load = false;
      setState(() {});

      CustomMessage.toast(response.body);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const B2BQueue()));
    } else {
      load = false;
      setState(() {});

      CustomMessage.toast(response.body);
    }
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    decode = json.decode(encodedMap!);
    customertype = decode!['userAccesBeanList']['customerTypeName'];
    customertypename = decode!['userAccesBeanList']['customerName'];
    await fetchClientDetails();
    await fetchRefDoctor();
    await fetchCountryCode();
    setState(() {});
  }

  fetchRefDoctor() async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.REFDOC}?unitId=${decode!['unitMasterId']}');
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
    Map<String, dynamic> g = jsonDecode(response.body);

    if (response.statusCode == 200) {
      load = false;
      RefDoctorListModel refDoctorListModel = RefDoctorListModel.fromJson(g);
      setState(() {
        Refdoc = refDoctorListModel.lstDocDetailsDto;
        doc = false;
      });
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Invalid ');
    }
  }

  fetchPrefix() async {
    load = true;
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();

    unitname = prefs.getString('Unitname');

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    //SharedPreferences prefs = await SharedPreferences.getInstance();

    final uri = Uri.parse('${url.baseurl}${url.PREFIX}');
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
    Map<String, dynamic> g = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        item = g['tmCmLookupDetLookupList'];
        pre = false;
        //load=false;
      });
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(g['exception']);
    }
  }

  fetchGender(title) async {
    load = true;
    setState(() {});
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.GENDER_PREFIX}?title=$title');
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
    // Map<String,dynamic> g=jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        gender.text = response.body;
        load = false;
      });
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Failed');
    }
  }

  fetchCountryCode() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    load = false;
    setState(() {});
    final uri = Uri.parse('${url.baseurl}${url.COUNTRYCODE}');
    IOClient ioClient = IOClient(ByPassCert().httpClient);

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
    //debugPrint(response.body);
    Map<String, dynamic> g = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        countrycode = g['lstCountrydto'];
        var initialCountry =
            countrycode?.firstWhere((e) => e['countryCode'] == '+91');
        // ${countri!['countryCode']}-${countri!['countryName']}
        nation = initialCountry['countryName'];
        countri = initialCountry;
        c = false;
      });
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(g['exception']);
    }
  }

  void _updateDobFromFields() {
    int years = int.tryParse(year.text) ?? 0;
    int months = int.tryParse(month.text) ?? 0;
    int days = int.tryParse(day.text) ?? 0;

    if (years > 0 || months > 0 || days > 0) {
      DateTime now = DateTime.now();
      DateTime calculatedDob = DateTime(
        now.year - years,
        now.month - months,
        now.day - days,
      );

      age.text = DateFormat('dd-MM-yyyy').format(calculatedDob);
    }
  }
}
