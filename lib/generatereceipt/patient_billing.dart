import 'dart:convert';
import 'package:dishabtob/generatereceipt/generated_reports.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/generatereceipt/download_bill.dart';
import 'package:dishabtob/generatereceipt/model/newgeneratedrecieptresponse.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';


class PatientBilling extends StatefulWidget {
  final Map<String, dynamic> patient;

  const PatientBilling(this.patient, {super.key});

  @override
  PatientBillingState createState() => PatientBillingState();
}

class PatientBillingState extends State<PatientBilling>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  bool load = false;
  TextEditingController rate = TextEditingController();
  TextEditingController discount = TextEditingController();


  Map<String, dynamic>? value;
  bool showIcon = false;

  int? currentIndex;

  NewGeneratedReceiptResponse? generateReceiptModel;

  @override
  void initState() {
    //GenerateBill();
    controller = TabController(length: 1, vsync: this);
    controller?.addListener(() {
      currentIndex = controller?.index;
      setState(() {});
    });
    setState(() {
      load = true;
    });
    //fetchB2BList();
    getPatientBillDetails();
    super.initState();
  }

  getPatientBillDetails() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATERECEIPT}?fromDate=2024-05-20&toDate=2024-05-22&unitId=$userUnitId&customerId=${decode!['customerId']}');

    final uri = Uri.parse(
        '${url.baseurl}${url.PATIENTBILLINGDETAILS}/${widget.patient['patientId'].toString()}/${widget.patient['b2bBillRecId'].toString()}?patientId=${widget.patient['patientId'].toString()}&billb2bRecId=${widget.patient['b2bBillRecId'].toString()}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    if (response.statusCode == 200) {
      value = jsonDecode(response.body);
      generateReceiptModel = NewGeneratedReceiptResponse.fromJson(value);
      debugPrint(response.body);
      setState(() {
        load = false;
      });
    } else {
      CustomMessage.toast('Failed');
      setState(() {
        load = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                            gradient:  LinearGradient(
                                colors: [AppColours.blue, AppColours.orange],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.0, 1.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  'Patient Billing Details',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                currentIndex == 1
                                    ? IconButton(
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.7),
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.5),

                                              // context and builder are
                                              // required properties in this widget
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DownloadBill(widget
                                                    .patient['b2bBillRecId']);
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.print,
                                          color: Colors.white,
                                        ))
                                    : const SizedBox(
                                        width: 30,
                                      )
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
                                Card(
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(

                                      // side:new  BorderSide(color: Color(0xFF2A8068)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.18,
                                      width: MediaQuery.of(context).size.width,
                                      //margin: EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6, right: 4),
                                              child: Row(
                                                  // crossAxisAlignment:
                                                  //     CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      height: 35,
                                                      width: 35,
                                                      // margin: EdgeInsets.all(10),
                                                      decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                Color.fromRGBO(
                                                                    21,
                                                                    115,
                                                                    175,
                                                                    1),
                                                                Color.fromRGBO(
                                                                    236,
                                                                    106,
                                                                    56,
                                                                    1)
                                                              ],
                                                              begin:
                                                                  FractionalOffset(
                                                                      0.0, 0.0),
                                                              end:
                                                                  FractionalOffset(
                                                                      1.0, 0.0),
                                                              stops: [0.0, 1.0],
                                                              tileMode: TileMode
                                                                  .clamp),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 5),
                                                        child: FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                              widget.patient[
                                                                  'patientName'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10),
                                                            ))),
                                                    const Spacer(),
                                                    Container(
                                                        height: 20,
                                                        width:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        20))),
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top: 8, left: 5),
                                                        //padding: EdgeInsets.all(value),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Patient ID #',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              ' ${widget.patient['patientId'].toString()}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                            ),
                                                          ],
                                                        ))
                                                  ]),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //SizedBox(width: 10,),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Icon(
                                                          Icons.calendar_month,
                                                          color: Colors.black87
                                                              .withOpacity(0.6),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Icon(
                                                          Icons.phone_android,
                                                          color: Colors.black87
                                                              .withOpacity(0.6),
                                                        ),
                                                      ]),
                                                  //SizedBox(width: 10,),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),

                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Text(
                                                        'Age',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        value?['age']
                                                                .split("/")
                                                                .first
                                                                .toString() ??
                                                            "-",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      //SizedBox(height: 10,),

                                                      //SizedBox(width: 20,),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Text(
                                                        'Contact',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        value?['contact'] ??
                                                            "-",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),

                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),

                                                  const Spacer(),
                                                  Column(
                                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                                      //mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        //SizedBox(height: 10,),

                                                        Icon(
                                                          Icons.male,
                                                          color: Colors.black87
                                                              .withOpacity(0.6),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ]),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),

                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Text(
                                                        'Gender',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        value?['gender'] ?? "-",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      //SizedBox(height: 10,),

                                                      //SizedBox(width: 20,),

                                                      const SizedBox(
                                                        height: 40,
                                                      ),

                                                      //
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ]),
                                          ])),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      border: Border.all(color: Colors.grey)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.98,
                                  child: TabBar(
                                    indicatorPadding: const EdgeInsets.all(0),
                                    labelPadding: const EdgeInsets.all(0),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    //dividerColor: Colors.red,
                                    labelColor: Colors.white,
                                    controller: controller,
                                    unselectedLabelColor: Colors.black54,
                                    indicator:  BoxDecoration(
                                        color: AppColours.blue,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                            topRight: Radius.circular(30))),
                                    indicatorColor: AppColours.blue,
                                    tabs: const [
                                      // Tab(child: Text('Generate Reports')),
                                      Tab(child: Text('Generated Reports')),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller,
                                    children: [
                                      //Generate_reports(widget.patient),
                                      // GeneratedReports(
                                      //     widget.patient,
                                      //     generateReceiptModel?.list ?? [],
                                      //     false,
                                      //     generateReceiptModel),
                                      GeneratedReports(
                                          widget.patient,
                                          generateReceiptModel?.listGeneratedReports ?? [],
                                          true,
                                          generateReceiptModel),
                                    ],
                                  ),
                                ),
                              ])))
                    ]))),
            offlineChild: Offline()));
  }
}
