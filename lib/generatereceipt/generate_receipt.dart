import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/generatereceipt/patient_billing.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'filter_receipt.dart';

class GenerateReceipt extends StatefulWidget {
  final List<dynamic>? IPD;

  const GenerateReceipt(this.IPD, {super.key});

  @override
  GenerateReceiptState createState() => GenerateReceiptState();
}

class GenerateReceiptState extends State<GenerateReceipt> {
  List<dynamic> IPD = [];
  bool load = false;
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
  FocusNode fto = FocusNode();
  Map<String, dynamic>? decode;
  String? title = 'Patient Id';
  List<String> item = ["Patient Id"];
  FocusNode fpatid = FocusNode();
  TextEditingController patientid = TextEditingController();

  var userUnitId;

  @override
  void initState() {
    setState(() {
      widget.IPD!.length == 0 ? load = true : load = false;
    });
    getuser();
    //fetchB2BList();

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
                                // SizedBox(width: 5,),
                                const Text(
                                  'Generate Receipt',
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
                                            return const FilterReceipt();
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.filter_alt,
                                      color: Colors.white,
                                    ))
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
                              Expanded(
                                  child: load
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.indigo,
                                          ),
                                        )
                                      : IPD.isEmpty && widget.IPD!.isEmpty
                                          ? const DataNotFound()
                                          : widget.IPD!.length == 0
                                              ? SmartReport(context, IPD)
                                              : SmartReport(
                                                  context, widget.IPD))
                            ]),
                          )),
                    ]))),
            offlineChild: Offline()));
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUnitId = prefs.get("UnitId");

    encodedMap = prefs.getString('user');
    debugPrint('jgh$encodedMap');

    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    fromdate.text = formattedDate;
    todate.text = formattedDate;
    setState(() {
      decode = json.decode(encodedMap!);
      debugPrint('hjghh$decode');
      widget.IPD!.length == 0
          ? fetchGererateReceiptList(formattedDate, formattedDate)
          : "";
    });
  }

  fetchGererateReceiptList(fromDate, toDate) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATERECEIPT}?fromDate=2024-05-20&toDate=2024-05-22&unitId=$userUnitId&customerId=${decode!['customerId']}');

    final uri = Uri.parse(
        '${url.baseurl}${url.GENERATERECEIPT}?fromDate=$fromDate&toDate=$toDate&userType=${decode?['userType']}&userCustomerId=${decode?['customerId']}&unitId=$userUnitId');
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
        IPD = value['list'];
        load = false;
      });
    } else {
      setState(() {
        load = false;
      });
      CustomMessage.toast('Failed to load');
    }
  }

  SmartReport(BuildContext context, IPD) {
    return ListView.builder(
        itemCount: IPD!.length,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = IPD![index];

          return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 3,
              child: Container(
                //  padding: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade200)),
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
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
                                    colors: [AppColours.blue, AppColours.orange],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(0.0, 1.0),
                                    stops: const [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20))),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          g['patientName'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  Icons.tag,
                                  color: Colors.black87.withOpacity(0.6),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.black87.withOpacity(0.6),
                                ),
                              ]),
                        ),
                        //SizedBox(width: 10,),

                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Patient ID',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['patientId'].toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              //SizedBox(height: 10,),

                              //SizedBox(width: 20,),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Admission Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                g['admissionDate'] != null
                                    ? g['admissionDate'].split(' ').first
                                    : '',
                                style: const TextStyle(fontSize: 12),
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.01,
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0,
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //SizedBox(height: 10,),

                                Icon(
                                  Icons.phone_android,
                                  color: Colors.black87.withOpacity(0.6),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0,
                              top: MediaQuery.of(context).size.height * 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Mobile',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                '${g['mobile']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              //SizedBox(height: 10,),

                              //SizedBox(width: 20,),

                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
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
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PatientBilling(g)));
                                    },
                                    child: const Text(
                                      'Generate Receipt',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 10),
                                    ),
                                    //Icon(Icons.download,color: Colors.white,size: 15,)
                                  )),
                              //
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
