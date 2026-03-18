import 'dart:convert';
import 'dart:io';

import 'package:dishabtob/billing/model/post_paid_ledger_details.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:excel/excel.dart' as excelR;
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPaidLedgerReport extends StatefulWidget {
  const PostPaidLedgerReport({super.key});

  @override
  State<PostPaidLedgerReport> createState() => _PostPaidLedgerReportState();
}

class _PostPaidLedgerReportState extends State<PostPaidLedgerReport> {
  bool load = false;
  var decode;
  var data;
  PostPaidLedgerDetails? dataList;

  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();

  String? unitcode;

  @override
  void initState() {
    var current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fromdate.text = current;
    todate.text = current;
    getUser();
    super.initState();
  }



  @override
  Widget build(BuildContext context,) {
    return StreamProvider<NetworkStatus>(
        create: (context) =>
        NetworkStatusService().networkStatusController.stream,
        initialData: NetworkStatus.Online,
        child: NetworkAwareWidget(
            onlineChild: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.2,
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
                          const Expanded(
                            child: Text(
                              'Postpaid Ledger Report',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                                onTap: () {
                                  generateExcel();
                                },
                                child: const Icon(
                                  Icons.file_download_outlined,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                      barrierColor:
                                      Colors.black.withOpacity(0.7),
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.4),
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return filterDetails();
                                      });
                                },
                                child: const Icon(
                                  Icons.filter_alt_outlined,
                                  color: Colors.white,
                                )),
                          ),
                        ])),
                Positioned(
                    bottom: MediaQuery
                        .of(context)
                        .size
                        .height * 0.018,
                    child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height -
                            MediaQuery
                                .of(context)
                                .size
                                .height * 0.15,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: const EdgeInsets.only(
                            left: 10, right: 20, top: 0),
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
                            : dataList?.result?.isEmpty ?? true
                            ? const DataNotFound()
                            : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: dataList?.result?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 5),
                                child: Card(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, top: 10),
                                    elevation: 3,
                                    color: const Color.fromRGBO(
                                        237, 245, 250, 1),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                      ),
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              237, 245, 250, 1),
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(
                                                  10)),
                                          border: Border.all(
                                              color: Colors
                                                  .grey.shade200)),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                2.0),
                                            child: Row(children: [
                                              const Padding(
                                                padding:
                                                EdgeInsets.only(
                                                    right: 4),
                                                child: Icon(
                                                  Icons
                                                      .calendar_month,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  const Text(
                                                    "Date",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                        "Nunito Sans"),
                                                  ),
                                                  Text(
                                                    dataList
                                                        ?.result?[
                                                    index]
                                                        .date !=
                                                        null
                                                        ? dataList!
                                                        .result![
                                                    index]
                                                        .date!
                                                        : "",
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .grey,
                                                        fontSize: 14,
                                                        fontFamily:
                                                        "Nunito Sans"),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                2.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              right:
                                                              4),
                                                          child: Icon(
                                                            Icons
                                                                .money,
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Debit Amount",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  12,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                            Text(
                                                              dataList
                                                                  ?.result?[index]
                                                                  .debit !=
                                                                  null
                                                                  ? dataList!
                                                                  .result![index]
                                                                  .debit!
                                                                  .toString()
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              right:
                                                              4),
                                                          child: Icon(
                                                            Icons
                                                                .money,
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Credit Amount",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  12,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                            Text(
                                                              dataList
                                                                  ?.result?[index]
                                                                  .credit !=
                                                                  null
                                                                  ? dataList!
                                                                  .result![index]
                                                                  .credit
                                                                  .toString()
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                2.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              right:
                                                              4),
                                                          child: Icon(
                                                            Icons
                                                                .settings_outlined,
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              const Text(
                                                                "Particulars",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 12,
                                                                    fontFamily: "Nunito Sans"),
                                                              ),
                                                              Text(
                                                                dataList
                                                                    ?.result?[index]
                                                                    .centreName !=
                                                                    null
                                                                    ? dataList!
                                                                    .result![index]
                                                                    .centreName!
                                                                    : "",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: 14,
                                                                    fontFamily: "Nunito Sans"),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                ]),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                2.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                              4),
                                                          child: Image
                                                              .asset(
                                                              'assets/file-text.png'),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "VC Type",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  12,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                            Text(
                                                              dataList
                                                                  ?.result?[index]
                                                                  .voucherType !=
                                                                  null
                                                                  ? dataList!
                                                                  .result![index]
                                                                  .voucherType
                                                                  .toString()
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                              4),
                                                          child: Image
                                                              .asset(
                                                            'assets/hash.png',
                                                            color: Colors
                                                                .grey,
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "VC No.",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  12,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                            Text(
                                                              dataList
                                                                  ?.result?[index]
                                                                  .voucherNo !=
                                                                  null
                                                                  ? dataList!
                                                                  .result![index]
                                                                  .voucherNo
                                                                  .toString()
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                  14,
                                                                  fontFamily:
                                                                  "Nunito Sans"),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            })))
                    ]))),
        offlineChild: Offline()));
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    unitcode = prefs.getString("UnitCode");

    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);

    fetchCustomerLedger(
      decode,
      date,
      date,
      decode['unitMasterId'],
      unitcode,
      decode['customerId'],
    );

    setState(() {});
  }

  fetchCustomerLedger(decode, fromDate, toDate, unitId, unitCode,
      customerId) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url
            .POSTPAIDLEDGERDETAILS}?fromDate=$fromDate&toDate=$toDate&customerType=${decode['customerType']}&customerUnit=0&unitId=$unitId&unitCode=$unitCode&customerId=$customerId');
    debugPrint(uri.path);

    final response = await ioClient.post(uri, headers: headers);
    debugPrint(response.body);
    // debugPrint(value);
    if (response.statusCode == 200) {
      load = false;
      var responseData = jsonDecode(response.body);
      if (responseData['status'] != 'fail') {
        dataList = PostPaidLedgerDetails.fromJson(responseData);
      }
      // Cast to List<Map<String, dynamic>> if each item is a Map
    } else {
      load = false;
      CustomMessage.toast('Failed to load fetchCustomerLedger');
    }
    setState(() {});
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
        '${url.baseurl}${url.POSTPAIDLEDGEREXCEL}?fromDate=${fromdate
            .text}&toDate=${todate
            .text}&unitId=${decode['unitMasterId']}&customerUnit=0&customerId=${decode['customerId']}&customerType=${decode['customerType']}&unitCode=$unitcode');
    debugPrint(uri.path);

    final response = await ioClient.post(uri, headers: headers);
    debugPrint(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> lstTatReport = data['result'] ?? [];

      if (lstTatReport.isEmpty) {
        CustomMessage.toast("No data to generate Excel");
        load = false;
        setState(() {});
        return;
      }

      // Create an Excel workbook
      var excel = excelR.Excel.createExcel();

      // Add a model sheet
      String sheetName = "Postpaid  Ledger Report";
      excelR.Sheet sheet = excel[sheetName];

      // Add headers
      List<excelR.TextCellValue> excelHeaders = [
        excelR.TextCellValue("Date"),
        excelR.TextCellValue("Centre Name"),
        excelR.TextCellValue("Voucher No"),
        excelR.TextCellValue("Voucher Type"),
        excelR.TextCellValue("Credit"),
        excelR.TextCellValue("Debit"),
        excelR.TextCellValue("Customer ID"),
        excelR.TextCellValue("Unit ID")
      ];

      sheet.appendRow(excelHeaders);

      // Add data rows
      for (var report in lstTatReport) {
        List<excelR.TextCellValue> row = [
          excelR.TextCellValue(report['date'] ?? ""),
          excelR.TextCellValue(report['centreName'] ?? ""),
          excelR.TextCellValue(report['voucherNo'].toString()),
          excelR.TextCellValue(report['voucherType'] ?? ""),
          excelR.TextCellValue(report['credit'].toString()),
          excelR.TextCellValue(report['debit'].toString()),
          excelR.TextCellValue(report['customerId'].toString()),
          excelR.TextCellValue(report['unitId'].toString())
        ];
        sheet.appendRow(row);
      }

      // Generate a timestamped filename
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = 'PostpaidLedger$timestamp.xlsx';

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

  Widget filterDetails() {
    return Container(
      decoration: const BoxDecoration(
        //color: Colors.black.withAlpha(1),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      // height: MediaQuery.of(context).size.height * 0.5,
      // width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const SizedBox(
              width: 30,
            ),
            const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                    child: Text(
                      'Filter By',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))),
            //SizedBox(width: 20,),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ))
          ]),

          Center(
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.07,
              child: TextFormField(
                readOnly: true,
                // autofocus: true,
                textInputAction: TextInputAction.done,
                controller: fromdate,

                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "From Date can not be empty";
                  } else {
                    return null;
                  }
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColours.blue, // <-- SEE HERE
                            onPrimary: Colors.white, // <-- SEE HERE
                            onSurface: AppColours.blue, // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                              AppColours.blue, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    initialDate: DateTime.now(),
                    //get today's date
                    firstDate: DateTime(1900),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime.now().add(const Duration(days: 0)),
                  );
                  if (pickedDate != null) {
                    //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    debugPrint(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      fromdate.text = formattedDate;
                    });
                  } else {
                    debugPrint("From Date is not selected");
                  }
                },
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  //hintText: 'Enter Username',
                  hintStyle: const TextStyle(fontSize: 14),
                  label: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'From Date',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // labelText: 'Password',
                  // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                  floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.07,
              child: TextFormField(
                readOnly: true,
                textInputAction: TextInputAction.done,
                controller: todate,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "To Date can not be empty";
                  } else {
                    return null;
                  }
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColours.blue, // <-- SEE HERE
                            onPrimary: Colors.white, // <-- SEE HERE
                            onSurface: AppColours.blue, // <-- SEE HERE
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                              AppColours.blue, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    initialDate: DateTime.now(),
                    //get today's date
                    firstDate: DateTime(1900),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime.now().add(const Duration(days: 0)),
                  );
                  if (pickedDate != null) {
                    //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    debugPrint(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      todate.text = formattedDate;
                    });
                  } else {
                    debugPrint("To Date is not selected");
                  }
                },
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
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
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  //hintText: 'Enter Username',
                  hintStyle: const TextStyle(fontSize: 14),
                  label: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'To Date',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // labelText: 'Password',
                  // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                  floatingLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  height: 30,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: Colors.white30),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(20))),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Reset',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        )
                      ]),
                )),
            GestureDetector(
              onTap: () async {
                await fetchCustomerLedger(decode, fromdate.text, todate.text,
                    decode['unitMasterId'], unitcode, decode['customerId']);
                Navigator.pop(context);
                //   searchPatient(firstname.text);
              },
              child: Container(
                height: 30,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4,
                decoration: BoxDecoration(
                    color: AppColours.orange,
                    border: Border.all(color: Colors.white30),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Results',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      )
                    ]),
              ),
            )
          ]),
          const SizedBox(
            height: 20,
          ),
          // SizedBox(height: 300,),
        ],
      ),
    );
  }
}
