import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addnewtest.dart';

class NewPackage extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final dynamic samples;
  final List<dynamic>? testList;

  const NewPackage(this.patient, this.samples, this.testList, {super.key});

  @override
  NewPackageState createState() => NewPackageState();
}

class NewPackageState extends State<NewPackage> {
  bool load = false;
  Map<String, dynamic>? decode;
  String? unitcode;
  List IPD = [];
  Map<String, dynamic> g = {};
  var userUnitId;
  var patientDet;

  @override
  void initState() {
    setState(() {
      load = true;
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
                                  'Sample Wise Services',
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
                              //SizedBox(height: 20,),
                              Expanded(
                                  child: load
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColours.blue,
                                          ),
                                        )
                                      : // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                                      IPD.isEmpty
                                          ? const Center(
                                              child: DataNotFound(),
                                            )
                                          : testListWidget(context)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color: Colors.grey))),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  Colors.white30),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Close',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            // side: BorderSide(color: Colors.red)
                                          )),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  AppColours.orange
                                                      .withOpacity(0.9)),
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddNewTest(
                                                      widget.patient,
                                                      null,
                                                      widget.testList,
                                                      widget.samples,
                                                      fromAddPackagePage: true,
                                                      savedTestPackageList: IPD,
                                                      patientDet: patientDet,
                                                    )),
                                          );
                                        },
                                        child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Save',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  testListWidget(BuildContext context) {
    return ListView.builder(
        itemCount: IPD.length,
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = IPD[index];

          return Stack(children: [
            Card(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                elevation: 3,
                color: const Color.fromRGBO(237, 245, 250, 1),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(237, 245, 250, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.shade200)),
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      Icons.settings,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Icon(
                                      Icons.science,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //SizedBox(height: 10,),
                                  const Text(
                                    'Sample Type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    '${g['samplename']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  //SizedBox(width: 20,),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Tests',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 210),
                                    child: Text(
                                      '${g['testName']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),

                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.01,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.185,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    color: AppColours.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Center(
                    child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(color: Colors.white),
                )),
              ),
            ),
          ]);
        });
  }

  fetchTreatment() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    //older api url
    final uri = Uri.parse(
        '${url.baseurl}${url.FETCHPATIENTDETAISL}?callform=${widget.patient!['treatmentId']}');

    debugPrint(uri.path);
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

    Map<String, dynamic> value = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      patientDet = value['listRegTreBillDto'];
      load = false;
      setState(() {});

      await fetchTestList();
    } else {
      setState(() {
        load = false;

        //loadname=false;
      });
    }
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    userUnitId = prefs.get("UnitId");

    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      unitcode = prefs.getString("UnitCode");
    });
    await fetchTreatment();
  }

  fetchTestList() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.TEST_LIST_PACKAGE}?unitId=$userUnitId&businessType=1&serviceId=${widget.samples['serviceid'].toString()}&subServiceId=${widget.samples['categoryid'].toString()}&patientId=${widget.patient!['patientId'].toString()}&treatmentId=${widget.patient?['treatmentId'].toString()}&billDetailsId=0&customerType=${patientDet[0]['customerType'].toString()}&customerId=${patientDet[0]['customerId'].toString()}');
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
    g = jsonDecode(response.body);

    if (g['status'] == 'success') {
      setState(() {
        IPD = g['responses'];
        debugPrint('jhgfgh');
        debugPrint(IPD.length.toString());
        load = false;
      });
    } else {
      CustomMessage.toast(g['status']);
      load = false;
      setState(() {});
    }
  }
}
