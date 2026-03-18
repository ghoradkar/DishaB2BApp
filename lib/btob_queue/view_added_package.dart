import 'dart:convert';
import 'package:dishabtob/Global/custom_message.dart';
import 'package:dishabtob/btob_queue/modal/view_package_tests_model.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAddedPackage extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final dynamic packageDetails;
  final Function? deleted;

  const ViewAddedPackage(this.patient,
      {super.key, this.packageDetails, this.deleted});

  @override
  ViewAddedPackageState createState() => ViewAddedPackageState();
}

class ViewAddedPackageState extends State<ViewAddedPackage> {
  bool load = false;
  Map<String, dynamic>? decode;
  String? unitcode;
  Map<String, dynamic> g = {};
  var userUnitId;

  ViewPackageTestsModel? viewPackageTestsModel;

  @override
  void initState() {
    setState(() {
      load = true;
    });
    getUser();

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
                                  'Sample Wise Services',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
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
                              //SizedBox(height: 20,),
                              Expanded(
                                  child: load
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColours.blue,
                                          ),
                                        )
                                      : // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                                      viewPackageTestsModel
                                                      ?.listOpdPackageDto !=
                                                  null &&
                                              viewPackageTestsModel!
                                                  .listOpdPackageDto!.isEmpty
                                          ? const Center(
                                              child: DataNotFound(),
                                            )
                                          : testListWidget(context)),
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  testListWidget(BuildContext context) {
    return ListView.builder(
        itemCount: viewPackageTestsModel?.listOpdPackageDto?.length,
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          ListOpdPackageDto? g =
              viewPackageTestsModel?.listOpdPackageDto?[index];

          return Stack(children: [
            Card(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                elevation: 3,
                color: const Color.fromRGBO(237, 245, 250, 1),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(237, 245, 250, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.shade200)),
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //SizedBox(width: 10,),

                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Icon(
                                      Icons.settings,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Image.asset(
                                      "assets/hash.png",
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Icon(
                                      Icons.science,
                                      color: Colors.black87.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //SizedBox(height: 10,),
                                  const Text(
                                    'Sample Type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    g?.sampleTypeName ?? "",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

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
                                    g?.barcode ?? "-",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Tests',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 210),
                                    child: Text(
                                      g?.categoryName ?? "",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  deleteTestFromPackage(g!);
                                },
                                icon: const Icon(Icons.delete_outline_outlined))
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.185,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    color: AppColours.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Center(
                    child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(color: Colors.white),
                )),
              ),
            ),
          ]);
        });
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    userUnitId = prefs.get("UnitId");

    debugPrint('jgh$encodedMap');
    setState(() {
      decode = json.decode(encodedMap!);
      unitcode = prefs.getString("UnitCode");
    });
    await fetchTestList();
  }

  fetchTestList() async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.TESTINPACKAGE}?pSId=13&pSubSId=${widget.packageDetails['subServiceId']}&sponsorId=0&chargesSlaveId=0&patientId=${widget.patient!['patientId'].toString()}&treatmentId=${widget.patient?['treatmentId'].toString()}&billDetailsId=${widget.packageDetails['billDetailsId']}');
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
      g = jsonDecode(response.body);
      viewPackageTestsModel = ViewPackageTestsModel.fromJson(g);
      debugPrint('jhgfgh');
      load = false;
      setState(() {});
    } else {
      CustomMessage.toast(g['status']);
      load = false;
      setState(() {});
    }
  }

  deleteTestFromPackage(ListOpdPackageDto g) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);
    var uri;
    if (FlavorConfig.instance.name != "B2BLifenity") {
      uri = Uri.parse(
          '${url.baseurl}${url.DELETETESTFROMPACKAGE}?billDetailsId=${g.billDetailsId.toString()}&otherBillDetailsId=${g.otherBillDetailsId.toString()}&childSubServiceIdOpdPackage=${g.childSubServiceId.toString()}');
    }else{
      uri = Uri.parse(
          '${url.baseurl}${url.DELETETESTFROMPACKAGE}?billDetailsId=${g.billDetailsId.toString()}&otherBillDetailsId=${g.otherBillDetailsId.toString()}&childSubServiceIdOpdPackage=${g.childSubServiceId.toString()}&userId=${decode!['userId']}');
    }

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
      CustomMessage.toast(response.body);
      widget.deleted!();
      setState(() {});
    } else {
      CustomMessage.toast(response.body);
      load = false;
      setState(() {});
    }
  }
}
