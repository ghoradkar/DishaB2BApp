import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/registration/patient_history.dart';
import 'package:dishabtob/registration/registration.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPatient extends StatefulWidget {
  final List<dynamic>? IPD;

  const GetPatient(this.IPD, {super.key});

  @override
  GetPatientState createState() => GetPatientState();
}

class GetPatientState extends State<GetPatient> {
  bool load = true;
  List IPD = [];
  List _allIPD = [];
  List _filteredIPD = [];
  String? unitId;
  Map<String, dynamic>? patient;
  Map<String, dynamic>? decode;

  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    setState(() {
      (widget.IPD?.length ?? []) == 0 ? load = true : load = false;
    });
    getUser();
    if (widget.IPD != null && widget.IPD!.isNotEmpty) {
      _allIPD = List.from(widget.IPD!);
      _filteredIPD = List.from(widget.IPD!);
    }
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut);
        });
      }
    });

    // fetchIPDList();
    debugPrint(DateFormat('dd/MM/yyyy, HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(1705048026000)));
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
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
                resizeToAvoidBottomInset: true,
                body: SafeArea(
                  top: false,
                  child: load
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColours.blue,
                          ),
                        )
                      : IPD.isEmpty && widget.IPD!.isEmpty
                          ? const DataNotFound()
                          : Container(
                              padding: const EdgeInsets.only(
                                  left: 2, right: 2, bottom: 2),
                              child: widget.IPD!.isEmpty
                                  ? smartReport(context, _filteredIPD)
                                  : smartReport(context, _filteredIPD),
                            ),
                )),
            offlineChild: Offline()));
  }

  smartReport(BuildContext context, List ipdList) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return CustomScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _SearchHeaderDelegate(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4,top: 10),
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  controller: searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _applyFilter,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    hintStyle: const TextStyle(fontSize: 14),
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Search",
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.7),
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: bottomInset),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Map<String, dynamic> g = ipdList[index];

                return Card(
                    // margin: const EdgeInsets.only(bottom: 10),
                    elevation: 3,
                    child: Stack(children: [
                      Container(
                        //  padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.grey.shade200)),
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,

                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //SizedBox(width: 10,),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 30, width: 30,
                                            // margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      AppColours.blue,
                                                      AppColours.orange
                                                    ],
                                                    begin:
                                                        const FractionalOffset(
                                                            0.0, 0.0),
                                                    end: const FractionalOffset(
                                                        1.0, 0.0),
                                                    stops: const [0.0, 1.0],
                                                    tileMode: TileMode.clamp),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Icon(
                                            Icons.tag,
                                            color:
                                                Colors.black87.withOpacity(0.6),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Icon(
                                            Icons.calendar_month,
                                            color:
                                                Colors.black87.withOpacity(0.6),
                                          ),
                                        ]),
                                  ),
                                  //SizedBox(width: 10,),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            g['patientName'].toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          //SizedBox(width: 20,),
                                          const Text(
                                            'Patient ID',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            g['ptId'].toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          //SizedBox(height: 10,),

                                          //SizedBox(width: 20,),
                                          const Text(
                                            'Reg Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          FlavorConfig.instance.name ==
                                                  "B2BLifenity"
                                              ? Text(
                                                  g['createdDateTime'] == null
                                                      ? ''
                                                      : DateFormat(
                                                              'dd-MM-yyyy, HH:mm:ss')
                                                          .format(DateTime.parse(
                                                                  g['createdDateTime'])
                                                              .toLocal())
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                )
                                              : Text(
                                                  g['createdDateTime'] == null
                                                      ? ''
                                                      : DateFormat(
                                                              'dd-MM-yyyy, HH:mm:ss')
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  g['createdDateTime']))
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              g['tFlag'] == 'Y'
                                  ? Container(
                                      height: 20,
                                      width: 92,
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 5,
                                          bottom: 5,
                                          top: 5),
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Mark Visit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                          Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        markVisit(g['ptId']);
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 85,
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 5,
                                            bottom: 5,
                                            top: 5),
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                            color: Colors.lightGreen,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Mark Visit',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            ),
                                            Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          ],
                                        ),
                                      ))
                            ]),
                      ),
                      Positioned(
                        right: 0,
                        child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    fetchPatientDetails(g['ptId'], 'view');
                                  },
                                  child: Container(
                                      width: 45,
                                      height: 35,
                                      margin: const EdgeInsets.only(
                                          top: 30, left: 10),
                                      //clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        color: Colors.grey.withOpacity(0.3),
                                        // AppColors.darkBlueBackgroundColor,
                                      ),
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        size: 20,
                                        color: Colors.black87.withOpacity(0.6),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    fetchPatientDetails(g['ptId'], 'edit');
                                  },
                                  child: Container(
                                      width: 45,
                                      height: 35,
                                      margin: const EdgeInsets.only(
                                          top: 5, left: 10),
                                      //clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        color: Colors.grey.withOpacity(0.3),
                                        // AppColors.darkBlueBackgroundColor,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.black87.withOpacity(0.6),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PatientHistory(g)));
                                  },
                                  child: Container(
                                      width: 45,
                                      height: 35,
                                      margin: const EdgeInsets.only(
                                          top: 5, left: 10),
                                      //clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        color: Colors.grey.withOpacity(0.3),
                                        // AppColors.darkBlueBackgroundColor,
                                      ),
                                      child: Icon(
                                        Icons.timer,
                                        size: 20,
                                        color: Colors.black87.withOpacity(0.6),
                                      ))),
                            ]),
                      )
                    ]));
              },
              childCount: ipdList.length,
            ),
          ),
        ),
      ],
    );
  }

  List _filterList(String query, List source) {
    final text = query.trim().toLowerCase();
    if (text.isEmpty) {
      return List.from(source);
    }

    return source.where((item) {
      final name = item['patientName']?.toString().toLowerCase() ?? '';
      final id = item['ptId']?.toString().toLowerCase() ?? '';
      return name.contains(text) || id.contains(text);
    }).toList();
  }

  void _applyFilter(String query) {
    setState(() {
      _filteredIPD = _filterList(query, _allIPD);
    });
  }

  fetchPatientDetails(patientId, access) async {
    load = true;
    setState(() {});
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri =
        Uri.parse('${url.baseurl}${url.PATIENT_DETAILS}?patId=$patientId');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      setState(() {
        load = false;
        patient = value['lstMarkVisit'].first;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                Registration(patient, access, 0, const [], 0)),
      );
    } else {
      load = false;
      setState(() {});
      CustomMessage.toast('Failed to load');
    }
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');

    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      unitId = prefs.getString('UnitId');
      debugPrint('hjghh$decode');
      widget.IPD!.isEmpty ? fetchIPDList() : '';
    });
  }

  markVisit(patid) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.MARK_VISIT}?patId=$patid&userId=${decode!['userId']}');
    debugPrint(uri.path);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.MARKLIST}?unitId=$unitId&meeshaFlow=off&userType=${decode!['userType']}&userId=${decode!['userId']}&userFor=other');
    // debugPrint(uri);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      setState(() {
        CustomMessage.toast('Successful!');
      });
      await fetchPatientDetails(patid, 'markvisit');
    } else {
      CustomMessage.toast('Failed to load');
    }
  }

  fetchIPDList() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.MARKLIST}?unitId=${decode!['unitMasterId']}&meeshaFlow=off&userType=${decode!['userType']}&userId=${decode!['userId']}&userFor=other');
    debugPrint(uri.path);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.MARKLIST}?unitId=$unitId&meeshaFlow=off&userType=${decode!['userType']}&userId=${decode!['userId']}&userFor=other');
    // debugPrint(uri);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    response.statusCode == 200
        ? {
            setState(() {
              IPD = value['lstRegviewDto'];
              _allIPD = List.from(IPD);
              _filteredIPD = _filterList(searchController.text, _allIPD);
              load = false;
            }),
          }
        : {CustomMessage.toast('Failed to load')};
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _SearchHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
