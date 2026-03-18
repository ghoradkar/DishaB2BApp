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
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientHistory extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const PatientHistory(this.patient, {super.key});

  @override
  PatientHistoryState createState() => PatientHistoryState();
}

class PatientHistoryState extends State<PatientHistory> {
  bool load = true;
  List IPD = [];
  List result = [];
  String? link;
  Map<String, dynamic>? decode;
  final mediaStorePlugin = MediaStore();
  int _platformSDKVersion = 0;

  @override
  void initState() {
    setState(() {
      load = true;
    });
    initPermission();
    initPlatformState();
    getUser();
    //fetchIPDList();
    debugPrint(DateFormat('dd/MM/yyyy, HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(1705048026000)));
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
                              'Patient History',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: MediaQuery.of(context).size.height*0.08,),

                      Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.08,
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  // border: Border.all(color: Colors.grey.withOpacity(0.4)),

                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              height: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height * 0.2,
                              //- MediaQuery.of(context).size.height*0.2,
                              width: MediaQuery.of(context).size.width,
                              child: load
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppColours.blue,
                                      ),
                                    )
                                  : IPD.isNotEmpty
                                      ? SingleChildScrollView(
                                          child: Column(children: [
                                          Card(
                                              elevation: 3,
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.2)),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        // margin: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                colors: [
                                                                  AppColours
                                                                      .blue,
                                                                  AppColours
                                                                      .orange
                                                                ],
                                                                begin:
                                                                    const FractionalOffset(
                                                                        0.0,
                                                                        0.0),
                                                                end: const FractionalOffset(
                                                                    1.0, 0.0),
                                                                stops: const [
                                                                  0.0,
                                                                  1.0
                                                                ],
                                                                tileMode:
                                                                    TileMode
                                                                        .clamp),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        20))),
                                                        child: const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          widget.patient![
                                                                  'patientName']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.tag,
                                                        color: Colors.black87
                                                            .withOpacity(0.4),
                                                      ),
                                                      Column(
                                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Patient ID',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              widget.patient![
                                                                      'ptId']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.4),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            )
                                                          ]),
                                                    ],
                                                  ))),
                                          const SizedBox(
                                            height: 15,
                                          ),

                                          load
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColours.blue,
                                                  ),
                                                )
                                              : IPD.length == 0 &&
                                                      IPD!.length == 0
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height -
                                                              100,
                                                      child:
                                                          const DataNotFound())
                                                  : smartReport(context),
                                          // SizedBox(height: 100,)
                                        ]))
                                      : Column(children: [
                                          Card(
                                              elevation: 3,
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.2)),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        // margin: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                colors: [
                                                                  AppColours
                                                                      .blue,
                                                                  AppColours
                                                                      .orange
                                                                ],
                                                                begin:
                                                                    const FractionalOffset(
                                                                        0.0,
                                                                        0.0),
                                                                end: const FractionalOffset(
                                                                    1.0, 0.0),
                                                                stops: const [
                                                                  0.0,
                                                                  1.0
                                                                ],
                                                                tileMode:
                                                                    TileMode
                                                                        .clamp),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        20))),
                                                        child: const Icon(
                                                          Icons.person,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          widget.patient![
                                                                  'patientName']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.tag,
                                                        color: Colors.black87
                                                            .withOpacity(0.4),
                                                      ),
                                                      Column(
                                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Patient ID',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              widget.patient![
                                                                      'ptId']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.4),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            )
                                                          ]),
                                                    ],
                                                  ))),
                                          const SizedBox(
                                            height: 15,
                                          ),

                                          load
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColours.blue,
                                                  ),
                                                )
                                              : IPD.length == 0 &&
                                                      IPD!.length == 0
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height -
                                                              264,
                                                      child:
                                                          const DataNotFound())
                                                  : smartReport(context),
                                          // SizedBox(height: 100,)
                                        ])))
                    ]))),
            offlineChild: Offline()));
  }

  smartReport(BuildContext context) {
    return ListView.builder(
        itemCount: IPD.length,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = IPD[index];

          return Stack(clipBehavior: Clip.none, children: [
            Card(
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              elevation: 3,
              child: Container(
                //padding: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade200)),
                height: MediaQuery.of(context).size.height * 0.47,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.black87.withOpacity(0.6),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Reg Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      g['datetime'],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ])
                            ],
                          ),
                          Column(children: [
                            Container(
                                height: 15,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.lightGreen.withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: const Center(
                                    child: Text(
                                  'Sample Reported',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.lightGreen),
                                ))),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 50, top: 3),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: AppColours.orange,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                      child: IconButton(
                                    onPressed: () async {
                                      await fetchReportPDF(
                                          g['patientId'],
                                          FlavorConfig.instance.name ==
                                                  "B2BLifenity"
                                              ? g['masterIdd']
                                              : g['masterId'],
                                          "withheader");
                                      // launch('${url.baseurl}${url.REPORT}?masterId=19298&patientId= 19919&envFlag');
                                    },
                                    icon: const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                                  )),
                                ))
                          ]),
                        ]),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: Colors.black87.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Collected At',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['centerName'],
                                style: const TextStyle(color: Colors.grey),
                              )
                            ])
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black87.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['patientname'],
                                style: const TextStyle(color: Colors.grey),
                              )
                            ])
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.document_scanner_outlined,
                          color: Colors.black87.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Barcode',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['barCode'],
                                style: const TextStyle(color: Colors.grey),
                              )
                            ])
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.black87.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Collected Date & Time',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['collectedDateTime'],
                                style: const TextStyle(color: Colors.grey),
                              )
                            ])
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.water_drop_outlined,
                          color: Colors.black87.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Test Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['profileName'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              )
                            ])
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(
                            Icons.water_drop_rounded,
                            color: Colors.black87.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon(Icons.water_drop_rounded,color: Colors.black87.withOpacity(0.6),),
                                // SizedBox(width: 10,),
                                const Text(
                                  'Sample',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),

                                Text(
                                  g['samplename'],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ]),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Icon(
                            Icons.system_security_update_good_sharp,
                            color: Colors.black87.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Latest Version No.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  g['debugPrint_version'].toString(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ]),
                        ]),
                      ],
                    ),
                    //SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: MediaQuery.of(context).size.height * 0.46,
                left: 5,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: AppColours.blue,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Center(
                      child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  )),
                ))
          ]);
        });
  }

  String generateFilename() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyyMMdd_HHmmss');
    return 'file_${formatter.format(now)}.pdf'; // Adjusted to .pdf extension
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      fetchIPDList();
      // unitId= prefs.getString('UnitId');
      // debugdebugPrint('hjghh$decode');
      // widget.IPD!.length==0?fetchIPDList():'';
    });
  }

  initPermission() async {
    List<Permission> permissions = [
      Permission.storage,
    ];

    if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
      permissions.add(Permission.storage);
      // permissions.add(Permission.audio);
      // permissions.add(Permission.videos);
    }

    await permissions.request();
    // we are not checking the status as it is an example app. You should (must) check it in a production app

    // You have set this otherwise it throws AppFolderNotSetException
    MediaStore.appFolder = FlavorConfig.instance.name!;
  }

  Future<void> initPlatformState() async {
    int platformSDKVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformSDKVersion = await mediaStorePlugin.getPlatformSDKInt();
    } on PlatformException {
      platformSDKVersion = -1;
    }

    if (!mounted) return;

    setState(() {
      _platformSDKVersion = platformSDKVersion;
    });

    print((await mediaStorePlugin.getFilePathFromUri(
        uriString: 'content://media/external/images/media/1000000056')));
    print((await mediaStorePlugin.getFilePathFromUri(
        uriString:
            'content://media/external_primary/images/media/1000000057')));
  }

  void openExternalStorageFolder(String s) async {
    // Specify the path to the external storage directory
    String externalStoragePath = s; // Adjust the path as needed

    // Open the folder in external storage using the open_file package
    await OpenFile.open(externalStoragePath);
  }

  fetchIPDList() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.PATIENT_HISTORY}?callFrom=callbackVersionHistorySearchBtn&searchBy=byHistory&tabId=normal&emergencyFlag=ALL&patient_id=${widget.patient!['ptId']}&unitId=${decode!['unitMasterId']}&userType=${decode!['userId']}');
    debugPrint(uri.path);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');
    debugPrint(response.body);

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    response.statusCode == 200
        ? {
            setState(() {
              IPD = value['labSampleWiseMasterDtoList'];
              load = false;
            }),
          }
        : {CustomMessage.toast('Failed to load')};
  }

  Future<void> fetchReportPDF(patid, masterid, withOrWithoutHeader) async {
    load = true;
    setState(() {});
    // await checkAndRequestPermissions();
    Map<String, dynamic>? g;
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.REPORT}?masterId=$masterid&patientId=$patid&envFlag&reportFlag=$withOrWithoutHeader&unitId=${decode!['unitMasterId']}&headerFlag=Y');

    final response = await ioClient.post(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);

      if (value['status'] == 'success') {
        load = false;
        setState(() {});
        result = value['result'];
        g = result.first;
        link = g!['url'];
      }
      launch(link!);
    } else {
      load = false;
      setState(() {});
    }
  }
}
