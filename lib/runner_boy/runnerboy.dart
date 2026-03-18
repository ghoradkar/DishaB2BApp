import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/runner_boy/b2b_collection.dart';
import 'package:dishabtob/runner_boy/b2b_submission.dart';
import 'package:dishabtob/runner_boy/filter_collection.dart';
import 'package:dishabtob/user/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class RunnerBoy extends StatefulWidget {
  final int selectedPage;
  final List<dynamic>? IPD;
  final List<dynamic>? selected;
  final List<dynamic>? submit;

  const RunnerBoy(this.selectedPage, this.IPD, this.selected, this.submit,
      {super.key});

  @override
  RunnerBoyState createState() => RunnerBoyState();
}

class RunnerBoyState extends State<RunnerBoy>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  String color = 'red';
  int _selectedIndex = 0;

  Map<String, dynamic>? decode;
  bool load = false;

  @override
  void initState() {
    debugPrint('registration');

    super.initState();

    controller = TabController(
        length: 2, vsync: this, initialIndex: widget.selectedPage);

    controller!.addListener(() {
      setState(() {
        // indicatorColor = colors[controller!.index];
        _selectedIndex = controller!.index;
      });
      //indicatorColor = colors[0];
      debugPrint("Selected Index: $_selectedIndex");
    });
  }

  // getuser() async {
  //   debugPrint('dashboard');
  //   String? encodedMap;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   encodedMap = prefs.getString('user');
  //   setState(() {
  //     decode = json.decode(encodedMap!);
  //     debugPrint(decode);
  //   });
  // }

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
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(21, 115, 175, 1),
                                  Color.fromRGBO(236, 106, 56, 0.7)
                                ],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(0.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                    )),
                                //SizedBox(width: 5,),
                                const Text(
                                  'Dashboard',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
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
                                            return FilterCollection(
                                                controller!.index);
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.filter_alt,
                                      color: Colors.white,
                                    )),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Profile(decode)),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white30,
                                        border: Border.all(color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40))),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ])),
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
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      //border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.94,
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

                                      //your currently selected index
                                    },
                                    indicatorSize: TabBarIndicatorSize.tab,

                                    //dividerColor: Colors.red,
                                    labelColor: Colors.white,
                                    controller: controller,

                                    unselectedLabelColor: Colors.black54,
                                    tabAlignment: TabAlignment.center,
                                    //indicatorColor: indicatorColor,

                                    indicator: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(21, 115, 175, 1),
                                              Color.fromRGBO(236, 106, 56, 0.7)
                                            ],
                                            begin: FractionalOffset(
                                                0.0, 0.0),
                                            end: FractionalOffset(
                                                1.0, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10))),

                                    //indicatorColor: Colors.red,
                                    tabs: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.34,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                        child: Row(children: [
                                          Icon(
                                            Icons.science,
                                            color: controller!.index == 0
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Tab(
                                              child: Text(
                                            'B2B Collection',
                                            style: TextStyle(fontSize: 10),
                                          ))
                                        ]),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          child: Row(children: [
                                            Icon(
                                              Icons.scoreboard,
                                              color: controller!.index == 1
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Tab(
                                                child: Text(
                                              'B2B Lab Submission',
                                              style: TextStyle(fontSize: 10),
                                            )),
                                          ])),
                                    ],
                                  )),

                              Expanded(
                                child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller,
                                    children: [
                                      widget.selectedPage == 0
                                          ? B2BCollection(
                                              widget.selectedPage,
                                              widget.IPD,
                                              widget.selected,
                                              widget.submit)
                                          : const B2BCollection(0, [], [], []),
                                      widget.selectedPage == 1
                                          ? B2BSubmission(
                                              widget.selectedPage,
                                              widget.IPD,
                                              widget.selected,
                                              widget.submit)
                                          : const B2BSubmission(1, [], [], [])
                                    ]),
                              ),
                            ])),
                      )
                    ]))),
            offlineChild: Offline()));
  }
}
