import 'dart:convert';
import 'package:dishabtob/dashboard/model/dashboard_count_model.dart';
import 'package:dishabtob/dashboard/patient_registered_list.dart';
import 'package:dishabtob/generatereceipt/generate_receipt.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/btob_queue/b2bqueue.dart';
import 'package:dishabtob/btob_queue/previous_bill.dart';
import 'package:dishabtob/billing/advance_utilization_report.dart';
import 'package:dishabtob/billing/customer_ledger_screen.dart';
import 'package:dishabtob/billing/generated_invoice.dart';
import 'package:dishabtob/billing/model/payment_gate_way_det.dart';
import 'package:dishabtob/billing/postpaid_ledger_report.dart';
import 'package:dishabtob/lis/accessioning/accessioning_list.dart.dart';
import 'package:dishabtob/lis/reporting/report_list.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/registration/registration.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/makepayment/prepaid_payment_receipt.dart';
import 'package:dishabtob/tat/tat_status.dart';
import 'package:dishabtob/user/edit_profile.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'filter.dart';
import 'package:encrypt/encrypt.dart' as encryption;

class HomePage extends StatefulWidget {
  final String? callfrom;
  final String? fromdate;
  final String? todate;
  final Map<String, dynamic>? decode;

  const HomePage(this.callfrom, this.fromdate, this.todate, this.decode,
      {super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, dynamic>? decode;
  Map<String, dynamic>? graphData;

  // String? nav;
  double? advance;
  double? consume;
  double? remain;
  Map<String, dynamic>? graph;
  String? callfrom = 'Today';

  List<dynamic>? consumption;
  List<dynamic> navigation = [];
  List<dynamic> billing = [];
  String? userPaymentType;
  List<PieData> pies = [
    PieData(value: 80, color: Colors.white),
    PieData(value: 20, color: Colors.white60),
  ];

  bool onExpansionPostPaid = false;

  String? decryptedKeyIdRazorPay;

  String? decryptedKeySecretRazorPay;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String? version;

  String? buildNumber;

  @override
  void initState() {
    getVersionName();
    var current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    getUser(widget.fromdate, widget.todate, widget.decode, widget.callfrom);

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
                backgroundColor: AppColours.blue,
                drawer: Drawer(
                    clipBehavior: Clip.none,
                    shadowColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                        //     bottomRight: Radius.circular(20)),
                        gradient: LinearGradient(
                            colors: [AppColours.blue, AppColours.orange],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.0, 1.0),
                            stops: const [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (navigation.isNotEmpty)
                                    navigation.first
                                                .toString()
                                                .toLowerCase()
                                                .contains('1:help desk') ||
                                            navigation.first
                                                .toString()
                                                .toLowerCase()
                                                .contains('1:helpdesk')
                                        ? helpDeskMenu()
                                        : const SizedBox.shrink(),
                                  if (navigation.isNotEmpty)
                                    (navigation.first
                                                .toString()
                                                .contains('9:lis') ||
                                            billing.first
                                                .toString()
                                                .toLowerCase()
                                                .contains('592:reporting'))
                                        ? lisMenu()
                                        : const SizedBox.shrink(),
                                  if (navigation.isNotEmpty)
                                    navigation.first
                                            .toString()
                                            .toLowerCase()
                                            .contains('6:billing')
                                        ? billingMenu()
                                        : const SizedBox.shrink(),

                                  ///dont remove
                                  // if (navigation.isNotEmpty)
                                  //   navigation.first
                                  //               .toString()
                                  //               .contains('23:TATSTATUS') &&
                                  //           FlavorConfig.instance.name ==
                                  //               "DubaiB2B" ||  FlavorConfig.instance.name ==
                                  //       "B2BLifenity"
                                  //       ? tatStatusMenu()
                                  //       : const SizedBox.shrink()
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (version != null) ? "Version : $version" : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )),
                appBar: AppBar(
                  centerTitle: false,
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: AppColours.blue,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            barrierColor: Colors.black.withOpacity(0.7),
                            backgroundColor: Colors.grey.withOpacity(0.4),

                            // context and builder are
                            // required properties in this widget
                            context: context,
                            builder: (BuildContext context) {
                              return const Filter();
                            });
                      },
                      child: Container(
                        height: 25,
                        width: 85,
                        decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.filter_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                'Filter by',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Profile(decode)),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40))),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
                body: Container(
                    height: MediaQuery.of(context).size.height * 0.92,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      gradient: LinearGradient(
                          colors: [AppColours.blue, AppColours.orange],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.0, 1.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: RefreshIndicator(
                      key: refreshIndicatorKey,
                      onRefresh: () async {
                        var current =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        await getUser(widget.fromdate, widget.todate,
                            widget.decode, current);
                      },
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  border: Border.all(color: Colors.white60),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  EasyPieChart(
                                    key: const Key('pie 1'),
                                    children: pies,
                                    showValue: false,
                                    borderEdge: StrokeCap.round,

                                    pieType: PieType.crust,
                                    onTap: (index) {},
                                    // style: const TextStyle(
                                    //     color: Colors.pinkAccent, fontSize: 10),
                                    gap: 0,
                                    borderWidth: 7,
                                    start: 0,
                                    size: 100,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Total\nRemaining\nAmount',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // const SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Text(
                                        //   widget.callfrom!,
                                        //   style: const TextStyle(
                                        //       color: Colors.white,
                                        //       fontSize: 10),
                                        // )
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 5,
                                    indent: 15,
                                    endIndent: 15,
                                    color: Colors.white60,
                                  ),
                                  const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.create_new_folder_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.read_more,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.money,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                  graph == null
                                      ? const SizedBox()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              advance == null
                                                  ? '0 ₹'
                                                  : '${advance.toString()} ₹',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              userPaymentType == "prepaid"
                                                  ? 'Advance Amount'
                                                  : 'Credit Amount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              consume == null
                                                  ? '0 ₹'
                                                  : '${consume.toString()} ₹',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              'Consumed Amount',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              remain == null
                                                  ? '0 ₹'
                                                  : '${remain.toString()} ₹',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Text(
                                              'Remaining Amount',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const PatientRegisteredList()),
                                    );
                                  },
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white12,
                                          border:
                                              Border.all(color: Colors.white60),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Icon(
                                            Icons
                                                .perm_contact_calendar_outlined,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          const Text(
                                            'Patient\nRegistered',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                          // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                          graphData == null
                                              ? const SizedBox()
                                              : Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white30,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Center(
                                                    child: Text(
                                                      graph?['grossAmount'] ==
                                                              null
                                                          ? '0'
                                                          : graph![
                                                                  'grossAmount']
                                                              .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                  ))
                                        ],
                                      )),
                                ),

                                // Container(
                                //     height: MediaQuery.of(context).size.height *
                                //         0.18,
                                //     width: MediaQuery.of(context).size.width *
                                //         0.27,
                                //     margin: const EdgeInsets.only(top: 20),
                                //     padding: const EdgeInsets.all(5),
                                //     decoration: BoxDecoration(
                                //         color: Colors.white12,
                                //         border:
                                //             Border.all(color: Colors.white60),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(20))),
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceAround,
                                //       children: [
                                //         const Icon(
                                //           Icons.settings,
                                //           color: Colors.white,
                                //           size: 30,
                                //         ),
                                //         const Text(
                                //           'Services\n Registered',
                                //           style: TextStyle(
                                //               color: Colors.white,
                                //               fontWeight: FontWeight.bold,
                                //               fontSize: 10),
                                //         ),
                                //         // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                //         graphData == null
                                //             ? const SizedBox()
                                //             : Container(
                                //                 height: 40,
                                //                 width: 40,
                                //                 decoration: const BoxDecoration(
                                //                     color: Colors.white30,
                                //                     borderRadius:
                                //                         BorderRadius.all(
                                //                             Radius.circular(
                                //                                 10))),
                                //                 child: Center(
                                //                   child: Text(
                                //                     graph!['servicesRegistered'] ==
                                //                             null
                                //                         ? '0'
                                //                         : graph![
                                //                                 'servicesRegistered']
                                //                             .toString(),
                                //                     style: const TextStyle(
                                //                         color: Colors.white,
                                //                         fontWeight:
                                //                             FontWeight.bold,
                                //                         fontSize: 10),
                                //                   ),
                                //                 ))
                                //       ],
                                //     )),
                                // Container(
                                //     height: MediaQuery.of(context).size.height *
                                //         0.18,
                                //     width: MediaQuery.of(context).size.width *
                                //         0.27,
                                //     margin: const EdgeInsets.only(top: 20),
                                //     padding: const EdgeInsets.all(5),
                                //     decoration: BoxDecoration(
                                //         color: Colors.white12,
                                //         border:
                                //             Border.all(color: Colors.white60),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(20))),
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceAround,
                                //       children: [
                                //         const Icon(
                                //           Icons.pending_actions,
                                //           color: Colors.white,
                                //           size: 30,
                                //         ),
                                //         const Text(
                                //           'Approval\nPending',
                                //           style: TextStyle(
                                //               color: Colors.white,
                                //               fontWeight: FontWeight.bold,
                                //               fontSize: 10),
                                //         ),
                                //         // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                //         graphData == null
                                //             ? const SizedBox()
                                //             : Container(
                                //                 height: 40,
                                //                 width: 40,
                                //                 decoration: const BoxDecoration(
                                //                     color: Colors.white30,
                                //                     borderRadius:
                                //                         BorderRadius.all(
                                //                             Radius.circular(
                                //                                 10))),
                                //                 child: Center(
                                //                   child: Text(
                                //                     graph!['approvalPending'] ==
                                //                             null
                                //                         ? '0'
                                //                         : graph![
                                //                                 'approvalPending']
                                //                             .toString(),
                                //                     style: const TextStyle(
                                //                         color: Colors.white,
                                //                         fontWeight:
                                //                             FontWeight.bold,
                                //                         fontSize: 10),
                                //                   ),
                                //                 ))
                                //       ],
                                //     )),

                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.pending_actions,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        const Text(
                                          'Approval\nPending',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                    graph?['approvalPending'] ==
                                                            null
                                                        ? '0'
                                                        : graph![
                                                                'approvalPending']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                              ]),
                          Visibility(
                            visible:
                                FlavorConfig.instance.name == "B2BLifenity",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          FlavorConfig.instance.name ==
                                                  "DubaiB2B"
                                              ? 'Gross Amount (AED)'
                                              : 'Gross Amount (₹)',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                    graph?['grossAmount'] ==
                                                            null
                                                        ? '0'
                                                        : graph!['grossAmount']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          FlavorConfig.instance.name ==
                                                  "DubaiB2B"
                                              ? 'Net Amount (AED)'
                                              : 'Net Amount (₹)',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                      graph?['netAmount'] != null ?  graph!['netAmount']
                                                        .toString():"0",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:
                                FlavorConfig.instance.name != "B2BLifenity",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          FlavorConfig.instance.name ==
                                                  "DubaiB2B"
                                              ? 'Gross Amount (AED)'
                                              : 'Gross Amount (₹)',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                    graph?['grossAmount'] ==
                                                            null
                                                        ? '0'
                                                        : graph!['grossAmount']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          FlavorConfig.instance.name ==
                                                  "DubaiB2B"
                                              ? 'Discount Amount (AED)'
                                              : 'Discount Amount (₹)',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                    graph?['discountAmount'] ==
                                                            null
                                                        ? '0'
                                                        : graph![
                                                                'discountAmount']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:
                                FlavorConfig.instance.name != "B2BLifenity",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          FlavorConfig.instance.name ==
                                                  "DubaiB2B"
                                              ? 'Net Amount (AED)'
                                              : 'Net Amount (₹)',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                      graph?['netAmount'] != null ?     graph!['netAmount']
                                                        .toString():"0",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border:
                                            Border.all(color: Colors.white60),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          FlavorConfig.instance.name ==
                                                  "DubaiB2B"
                                              ? 'Received Amount (AED)'
                                              : 'Received Amount (₹)',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        // Center(child:Text('Registered',style: TextStyle(color: Colors.white),),),
                                        graphData == null
                                            ? const SizedBox()
                                            : Container(
                                                height: 30,
                                                width: 100,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white30,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Text(
                                                      graph?['receivedAmount'] != null ?  graph!['receivedAmount']
                                                        .toString():"0",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ))
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
            offlineChild: Offline()));
  }

  getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  helpDeskMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Container(
          height: 40,
          width: 120,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.call,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Help Desk',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        billing.first.toString().contains('2:Registration')
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            const Registration({}, '', 0, [], 0)),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Icon(
                      Icons.edit_document,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Registration',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            : const SizedBox(),
        billing.first.toString().contains('567:B To B Queue')
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(),
        billing.first.toString().contains('567:B To B Queue')
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const B2BQueue()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'B2B Queue',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            : const SizedBox(),
        billing.first.toString().contains('597:BB Previous Bill')
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(),
        billing.first.toString().contains('597:BB Previous Bill')
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PreviousBill(const [])),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'B2B Previous Bill',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  lisMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          height: 40,
          width: 120,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.science_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'lis',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        if (billing.isNotEmpty)
          billing.first.toString().contains('592:Reporting')
              ? const SizedBox(
                  height: 10,
                )
              : const SizedBox.shrink(),
        if (billing.isNotEmpty)
          billing.first.toString().contains('592:Reporting')
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AccessioningList()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        "assets/accessioning.png",
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Accessioning',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        const SizedBox(
          height: 10,
        ),
        if (billing.isNotEmpty)
          billing.first.toString().contains('592:Reporting')
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportList()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.receipt,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Reporting',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
      ],
    );
  }

  billingMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          height: 40,
          width: 120,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'billing',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),

        Visibility(
          visible: userPaymentType == "prepaid",
          child: const SizedBox(
            height: 6,
          ),
        ),
        Visibility(
          visible: userPaymentType == "prepaid",
          child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.transparent),
              child: ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(18, 90, 136, 0.7),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  )),
                  collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      //the outline color
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Prepaid billing',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  children: [
                    ///Commented for dubai jlt
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            if (FlavorConfig.instance.name == "B2BLifenity") {
                              CustomMessage.toast("Under development");
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const AdvanceUtilization({})));
                            }
                          },
                          child: const Text(
                            'Advanced Utilization Report',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          )),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerLedgerScreen([])));
                          },
                          child: const Text(
                            'Customer Ledger Details',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            textAlign: TextAlign.start,
                          )),
                    ),

                    ///Commented for dubai jlt dont remove below commented

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: GestureDetector(
                    //       onTap: () {
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (context) => PrepaidPaymentReceipt(
                    //                   decryptedKeyIdRazorPay:
                    //                       decryptedKeyIdRazorPay!,
                    //                   decryptedKeySecretRazorPay:
                    //                       decryptedKeySecretRazorPay!,
                    //                 )));
                    //       },
                    //       child: const Text(
                    //         'Make Payment',
                    //         style: TextStyle(color: Colors.white, fontSize: 13),
                    //         textAlign: TextAlign.start,
                    //       )),
                    // ),
                  ])),
        ),

        ///Commented for dubai jlt
        Visibility(
          visible: billing.first
              .toString()
              .toLowerCase()
              .contains('602:postpaid billing'),
          child: Padding(
            padding: EdgeInsets.only(top: onExpansionPostPaid ? 10 : 0),
            child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.transparent),
                child: ExpansionTile(
                    onExpansionChanged: (ischanged) {
                      onExpansionPostPaid = ischanged;
                      setState(() {});
                      debugPrint(ischanged.toString());
                    },
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(18, 90, 136, 0.7),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    )),
                    collapsedShape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent),
                        //the outline color
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    // collapsedBackgroundColor: Colors.white,

                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.money,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Postpaid billing',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    children: [
                      ///dont remove
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(56, 10, 10, 10),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.of(context).push(MaterialPageRoute(
                      //           builder: (context) => const GenerateReceipt([])));
                      //     },
                      //     child: const Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         'Generate Receipt',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(56, 10, 10, 10),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GeneratedInvoice(
                                        const [],
                                        decryptedKeyIdRazorPay:
                                            decryptedKeyIdRazorPay ?? '',
                                        decryptedKeySecretRazorPay:
                                            decryptedKeySecretRazorPay ?? '',
                                      )));
                            },
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Generated Invoice',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            )),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(56, 10, 10, 10),
                      //   child: InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).push(MaterialPageRoute(
                      //             builder: (context) =>
                      //                 const PostPaidLedgerReport()));
                      //       },
                      //       child: const Align(
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           'PostPaid Ledger Report',
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 13),
                      //         ),
                      //       )),
                      // ),
                    ])),
          ),
        ),
      ],
    );
  }

  tatStatusMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Container(
          height: 40,
          width: 120,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/trend-up.png"),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'TAT Status',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TatStatus()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 25,
              ),
              Image.asset("assets/trend-up.png"),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'TAT Status',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }

  getUser(fromdate, todate, decode, callfrom) async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    if (encodedMap != null) {
      decode = json.decode(encodedMap);
      // decode=user!.first;
      // debugPrint(decode);
      navigation = decode!['userAccesBeanList']['moduleViewHashSet'];

      billing = decode!['userAccesBeanList']["subModuleViewHashSet"];

      if (navigation.isNotEmpty) navigation.contains("'1:Help Desk',");

      await fetchData(fromdate, todate, decode, callfrom);
      fetchConsumption(decode);
      if (navigation.first.toString().toLowerCase().contains('6:billing')) {
        getPaymentDetails(decode);
      }

      setState(() {});
    }
  }

  getPaymentDetails(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.GETPAYMENTDETAIL}?unitId=${decode!['unitMasterId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response;

    if (FlavorConfig.instance.name != "B2BLifenity") {
      response = await ioClient.post(
        uri,
        headers: headers,

        //encoding: encoding,
      );
    } else {
      response = await ioClient.get(
        uri,
        headers: headers,
      );
    }

    debugPrint(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      PaymentGateWayDet paymentGateWayDet = PaymentGateWayDet.fromJson(data);
      final key = encryption.Key(
          base64Decode(paymentGateWayDet.result.first.dynamicKey));

      // Decrypt
      decryptedKeyIdRazorPay =
          decryptAES(paymentGateWayDet.result.first.keyId, key);
      decryptedKeySecretRazorPay =
          decryptAES(paymentGateWayDet.result.first.keySecret, key);

      print('decryptedKeyIdRazorPay $decryptedKeyIdRazorPay');
      print('decryptedKeySecretRazorPay $decryptedKeySecretRazorPay');

      setState(() {});
    } else {
      CustomMessage.toast(graphData!['exception']);
    }
  }

  String decryptAES(String encryptedValue, encryption.Key key) {
    final encrypter =
        encryption.Encrypter(encryption.AES(key, mode: encryption.AESMode.ecb));
    final decrypted =
        encrypter.decrypt64(encryptedValue, iv: encryption.IV.fromLength(16));
    return decrypted;
  }

  fetchData(fromdate, todate, decode, callfrom) async {
    debugPrint(fromdate);
    debugPrint(todate);
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.DASHBOARD}?customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&userId=${decode!['userId']}&unitId=${decode!['unitMasterId']}&fromDate=$fromdate&toDate=$todate&callFrom=$callfrom&userType=${decode!['userType']}');
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
      setState(() {
        graphData = jsonDecode(response.body);
        List l = graphData!['lstGraphDto'];
        graph = l.first;
      });
    } else {
      CustomMessage.toast(graphData!['exception']);
    }
  }

  fetchConsumption(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.CONSUMPTION}?customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&unitId=${decode!['unitMasterId']}');
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
      Map<String, dynamic> value = jsonDecode(response.body);
      userPaymentType = value['lstPrePostConsumtionDto'][0]['paymentFlag'];
      if (userPaymentType == "prepaid") {
        await fetchAmountCount(decode);
      } else {
        consumption = value['lstPrePostConsumtionDto'];
        Map<String, dynamic> t = consumption!.first;
        advance = t['postpaidAmount'];
        consume = t['billConsumeAmount'];
        remain = t['billRemainAmount'];
      }

      setState(() {});
    } else {
      CustomMessage.toast(graphData!['exception']);
    }
  }

  fetchAmountCount(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.CONSUMPTIONAVAILABLEAMT}?userType=${decode!['userType']}&callFrom=&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}');
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
      Map<String, dynamic> value = jsonDecode(response.body);
      consumption = value['lstPrepaidCustomerDto'];
      Map<String, dynamic> t = consumption!.first;

      advance = t['availableAmount'];

      consume = t['billConsumeAmount'];
      remain = t['billRemainAmount'];

      setState(() {});
    } else {
      CustomMessage.toast(graphData!['exception']);
    }
  }
}
