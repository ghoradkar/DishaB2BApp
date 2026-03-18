import 'dart:convert';
import 'package:age_calculator/age_calculator.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/registration/model/id_proof_model.dart';
import 'package:dishabtob/registration/model/blood_group_model.dart';
import 'package:dishabtob/registration/model/patient_type_model.dart';
import 'package:dishabtob/registration/registration.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemographicInfo extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final  Map<String, dynamic>? details;
  // final List? details;
  final String? access;
  final int? ttid;

  const DemographicInfo(this.patient, this.details, this.access, this.ttid,
      {super.key});

  @override
  DemographicInfoState createState() => DemographicInfoState();
}

class DemographicInfoState extends State<DemographicInfo> {
  bool load = false;
  List<Map<String, dynamic>> covid = [];
  String? dose_name;
  String? vaccine_name;
  String? edit;
  int? selindex;
  int? ptid;
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic>? user;
  List<dynamic>? nationality;
  String? vaccine;
  List<dynamic>? vaccinetype;
  List<dynamic>? dosetype;
  String? dose;

  Map<String, dynamic>? decode;
  String? customertype;
  String? customertypename;
  List<dynamic>? IPD;
  String? unitname;
  bool _switchValue = true;
  IdProofResult? idProof;
  bool visible = false;
  BloodGroupResult? bloodgroup;
  int? nation;
  FocusNode fidnumber = FocusNode();
  TextEditingController idnumber = TextEditingController();
  FocusNode fpassport = FocusNode();
  TextEditingController passport = TextEditingController();
  FocusNode fvisa = FocusNode();
  TextEditingController visa = TextEditingController();
  FocusNode fhasana = FocusNode();
  TextEditingController hasana = TextEditingController();
  FocusNode fheight = FocusNode();
  TextEditingController height = TextEditingController();
  FocusNode fweight = FocusNode();
  TextEditingController weight = TextEditingController();
  FocusNode fcowin = FocusNode();
  TextEditingController cowin = TextEditingController();
  FocusNode fvaccine = FocusNode();
  TextEditingController vaccinedate = TextEditingController();

  PatientTypeModel? patientTypeModel;

  Result? dropdownValue;

  List<BloodGroupResult>? bloodgrouplist;

  List<IdProofResult>? idProofList;

  @override
  void initState() {
    // fetchIPDList();
    setState(() {
      load = true;
    });
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
                body: SingleChildScrollView(
                    child: Container(
                        color: Colors.white,
                        child: Column(children: [
                          Card(
                            color: Colors.white,
                            elevation: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.98,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border:
                                      Border.all(color: Colors.grey.shade200)),
                              padding: const EdgeInsets.all(3),
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        const Text(
                                          'Name : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          customertypename?.toString() ?? "",
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ]),
                                      Row(children: [
                                        const Text(
                                          'Type : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                        Text(
                                          customertype ?? "",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ]),
                                      Row(children: [
                                        const Text(
                                          'Unit : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                        Text(
                                          (unitname ?? "").trim(),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ]),
                                    ],
                                  )),
                                  Column(
                                    children: [
                                      const Text(
                                        'Emergency',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                      Row(children: [
                                        const Text(
                                          'No',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                        CupertinoSwitch(
                                          value: _switchValue,
                                          activeColor: AppColours.blue,
                                          onChanged: (value) {
                                            widget.access == 'view'
                                                ? {}
                                                : setState(() {
                                                    _switchValue = value;
                                                  });
                                          },
                                        ),
                                        Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: AppColours.blue,
                                              fontSize: 11),
                                        ),
                                      ])
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                              child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                  colors: [AppColours.blue, AppColours.orange],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: ExpansionTile(
                              onExpansionChanged: (value) {
                                setState(() {
                                  visible = value;
                                });
                              },
                              initiallyExpanded: true,
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              shape: const Border(
                                  top: BorderSide(color: Colors.white),
                                  bottom: BorderSide(color: Colors.white)),
                              title: const Text(
                                "Bio/Medical Information",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15))),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FlavorConfig.instance.name == "DubaiB2B"
                                            ? Center(
                                                child: SizedBox(
                                                // decoration: BoxDecoration(
                                                //   border: Border.all(
                                                //     color: Colors.grey,
                                                //   ),
                                                //   color: Colors.white,
                                                //   borderRadius:
                                                //       const BorderRadius.all(
                                                //     Radius.circular(10),
                                                //   ),
                                                // ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: DropdownButtonFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.person,
                                                      color: Colors.black54,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10,
                                                    ),
                                                  ),
                                                  hint: Text(
                                                    'Patient Type *',
                                                    style: TextStyle(
                                                      color: Colors.black87
                                                          .withOpacity(0.7),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: dropdownValue,
                                                  validator: (value) => value ==
                                                          null
                                                      ? 'patient type is required'
                                                      : null,
                                                  items: patientTypeModel
                                                      ?.result
                                                      ?.map((e) =>
                                                          DropdownMenuItem<
                                                              Result>(
                                                            value: e,
                                                            child: Text(e
                                                                    .patientTypeName ??
                                                                ''), // Handle null values
                                                          ))
                                                      .toList(),
                                                  onChanged: (Result? value) {
                                                    dropdownValue = value;
                                                    setState(() {});
                                                    // Handle selection
                                                  },
                                                ),
                                              ))
                                            : const SizedBox.shrink(),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        Center(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade200,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.account_box_outlined,
                                                    color: Colors.black54),
                                                // Prefix Icon
                                                const SizedBox(width: 10),
                                                // Add some spacing
                                                Expanded(
                                                    child: FormField(
                                                  builder:
                                                      (FormFieldState state) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        DropdownButton(
                                                          underline: Container(
                                                            color: Colors.white,
                                                          ),
                                                          hint: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Id Proof',
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
                                                          // padding: const EdgeInsets.all(5),
                                                          isExpanded: true,
                                                          dropdownColor:
                                                              Colors.white,
                                                          iconEnabledColor:
                                                              Colors.black54,
                                                          value: idProof,
                                                          items: idProofList
                                                              ?.map((country) {
                                                            return DropdownMenuItem(
                                                              value: country,
                                                              child: Text(
                                                                country.idProofName ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (country) {
                                                            setState(() {
                                                              idProof =
                                                                  country!;
                                                              state.didChange(
                                                                  country); // Inform the FormField of changes
                                                            });
                                                          },
                                                        ),
                                                        if (state.hasError)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5),
                                                            child: Text(
                                                              state.errorText!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                      ],
                                                    );
                                                  },
                                                  initialValue: idProof,
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'ID proof is required';
                                                    }
                                                    return null;
                                                  },
                                                )),
                                              ],
                                            ),
                                          ),
                                        )),
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
                                              enabled: widget.access == 'view'
                                                  ? false
                                                  : true,
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

                                              focusNode: fidnumber,
                                              autofocus: true,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: idnumber,
                                              //focusNode: fpassword,
                                              //obscureText: _obscured,
                                              // validator: (value) {
                                              //   if (value == null ||
                                              //       value.trim().isEmpty) {
                                              //     return "Identification Number can not be empty";
                                              //   } else {
                                              //     return null;
                                              //   }
                                              // },
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              cursorColor: Colors.black,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.transparent,

                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 4, 0),
                                                  child: GestureDetector(
                                                    //   onTap: _toggleObscured,
                                                    child: Icon(
                                                      Icons.tag,
                                                      color: Colors.black87
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),

                                                //hintText: 'Enter Username',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14),
                                                label: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'Identification Number',
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                              // validator: (value) {
                                              //   if (value == null ||
                                              //       value.isEmpty) {
                                              //     return 'passport is required';
                                              //   } else {
                                              //     return null;
                                              //   }
                                              // },

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

                                              focusNode: fpassport,
                                              enabled: widget.access == 'view'
                                                  ? false
                                                  : true,
                                              autofocus: true,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: passport,

                                              style: const TextStyle(
                                                  color: Colors.black),
                                              cursorColor: Colors.black,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.transparent,

                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),

                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 4, 0),
                                                  child: GestureDetector(
                                                    //   onTap: _toggleObscured,
                                                    child: Icon(
                                                      Icons.book,
                                                      color: Colors.black87
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),

                                                //hintText: 'Enter Username',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14),
                                                label: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Passport',
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                              enabled: widget.access == 'view'
                                                  ? false
                                                  : true,
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

                                              focusNode: fvisa,
                                              autofocus: true,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: visa,
                                              //focusNode: fpassword,
                                              //obscureText: _obscured,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
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
                                                fillColor: Colors.transparent,

                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 4, 0),
                                                  child: GestureDetector(
                                                    //   onTap: _toggleObscured,
                                                    child: Icon(
                                                      Icons
                                                          .contact_page_outlined,
                                                      color: Colors.black87
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),

                                                //hintText: 'Enter Username',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14),
                                                label: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Visa Type',
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                              enabled: widget.access == 'view'
                                                  ? false
                                                  : true,
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

                                              focusNode: fhasana,
                                              autofocus: true,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: hasana,
                                              //focusNode: fpassword,
                                              //obscureText: _obscured,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
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
                                                fillColor: Colors.transparent,

                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 4, 0),
                                                  child: GestureDetector(
                                                    //   onTap: _toggleObscured,
                                                    child: Icon(
                                                      Icons.save,
                                                      color: Colors.black87
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),

                                                //hintText: 'Enter Username',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14),
                                                label: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Hasana Number',
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                            child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade200,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    "assets/nationality.png"),
                                                // Prefix Icon
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: FormField<int>(
                                                    builder:
                                                        (FormFieldState<int>
                                                            state) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          DropdownButton<int>(
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
                                                                        'Nationality *',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black87
                                                                          .withOpacity(
                                                                              0.7),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            autofocus: true,
                                                            // padding:
                                                            //     const EdgeInsets
                                                            //         .all(5),
                                                            isExpanded: true,
                                                            dropdownColor:
                                                                Colors.white,
                                                            iconEnabledColor:
                                                                Colors.black54,
                                                            value: nation,
                                                            items: nationality
                                                                ?.map(
                                                                    (country) {
                                                              return DropdownMenuItem<
                                                                  int>(
                                                                value: FlavorConfig
                                                                            .instance
                                                                            .name ==
                                                                        "B2BLifenity"
                                                                    ? country[
                                                                        'id']
                                                                    : country[
                                                                        'nationalityId'],
                                                                child: Text(
                                                                  FlavorConfig.instance
                                                                              .name ==
                                                                          "B2BLifenity"
                                                                      ? country[
                                                                          'nationality']
                                                                      : country[
                                                                          'nationality'],
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
                                                              setState(() {
                                                                nation = int
                                                                    .parse(country
                                                                        .toString());
                                                                state.didChange(
                                                                    nation); // Update FormField state
                                                              });
                                                            },
                                                          ),
                                                          if (state.hasError)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5),
                                                              child: Text(
                                                                state
                                                                    .errorText!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                    initialValue: nation,
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a nationality';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        Center(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 8),
                                              const Icon(
                                                  Icons.bloodtype_outlined),
                                              Expanded(
                                                child: DropdownButton(
                                                  underline: Container(
                                                    color: Colors.white,
                                                  ),
                                                  hint: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Blood Group',
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
                                                  autofocus: true,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  isExpanded: true,
                                                  dropdownColor: Colors.white,
                                                  iconEnabledColor:
                                                      Colors.black54,
                                                  value: bloodgroup,
                                                  items: bloodgrouplist
                                                      ?.map((country) {
                                                    return DropdownMenuItem(
                                                      value: country,
                                                      child: Text(
                                                        country.bloodGroupName ??
                                                            '',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (country) {
                                                    if (widget.access ==
                                                        'view') {
                                                    } else {
                                                      setState(() {
                                                        bloodgroup = country;
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.37,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    enabled:
                                                        widget.access == 'view'
                                                            ? false
                                                            : true,
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

                                                    focusNode: fweight,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: weight,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    // validator: (value) {
                                                    //   if (value!.isEmpty) {
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

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Weight',
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
                                              Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.37,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  child: TextFormField(
                                                    enabled:
                                                        widget.access == 'view'
                                                            ? false
                                                            : true,
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

                                                    focusNode: fheight,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: height,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    //focusNode: fpassword,
                                                    //obscureText: _obscured,
                                                    // validator: (value) {
                                                    //   if (value!.isEmpty) {
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

                                                      //hintText: 'Enter Username',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14),
                                                      label: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Height',
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
                                            ],
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
                                              enabled: widget.access == 'view'
                                                  ? false
                                                  : true,
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

                                              focusNode: fcowin,
                                              autofocus: true,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: cowin,
                                              //focusNode: fpassword,
                                              //obscureText: _obscured,
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
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
                                                fillColor: Colors.transparent,

                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 4, 0),
                                                  child: GestureDetector(
                                                    //   onTap: _toggleObscured,
                                                    child: Icon(
                                                      Icons.tag,
                                                      color: Colors.black87
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),

                                                //hintText: 'Enter Username',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14),
                                                label: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'Cowin Beneficiary Id',
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
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                          )),
                          Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  gradient: LinearGradient(
                                      colors: [
                                        AppColours.blue,
                                        AppColours.orange
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 0.0),
                                      stops: const [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: ExpansionTile(
                                    // onExpansionChanged:(value){
                                    //   setState(() {
                                    //     visible=value;
                                    //   });
                                    // },

                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    shape: const Border(
                                        top: BorderSide(color: Colors.white),
                                        bottom:
                                            BorderSide(color: Colors.white)),
                                    // collapsedShape:  RoundedRectangleBorder(
                                    //     side:new  BorderSide(color:Colors.white), //the outline color
                                    //     borderRadius:  BorderRadius.all( Radius.circular(20))),
                                    // collapsedBackgroundColor: Colors.white,

                                    title: const Text(
                                      "Covid Information",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade200),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15))),
                                        child: Form(
                                          child: Column(children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              child: DropdownButton(
                                                underline: const SizedBox(),
                                                hint: RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Dose Type',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                autofocus: true,
                                                padding:
                                                    const EdgeInsets.all(5),
                                                isExpanded: true,
                                                dropdownColor: Colors.white,
                                                iconEnabledColor:
                                                    Colors.black54,
                                                value: dose,
                                                items: dosetype?.map((country) {
                                                  return DropdownMenuItem(
                                                    value:
                                                        country['lookupDetId']
                                                            .toString(),
                                                    child: Text(
                                                      country[
                                                          'lookupDetDescEn'],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (country) {
                                                  var t = country;
                                                  debugPrint(t);

                                                  Map<String, dynamic> h =
                                                      dosetype!.elementAt(
                                                          dosetype!.indexWhere(
                                                              (element) =>
                                                                  element[
                                                                      "lookupDetId"] ==
                                                                  int.parse(
                                                                      t!)));

                                                  dose_name =
                                                      h['lookupDetDescEn'];

                                                  dose = country.toString();
                                                  debugPrint(dose);
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                  setState(() {});
                                                },
                                              ),
                                            )),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            Center(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              child: DropdownButton(
                                                underline: Container(
                                                  color: Colors.white,
                                                ),
                                                hint: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Vaccine Type',
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
                                                autofocus: true,
                                                padding:
                                                    const EdgeInsets.all(5),
                                                isExpanded: true,
                                                dropdownColor: Colors.white,
                                                iconEnabledColor:
                                                    Colors.black54,
                                                value: vaccine,
                                                items:
                                                    vaccinetype?.map((country) {
                                                  return DropdownMenuItem(
                                                    value:
                                                        country['lookupDetId']
                                                            .toString(),
                                                    child: Text(
                                                      country[
                                                          'lookupDetDescEn'],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (country) {
                                                  var t = country;
                                                  if (widget.access != 'view') {
                                                    Map<String, dynamic> h =
                                                        vaccinetype!.elementAt(
                                                            vaccinetype!.indexWhere(
                                                                (element) =>
                                                                    element[
                                                                        "lookupDetId"] ==
                                                                    int.parse(
                                                                        t!)));

                                                    vaccine_name =
                                                        h['lookupDetDescEn'];
                                                    debugPrint(vaccine_name);

                                                    vaccine =
                                                        country.toString();
                                                    FocusScope.of(context)
                                                        .nextFocus();
                                                    setState(() {});
                                                  }
                                                },
                                              ),
                                            )),
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
                                                  focusNode: fvaccine,
                                                  enabled:
                                                      widget.access == 'view'
                                                          ? false
                                                          : true,
                                                  autofocus: true,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller: vaccinedate,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                          data:
                                                              Theme.of(context)
                                                                  .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary:
                                                                  AppColours
                                                                      .blue,
                                                              // <-- SEE HERE
                                                              onPrimary:
                                                                  Colors.white,
                                                              // <-- SEE HERE
                                                              onSurface: AppColours
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
                                                      firstDate: DateTime(1900),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 0)),
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
                                                        vaccinedate.text =
                                                            formattedDate;

                                                        var year1 =
                                                            pickedDate.year;
                                                        var year2 =
                                                            DateTime.now().year;
                                                        int months, days;
                                                        int totalDays =
                                                            DateTime.now()
                                                                .difference(
                                                                    pickedDate)
                                                                .inDays;
                                                        int years =
                                                            totalDays ~/ 365;
                                                        DateDuration duration;

                                                        months = (totalDays -
                                                                years * 365) ~/
                                                            30;
                                                        days = totalDays -
                                                            years * 365 -
                                                            months * 30;

                                                        duration = AgeCalculator.dateDifference(
                                                            fromDate: DateTime(
                                                                pickedDate.year,
                                                                pickedDate
                                                                    .month,
                                                                pickedDate.day),
                                                            toDate: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day));
                                                      });
                                                    } else {
                                                      debugPrint(
                                                          "Date is not selected");
                                                    }
                                                  },
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,

                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    //floatingLabelBehavior: FloatingLabelBehavior.never,
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 4, 0),
                                                      child: GestureDetector(
                                                        onTap: () {},
                                                        child: const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    prefixIcon: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 4, 0),
                                                      child: GestureDetector(
                                                        onTap: () {},
                                                        child: Icon(
                                                          Icons.calendar_month,
                                                          color: Colors.black87
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ),

                                                    //hintText: 'Enter Username',
                                                    hintStyle: const TextStyle(
                                                        fontSize: 14),
                                                    label: RichText(
                                                      text: const TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'Date Of Vaccination',
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
                                                            color: Colors.black,
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
                                                  0.04,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
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
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                AppColours
                                                                    .orange),
                                                  ),
                                                  onPressed: () async {
                                                    if (edit == 'edit' &&
                                                        dose != null &&
                                                        vaccine != null) {
                                                      setState(() {
                                                        covid.removeAt(
                                                            selindex!);
                                                        edit = 'edited';
                                                        CustomMessage.toast(
                                                            'Information Added Successfully');
                                                        covid.add({
                                                          "doseTypeId": dose,
                                                          "cowinBeneficiaryId":
                                                              cowin.text,
                                                          "typeOfVaccinationId":
                                                              vaccine,
                                                          "Date Of Vaccination":
                                                              vaccinedate.text,
                                                          "dose_name":
                                                              dose_name,
                                                          "vaccine_name":
                                                              vaccine_name
                                                        });

                                                        // vaccinedate.clear();
                                                        // vaccine = null;
                                                        // dose = null;
                                                      });
                                                    } else if (dose != null &&
                                                        vaccine != null) {
                                                      //vaccinedate.text.trim().isEmpty||cowin.text.trim().isEmpty?CustomMessage.toast('Please Select date and Cowin Id'):

                                                      setState(() {
                                                        CustomMessage.toast(
                                                            'Information Added Successfully');
                                                        covid.add({
                                                          "doseTypeId": dose,
                                                          "cowinBeneficiaryId":
                                                              cowin.text,
                                                          "typeOfVaccinationId":
                                                              vaccine,
                                                          "Date Of Vaccination":
                                                              vaccinedate.text,
                                                          "dose_name":
                                                              dose_name,
                                                          "vaccine_name":
                                                              vaccine_name
                                                        });

                                                        // vaccinedate.clear();
                                                        // vaccine = null;
                                                        // dose = null;
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          edit != 'edit'
                                                              ? 'Add'
                                                              : "Update",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                        ),
                                                        const Icon(
                                                          Icons.arrow_forward,
                                                          color: Colors.white,
                                                          size: 20,
                                                        )
                                                      ]),
                                                )),
                                            covid.isEmpty
                                                ? Container(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.8,
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue
                                                            .withOpacity(0.1),
                                                        borderRadius: const BorderRadius
                                                            .all(
                                                          Radius.circular(10),
                                                        ),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .shade400)),
                                                    margin: const EdgeInsets.only(
                                                        top: 20),
                                                    // height: MediaQuery.of(context).size.height * 0.1,
                                                    child: const Text(
                                                        'Data Not Selected',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14)))
                                                : Expanded(child: smartReport(context))
                                          ]),
                                        ),
                                      ),
                                    ])),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.access != 'view'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: const BorderSide(
                                                        color: Colors.grey))),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white30),
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
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )
                                              ]),
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              // side: BorderSide(color: Colors.red)
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(AppColours.orange),
                                          ),
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                    .validate() ==
                                                true) {
                                              widget.access == 'edit' ||
                                                      widget.access == 'add'
                                                  ? editPatient(
                                                      _switchValue,
                                                      idProof?.idproofId ?? 0,
                                                      idnumber.text,
                                                      passport.text,
                                                      visa.text,
                                                      hasana.text,
                                                      nation,
                                                      bloodgroup
                                                              ?.bloodGroupId ??
                                                          0,
                                                      weight.text,
                                                      height.text,
                                                      cowin.text,
                                                      '',
                                                      covid,
                                                      dose,
                                                      vaccine)
                                                  : register(
                                                      _switchValue,
                                                      idProof,
                                                      idnumber.text,
                                                      passport.text,
                                                      visa.text,
                                                      hasana.text,
                                                      nation,
                                                      bloodgroup,
                                                      weight.text,
                                                      height.text,
                                                      cowin.text,
                                                      '',
                                                      covid);
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
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 20,
                                                )
                                              ]),
                                        )),
                                  ],
                                )
                              : const SizedBox()
                        ])))),
            offlineChild: Offline()));
  }

  smartReport(BuildContext context) {
    return ListView.builder(
        itemCount: covid.length,
        //padding: EdgeInsets.only(bottom: 5),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = covid[index];

          return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(color: Colors.grey.shade400)),
              margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
              // height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        const Text(
                          'Dose Type:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          g['dose_name'],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          'Type of Vaccine:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          g['vaccine_name'],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          'Date of Vaccination:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          g['Date Of Vaccination'].toString(),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ]),
                    ],
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selindex = index;
                                edit = 'edit';
                                vaccine = g['typeOfVaccinationId'];
                                dose = g['doseTypeId'];
                                vaccinedate.text = g['Date Of Vaccination'];
                              });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey.shade600,
                              size: 20,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                covid.removeAt(index);
                                vaccine = null;
                                dose = null;
                                vaccinedate.clear();
                              });
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.grey.shade600,
                              size: 20,
                            ))
                      ])
                ],
              ));
        });
  }

  editPatient(
      switchvalue,
      idtype,
      idno,
      passport,
      visatype,
      hasana,
      nationality,
      bloodgroup,
      weight,
      height,
      cowin,
      covidinfo,
      covid,
      dose,
      vaccine) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    var t;
    widget.patient!['ptId'] ?? (t = ptid);
    final uri = Uri.parse(
        '${url.baseurl}${url.REGISTRATION}?userId=${decode!['userId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "patientDetails": {
        "patientId": user!['ptId'],
        "prefix": user!['prefix'],
        "lookupDetIdTtl": "19",
        "fName": user!['fName'],
        "mName": user!['mName'],
        "lName": user!['lName'],
        "gender": user!['gender'],
        "mobile": user!['mobile'],
        "dob": user!['dob'],
        "age": user!['age'].toString(),
        "ageMonths": user!['ageMonths'].toString(),
        "ageDays": user!['ageDays'].toString(),
        "districtId": user!['districtId'],
        "stateId": user!['stateId'],
        "areaCode": 0,
        "unitId": decode!['unitMasterId'].toString(),
        "adharcardNo": "",
        "transSMS": "Y",
        "transEmail": "Y",
        "pramoEmail": "N",
        "pramoSMS": "N",
        "emergency": switchvalue == true ? 'Y' : 'N',
        "external": "N",
        "mrnno": "",
        "address": user!['address'],
        "imageName": "patientPhoto.jpg",
        "aadharImageName": "aadhar.jpg",
        "aadharBackImageName": "aadhar.jpg",
        "passport": passport,
        "visa": visatype,
        "hasanaID": hasana,
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
        "emailId": user!['emailId'],
        "maritalStatusId": "0",
        "nationalityId": nation.toString(),
        "religionId": "0",
        "languageId": "0",
        "bloodGroupId": bloodgroup,
        "identityProofId": idtype.toString(),
        "identificationNumber": idno,
        "annualIncomeId": "0",
        "occupation": "",
        "education": "0",
        "noOfChildren": 0,
        "flightNumber": "",
        "txtPincode": user!['txtPincode'].toString(),
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "country": user!['country_code'].toString(),
        "countryCode": user!['country_code'].toString(),
        "specArrivalDate": "",
        "specArrivalTime": "",
        "formalinDate": "",
        "formalinFixationTime": "",
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
        "specRemovalTime": "14:59",
        "geneClinicalDetails": "",
        "genePreviousTherapy": "",
        "geneAnomalies": "",
        "geneAdditionalRemarks": "",
        "nhsNo": "",
        "lookupDetIdEthnicity": "",
        "refDoctorClnic": "",
        "patientType": dropdownValue?.patientTypeId.toString(),
      },
      "covidDetails": {
        "doseTypeId": dose,
        "cowinBeneficiaryId": cowin.toString(),
        "typeOfVaccinationId": vaccine
      },
      "histoDetails": {},
      "paymentResponsibleDetails": {},
      "mlcDetails": {
        "mlcId": "0",
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
        "businessType": "1",
        "gestationalAge": "0",
        "urineVol": "0",
        "lmpDate": user!['lmp'],
        "specialCase": "0",
        "refersource": "0",
        "customerType": decode!['customerType'],
        "customerId": decode!['customerId'],
        "tFlag": "N",
        "doctorIdList": "",
        "unitId": decode!['unitMasterId'],
        "refDocId": "0",
        "weight": weight,
        "height": height,
        "empid": "",
        "tpaid": "",
        "caseType": "1",
        "reqGenFormId": "0",
        "referredBy": "--Select--",
        "referredSource": "0",
        "referredSourceSlave": "",
        "referredSourceDocId": "0",
        "refDate": null,
        "sanctionAmt": "0",
        "sactionOrdNo": "0",
        "neisNo": "0",
        "visitNo": "0",
        "ipdOrOpd": "0",
        "validUpToDate": null,
        "treatPermited": "0",
        "diseToBeTreat": "0",
        "admissionDateTime": "",
        "radioSelfRelative": "N",
        "radioPresentRetired": "N",
        "emergencyFlag": user!['emergencyFlag'],
        "patientHistory": user!['patientHistory'],
        "b2bPatientId": user!['b2b_Patient_id'],
        "collectionDate": user!['collectionDate'],
        "collectionTime": user!['collectionTime'],
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "patientBarcode": "",
        "registeredAt": "other",
        "refDoctorName": user!['refDoctorName'].toString(),
        "doctorMobileNo": "",
        "externalPatientId": user!['externalPatientId'].toString(),
      },
      "billMaster": {
        "sourceTypeId": "0",
        "departmentId": "1",
        "billId": user!['billId'],
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
      "queryType": "update",
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

    response.body.contains('Patient registered successfully.')
        ? {
            CustomMessage.toast('Patient Details Updated Successfully..'),
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const Registration({}, '', 0, [], 0)),
            ),
          }
        : CustomMessage.toast('Failed');
  }

  register(switchvalue, idtype, idno, passport, visatype, hasana, nationality,
      bloodgroup, weight, height, cowin, covidinfo, covid) async {
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
        "patientId": widget.patient!['ptId'],
        "prefix": '',
        "lookupDetIdTtl": "19",
        "fName": '',
        "mName": '',
        "lName": '',
        "gender": '',
        "mobile": '',
        "dob": '',
        "age": '',
        "ageMonths": '',
        "ageDays": '',
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
        "mrnno": "",
        "address": '',
        "imageName": "patientPhoto.jpg",
        "aadharImageName": "aadhar.jpg",
        "aadharBackImageName": "aadhar.jpg",
        "passport": passport,
        "visa": visatype,
        "hasanaID": hasana,
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
        "emailId": '',
        "maritalStatusId": "0",
        "nationalityId": nationality,
        "religionId": "0",
        "languageId": "0",
        "bloodGroupId": bloodgroup,
        "identityProofId": idtype,
        "identificationNumber": idno,
        "annualIncomeId": "0",
        "occupation": "",
        "education": "0",
        "noOfChildren": 0,
        "flightNumber": "",
        "txtPincode": '',
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "country": '',
        "countryCode": '',
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
        "patientType": dropdownValue?.patientTypeId.toString()
      },
      "covidDetails": {
        "doseTypeId": 0,
        "cowinBeneficiaryId": cowin,
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
        "createdBy": null,
        "createdDateTime": "",
        "updatedDateTime": null,
        "deletedBy": null,
        "deletedDateTime": null,
        "refDocId": 0,
        "caseType": 1,
        "weight": weight,
        "height": height,
        "notes": "-",
        "empid": "",
        "count": 1,
        "trcount": "0",
        "opdipdno": "0",
        "tpaid": "-",
        "cancelNarration": "-",
        "admCancelFlag": "N",
        "refersource": "0",
        "emergencyFlag": '',
        "patientHistory": '',
        "businessType": 1,
        "customerType": decode!['customerType'],
        "customerId": decode!['customerId'],
        "specialCase": '',
        "gestationalAge": 0,
        "urineVol": "0",
        "lmpDate": '',
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
        "refDoctorName": '',
        "patientName": "",
        "userName": "",
        "cancelDate": null,
        "cancelTime": null,
        "radioPatientType": "C",
        "radioSelfRelative": "N",
        "radioPresentRetired": "N",
        "collectionDate": '',
        "collectionTime": '',
        "b2bPatientId": '',
        "doctorMobileNo": '',
        "connectingFlight": "",
        "optDestinationCity": "",
        "flightDepartureDate": "",
        "flightDepartureTime": "",
        "destinationCity": "",
        "cityOfOrigin": "",
        "patientBarcode": "",
        "registeredAt": "other",
        "networkApiChk": "N",
        "externalPatientId": '',
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
      "queryType": "update",
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
    response.body.contains('Patient registered successfully.')
        ? {
            CustomMessage.toast(response.body),
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      Registration(const {}, 'add', 0, const [], 0)),
            ),
          }
        : CustomMessage.toast('Failed');
  }

  fetchIPDList() async {
    // Initialize IOClient with bypass certificate handling
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    // Define headers for the API call
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Construct the URI with parameters
    final uri = Uri.parse(
        '${url.baseurl}${url.MARKLIST}?unitId=${decode!['unitMasterId']}&meeshaFlow=off&userType=${decode!['userType']}&userId=${decode!['userId']}&userFor=other');
    debugPrint('Request URL: ${uri.toString()}');

    try {
      // Make the POST request
      final response = await ioClient.post(
        uri,
        headers: headers,
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      // Decode the JSON response
      if (response.statusCode == 200) {
        Map<String, dynamic> value = jsonDecode(response.body);

        // Access the 'lstRegviewDto' list
        setState(() {
          IPD = value['lstRegviewDto']; // Assign the list to the IPD variable
          load = false;

          // Safely access the first element if the list is not empty
          if (IPD != null && IPD!.isNotEmpty) {
            ptid = IPD?.first['ptId'];
            debugPrint('First ptId: $ptid');
          } else {
            debugPrint('lstRegviewDto is empty');
          }
        });
      } else {
        // Handle non-200 responses
        CustomMessage.toast('Failed to load');
      }
    } catch (e) {
      // Handle exceptions
      debugPrint('Error fetching IPD list: $e');
      CustomMessage.toast('An error occurred');
    }
  }

  bloodGroupList() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse('${url.baseurl}${url.GETBLOODGROUP}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      BloodGroupModel bloodGroupModel = BloodGroupModel.fromJson(value);
      setState(() {
        bloodgrouplist = bloodGroupModel.result;
        load = false;
      });
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  getIdProofList() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse('${url.baseurl}${url.IDPROOFLIST}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      IdProofModel idProofModel = IdProofModel.fromJson(value);
      setState(() {
        idProofList = idProofModel.result;
        load = false;
      });
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  fetchNationality() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.NATIONALITY}');
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
    Map<String, dynamic> g = jsonDecode(response.body);

    response.statusCode == 200
        ? {
            setState(() {
              nationality = g['nationalityList'];
              load = false;
            }),
          }
        : CustomMessage.toast(g['exception']);
  }

  fetchDoseType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    unitname = prefs.getString('Unitname');
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.DOSE}');
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
    Map<String, dynamic> g = jsonDecode(response.body);

    response.statusCode == 200
        ? {
            setState(() {
              dosetype = g['tmCmLookupDetLookupList'];
              load = false;
            }),
          }
        : CustomMessage.toast(g['exception']);
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      decode = json.decode(encodedMap!);
      // decode=user!.first;

      customertype = decode!['userAccesBeanList']['customerTypeName'];
      customertypename = decode!['userAccesBeanList']['customerName'];
      debugPrint(customertype);
      debugPrint(customertypename);
    });
    await fetchIPDList();
    await bloodGroupList();
    await getIdProofList();

    await fetchNationality();
    await fetchDoseType();
    await fetchVaccineType();
    await getPatientType();
    widget.details == null
        ? setState(() {
            user = {};
          })
        : setState(() {
            user = widget.details;
          });

    if (widget.details != null) {
      // debugPrint(item[user!['identityProofId']]);

      if (user!['identityProofId'] != 0) {
        idProof = idProofList
            ?.firstWhere((e) => e.idproofId == user!['identityProofId']);
      }

      _switchValue = user!['emergencyFlag'] == 'Y' ? true : false;
      //title=item.where((element) => )

      idnumber.text = user!['identificationNumber'] != null ? user!['identificationNumber'].toString():'';
      passport.text = user!['passport'] ?? "";
      visa.text = user!['visa'] ?? '';
      hasana.text = user!['hasanaId'] ?? '';
      height.text = user!['height'];
      weight.text = user!['weight'];
      if (user!['bloodGroupId'] != 0) {
        BloodGroupResult? bloodG = bloodgrouplist
            ?.firstWhere((e) => e.bloodGroupId == (user!['bloodGroupId']));
        bloodgroup = bloodG;
      }
      // bloodgroup = user!['bloodGroupId'];
      nation = user!['nationalityId'];
      print(widget.patient);
      if (FlavorConfig.instance.name == "DubaiB2B") {
        dropdownValue = patientTypeModel?.result?.firstWhere(
            (e) =>
                e.patientTypeId ==
                int.parse(widget.patient?['lstMarkVisit'][0]['patientType']),
            orElse: () => Result());
      }

      cowin.text = user!['covidList'] == null
          ? ""
          : user!['covidList']['cowinBeneficiaryId'];

      //cowin.text=user![''];
      setState(() {});
    }
  }

  fetchVaccineType() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.VACCINE}');
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
    Map<String, dynamic> g = jsonDecode(response.body);

    response.statusCode == 200
        ? {
            setState(() {
              vaccinetype = g['tmCmLookupDetLookupList'];
              load = false;
            }),
          }
        : CustomMessage.toast(g['exception']);
  }

  getPatientType() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.PATIENTTYPE}');
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
      Map<String, dynamic> g = jsonDecode(response.body);

      patientTypeModel = PatientTypeModel.fromJson(g);
      setState(() {
        load = false;
      });
    } else {
      setState(() {
        load = false;
      });
    }
  }
}
