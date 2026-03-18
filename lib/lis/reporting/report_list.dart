import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/lis/reporting/reportview.dart';
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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'filter_report.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  ReportListState createState() => ReportListState();
}

class ReportListState extends State<ReportList>
    with SingleTickerProviderStateMixin {
  bool load = false;
  TabController? controller;
  final mediaStorePlugin = MediaStore();
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  TextEditingController firstNameOrIdController = TextEditingController();
  String? title;
  List<String> item = ["Patient Id", "Patient Name"];
  var paymentStat;
  String? current;
  int? _platformSDKVersion;
  late PagingController<int, dynamic> allRecordePagingController;
  late PagingController<int, dynamic> histoRecordePagingController;

  // final PagingController<int, dynamic> pagingController;
  static const pageSize = 10;
  int? currentIndex;

  String? selectedMode;
  String? fromDate;
  String? toDate;
  String? firstNameOrId;

  String? unitcode;

  @override
  void initState() {
    controller = TabController(
        length: FlavorConfig.instance.name == "DubaiB2B" ||
                FlavorConfig.instance.name == "B2BLifenity"
            ? 2
            : 1,
        vsync: this);
    controller?.addListener(() {
      currentIndex = controller?.index;
      setState(() {});
    });
    allRecordePagingController = PagingController(firstPageKey: 0);
    histoRecordePagingController = PagingController(firstPageKey: 0);

    current = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fromdate.text = current!;
    todate.text = current!;

    initPermission();
    initPlatformState();
    unitName();
    // String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    allRecordePagingController.addPageRequestListener((pageKey) {
      if (selectedMode == null) {
        fetchPagePatientByDateAllRecords(
            pageKey, fromdate.text, todate.text, '');
      } else if (selectedMode == "byId") {
        firstNameOrId = firstNameOrIdController.text;
        // fetchPagePatientByDate(
        //     pageKey, fromDate!, toDate!, firstNameOrId ?? '');
        fetchPagePatientByNameAndId(firstNameOrId, selectedMode!, pageKey);
      } else if (selectedMode == "byName") {
        firstNameOrId = firstNameOrIdController.text;
        fetchPagePatientByNameAndId(firstNameOrId, selectedMode!, pageKey);
        // searchReportByIdAndName(firstNameOrId, selectedMode!);
      }
    });
    refreshAllRecTry();

    if (FlavorConfig.instance.name == "DubaiB2B" ||
        FlavorConfig.instance.name == "B2BLifenity") {
      histoRecordePagingController.addPageRequestListener((pageKey) {
        if (selectedMode == null) {
          fetchPagePatientByDateHistopath(
              pageKey, fromdate.text, todate.text, '');
        } else if (selectedMode == "byId") {
          firstNameOrId = firstNameOrIdController.text;
          // fetchPagePatientByDate(
          //     pageKey, fromDate!, toDate!, firstNameOrId ?? '');
          fetchPagePatientByNameAndId(firstNameOrId, selectedMode!, pageKey);
        } else if (selectedMode == "byName") {
          firstNameOrId = firstNameOrIdController.text;
          fetchPagePatientByNameAndId(firstNameOrId, selectedMode!, pageKey);
          // searchReportByIdAndName(firstNameOrId, selectedMode!);
        }
      });
      refreshHisRecTry();
    }
    ;
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
                                  'Reporting',
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
                                              callBy: (value) {
                                                fromDate = fromdate.text;
                                                toDate = todate.text;
                                                firstNameOrId =
                                                    firstNameOrIdController
                                                        .text;
                                                if (firstNameOrId != null &&
                                                    firstNameOrId!.isNotEmpty) {
                                                  selectedMode = value;
                                                } else {
                                                  selectedMode = null;
                                                }

                                                if (controller?.index == 0) {
                                                  refreshAllRecTry();
                                                } else if (controller?.index ==
                                                    1) {
                                                  refreshHisRecTry();
                                                }
                                                Navigator.pop(context);
                                              },
                                              onReset: () {
                                                // Handle reset logic if necessary
                                                selectedMode = null;
                                                fromDate = null;
                                                toDate = null;
                                                firstNameOrId = null;
                                                if (controller?.index == 0) {
                                                  refreshAllRecTry();
                                                } else if (controller?.index ==
                                                    1) {
                                                  refreshHisRecTry();
                                                }
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
                                                todate.text = toDate;
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
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    border: Border.all(color: Colors.grey)),
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: TabBar(
                                  indicatorPadding: const EdgeInsets.all(0),
                                  labelPadding: const EdgeInsets.all(0),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  //dividerColor: Colors.red,
                                  labelColor: Colors.white,
                                  controller: controller,
                                  unselectedLabelColor: Colors.black54,
                                  indicator: BoxDecoration(
                                      color: AppColours.blue,
                                      // borderRadius: const BorderRadius.all(Radius.circular(30))
                                      borderRadius: BorderRadius.only(
                                          topLeft: controller?.index == 0
                                              ? const Radius.circular(30)
                                              : const Radius.circular(0),
                                          bottomLeft: controller?.index == 0
                                              ? const Radius.circular(30)
                                              : const Radius.circular(0),
                                          bottomRight: controller?.index == 0
                                              ? const Radius.circular(0)
                                              : const Radius.circular(30),
                                          topRight: controller?.index == 0
                                              ? const Radius.circular(0)
                                              : const Radius.circular(30))),
                                  // indicatorColor: Colors.blue,
                                  tabs: [
                                    const Tab(child: Text('All Records')),
                                    Visibility(
                                        visible: FlavorConfig.instance.name ==
                                                "DubaiB2B" ||
                                            FlavorConfig.instance.name ==
                                                "B2BLifenity",
                                        child: const Tab(
                                            child: Text('Histopath Records'))),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller,
                                  children: [
                                    load
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColours.blue,
                                            ),
                                          )
                                        : allRecords(context),
                                    load
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColours.blue,
                                            ),
                                          )
                                        : histopathRecords(context)
                                  ],
                                ),
                              ),
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  allRecords(BuildContext context) {
    return PagedListView<int, dynamic>(
        padding: EdgeInsets.zero,
        pagingController: allRecordePagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
            noItemsFoundIndicatorBuilder: (context) => const DataNotFound(),
            itemBuilder: (context, item, index) => Card(
                // margin: const EdgeInsets.only(bottom: 10),
                elevation: 3,
                child: Container(
                  //  padding: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.shade200)),
                  // height: MediaQuery.of(context).size.height * 0.26,
                  // width: MediaQuery.of(context).size.width,
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
                              item['patientname'].toString(),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.tag,
                                    color: Colors.black87.withOpacity(0.6),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Icon(
                                    Icons.female,
                                    color: Colors.black87.withOpacity(0.6),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Icon(
                                    Icons.science_outlined,
                                    color: Colors.black87.withOpacity(0.6),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Icon(
                                    Icons.science_outlined,
                                    color: Colors.black87.withOpacity(0.6),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  SizedBox(height: 5,),
                                const Text(
                                  'Patient ID',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  item['patientId'].toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                //SizedBox(height: 10,),

                                //SizedBox(width: 20,),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Gender',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  item['patientgander'].toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                const Text(
                                  'Total Tests',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  item['testCount'].toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),

                                // const SizedBox(
                                //   height: 5,
                                // ),
                                //
                                // const Text(
                                //   'Date',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 12),
                                // ),
                                // Text(
                                //   item['datetime'].toString(),
                                //   style: const TextStyle(fontSize: 12),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 0,
                                top: MediaQuery.of(context).size.height * 0.0),
                            child: Column(children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.black87.withOpacity(0.6),
                              ),
                              // const SizedBox(
                              //   height: 50,
                              // ),
                              const SizedBox(
                                height: 20,
                              ),
                              Icon(
                                Icons.calendar_month,
                                color: Colors.black87.withOpacity(0.6),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.science_outlined,
                                color: Colors.black87.withOpacity(0.6),
                              ),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //SizedBox(height: 5,),
                                const Text(
                                  'Age',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${item['patientage']}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                // const SizedBox(
                                //   height: 40,
                                // ),
                                const SizedBox(
                                  height: 5,
                                ),

                                const Text(
                                  'Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  item['datetime'].toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                const Text(
                                  'Test In Report',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${item['reportCount'] ?? "0"}',
                                  style: const TextStyle(fontSize: 12),
                                ),

                                //
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(left: 22, top: 2, bottom: 2),
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.science_outlined,
                      //         color: Colors.black87.withOpacity(0.6),
                      //       ),
                      //       // const SizedBox(
                      //       //   width: 20,
                      //       // ),
                      //       Expanded(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(left: 32),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               const Text(
                      //                 'Test Name',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 12),
                      //               ),
                      //               Text(
                      //                 item['profileName'] != null
                      //                     ? item['profileName'].toString()
                      //                     : "-",
                      //                 style: const TextStyle(fontSize: 12),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.32,
                              height:
                                  MediaQuery.of(context).size.height * 0.042,
                              child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      // side: BorderSide(color: Colors.red)
                                    )),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppColours.orange),
                                  ),
                                  onPressed: () async {
                                    await checkPaymentStatus(
                                        item['patientId'], item['treatmentId']);
                                    if (paymentStat == 0.0) {
                                      if (FlavorConfig.instance.name !=
                                          "B2BLifenity") {
                                        await printReport(item['masterId'],
                                            item['patientId'], "withheader");
                                      } else {
                                        await printReport(item['masterIdd'],
                                            item['patientId'], "withheader");
                                      }
                                    } else if (paymentStat == 1.1) {
                                      CustomMessage.toast(
                                          "The Payment Has Not Been Made");
                                    } else {
                                      CustomMessage.toast(
                                          "Something went wrong");
                                    }
                                  },
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'View Reports',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      ])
                                  //Icon(Icons.download,color: Colors.white,size: 15,)

                                  )),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  histopathRecords(BuildContext context) {
    return Visibility(
      visible: FlavorConfig.instance.name == "DubaiB2B" ||
          FlavorConfig.instance.name == "B2BLifenity",
      child: PagedListView<int, dynamic>(
          padding: EdgeInsets.zero,
          pagingController: histoRecordePagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
              noItemsFoundIndicatorBuilder: (context) => const DataNotFound(),
              itemBuilder: (context, item, index) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 3,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey.shade200)),
                    // height: MediaQuery.of(context).size.height * 0.32,
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Container(
                                  height: 40, width: 40,
                                  // margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            AppColours.blue,
                                            AppColours.orange,
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 0.0),
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
                                  item['patientname'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.tag,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Icon(
                                      Icons.tag,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Icon(
                                      Icons.science_outlined,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                  ]),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //  SizedBox(height: 5,),
                                      const Text(
                                        'Patient ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        item['patientId'].toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      //SizedBox(height: 10,),

                                      //SizedBox(width: 20,),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Barcode',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        item['barCode'] ?? '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),

                                      const Text(
                                        'Test Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        item['profileName'] ?? "",
                                        // maxLines: 2,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    top: MediaQuery.of(context).size.height *
                                        0.0),
                                child: Column(children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.black87.withOpacity(0.6),
                                  ),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //SizedBox(height: 5,),
                                    const Text(
                                      'Reg Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '${item['datetime'] ?? ""}',
                                      style: const TextStyle(fontSize: 12),
                                    ),

                                    //
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: const Color(0xffD8F9E2),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  "${item['trackStage'] ?? "NA"}",
                                  style:
                                      const TextStyle(color: Color(0xff14923A)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
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
                                        await checkPaymentStatus(
                                            item['patientId'],
                                            item['treatmentId']);
                                        if (paymentStat == 0.0) {
                                          await printReport(item['masterId'],
                                              item['patientId'], "withheader");
                                        } else if (paymentStat == 1.1) {
                                          CustomMessage.toast(
                                              "The Payment Has Not Been Made");
                                        } else {
                                          CustomMessage.toast(
                                              "Something went wrong");
                                        }
                                      },
                                      child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'View Report',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          ])
                                      //Icon(Icons.download,color: Colors.white,size: 15,)

                                      )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )))),
    );
  }

  refreshAllRecTry() {
    allRecordePagingController.refresh();
  }

  refreshHisRecTry() {
    histoRecordePagingController.refresh();
  }

  Future<void> fetchPagePatientByDateAllRecords(
      int pageKey, String fromDate, String toDate, String firstNameOrId) async {
    try {
      // Simulate API call to get data from the API based on pageKey
      final newItems =
          await fetchReportList(fromDate, toDate, firstNameOrId, pageKey);

      // Check if we received less than the page size (means end of list)
      final isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        allRecordePagingController.appendLastPage(newItems);
      } else {
        int nextPageKey = pageKey + 1;
        allRecordePagingController.appendPage(newItems, nextPageKey);
        // int nextPageKey = pageKey + newItems.length;
        // pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      allRecordePagingController.error = error;
    }
  }

  Future<void> fetchPagePatientByDateHistopath(
      int pageKey, String fromDate, String toDate, String firstNameOrId) async {
    try {
      // Simulate API call to get data from the API based on pageKey
      final newItems =
          await fetchHistropathList(fromDate, toDate, firstNameOrId, pageKey);

      // Check if we received less than the page size (means end of list)
      final isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        histoRecordePagingController.appendLastPage(newItems);
      } else {
        int nextPageKey = pageKey + 1;
        histoRecordePagingController.appendPage(newItems, nextPageKey);
        // int nextPageKey = pageKey + newItems.length;
        // pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      histoRecordePagingController.error = error;
    }
  }

  Future<void> fetchPagePatientByNameAndId(
      firstNameOrId, selectedMode, pageKey) async {
    var newItems;
    try {
      // Simulate API call to get data from the API based on pageKey
      if (controller?.index == 0) {
        newItems =
            await searchReportByIdAndName(firstNameOrId, selectedMode, pageKey);
      } else if (controller?.index == 1) {
        if (selectedMode == 'byId') {
          newItems =
              await searchHistoPathById(firstNameOrId, selectedMode, pageKey);
        } else if (selectedMode == 'byName') {
          newItems =
              await searchHistoPathByNAme(firstNameOrId, selectedMode, pageKey);
        }
      }
      // Check if we received less than the page size (means end of list)
      final isLastPage = newItems.length < pageSize;

      if (isLastPage) {
        if (controller?.index == 0) {
          allRecordePagingController.appendLastPage(newItems);
        } else if (controller?.index == 1) {
          histoRecordePagingController.appendLastPage(newItems);
        }
      } else {
        int nextPageKey = pageKey + 1;
        if (controller?.index == 0) {
          allRecordePagingController.appendPage(newItems, nextPageKey);
        } else if (controller?.index == 1) {
          histoRecordePagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      if (controller?.index == 0) {
        allRecordePagingController.error = error;
      } else if (controller?.index == 1) {
        histoRecordePagingController.error = error;
      }
    }
  }

  ///Dont remove
  searchReportByIdAndName(patid, searchBy, pageKey) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    // debugPrint('11$decode');
    //getuser();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.SEARCH_REPORTS}?searchText=$patid&searchBy=$searchBy&callFrom=reportingAutoSugg&tabId=allTabLi&emergencyFlag=All&emailStatus=""&unitId=${decode!['unitMasterId']}&userType=${decode!['userType']}&userCustomerType=${decode!['customerType']}&userCustomerId=${decode!['customerId']}');
    debugPrint(uri.path);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      firstNameOrIdController.text = "";
      title = item.first;

      return value['labSampleWiseMasterDtoList'];
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  searchHistoPathById(patid, searchBy, pageKey) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    // debugPrint('11$decode');
    //getuser();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.SEARCH_HISTOPATHBYID}?patientId=$patid&callFrom=reportingAutoSugg&tabId=histopathTabLi&emergencyFlag=All&unitId=${decode!['unitMasterId']}&userType=${decode!['userType']}&customerIds=${decode!['customerId']}');
    debugPrint(uri.path);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      firstNameOrIdController.text = "";
      title = item.first;

      return value['histopathologySampleWiseMasterProcessingg'];
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  searchHistoPathByNAme(searchText, searchBy, pageKey) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    // debugPrint('11$decode');
    //getuser();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.SEARCH_HISTOPATHBYNAME}?searchText=$searchText&searchBy=$searchBy&callFrom=reportingAutoSugg&tabId=histopathTabLi&emergencyFlag=All&emailStatus=N&unitId=${decode!['unitMasterId']}&userType=${decode!['userType']}&customerIds=${decode!['customerId']}');
    debugPrint(uri.path);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      firstNameOrIdController.text = "";
      title = item.first;

      return value['labSampleWiseMasterDtoList'];
    } else {
      CustomMessage.toast('Failed to load');
    }
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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

  checkPaymentStatus(patId, treatId) async {
    load = true;
    setState(() {});
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
        '${url.baseurl}${url.CHECK_PAYMENT}?patientId=$patId&treatmentId=$treatId&userId=${decode!["userId"]}');
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

    paymentStat = jsonDecode(response.body);
    debugPrint(paymentStat.toString());
    if (response.statusCode == 200) {
      setState(() {
        load = false;
      });
    } else {
      CustomMessage.toast('Failed to load');
      setState(() {
        load = false;
      });
    }
  }

  Future<void> printReport(masterId, patientId, reportFlag) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? encodedMap = prefs.getString('user');
      if (encodedMap == null) {
        CustomMessage.toast('User not found');
        load = false;
        setState(() {});
        return;
      }

      final decode = json.decode(encodedMap);
      var uri;
      if (FlavorConfig.instance.name != "B2BLifenity") {
        uri = Uri.parse(
          '${url.baseurl}${url.REPORT_PDF}?masterId=$masterId&patientId=$patientId&envFlag=&unitId=${decode['unitMasterId']}&reportFlag=$reportFlag&headerFlag=Y',
        );
      } else {
        uri = Uri.parse(
          '${url.baseurl}${url.REPORT_PDF}?masterId=$masterId&patientId=$patientId&envFlag=&unitId=${decode['unitMasterId']}&reportFlag=$reportFlag&headerFlag=Y&uId=${decode['userId']}&uName=${decode['userName']}&unitCode=$unitcode',
        );
      }

      final response = await ioClient.post(uri);
      if (response.statusCode != 200) {
        CustomMessage.toast('Failed to load report');
        load = false;
        setState(() {});
        return;
      }

      final resultList = jsonDecode(response.body)['result'];
      final finalDoc = PdfDocument();
      final docProcessor = PdfDocument();

      for (final item in resultList) {
        final pdfUrl = item['url'];
        if (pdfUrl == null || pdfUrl.toString().isEmpty) continue;

        final pdfResponse = await ioClient.get(Uri.parse(pdfUrl));
        if (pdfResponse.statusCode != 200) continue;

        final tempDir = await getTemporaryDirectory();
        final tempFilePath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(pdfResponse.bodyBytes);

        if (await tempFile.length() < 1000) {
          debugPrint("Skipping too small or empty PDF: ${tempFile.path}");
          continue;
        }

        final importedDoc =
            PdfDocument(inputBytes: await tempFile.readAsBytes());

        for (int i = 0; i < importedDoc.pages.count; i++) {
          final page = importedDoc.pages[i];
          final newPage = finalDoc.pages.add();

          final template = page.createTemplate();

          final destSize = Size(
              newPage.getClientSize().width, newPage.getClientSize().height);
          final srcSize = Size(template.size.width, template.size.height);

          final double scaleX = destSize.width / srcSize.width;
          final double scaleY = destSize.height / srcSize.height;
          final double scale = min(scaleX, scaleY);

          final double offsetX = (destSize.width - srcSize.width * scale) / 2;
          final double offsetY = (destSize.height - srcSize.height * scale) / 2;

          newPage.graphics.drawPdfTemplate(
            template,
            Offset(offsetX, offsetY),
            Size(srcSize.width * scale, srcSize.height * scale),
          );
        }

        importedDoc.dispose();
      }

      final dir = await getTemporaryDirectory();
      final outputPath = '${dir.path}/merged_report.pdf';
      final file = File(outputPath);
      await file.writeAsBytes(await finalDoc.save());
      finalDoc.dispose();

      load = false;
      setState(() {});

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportView(
            patientId,
            decode['unitMasterId'],
            masterId.toString(),
            file: file.path,
            unitcode: unitcode,
          ),
        ),
      );
    } catch (e) {
      debugPrint('printReport error: $e');
      CustomMessage.toast('Unexpected error occurred');
      load = false;
      setState(() {});
    }
  }

  fetchReportList(fromdate, todate, patid, startIndex) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);

    // setState(() {
    //   load = true;
    // });
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    ///dont remove this was updated api url send by vinod
    // http://210.89.42.107:8383/EhatEnterprise/ehat/phlebotomy/b2bsearchReportingPatient?custTypeId=0&custNameId=0&fromDate=09/04/2025&toDate=10/04/2025&callFrom=reportingSearchBtn&searchBy=byDate&tabId=allTabLi&startIndex=0&emergencyFlag=&testNameId=0&patientId=&emailStatus=N&paymentStatusCode=undefined&unitId=1001&userType=other&userFor=admin&customerIds=570

    var uri;

    if (FlavorConfig.instance.name != "B2BLifenity") {
      uri = Uri.parse(
          '${url.baseurl}${url.REPORT_LIST}?custTypeId=${decode?['customerType']}&custNameId=${decode?['customerId']}&fromDate=$fromdate&toDate=$todate&callFrom=reportingSearchBtn&searchBy=byDate&tabId=allTabLi&startIndex=$startIndex&emergencyFlag=&emailStatus=N&patientId=$patid&paymentStatusCode=undefined&testNameId=0&unitId=${decode?['unitMasterId']}&userType=${decode?['userType']}&userFor=other&customerIds=${decode?['customerId']}');
    } else {
      uri = Uri.parse(
          '${url.baseurl}${url.REPORT_LIST}?custTypeId=${decode?['customerType']}&custNameId=${decode?['customerId']}&fromDate=$fromdate&toDate=$todate&callFrom=reportingSearchBtn&searchBy=byDate&tabId=patientWiseTabLi&startIndex=$startIndex&emergencyFlag=&emailStatus=N&patientId=$patid&paymentStatusCode=undefined&testNameId=0&unitId=${decode?['unitMasterId']}&userType=${decode?['userType']}&userFor=other&customerIds=${decode?['customerId']}');
    }

    debugPrint(uri.path);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATE_RECEIPT}/18402/0');
    // debugPrint(uri);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      firstNameOrIdController.text = "";
      title = item.first;
      // setState(() {
      //   IPD = value['labSampleWiseMasterDtoList'];
      //   load = false;
      // }),

      // load = false;
      // setState(() {});
      return value['labSampleWiseMasterDtoList'];
    } else {
      CustomMessage.toast('Failed to load');
    }
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

  fetchHistropathList(fromdate, todate, patid, startIndex) async {
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    var decode = json.decode(encodedMap!);

    // setState(() {
    //   load = true;
    // });
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.HISOPATHLIST}?custTypeId=${decode?['customerType']}&custNameId=${decode?['customerId']}&fromDate=$fromdate&toDate=$todate&callFrom=histopathSearchBtn&searchBy=byDate&tabId=histopathTabLi&startIndex=$startIndex&emergencyFlag=All&emailStatus=Y&patientId=$patid&paymentStatusCode=undefined&testNameId=0&unitId=${decode?['unitMasterId']}&userType=${decode?['userType']}&customerIds=${decode?['customerId']}');
    debugPrint(uri.path);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATE_RECEIPT}/18402/0');
    // debugPrint(uri);

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      firstNameOrIdController.text = "";
      title = item.first;
      // setState(() {
      //   IPD = value['labSampleWiseMasterDtoList'];
      //   load = false;
      // }),

      // load = false;
      // setState(() {});
      return value['histopathologySampleWiseMasterProcessingg'];
    } else {
      CustomMessage.toast('Failed to load');
    }
  }
}
