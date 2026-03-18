import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/btob_queue/addtest.dart';
import 'package:dishabtob/dashboard/homescreen.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class B2BQueuePatientList extends StatefulWidget {
  const B2BQueuePatientList({super.key});

  @override
  B2BQueuePatientListState createState() => B2BQueuePatientListState();
}

class B2BQueuePatientListState extends State<B2BQueuePatientList> {
  List? IPD;
  bool load = false;
  Map<String, dynamic>? decode;
  List<dynamic>? sample;
  String? title = 'Patient Id';
  List<String> item = ["Patient Id", 'Patient Name'];
  FocusNode fpatid = FocusNode();
  String? current;
  TextEditingController patientid = TextEditingController();

  @override
  void initState() {
    getuser();
    fetchSampleList();
    setState(() {
      current = DateFormat('yyyy-MM-dd').format(DateTime.now());
      load = true;
    });
    //fetchB2BList(decode);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StreamProvider<NetworkStatus>(
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          initialData: NetworkStatus.Online,
          child: NetworkAwareWidget(
              onlineChild: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(children: [
                      Card(
                          // elevation: 1,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width * 0.9,
                            //margin: EdgeInsets.only(top: 10),
                            // padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  width:
                                      MediaQuery.of(context).size.width * 0.78,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: DropdownButton(
                                    underline: Container(
                                      color: Colors.white,
                                    ),
                                    hint: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Prefix',
                                            style: TextStyle(
                                                color: Colors.black87
                                                    .withOpacity(0.7),
                                                fontSize: 14),
                                          ),
                                          const TextSpan(
                                            text: '*',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    autofocus: true,
                                    padding: const EdgeInsets.all(5),
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black54,
                                    value: title,
                                    items: item.map((country) {
                                      return DropdownMenuItem(
                                        value: country,
                                        child: Text(
                                          country,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (country) {
                                      setState(() {
                                        title = country;
                                        FocusScope.of(context).nextFocus();
                                      });
                                    },
                                  ),
                                )),
                                Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: TextFormField(
                                      onEditingComplete: () {
                                        FocusScope.of(context).nextFocus();
                                      },
                                      //  Unitname(username.text);},
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).nextFocus();
                                      },
                                      // Unitname(username.text);},

                                      focusNode: fpatid,
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                      controller: patientid,
                                      //focusNode: fpassword,
                                      //obscureText: _obscured,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Patient ID can not be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      style:
                                          const TextStyle(color: Colors.black),
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.transparent,

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
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
                                        disabledBorder: OutlineInputBorder(
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
                                            const TextStyle(fontSize: 12),
                                        label: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: title == 'Patient Id'
                                                    ? 'Type Patient ID here'
                                                    : 'Type Patient Name Here',
                                                style: TextStyle(
                                                    color: Colors.black87
                                                        .withOpacity(0.7),
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // labelText: 'Password',
                                        // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                        floatingLabelStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
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
                                                          Color>(
                                                      AppColours.orange
                                                          .withOpacity(0.9)),
                                            ),
                                            onPressed: () async {
                                              patientid.text == null ||
                                                      patientid.text
                                                          .trim()
                                                          .isEmpty
                                                  ? fetchB2BList(decode)
                                                  : fetchB2BItem(
                                                      patientid.text, title);
                                            },
                                            child: const Row(
                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Search',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ]),
                                          ))),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: load || IPD == null
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColours.blue,
                                  ),
                                )
                              : IPD == []
                                  ? const Center(
                                      child: DataNotFound(),
                                    )
                                  : b2bQueueList(context))
                    ]),
                  )),
              offlineChild: Offline())),
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
      debugPrint('hjghh$decode');
      fetchB2BList(decode);
    });
  }

  fetchB2BItem(patid, tit) async {
    load = true;
    setState(() {});
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri;
    final response;
    Map<String, dynamic>? value;
    if (tit == 'Patient Id') {
      uri = Uri.parse(
          '${url.baseurl}${url.B2BSEARCH}?deptId=1&letter=$patid&usertype=PID&businessType=1&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&userTypeForCall=${decode!['userType']}&userId=${decode!['userId']}&startIndex=0&unitId=${decode!['unitMasterId']}&userFor=other&userType=${decode!['userType']}');

      response = await ioClient.get(
        uri,
        headers: headers,
      );

      value = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          IPD = value!['listOpdQueManagmentViewDto'];
          load = false;
        });
      } else {
        load = false;
        setState(() {});
        CustomMessage.toast('Failed to load');
      }
    } else {
      uri = Uri.parse(
          '${url.baseurl}${url.B2BSEARCH}?deptId=1&letter=$patid&usertype=N&businessType=1&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&userTypeForCall=${decode!['userType']}&userId=${decode!['userId']}&startIndex=0&unitId=${decode!['unitMasterId']}&userFor=other&userType=${decode!['userType']}');
      // debugPrint(uri),
      response = await ioClient.get(
        uri,
        headers: headers,
      );

      value = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          IPD = value!['listOpdQueManagmentViewDto'];
          load = false;
        });
      } else {
        load = false;
        setState(() {});
        CustomMessage.toast('Failed to load');
      }
    }
  }

  fetchB2BList(decode) async {
    load = true;
    setState(() {});
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    String l = decode!['deptId'];
    debugPrint(l.substring(0, 1));

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.B2BQUEUE}?deptId=${l.substring(0, 1)}&unitId=${decode!['unitMasterId']}&userId1=${decode!['userId']}&userType=${decode!['userType']}&businessType=1&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&userId=${decode!['userId']}&startIndex=0&userFor=other');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
    );

    Map<String, dynamic> value = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        IPD = value['listOpdQueManagmentViewDto'];
        load = false;
      });
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Failed to load');
    }
  }

  fetchSampleList() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.SAMPLE_LIST}?searchText=&callFrom=onload');
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

    if (response.statusCode == 200) {
      setState(() {
        sample = g['testSamplelist'];
        load = false;
      });
    } else {
      CustomMessage.toast('Invalid ');
    }
  }

  b2bQueueList(BuildContext context) {
    return ListView.builder(
        itemCount: IPD!.length,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = IPD![index];

          return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 3,
              child: Container(
                //  padding: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade200)),
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Container(
                            height: 24, width: 24,
                            // margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      AppColours.blue,
                                      AppColours.orange
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: const [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            g['patientName'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //SizedBox(width: 10,),

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(Icons.tag,
                                    color: Colors.black87.withOpacity(0.6),
                                    size: 20),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(Icons.calendar_month,
                                    color: Colors.black87.withOpacity(0.6),
                                    size: 20),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(Icons.calendar_month,
                                    color: Colors.black87.withOpacity(0.6),
                                    size: 20),
                              ]),
                        ),
                        //SizedBox(width: 10,),

                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Patient ID',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(
                                g['patientId'].toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                              //SizedBox(height: 10,),

                              //SizedBox(width: 20,),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Age',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(
                                FlavorConfig.instance.name == "B2BLifenity"
                                    ? g['patientAge'] ?? g['age']
                                    : g['age'] ?? '',
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Admission Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(
                                FlavorConfig.instance.name == "B2BLifenity"
                                    ? g['createdDateTimee'] == null
                                        ? g['createddatetime']
                                        : formatDateTime(g['createdDateTimee'])
                                    : DateFormat('dd/MM/yyyy, HH:mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            g['createdDateTime'])),
                                style: const TextStyle(fontSize: 10),
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
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //SizedBox(height: 10,),

                                Icon(Icons.phone_android,
                                    color: Colors.black87.withOpacity(0.6),
                                    size: 20),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.person,
                                  color: Colors.black87.withOpacity(0.6),
                                  size: 20,
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
                              //SizedBox(height: 5,),
                              const Text(
                                'Mobile',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(
                                '${g['mobile']}',
                                style: const TextStyle(fontSize: 10),
                              ),
                              //SizedBox(height: 10,),

                              //SizedBox(width: 20,),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Gender',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text(
                                '${g['gender']}',
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // SizedBox(
                              //     width:
                              //     MediaQuery
                              //         .of(context)
                              //         .size
                              //         .width * 0.215,
                              //     height:
                              //     MediaQuery
                              //         .of(context)
                              //         .size
                              //         .height * 0.04,
                              //     child: TextButton(
                              //       style: ButtonStyle(
                              //         shape: MaterialStateProperty.all<
                              //             RoundedRectangleBorder>(
                              //             RoundedRectangleBorder(
                              //               borderRadius:
                              //               BorderRadius.circular(20.0),
                              //               // side: BorderSide(color: Colors.red)
                              //             )),
                              //         backgroundColor:
                              //         MaterialStateProperty.all<Color>(
                              //             AppColours.orange
                              //                 .withOpacity(0.9)),
                              //       ),
                              //       onPressed: () async {
                              //         Navigator.of(context)
                              //             .push(MaterialPageRoute(
                              //             builder: (context) =>
                              //             //Addnewtest(g,null,sample)));
                              //             AddTest(g, sample)));
                              //       },
                              //       child: const Text(
                              //         'Add Tests',
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //             fontSize: 10),
                              //       ),
                              //     )),
                              //
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  String formatDateTime(String inputDate) {
    try {
      // Parse the incoming ISO format
      DateTime dateTime = DateTime.parse(inputDate);

      // Format to dd/MM/yyyy, HH:mm:ss
      return DateFormat('dd/MM/yyyy, HH:mm:ss').format(dateTime.toLocal());
    } catch (e) {
      return inputDate; // fallback
    }
  }
}
