import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/registration/demographic_info.dart';
import 'package:dishabtob/registration/filter_appointment.dart';
import 'package:dishabtob/registration/get_patient.dart';
import 'package:dishabtob/registration/personal_info.dart';
import 'package:dishabtob/registration/upload_document.dart';
import 'package:dishabtob/dashboard/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class Registration extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final String? access;
  final int selectedPage;
  final List<dynamic>? IPD;
  final int? ttid;

  const Registration(
      this.patient, this.access, this.selectedPage, this.IPD, this.ttid,
      {super.key});

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  String color = 'red';
  int _selectedIndex = 0;

  Map<String, dynamic>? decode;
   Map<String, dynamic>? details;
  bool load = false;

  @override
  void initState() {
    setState(() {
      details = widget.patient;
    });

    controller = (widget.access != 'view' &&
            widget.access != 'edit' &&
            widget.access != 'add')
        ? TabController(
            length: 2, vsync: this, initialIndex: widget.selectedPage)
        : TabController(
            length: 3, vsync: this, initialIndex: widget.selectedPage);

    controller!.addListener(() {
      setState(() {
        // indicatorColor = colors[controller!.index];
        _selectedIndex = controller!.index;
      });
      //indicatorColor = colors[0];
      debugPrint("Selected Index: $_selectedIndex");
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
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                AppColours.blue,
                                AppColours.orange
                              ],
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
                                'Patient registration',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            widget.access != 'view' &&
                                    widget.access != 'edit' &&
                                    widget.access != 'add'
                                ? controller!.index == 1
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.11,
                                      )
                                : controller!.index == 2
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.11,
                                      ),
                            widget.access != 'view' &&
                                    widget.access != 'edit' &&
                                    widget.access != 'add'
                                ? controller!.index == 1
                                    ? IconButton(
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
                                                return const FilterAppointment();
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.filter_alt,
                                          color: Colors.white,
                                        ))
                                    : const SizedBox()
                                : controller!.index == 2
                                    ? IconButton(
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
                                                return const FilterAppointment();
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.filter_alt,
                                          color: Colors.white,
                                        ))
                                    : const SizedBox(),
                            widget.access != 'view' &&
                                    widget.access != 'edit' &&
                                    widget.access != 'add'
                                ? const SizedBox()
                                : controller!.index == 1
                                    ? InkWell(
                                        onTap: () async {
                                          showModalBottomSheet<void>(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.7),
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.5),

                                              // context and builder are
                                              // required properties in this widget
                                              context: context,
                                              builder: (BuildContext context) {
                                                return UploadDocument(details);
                                              });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                              color: AppColours.orange,
                                              border: Border.all(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Row(
                                            children: [
                                              Text(
                                                'Upload Documents',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                              Icon(
                                                Icons.upload,
                                                color: Colors.white,
                                                size: 15,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
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
                                  onTap: (index) {
                                    if (index == 0) {
                                      setState(() {
                                        color = 'red';
                                      });
                                    }
                                    if (index == 1) {
                                      setState(() {
                                        color = 'yellow';
                                      });
                                    }
                                    if (index == 2) {
                                      widget.access != 'view' &&
                                              widget.access != 'edit' &&
                                              widget.access != 'add'
                                          ? {}
                                          : {
                                              setState(() {
                                                color = 'blue';
                                              }),
                                            };
                                    }

                                    //your currently selected index
                                  },
                                  indicatorSize: TabBarIndicatorSize.tab,

                                  //dividerColor: Colors.red,
                                  labelColor: Colors.white,
                                  controller: controller,
                                  unselectedLabelColor: Colors.black54,
                                  tabAlignment: TabAlignment.center,
                                  //indicatorColor: indicatorColor,

                                  indicator: color == 'red'
                                      ?  BoxDecoration(
                                          color: AppColours.blue,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(0),
                                              topRight: Radius.circular(0)))
                                      : widget.access != 'view' &&
                                              widget.access != 'edit'
                                          ?  BoxDecoration(
                                              color: AppColours.blue,
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20)))
                                          : color == 'yellow'
                                              ?  BoxDecoration(
                                                  color: AppColours.blue,
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(0),
                                                      bottomLeft:
                                                          Radius.circular(0),
                                                      bottomRight:
                                                          Radius.circular(0),
                                                      topRight:
                                                          Radius.circular(0)))
                                              :  BoxDecoration(
                                                  color: AppColours.blue,
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(0),
                                                      bottomLeft:
                                                          Radius.circular(0),
                                                      bottomRight:
                                                          Radius.circular(0),
                                                      topRight:
                                                          Radius.circular(0))),

                                  //indicatorColor: Colors.red,
                                  tabs: widget.access != 'view' &&
                                          widget.access != 'edit' &&
                                          widget.access != 'add'
                                      ? [
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.37,
                                              child: const Tab(
                                                  child: Text(
                                                'Personal Info',
                                                style: TextStyle(fontSize: 10),
                                              ))),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.34,
                                            child: const Tab(
                                                child: Text(
                                              'Get Patient',
                                              style: TextStyle(fontSize: 10),
                                            )),
                                          )
                                        ]
                                      : [
                                          const Tab(
                                              child: Text(
                                            'Personal Info',
                                            style: TextStyle(fontSize: 10),
                                          )),
                                          const Tab(
                                              child: Text(
                                            'Demographic Info',
                                            style: TextStyle(fontSize: 10),
                                          )),
                                          const Tab(
                                            child: Text(
                                              'Get Patient',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          )
                                        ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller,
                                  children: widget.access != 'view' &&
                                          widget.access != 'edit' &&
                                          widget.access != 'add'
                                      ? [
                                          PersonalInfo(widget.patient, details,
                                              widget.access),
                                          MediaQuery.removeViewInsets(
                                              context: context,
                                              removeBottom: true,
                                              child: GetPatient(widget.IPD))
                                        ]
                                      : [
                                          PersonalInfo(widget.patient, details,
                                              widget.access),
                                          DemographicInfo(
                                              widget.patient,
                                              details,
                                              widget.access,
                                              widget.ttid),
                                          MediaQuery.removeViewInsets(
                                              context: context,
                                              removeBottom: true,
                                              child: GetPatient(widget.IPD))

                                        ],
                                ),
                              ),
                            ])),
                      )
                    ]))),
            offlineChild: Offline()));
  }
}
