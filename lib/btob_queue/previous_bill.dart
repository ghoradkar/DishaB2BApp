import 'dart:convert';

import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/custom_message.dart';
import '../network/network_aware.dart';
import '../network/network_status.dart';
import '../network/offline.dart';
import 'filter_bills.dart';

class PreviousBill extends StatefulWidget {
  List<dynamic> IPD = [];


  PreviousBill(this.IPD, {super.key});

  @override
  PreviousBillState createState() => PreviousBillState();
}

class PreviousBillState extends State<PreviousBill> {
  List<dynamic>? IPD;
  bool load = false;
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
  FocusNode fto = FocusNode();
  Map<String, dynamic>? decode;
  String? unitid;
  String? title = 'Patient Id';
  List<String> item = ["Patient Id"];
  FocusNode fpatid = FocusNode();
  TextEditingController patientid = TextEditingController();

  var unitcode;

  @override
  void initState() {
    setState(() {
      widget.IPD.length == 0 || widget.IPD == null ? load = true : load = false;
    });

    getuser();
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fromdate.text = formattedDate;
    todate.text = formattedDate;
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
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'B2B Previous Bill',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                          barrierColor:
                                              Colors.black.withOpacity(0.7),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.4),

                                          // context and builder are
                                          // required properties in this widget
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const FilterBills(callFrom: true,);
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
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(children: [
                              Expanded(
                                  child: load
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColours.blue,
                                          ),
                                        )
                                      : IPD != null &&
                                              IPD!.isEmpty &&
                                              widget.IPD.isEmpty
                                          ? const DataNotFound()
                                          :
                                          // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                                          widget.IPD.length == 0
                                              ? previousBillList(context, IPD)
                                              : previousBillList(
                                                  context, widget.IPD))
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  previousBillList(BuildContext context, IPD) {
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
                            height: 40, width: 40,
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
                            g['patientName'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                                Icon(
                                  Icons.tag,
                                  color: Colors.black87.withOpacity(0.6),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.receipt,
                                  color: Colors.black87.withOpacity(0.6),
                                ),
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
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                FlavorConfig.instance.name == "B2BLifenity"
                                    ? g['patientId'].toString()
                                    : g['ptId'].toString(),
                                style: const TextStyle(fontSize: 12),
                              ),

                              //SizedBox(width: 20,),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Bill No.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['opdipdno'] ?? "-",
                                style: const TextStyle(fontSize: 12),
                              ),
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
                                  Icons.phone_android,
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
                                'registration Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                FlavorConfig.instance.name == "B2BLifenity"
                                    ? g['createddatetime']
                                    : DateFormat('dd/MM/yyyy, HH:mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            g['createdDateTime'])),
                                style: const TextStyle(fontSize: 12),
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Mobile',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                '${g['mobile']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              //SizedBox(height: 10,),

                              //SizedBox(width: 20,),

                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height: MediaQuery.of(context).size.height *
                                      0.042,
                                  child: TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: const BorderSide(
                                                    color: Colors.white))),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColours.orange),
                                      ),
                                      onPressed: () async {
                                        if (FlavorConfig.instance.name ==
                                            "B2BLifenity") {
                                          fetchBill(
                                              g['treatmentId'],
                                              g['patientId'],
                                              g['departmentId'],
                                              g['unitId']);
                                        } else {
                                          fetchBill(g['ttId'], g['ptId'],
                                              g['department_id'], g['unitId']);
                                        }
                                      },
                                      child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Download Bill',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Icon(
                                              Icons.download,
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          ]))),
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

  fetchBill(treatid, patid, deptid, uid) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.PREVIOUS_BILL_DOWNLOAD}?treatId=$treatid&callfrom=general&Prev=No&patID=$patid&deptId=$deptid&unitId=$uid&userId=${decode!['userId']}&uName=${decode!['userName']}&unitCode=$unitcode');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
    );
    debugPrint(response.body);


    String? link;
    List t;
    Map<String, dynamic>? v;
    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    value['status'] == 'success'
        ? {
            setState(() {
              t = value['result'];
              v = t.first;
              link = v!['url'];
              launch(link!);
            })
          }
        : {CustomMessage.toast('Failed to load')};
  }

  unitName() async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final uri =
          Uri.parse('${url.baseurl}${url.UNIT}?ulogin=${decode['userName']}');
      debugPrint("b2bMobilefetchUnitList ${uri.path}");

      final response = await ioClient.post(
        uri,
        headers: headers,
      );

      debugPrint(response.body);
      Map<String, dynamic> value = jsonDecode(response.body);
      debugPrint(response.body);

      if (response.statusCode == 200 && value['lstUnit'].isNotEmpty) {
        load = false;

        var unit = value['lstUnit'];
        var getunit = unit.first;
        unitcode = getunit!['unitCode'];

        setState(() {});
      } else {
        setState(() {
          load = false;
        });
      }

      if (value['lstUnit'].isEmpty || response.statusCode != 200) {
        CustomMessage.toast('Please Enter Proper Username');
      } else {
        CustomMessage.toast('Please Wait');
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        load = false;
      });
      // CustomMessage.toast('Failed to fetch unit');
    }
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      unitid = prefs.getString('UnitId');
      debugPrint('hjghh$decode');
      widget.IPD.isEmpty
          ? searchbillbydate(DateTime.now().toString().substring(0, 10),
              DateTime.now().toString().substring(0, 10))
          : "";
      // fetchB2BList(DateTime.now().toString().substring(0,10),DateTime.now().toString().substring(0,10)):'';
    });
    unitName();
  }

  searchbillbydate(fromdate, todate) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.PREVIOUS_BILL}?inputFromDate=$fromdate&inputToDate=$todate&deptId=1&startIndex=0&businessType=1&userType=${decode!['userType']}&userFor=other&userId=${decode!['userId']}&unitId=$unitid');

    // final uri = Uri.parse(
    //     '${url.baseurl}${url.PREVIOUS_BILL}?inputFromDate=$fromdate&inputToDate=$todate&deptId=1&startIndex=0&businessType=1&userType=receptionist&userFor=other&userId=163&unitId=2');
    // debugPrint(uri);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(response.body);

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (value['status'] == 'failed') {
      CustomMessage.toast(value['response']);
      setState(() {
        IPD = [];
        load = false;
      });
      // Navigator.pop(context),
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => PreviousBill([],false))),
    } else {
      IPD = value['lstRegviewDto'] ?? [];

      load = false;
      // Navigator.pop(context);
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => PreviousBill(IPD!,true)));
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => Registration({},'',1,IPD,0)));
      setState(() {});
    }
  }
}
