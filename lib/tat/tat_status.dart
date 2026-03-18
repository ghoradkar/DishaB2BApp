import 'dart:convert';
import 'dart:io';
import 'package:dishabtob/lis/reporting/filter_report.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/tat/tat_table.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:excel/excel.dart' as excelR;
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TatStatus extends StatefulWidget {
  const TatStatus({super.key});

  @override
  State<TatStatus> createState() => _TatStatusState();
}

class _TatStatusState extends State<TatStatus> {
  bool load = false;
  var decode;

  List<dynamic>? dataList;
  String? fromDate;
  String? toDate;
  String? firstNameOrId;
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  TextEditingController firstNameOrIdController = TextEditingController();
  String? selectedMode;
  String? title;
  List<String> item = ["Patient Id", "Patient Name"];
  String? current;
  String patientId = '';

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
                                  'TAT Status',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    if (dataList?.length != 0 &&
                                        dataList != null) {
                                      await generateExcel();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColours.orange),
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Export To Excel",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.ios_share,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
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

                                                selectedMode = value;
                                                patientId =
                                                    firstNameOrIdController
                                                        .text;
                                                if (selectedMode == 'byId') {
                                                  await fetchTatList(
                                                      decode,
                                                      firstNameOrId ?? "0",
                                                      'search');
                                                } else if (selectedMode ==
                                                    'byName') {
                                                  await fetchTatListByNAme(
                                                      firstNameOrId ?? '',
                                                      "byName");
                                                }
                                                Navigator.pop(context);
                                              },
                                              onReset: () {
                                                // Handle reset logic if necessary
                                                selectedMode = null;
                                                fromDate = null;
                                                toDate = null;
                                                firstNameOrId = null;
                                                setModalState(() {});
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
                                                toDate.text = toDate;
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
                          bottom: MediaQuery.of(context).size.height * 0.018,
                          child: Container(
                              height: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 20, top: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: load
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: AppColours.blue,
                                    ))
                                  : Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // Background color
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            // Rounded corners
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
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const Row(
                                                children: [
                                                  Text(
                                                    "Business Type :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text("B2B"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text("Customer Name :",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(decode['userAccesBeanList']['customerName']),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        (dataList != null &&
                                                dataList!.isNotEmpty)
                                            ? Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: TatTable(
                                                    l1: List.generate(
                                                        dataList?.length ?? 0,
                                                        (index) => (index + 1)
                                                            .toString()),
                                                    l2: dataList
                                                            ?.map((e) =>
                                                                e['patientId'])
                                                            .toList() ??
                                                        [],
                                                    l3: dataList
                                                            ?.map((e) => e[
                                                                'patientName'])
                                                            .toList() ??
                                                        [],
                                                    l4: dataList
                                                            ?.map((e) =>
                                                                e['profileName'] ??
                                                                '')
                                                            .toList() ??
                                                        [],
                                                    l5: dataList
                                                            ?.map((e) =>
                                                                e['tatEndTime'] ??
                                                                '')
                                                            .toList() ??
                                                        [],
                                                    tableHeader: const [
                                                      "Sr.\nNo",
                                                      "Patient\nID",
                                                      "Patient\nName",
                                                      "Profile\nTest/Name",
                                                      "TAT End\nTime"
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const Expanded(
                                                child: DataNotFound()),
                                      ],
                                    )))
                    ]))),
            offlineChild: Offline()));
  }

  generateExcel() async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.TATSTATUSLISTExcel}?fromDate=${fromdate.text}&toDate=${todate.text}&sampleTypeIds=&testTypeId=0&headingId=0&callfrom=search&tatStatus=&testStatus=0&userFor=other&unitId=${decode['unitMasterId']}&userType=${decode['userType']}&customerIds=${decode['customerId']}&patientId=0&filterDateFlag=byRegDate');
    debugPrint(uri.path);

    final response = await ioClient.post(uri, headers: headers);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      List<dynamic>? lstTatReport;
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (FlavorConfig.instance.name == "B2BLifenity") {
        lstTatReport = data['result'] ?? [];
      } else {
        lstTatReport = data['lsttatreport'] ?? [];
      }

      if (lstTatReport == []) {
        CustomMessage.toast("No data to generate Excel");
        load = false;
        setState(() {});
        return;
      }

      // Create an Excel workbook
      var excel = excelR.Excel.createExcel();

      // Add a model sheet
      String sheetName = "Tat Report";
      excelR.Sheet sheet = excel[sheetName];

      // Add headers
      List<excelR.TextCellValue> excelHeaders = [
        excelR.TextCellValue("registration Date"),
        excelR.TextCellValue("Authorization DateTime"),
        excelR.TextCellValue("Profile Name"),
        excelR.TextCellValue("Patient Name"),
        excelR.TextCellValue("Patient ID"),
        excelR.TextCellValue("TAT Time"),
        excelR.TextCellValue("Test Status"),
        excelR.TextCellValue("TAT Start Time"),
        excelR.TextCellValue("TAT End Time"),
        excelR.TextCellValue("TAT Remaining Time"),
        excelR.TextCellValue("Late By"),
        excelR.TextCellValue("Stage"),
        excelR.TextCellValue("registration Time"),
        excelR.TextCellValue("TAT Flag"),
        excelR.TextCellValue("Customer Name"),
        excelR.TextCellValue("Flag"),
        excelR.TextCellValue("Test Status Int"),
        excelR.TextCellValue("Remaining Time Int")
      ];

      sheet.appendRow(excelHeaders);

      // Add data rows
      for (var report in lstTatReport!) {
        List<excelR.TextCellValue> row = [
          excelR.TextCellValue(report['registrationDate']),
          excelR.TextCellValue(report['authorizationDateTime']),
          excelR.TextCellValue(report['profileName']),
          excelR.TextCellValue(report['patientName']),
          excelR.TextCellValue(report['patientId'].toString()),
          excelR.TextCellValue(report['tatTime']),
          excelR.TextCellValue(report['testStatus']),
          excelR.TextCellValue(report['tatStartTime']),
          excelR.TextCellValue(report['tatEndTime']),
          excelR.TextCellValue(report['tatRemainingTime']),
          excelR.TextCellValue(report['lateBy']),
          excelR.TextCellValue(report['stage']),
          excelR.TextCellValue(report['registrationTime']),
          excelR.TextCellValue(report['tatFlag']),
          excelR.TextCellValue(report['customerName']),
          excelR.TextCellValue(report['flag']),
          excelR.TextCellValue(report['testStatusInt'].toString()),
          excelR.TextCellValue(report['remainingTimeInt'].toString())
        ];
        sheet.appendRow(row);
      }

      // Generate a timestamped filename
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = 'TatReport_$timestamp.xlsx';

      // Save the file in the application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.save()!);

      print('Excel file saved: $filePath');
      CustomMessage.toast("Excel saved: $fileName");

      // Open the file for the user
      OpenFile.open(filePath);

      load = false;
      setState(() {});
    } else {
      CustomMessage.toast("Something went wrong while generating Excel");
      load = false;
      setState(() {});
    }
  }

  getUser() async {
    debugPrint('tat screen');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // current = DateFormat('dd-MM-yyyy').format(DateTime.now());
    fromdate.text = current!;
    todate.text = current!;

    await fetchTatList(decode, "0", 'onload');

    setState(() {});
  }

  fetchTatList(decode, patientid, callFrom) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.TATSTATUSLIST}?fromDate=${fromdate.text}&toDate=${todate.text}&sampleTypeIds=&testTypeId=0&headingId=0&callfrom=$callFrom&tatStatus=0&testStatus=0&userFor=other&unitId=${decode['unitMasterId']}&userType=${decode['userType']}&customerIds=${decode['customerId']}&patientId=$patientid&filterDateFlag=byRegDate');
    debugPrint(uri.path);

    final response = await ioClient.post(uri, headers: headers);
    debugPrint(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      load = false;

      if (responseData['status'] == "Success") {
        dataList = responseData['result'];
      }
      // Cast to List<Map<String, dynamic>> if each item is a Map
    } else {
      load = false;
      CustomMessage.toast('Failed to load');
    }
    setState(() {});
  }

  fetchTatListByNAme(searchText, searchType) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.TATSTATUSLISTBYNAME}?searchText=$searchText&searchType=$searchType');
    debugPrint(uri.path);

    final response = await ioClient.get(uri, headers: headers);
    debugPrint(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      load = false;

      var responseData = jsonDecode(response.body);

      // Cast to List<Map<String, dynamic>> if each item is a Map
      dataList = responseData['result'];
    } else {
      load = false;
      CustomMessage.toast('Failed to load');
    }
    setState(() {});
  }
}
