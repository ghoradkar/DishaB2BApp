import 'dart:convert';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/btob_queue/addnewtest.dart';
import 'package:dishabtob/btob_queue/b2bqueue.dart';
import 'package:dishabtob/btob_queue/view_added_package.dart';
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

class AddTest extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final List<dynamic>? sample;

  const AddTest(this.patient, this.sample, {super.key});

  @override
  AddTestState createState() => AddTestState();
}

class AddTestState extends State<AddTest> {
  List? testList;
  List<dynamic>? sampleList = [];
  bool load = false;
  List<List<dynamic>>? subservices;
  List<List<bool>>? subListSelectedStatus;
  List<List>? subservicecost;
  double cost = 0.0;

  List<dynamic> sampleName = [];
  List<bool>? selected = [];

  String? runnerBoy;
  Map<String, dynamic>? decode;
  List<dynamic>? consumption;
  double? advance;
  double? consume;
  double? remain;

  List<dynamic> billing = [];
  TextEditingController username = TextEditingController();
  FocusNode fusername = FocusNode();
  TextEditingController password = TextEditingController();
  FocusNode fpassword = FocusNode();

  bool visible = false;
  TextEditingController patientid = TextEditingController();

  var userUnitId;

  String? userPaymentType;

  var samples;

  @override
  void initState() {
    setState(() {
      load = true;
      // loadname=true;
    });
    getUser();
    //FetchSampleList();
    debugPrint('jhgfdfghj');

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
                                colors: [
                                  AppColours.blue,
                                  AppColours.orange,
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const B2BQueue()));
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                //SizedBox(width: 5,),
                                const Text(
                                  'Add Tests',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.33,
                                    height: MediaQuery
                                        .of(context)
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
                                                side: const BorderSide(
                                                    color: Colors.white))),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppColours.orange
                                                .withOpacity(0.9)),
                                      ),
                                      onPressed: () async {
                                        print(widget.sample);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewTest(
                                                    widget.patient,
                                                    null,
                                                    widget.sample,
                                                    0,
                                                    fromAddPackagePage: false,
                                                    savedTestPackageList:
                                                    subservices,
                                                  )),
                                        );
                                      },
                                      child: const Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Add New Test',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          ]),
                                    ))
                              ])),
                      Positioned(
                          bottom: MediaQuery
                              .of(context)
                              .size
                              .height * 0.02,
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
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  Card(
                                    elevation: 3,
                                    shape: const RoundedRectangleBorder(

                                      // side:new  BorderSide(color: Color(0xFF2A8068)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Container(
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.13,
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        //margin: EdgeInsets.only(top: 10),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      // margin: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                AppColours.blue,
                                                                AppColours
                                                                    .orange
                                                              ],
                                                              begin:
                                                              const FractionalOffset(
                                                                  0.0, 0.0),
                                                              end:
                                                              const FractionalOffset(
                                                                  1.0, 0.0),
                                                              stops: const [
                                                                0.0,
                                                                1.0
                                                              ],
                                                              tileMode: TileMode
                                                                  .clamp),
                                                          borderRadius:
                                                          const BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              20))),
                                                      child: const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 10,
                                                              left: 5),
                                                          child: Text(
                                                            widget.patient![
                                                            'patientName']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 12),
                                                          )),
                                                    ),
                                                    Container(
                                                        height: 20,
                                                        width:
                                                        MediaQuery
                                                            .of(
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
                                                            top: 5, left: 5),
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
                                                              ' ${widget
                                                                  .patient!['patientId']
                                                                  .toString()}',
                                                              style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                  10),
                                                            ),
                                                          ],
                                                        ))
                                                  ]),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  const Icon(Icons.money),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text(
                                                        'Consumed Amount',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.black87,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 10),
                                                      ),
                                                      Row(children: [
                                                        Text(
                                                          '${consume.toString()} ₹',
                                                          style:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .red,
                                                              fontSize: 12),
                                                        ),
                                                        const Icon(
                                                          Icons.arrow_downward,
                                                          color: Colors.red,
                                                          size: 15,
                                                        )
                                                      ]),
                                                    ],
                                                  ),
                                                  const Icon(Icons.money),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text(
                                                        'Remaining Amount',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.black87,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 10),
                                                      ),
                                                      Row(children: [
                                                        Text(
                                                          '${remain.toString()} ₹',
                                                          style:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .green,
                                                              fontSize: 12),
                                                        ),
                                                        const Icon(
                                                          Icons.arrow_upward,
                                                          color: Colors.green,
                                                          size: 15,
                                                        )
                                                      ]),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ])),
                                  ),
                                  load
                                      ? const Center(
                                      child: CircularProgressIndicator())
                                      : SingleChildScrollView(
                                      child: testList!.isEmpty
                                          ? SizedBox(
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.9,
                                        child: const DataNotFound(),
                                      )
                                          : mainTestList(context))
                                ]),
                              ))),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(5),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2,
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                    colors: [
                                      AppColours.blue,
                                      AppColours.orange,
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: const [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        List<Map<String, dynamic>>
                                        selectedItems = getSelectedServices(
                                            subservices,
                                            subListSelectedStatus);
                                        selectedItems.isEmpty
                                            ? CustomMessage.toast(
                                            'Please Add Test')
                                            : showModalBottomSheet(
                                            isScrollControlled: true,
                                            barrierColor: Colors.black
                                                .withOpacity(0.7),
                                            backgroundColor: Colors.grey
                                                .withOpacity(0.5),
                                            context: context,
                                            shape:
                                            const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(
                                                      30.0),
                                                  topRight:
                                                  Radius.circular(
                                                      30.0)),
                                            ),
                                            builder:
                                                (BuildContext context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery
                                                        .of(
                                                        context)
                                                        .viewInsets
                                                        .bottom),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10),
                                                  child: Column(
                                                    // crossAxisAlignment:
                                                    //     CrossAxisAlignment
                                                    //         .start,
                                                    mainAxisSize:
                                                    MainAxisSize.min,

                                                    children: <Widget>[
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                          children: [
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            const Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                                child: Center(
                                                                    child: Text(
                                                                      'Send For Processing',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                          16),
                                                                    ))),
                                                            //SizedBox(width: 20,),
                                                            IconButton(
                                                                onPressed:
                                                                    () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon:
                                                                const Icon(
                                                                  Icons
                                                                      .clear,
                                                                  color: Colors
                                                                      .white,
                                                                ))
                                                          ]),
                                                      SizedBox(
                                                        height: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .height *
                                                            0.03,
                                                      ),
                                                      const Center(
                                                        child: Text(
                                                          'Are You Sure',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .height *
                                                            0.01,
                                                      ),
                                                      const Center(
                                                        child: Text(
                                                            'To Send this following tests/package into Lab?',
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                            textAlign:
                                                            TextAlign
                                                                .center),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .height *
                                                            0.1,
                                                      ),

                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                Container(
                                                                  height:
                                                                  30,
                                                                  width: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width *
                                                                      0.35,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white10,
                                                                      border: Border
                                                                          .all(
                                                                          color: Colors
                                                                              .white30),
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius
                                                                              .circular(
                                                                              20))),
                                                                  child: const Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                      children: [
                                                                        Text(
                                                                          'No',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 12),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .arrow_forward,
                                                                          color: Colors
                                                                              .white,
                                                                          size: 20,
                                                                        )
                                                                      ]),
                                                                )),
                                                            GestureDetector(
                                                              onTap: load
                                                                  ? null
                                                                  : () async {
                                                                Navigator.pop(
                                                                    context);
                                                                load =
                                                                true;
                                                                setState(
                                                                        () {});

                                                                List<Map<
                                                                    String,
                                                                    dynamic>>
                                                                selectedTests =
                                                                await fetchTestsFromPackages(
                                                                    selectedItems);

                                                                removeKeysConditionally(
                                                                    selectedTests);

                                                                sendForProcessing(
                                                                    selectedTests);
                                                              },
                                                              child:
                                                              Container(
                                                                height: 30,
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width *
                                                                    0.35,
                                                                decoration: BoxDecoration(
                                                                    color: AppColours
                                                                        .orange,
                                                                    border: Border
                                                                        .all(
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius: const BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            20))),
                                                                child: const Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                    children: [
                                                                      Text(
                                                                        'Yes',
                                                                        style:
                                                                        TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize: 12),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward,
                                                                        color:
                                                                        Colors
                                                                            .white,
                                                                        size:
                                                                        20,
                                                                      )
                                                                    ]),
                                                              ),
                                                            )
                                                          ]),
                                                      //SizedBox(height: 100,),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Send To Processing',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ])),
                        ),
                      ),
                    ]))),
            offlineChild: Offline()));
  }

  mainTestList(BuildContext context) {
    return ListView.builder(
        itemCount: sampleName.length,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SingleChildScrollView(
              child: Card(
                  child: Container(
                    // height: 60,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                          colors: [
                            AppColours.blue,
                            AppColours.orange,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: ExpansionTile(
                        onExpansionChanged: (value) {
                          setState(() {
                            visible = value;
                          });
                        },
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white,
                        //collapsedBackgroundColor: Colors.cyan,

                        shape: const Border(
                            top: BorderSide(color: Colors.white),
                            bottom: BorderSide(color: Colors.white)),
                        collapsedShape: const RoundedRectangleBorder(

                          //side:new  BorderSide(color:Colors.white), //the outline color
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                        // collapsedBackgroundColor: ,

                        title: CheckboxListTile(
                            activeColor: AppColours.white,
                            checkColor: AppColours.blue,
                            side: const BorderSide(color: Colors.white),
                            //fillColor: MaterialStateColor.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text(
                              sampleName[index]['sampleName'].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            selected: selected![index],
                            value: selected![index],
                            onChanged: (bool? value) {
                              debugPrint(value.toString());

                              subListSelectedStatus![index].fillRange(0,
                                  subListSelectedStatus![index].length,
                                  value ?? true);

                              setState(() {
                                selected![index] = value ?? true;
                              });
                            }),
                        children: [
                          Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.36,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade200),
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              child: SingleChildScrollView(
                                  child: Form(
                                    child: Column(children: [
                                      Container(
                                          height: 50,
                                          color: Colors.grey.shade200,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: [
                                              Image.asset(
                                                  "assets/quantity-add-test.png"),
                                              Column(
                                                children: [
                                                  const Text(
                                                    'Quantity',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                  Text(
                                                      subservices![index].length
                                                          .toString())
                                                ],
                                              ),
                                              const SizedBox(),
                                              Image.asset("assets/cash.png"),
                                              Column(
                                                children: [
                                                  const Text(
                                                    'Total Price',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                  Text(subservicecost![index]
                                                      .last
                                                      .toString())
                                                ],
                                              ),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      subTestList(subservices, index),
                                    ]),
                                  )))
                        ]),
                  )));
        });
  }

  Widget subTestList(subservices, index) {
    return ListView.builder(
        itemCount: subservices![index].length,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, subListIndex) {
          Map<String, dynamic> g = subservices![index][subListIndex];

          return Column(children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.18,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  decoration: BoxDecoration(
                    color: g['sndToLabFlag'] == 'Y'
                        ? const Color.fromRGBO(192, 232, 186, 0.9)
                        : Colors.grey.shade200,
                    // Color.fromRGBO(
                    //     192, 232, 186, 0.9),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.settings,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sub Service Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Container(
                                  constraints:
                                  const BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    g['subServiceName'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Checkbox(
                                activeColor: AppColours.orange,
                                value: subListSelectedStatus![index]
                                [subListIndex],
                                onChanged: (value) {
                                  subListSelectedStatus![index][subListIndex] =
                                      value ?? true;
                                  if (subListSelectedStatus![index]
                                      .every((element) => element == true)) {
                                    selected![index] = true;
                                  } else {
                                    selected![index] = false;
                                  }
                                  setState(() {});
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.document_scanner,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Barcode',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    g['barCode'] ?? "-",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ]),
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              Icons.money,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Amount',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  g['rate'].toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${g['collectionDate']
                                      .toString()} - ${g['collectionTime']
                                      .toString()}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ])),
              Positioned(
                bottom: MediaQuery
                    .of(context)
                    .size
                    .height * 0.16,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: AppColours.blue,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(20))),
                  child: Center(
                      child: Text(
                        (subListIndex + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ]),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                decoration: BoxDecoration(
                    color: g['sndToLabFlag'] == 'Y'
                        ? Colors.lightGreen.shade300
                        : Colors.grey.shade400,
                    //Colors.lightGreen.shade300,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: g['serviceId'] == 11
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: g['serviceId'] != 11,
                      child: GestureDetector(
                        onTap: () async {
                          await Fetchlist(g);
                        },
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: g['accessioningStatus'] == 3
                              ? Colors.lightGreen.shade800
                              : AppColours.dark_blue,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: g['serviceId'] != 11,
                      child: Container(
                        height: 40,
                        color: g['accessioningStatus'] == 3
                            ? Colors.lightGreen.shade800
                            : AppColours.dark_blue,
                        width: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        debugPrint('ggg');
                        if (g['accessioningStatus'] == 3) {
                          CustomMessage.toast(
                              "The test/package is in the processing");
                        } else {
                          showModalBottomSheet<void>(
                              barrierColor: Colors.black.withOpacity(0.7),
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery
                                          .of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Center(
                                                    child: Text(
                                                      'Delete Test',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.bold,
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
                                      SizedBox(
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.03,
                                      ),
                                      const Center(
                                        child: Text(
                                          'Are You Sure !',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.01,
                                      ),
                                      const Center(
                                        child: Text(
                                            'You Want to Delete this Test?',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center),
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.1,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white10,
                                                      border: Border.all(
                                                          color:
                                                          Colors.white30),
                                                      borderRadius:
                                                      const BorderRadius
                                                          .all(
                                                          Radius.circular(
                                                              20))),
                                                  child: const Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_forward,
                                                          color: Colors.white,
                                                          size: 20,
                                                        )
                                                      ]),
                                                )),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                showModalBottomSheet(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.7),
                                                    backgroundColor: Colors.grey
                                                        .withOpacity(0.5),
                                                    isScrollControlled: true,
                                                    context: context,
                                                    shape:
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(
                                                              30.0),
                                                          topRight: Radius
                                                              .circular(
                                                              30.0)),
                                                    ),
                                                    builder:
                                                        (BuildContext context) {
                                                      return Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            bottom:
                                                            MediaQuery
                                                                .of(
                                                                context)
                                                                .viewInsets
                                                                .bottom),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: <Widget>[
                                                            Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  const Padding(
                                                                      padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                          20),
                                                                      child: Center(
                                                                          child: Text(
                                                                            'Password Verification',
                                                                            style: TextStyle(
                                                                                color:
                                                                                Colors
                                                                                    .white,
                                                                                fontWeight: FontWeight
                                                                                    .bold,
                                                                                fontSize: 16),
                                                                          ))),
                                                                  //SizedBox(width: 20,),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator
                                                                            .pop(
                                                                            context);
                                                                        username
                                                                            .clear();
                                                                        password
                                                                            .clear();
                                                                      },
                                                                      icon:
                                                                      const Icon(
                                                                        Icons
                                                                            .clear,
                                                                        color: Colors
                                                                            .white,
                                                                      ))
                                                                ]),
                                                            SizedBox(
                                                              height: MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .height *
                                                                  0.03,
                                                            ),
                                                            Center(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width *
                                                                    0.85,
                                                                height: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .height *
                                                                    0.07,
                                                                child:
                                                                TextFormField(
                                                                  onEditingComplete:
                                                                      () {
                                                                    FocusScope
                                                                        .of(
                                                                        context)
                                                                        .nextFocus();
                                                                  },
                                                                  //  Unitname(username.text);},
                                                                  onFieldSubmitted:
                                                                      (value) {
                                                                    FocusScope
                                                                        .of(
                                                                        context)
                                                                        .nextFocus();
                                                                  },
                                                                  // Unitname(username.text);},

                                                                  focusNode:
                                                                  fusername,
                                                                  autofocus:
                                                                  true,
                                                                  textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                                  controller:
                                                                  username,
                                                                  //focusNode: fpassword,
                                                                  //obscureText: _obscured,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null ||
                                                                        value
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      return "Username can not be empty";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  cursorColor:
                                                                  Colors
                                                                      .white,
                                                                  decoration:
                                                                  InputDecoration(
                                                                    filled:
                                                                    true,
                                                                    fillColor:
                                                                    Colors
                                                                        .white10,

                                                                    focusedBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          8.0),
                                                                      borderSide:
                                                                      const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          8.0),
                                                                      borderSide:
                                                                      const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                        1.0,
                                                                      ),
                                                                    ),
                                                                    //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                    //hintText: 'Enter Username',
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                        14),
                                                                    label:
                                                                    RichText(
                                                                      text:
                                                                      const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            'Please Enter User Name',
                                                                            style:
                                                                            TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    // labelText: 'Password',
                                                                    // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                                    floatingLabelStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        14,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .height *
                                                                  0.02,
                                                            ),
                                                            Center(
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .width *
                                                                    0.85,
                                                                height: MediaQuery
                                                                    .of(
                                                                    context)
                                                                    .size
                                                                    .height *
                                                                    0.07,
                                                                child:
                                                                TextFormField(
                                                                  focusNode:
                                                                  fpassword,
                                                                  // autofocus: true,
                                                                  textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                                  controller:
                                                                  password,
                                                                  //focusNode: fpassword,
                                                                  //obscureText: _obscured,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null ||
                                                                        value
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      return "Password can not be empty";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  cursorColor:
                                                                  Colors
                                                                      .white,
                                                                  decoration:
                                                                  InputDecoration(
                                                                    filled:
                                                                    true,
                                                                    fillColor:
                                                                    Colors
                                                                        .white10,

                                                                    focusedBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          8.0),
                                                                      borderSide:
                                                                      const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          8.0),
                                                                      borderSide:
                                                                      const BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                        1.0,
                                                                      ),
                                                                    ),
                                                                    //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                                    //hintText: 'Enter Username',
                                                                    hintStyle: const TextStyle(
                                                                        fontSize:
                                                                        14),

                                                                    label:
                                                                    RichText(
                                                                      text:
                                                                      const TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                            'Please Enter User Password',
                                                                            style:
                                                                            TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    floatingLabelStyle: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        14,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery
                                                                  .of(
                                                                  context)
                                                                  .size
                                                                  .height *
                                                                  0.02,
                                                            ),

                                                            Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                                children: [
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .pop(
                                                                            context);
                                                                        username
                                                                            .clear();
                                                                        password
                                                                            .clear();
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        height:
                                                                        30,
                                                                        width: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .width *
                                                                            0.35,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                            Colors
                                                                                .white10,
                                                                            border: Border
                                                                                .all(
                                                                                color: Colors
                                                                                    .white30),
                                                                            borderRadius: const BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    20))),
                                                                        child: const Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceAround,
                                                                            children: [
                                                                              Text(
                                                                                'Close',
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontSize: 12),
                                                                              ),
                                                                              Icon(
                                                                                Icons
                                                                                    .arrow_forward,
                                                                                color: Colors
                                                                                    .white,
                                                                                size: 20,
                                                                              )
                                                                            ]),
                                                                      )),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      username
                                                                          .text
                                                                          .trim()
                                                                          .isNotEmpty &&
                                                                          password
                                                                              .text
                                                                              .trim()
                                                                              .isNotEmpty
                                                                          ? validateUser(
                                                                          username
                                                                              .text,
                                                                          password
                                                                              .text,
                                                                          g['billDetailsId'])
                                                                          : CustomMessage
                                                                          .toast(
                                                                          'Please Enter Valid Inputs');
                                                                    },
                                                                    child:
                                                                    Container(
                                                                      height:
                                                                      30,
                                                                      width: MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width *
                                                                          0.35,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColours
                                                                              .orange,
                                                                          border: Border
                                                                              .all(
                                                                              color: Colors
                                                                                  .white30),
                                                                          borderRadius: const BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  20))),
                                                                      child: const Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                          children: [
                                                                            Text(
                                                                              'Submit',
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontSize: 12),
                                                                            ),
                                                                            Icon(
                                                                              Icons
                                                                                  .arrow_forward,
                                                                              color: Colors
                                                                                  .white,
                                                                              size: 20,
                                                                            )
                                                                          ]),
                                                                    ),
                                                                  )
                                                                ]),
                                                            //SizedBox(height: 100,),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                height: 30,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width *
                                                    0.35,
                                                decoration: BoxDecoration(
                                                    color: AppColours.orange,
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            20))),
                                                child: const Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                    children: [
                                                      Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
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
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                      child: Icon(
                        Icons.delete_outline,
                        color: g['accessioningStatus'] == 3
                            ? Colors.lightGreen.shade800
                            : AppColours.dark_blue,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
          ]);
        });
  }

  Fetchlist(packageDetails) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ViewAddedPackage(
                widget.patient,
                deleted: () async {
                  Navigator.pop(context);
                  await fetchTreatment();
                },
                packageDetails: packageDetails,
              )),
    );
  }

  fetchTreatment() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // older api url
    final uri = Uri.parse(
        '${url.baseurl}${url.ALREADY_ADDED_Test}?callform=${widget
            .patient!['treatmentId']}&unitId=${decode!['unitMasterId']}');

    // final uri = Uri.parse(
    //     '${url.baseurl}${url.ALREADY_ADDED_Test}?callform=${widget.patient!['treatmentId']}');

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

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    List n = [];
    if (value['status'] == 'success') {
      testList = value['data'];

      load = false;

      selected = List.generate(testList!.length, (index) => false);
      setState(() {});
      if (testList!.isNotEmpty) {
        for (var e in testList!) {
          sampleList!.add(widget.sample
              ?.where((element) => element['sampleId'] == e['sampleTypeId']));

          selected![testList!.indexOf(e)] = e['sndToLabFlag'] == 'N';

          for (var e in sampleList!) {
            sampleName.contains(e.first) ? "" : sampleName.add(e.first);
          }

          subservices = List.generate(sampleName.length, (index) => []);
          subListSelectedStatus =
              List.generate(sampleName.length, (index) => []);

          subservicecost = List.generate(sampleName.length, (index) => []);

          for (int i = 0; i < sampleName.length; i++) {
            var filteredList = testList!
                .where((element) =>
            element['sampleTypeId'] == sampleName[i]['sampleId'])
                .map((element) {
              // Add the model field to the element
              element['sampleName'] = sampleName[i]['sampleName'];
              return element;
            });

            subservices![i].addAll(filteredList);

            subListSelectedStatus![i].addAll(List.generate(
                subservices![i].length,
                    (index) =>
                filteredList.toList()[index]['sndToLabFlag'] == 'N'));
          }
        }
        for (int i = 0; i < subservices!.length; i++) {
          n = subservices![i];

          for (var p in n) {
            cost = cost + p['rate'];
            subservicecost![i].add(cost);
          }
          cost = 0;

          //list=n,
          // debugPrint(subservicecost)
        }
        setState(() {});
      } else {
        setState(() {
          load = false;
          //loadname=false;
        });
      }
    } else {
      //CustomMessage.toast(value['status']),
      setState(() {
        load = false;
        testList = [];
        //loadname=false;
      });
    }
  }

  fetchTestListInPackage(samples) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url
            .TESTINPACKAGE}?pSId=${samples['serviceId']}&pSubSId=${samples['subServiceId']
            .toString()}&sponsorId=0&chargesSlaveId=0&patientId=${widget
            .patient!['patientId'].toString()}&treatmentId=${widget
            .patient!['treatmentId']
            .toString()}&billDetailsId=${samples['bilDetId']}');
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
    var g = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // IPD?.add(g['responses']);
      debugPrint('jhgfgh');
      load = false;
      setState(() {});
      return g['listOpdPackageDto'];
    } else {
      CustomMessage.toast(g['status']);
      load = false;
      setState(() {});
    }
  }

  sendForProcessing(selected) async {
    // debugPrint(selected);
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    load = true;
    setState(() {});
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.SEND_FOR_PROCESSING}');
    debugPrint(uri.path);
    // debugPrint(selected.length);
    // Map<String,dynamic> t=selected.first;
    // debugPrint(t);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {
      "master": {
        "sampleWiseMasterId": null,
        "patientId": widget.patient!['patientId'],
        "treatmentId": widget.patient!['treatmentId'],
        "sampleTypeId": 0,
        "barCode": null,
        "bilDetId": null,
        "profileId": null,
        "collecteddatetime": null,
        "authorizeddatetime": null,
        "postdatetime": null,
        "acceptedDateTime": null,
        "collectionDate": null,
        "collectionTime": null,
        "profiId": null,
        "profileName": null,
        "testId": null,
        "testName": null,
        "methodename": null,
        "masterId": null,
        "barcodenumber": null,
        "masterid": null,
        "collecteddate": null
      },
      "registeredAt": "other",
      "unitId": decode!['unitMasterId'],
      "userId": decode!['userId'],
      "runnerBoy": runnerBoy,
      "userInhouseId": decode!['customerId'],
      "histoList": {},
      "lstSubList": selected
    };
    final jsonbody = json.encode(body);
    debugPrint(jsonbody);

    final response = await ioClient.post(uri, headers: headers, body: jsonbody

      //encoding: encoding,
    );
    debugPrint(response.body);
    Map<String, dynamic> g = jsonDecode(response.body);

    if (response.statusCode == 200) {
      load = false;
      setState(() {});
      CustomMessage.toast(g['message'] ?? "Test Added Successfully");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AddTest(widget.patient, widget.sample)));
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast(g['message']);
    }
  }

  List<Map<String, dynamic>> getSelectedServices(
      List<List<dynamic>>? subServices,
      List<List<bool>>? subListSelectedStatus) {
    List<Map<String, dynamic>> selectedTests = [];
    if (subServices != null && subListSelectedStatus != null) {
      for (int i = 0; i < subServices.length; i++) {
        for (int j = 0; j < subServices[i].length; j++) {
          if (subListSelectedStatus[i][j]) {
            var n = subServices[i][j];
            selectedTests.add({
              "bilDetId": n['billDetailsId'],
              "serviceId": n['serviceId'],
              "subServiceId": n['subServiceId'],
              "refdocid": n['regRefDocId'],
              "gender": n['gender'],
              "sampleTypeId": n['sampleTypeId'],
              "inOutHouse": n['inOutHouse'],
              "barCode": n['barCode'],
              "businessType": n['businessType'],
              "customerType": n['customerType'],
              "customerId": n['customerId'],
              "collectionDate": n['collectionDate'],
              "collectionTime": n['collectionTime'],
              "templateWise": n['templateWise'],
              "isCombination": "N",
              "packageId": n['packageId'],
              "sampleName": n['sampleName'],
            });
          }
        }
      }
    }

    return selectedTests;
  }

  deleteTest(billid) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url
            .DELETE_TEST}?billDetId=$billid&cancleType=Y&deptId=1&userId=${decode!['userId']}');
    debugPrint(uri.path);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.post(
      uri,
      headers: headers,
    );
    debugPrint(response.body);
    Map<String, dynamic> g = jsonDecode(response.body);

    g['status'] == 'success'
        ? {
      CustomMessage.toast(g['message']),
      Navigator.pop(context),
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AddTest(widget.patient, widget.sample))),
    }
        : {CustomMessage.toast(g['response'])};
  }

  closeTreatment(treatmentid, userId) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url
            .CLOSETREATMENT}?treatmentId=$treatmentid&userId=${decode!['userId']}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    //Map<String, dynamic> value = jsonDecode(response.body);
    //debugPrint(value);
    response.statusCode == 200
        ? {
      CustomMessage.toast(response.body),
      Navigator.pop(context),
      Navigator.pop(context),
    }
        : {CustomMessage.toast('Failed to load')};
  }

  fetchConsumption(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url
            .CONSUMPTION}?customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&unitId=${decode!['unitMasterId']}');
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
        fetchAmountCount(decode);
      } else {
        consumption = value['lstPrePostConsumtionDto'];
        Map<String, dynamic> t = consumption!.first;
        advance = t['postpaidAmount'];
        // advance = billing.first.toString().contains('599:Prepaid billing')
        //     ? t['prepaidAmount']
        //     : t['postpaidAmount'];
        consume = t['billConsumeAmount'];
        remain = t['billRemainAmount'];
      }

      setState(() {});
    } else {
      CustomMessage.toast("something went wrong");
    }
  }

  fetchAmountCount(decode) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url
            .CONSUMPTIONAVAILABLEAMT}?userType=${decode!['userType']}&callFrom=&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}');
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
      CustomMessage.toast("something went wrong");
    }
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');
    decode = json.decode(encodedMap!);
    userUnitId = prefs.get("UnitId");

    billing = decode!['userAccesBeanList']["subModuleViewHashSet"];

    await fetchConsumption(decode);
    await fetchTreatment();

    runnerBoy = prefs.getString("runnerboy");
    // fetchPrepaid();
    setState(() {});
  }

  validateUser(username, password, billid) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url
            .VALIDATE_USER}?userId=${decode!['userId']}&userName=$username&userPassword=$password');
    debugPrint(uri.path);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.post(
      uri,
      headers: headers,
    );
    debugPrint(response.body);
    Map<String, dynamic> g = jsonDecode(response.body);

    g['status'] == 'success'
        ? {CustomMessage.toast(g['response']), deleteTest(billid)}
        : {CustomMessage.toast(g['response'])};
  }

  Map<String, String> convertIsoToMap(String isoString) {
    DateTime dt = DateTime.parse(isoString);

    DateFormat dateFormatter = DateFormat('yyyy/MM/dd');
    DateFormat timeFormatter = DateFormat('HH:mm:ss');

    return {
      "date": dateFormatter.format(dt),
      "time": timeFormatter.format(dt),
    };
  }

  Map<String, String> formatTimestamp(int? timestamp) {
    // Convert the timestamp to a DateTime object
    DateTime? dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp ?? 0);

    // Define the format for date and time separately
    DateFormat dateFormatter = DateFormat('yyyy/MM/dd');
    DateFormat timeFormatter = DateFormat('HH:mm:ss'); // 24-hour format

    // Format the DateTime object to separate date and time strings
    String formattedDate = dateFormatter.format(dateTime);
    String formattedTime = timeFormatter.format(dateTime);

    return {
      'date': formattedDate,
      'time': formattedTime,
    };
  }

  removeKeysConditionally(List<Map<String, dynamic>> list) {
    for (var map in list) {
      // Check if the sampleName is "Package"
      if (map['sampleName'] != null) {
        // Remove the keys if the condition is met
        map.remove('sampleName');
        map.remove('packageId');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchTestsFromPackages(
      List<Map<String, dynamic>> selectedItems) async {
    List<Map<String, dynamic>> finalItems = [];
    for (var element in selectedItems) {
      if (element['sampleName'] == "Package") {
        var list = await fetchTestListInPackage(element);
        for (var n in list) {
          Map<String, String>? formattedDateTime;
          if (FlavorConfig.instance.name == "B2BLifenity") {
            formattedDateTime =
            n['createdDateTime'] == null ? null : convertIsoToMap(
                n['createdDateTime']);
          } else {
            formattedDateTime = n['createdDateTime'] == null ? null : formatTimestamp(n['createdDateTime']);
          }

          finalItems.add({
            "bilDetId": n['billDetailsId'],
            "serviceId": n['childServiceId'],
            "subServiceId": n['childSubServiceId'],
            "refdocid": 0,
            "gender": n['gender'],
            "sampleTypeId": n['sampleTypeId'],
            "inOutHouse": 0,
            "barCode": n['barcode'],
            "businessType": widget.patient!['businessType'],
            "customerType": decode!['customerType'],
            "customerId": decode!['customerId'],
            "collectionDate": formattedDateTime == null
                ? ""
                : formattedDateTime['date'],
            "collectionTime": formattedDateTime == null
                ? ""
                : formattedDateTime['time'],
              "templateWise": n['templateWise'],
              "isCombination": "N",
              "packageId": n['subServiceId']
          });
        }
      } else {
        finalItems.add(element);
      }
    }
    return finalItems;
  }
}
