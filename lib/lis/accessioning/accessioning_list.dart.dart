import 'dart:convert';
import 'package:dishabtob/Global/custom_message.dart';
import 'package:dishabtob/lis/reporting/filter_report.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AccessioningList extends StatefulWidget {
  const AccessioningList({super.key});

  @override
  AccessioningListState createState() => AccessioningListState();
}

class AccessioningListState extends State<AccessioningList> {
  bool load = false;
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  TextEditingController firstNameOrIdController = TextEditingController();
  String? title;
  List<String> item = ["Patient Id", "Patient Name"];
  String? current;
  String? fromDate;
  String? toDate;
  String? firstNameOrId;
  List? accesioningList;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    current = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fromdate.text = current!;
    todate.text = current!;
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    getInitialData(fromDate != null ? fromDate! : formattedDate,
        toDate != null ? toDate! : formattedDate, "", "", "byDate");
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
                                //  SizedBox(width: 5,),
                                const Text(
                                  'Accessioning',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      barrierColor:
                                          Colors.black.withOpacity(0.7),
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.4),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setModalState) {
                                            return FilterReport(
                                              callBy: (value) async {
                                                fromDate = fromdate.text;
                                                toDate = todate.text;
                                                firstNameOrId =
                                                    firstNameOrIdController
                                                        .text;

                                                if (firstNameOrIdController
                                                    .text.isNotEmpty) {
                                                  if (value == "byId") {
                                                    await fetchListById(
                                                        firstNameOrIdController
                                                            .text);
                                                  } else if (value ==
                                                      "byName") {
                                                    await fetchListByName(
                                                        firstNameOrIdController
                                                            .text);
                                                  }
                                                } else {
                                                  await getInitialData(
                                                      fromdate.text,
                                                      todate.text,
                                                      "",
                                                      "",
                                                      "byDate");
                                                }

                                                Navigator.pop(context);
                                              },
                                              onReset: () {
                                                fromDate = null;
                                                toDate = null;
                                                firstNameOrId = null;

                                                Navigator.pop(context);
                                              },
                                              fromDateController: fromdate,
                                              toDateController: todate,
                                              firstname:
                                                  firstNameOrIdController,
                                              onTapFromD: (fromD) {
                                                fromdate.text = fromD;
                                                setModalState(
                                                    () {}); // Update modal state
                                              },
                                              onTapToD: (toDate) {
                                                // toDate.text = toDate;
                                                setModalState(
                                                    () {}); // Update modal state
                                              },
                                              onChangedFirstName: (firstName) {
                                                firstNameOrIdController.text =
                                                    firstName;
                                                setModalState(
                                                    () {}); // Update modal state
                                              },
                                              title: title ?? item.first,
                                              item: item,
                                              onChangedSearchBy: (searchBy) {
                                                title =
                                                    searchBy; // Update selected dropdown value
                                                setModalState(
                                                    () {}); // Update modal state to reflect changes
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt,
                                    color: Colors.white,
                                  ),
                                )
                              ])),
                      Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          child: Container(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(children: [
                              Expanded(
                                  child: load || accesioningList == null
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColours.blue,
                                          ),
                                        )
                                      : accesioningList!.isNotEmpty
                                          ? accessioningListWidget(context)
                                          : const DataNotFound())
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  accessioningListWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          String formattedDate =
              DateFormat('dd/MM/yyyy').format(DateTime.now());

          await getInitialData(fromDate != null ? fromDate! : formattedDate,
              toDate != null ? toDate! : formattedDate, "", "", "byDate");
        },
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: accesioningList?.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 5,bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  // height: MediaQuery.of(context).size.height * 0.32,
                  // width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        AppColours.blue,
                                        AppColours.orange,
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
                              accesioningList?[index]['patientname'] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              flex: 7,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Icon(
                                            Icons.tag,
                                            color:
                                                Colors.black87.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Image.asset('assets/barcode.png'),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Icon(
                                            Icons.edit_outlined,
                                            color:
                                                Colors.black87.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Icon(
                                            Icons.settings,
                                            color:
                                                Colors.black87.withOpacity(0.6),
                                          ),
                                        ]),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //  SizedBox(height: 5,),
                                          const Text(
                                            'Patient ID',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            accesioningList?[index]
                                                        ['patientId'] !=
                                                    null
                                                ? accesioningList![index]
                                                        ['patientId']
                                                    .toString()
                                                : "",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),

                                          const Text(
                                            'Barcode',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            accesioningList?[index]['barCode'] ??
                                                "",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Test Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),

                                          LayoutBuilder(
                                              builder: (context, constraints) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                accesioningList?[index]
                                                        ['profileName'] ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                                // Adds "..." if text overflows
                                                maxLines: 2,
                                              ),
                                            );
                                          }),
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          const Text(
                                            'Sample Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            accesioningList?[index]
                                                    ['samplename'] ??
                                                "",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.0),
                                    child: Column(children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'Reg. Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          accesioningList?[index]
                                                  ['registeredDate'] ??
                                              "",
                                          style: const TextStyle(fontSize: 12),
                                        ),

                                        const SizedBox(
                                          height: 10,
                                        ),

                                        const Text(
                                          'Collection\nDate & Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          '${accesioningList?[index]['collectedDateTime'].replaceAll(', ', ',\n') ?? ""}',
                                          style: const TextStyle(fontSize: 12),
                                        ),

                                        //
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.37,
                              // height: MediaQuery.of(context).size.height *
                              //     0.042,
                              child: TextButton(
                                  style: ButtonStyle(
                                    alignment: Alignment.center,
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.white))),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      AppColours.orange,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    accesioningList?[index]
                                            ['statusDescription'] ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ))),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  getInitialData(fromdate, todate, patid, patientName, searchBy) async {
    await fetchListByDate(fromdate, todate, patid, patientName, searchBy);
  }

  fetchListByDate(fromdate, todate, patid, patientName, searchBy) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.Accessioning}?custTypeId=0&custNameId=0&fromDate=$fromdate&toDate=$todate&callFrom=accessionTestSearchBtn&searchBy=$searchBy&tabId=AL&startIndex=0&emergencyFlag=All&patientId=$patid&patientname=$patientName&testNameId=0&unitId=${decode?['unitMasterId']}&user&userType=${decode?['userType']}&customerIds=${decode?['customerId']}');
        // '${url.baseurl}${url.Accessioning}?custTypeId=${decode?['customerType']}&custNameId=${decode?['customerId']}&fromDate=$fromdate&toDate=$todate&callFrom=accessionTestSearchBtn&searchBy=$searchBy&tabId=AL&startIndex=0&emergencyFlag=All&patientId=$patid&patientname=$patientName&testNameId=0&unitId=${decode?['unitMasterId']}&user&userType=${decode?['userType']}&customerIds=${decode?['customerId']}');
    debugPrint(uri.path);
    final response = await ioClient.get(
      uri,
      headers: headers,
    );

    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      firstNameOrIdController.text = "";
      title = item.first;
      accesioningList = value['labSampleWiseMasterDtoList'];
      setState(() {});
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  fetchListById(patid) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.AccessioningByID}?callFrom=accessionTestAutoSugg&tabId=AL&emergencyFlag=All&id=$patid&unitId=${decode?['unitMasterId']}&userType=${decode?['userType']}&customerIds=${decode?['customerId']}');
    debugPrint(uri.path);
    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      firstNameOrIdController.text = "";
      title = item.first;
      accesioningList = value['labSampleWiseMasterDtoList'];
      // return value['labSampleWiseMasterDtoList'];
      setState(() {});
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  fetchListByName(patientName) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.AccessioningByName}?callFrom=accessionTestAutoSugg&tabId=AL&emergencyFlag=All&patientName=$patientName&unitId=${decode?['unitMasterId']}&userType=${decode?['userType']}&customerIds=${decode?['customerId']}');
    debugPrint(uri.path);
    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    debugPrint(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      firstNameOrIdController.text = "";
      title = item.first;
      accesioningList = value['labSampleWiseMasterDtoList'];
      // return value['labSampleWiseMasterDtoList'];
      setState(() {});
    } else {
      CustomMessage.toast('Failed to load');
    }
  }
}
