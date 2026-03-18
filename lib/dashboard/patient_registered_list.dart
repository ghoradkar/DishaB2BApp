import 'package:dishabtob/btob_queue/filter_bills.dart';
import 'package:dishabtob/dashboard/b2b_previous_bill_list.dart';
import 'package:dishabtob/dashboard/b2b_queue_patient_list.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/dashboard/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientRegisteredList extends StatefulWidget {
  const PatientRegisteredList({super.key});

  @override
  PatientRegisteredListState createState() => PatientRegisteredListState();
}

class PatientRegisteredListState extends State<PatientRegisteredList>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  int _selectedIndex = 0;

  Map<String, dynamic>? decode;
  Map<String, dynamic>? details;
  bool load = false;

  List<dynamic> IPD = [];

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);

    controller!.addListener(() {
      setState(() {
        // indicatorColor = colors[controller!.index];
        _selectedIndex = controller!.index;
      });
    });
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
                                  String current = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                              'Today',
                                              current,
                                              current,
                                              decode)));
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              width: 4,
                            ),
                            const Expanded(
                              child: Text(
                                'Patient Registration',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            if (controller!.index == 1)
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
                                          return FilterBills(
                                            callFrom: false,
                                            callB: (ipd) {
                                              IPD = ipd;
                                              setState(() {});
                                            },
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt,
                                    color: Colors.white,
                                  ))
                          ],
                        ),
                      ),
                      // SizedBox(height: MediaQuery.of(context).size.height*0.08,),

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
                              // SizedBox(height:5,),

                              Container(
                                margin: const EdgeInsets.only(
                                    top: 0, bottom: 10, left: 0, right: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.94,
                                child: TabBar(
                                    isScrollable: false,

                                    //   isScrollable: true,

                                    // dividerColor: Colors.red ,
                                    // dividerHeight: 33,
                                    onTap: (index) {},
                                    indicatorSize: TabBarIndicatorSize.tab,

                                    //dividerColor: Colors.red,
                                    labelColor: Colors.white,
                                    controller: controller,
                                    unselectedLabelColor: Colors.black54,
                                    tabAlignment: TabAlignment.center,
                                    //indicatorColor: indicatorColor,

                                    indicator: BoxDecoration(
                                        color: AppColours.blue,
                                        borderRadius:
                                            BorderRadius.circular(20)),

                                    //indicatorColor: Colors.red,
                                    tabs: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.37,
                                          child: const Tab(
                                              child: Text(
                                            'B2B Queue',
                                            style: TextStyle(fontSize: 10),
                                          ))),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.34,
                                        child: const Tab(
                                            child: Text(
                                          'B2B Previous Bill',
                                          style: TextStyle(fontSize: 10),
                                        )),
                                      )
                                    ]),
                              ),
                              Expanded(
                                child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller,
                                    children: [
                                      const B2BQueuePatientList(),
                                      B2BPreviousBillList(
                                        IPD: IPD,
                                      ),
                                    ]),
                              ),
                            ])),
                      )
                    ]))),
            offlineChild: Offline()));
  }
}
