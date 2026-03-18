import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/generatereceipt/generate_receipt.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishabtob/global/url.dart' as url;

class FilterReceipt extends StatefulWidget {
  const FilterReceipt({super.key});

  @override
  FilterReceiptState createState() => FilterReceiptState();
}

class FilterReceiptState extends State<FilterReceipt> {
  TextEditingController fromdateController = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todateContoller = TextEditingController();
  FocusNode fto = FocusNode();
  Color yesterday = Colors.transparent;
  Color month = Colors.transparent;
  Color customr = Colors.transparent;
  Color today = AppColours.blue.withOpacity(0.6);
  Color last7 = Colors.transparent;
  Color lstmonth = Colors.transparent;

  String? callfrom = 'today';
  Map<String, dynamic>? decode;
  Map<String, dynamic>? data;
  Map<String, dynamic>? graph;
  String? current;
  String? title = 'Patient Id';
  String? gen = 'Patient Id';
  bool visible = false;
  List<String> item = ["Patient Id", "Patient Name"];
  Map<String, dynamic>? user;
  FocusNode ffirst = FocusNode();

  bool load = false;
  List<dynamic>? IPD;
  FocusNode fpatid = FocusNode();
  TextEditingController patientid = TextEditingController();
  var userUnitId;





  @override
  void initState() {
    current = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fromdateController.text = current!;
    todateContoller.text = current!;
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        initialData: NetworkStatus.Online,
        child: NetworkAwareWidget(
            onlineChild: SingleChildScrollView(
                child: Container(
              decoration: const BoxDecoration(
                  //color: Colors.black.withAlpha(1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.56,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              'Filter By',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
                  Center(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        // height: MediaQuery.of(context).size.height*0.07,
                        color: Colors.white10,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: DropdownButton(
                      underline: Container(
                        color: Colors.white,
                      ),
                      hint: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Search By',
                              style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7),
                                  fontSize: 14),
                            ),
                            const TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      autofocus: true,
                      padding: const EdgeInsets.all(5),
                      isExpanded: true,
                      dropdownColor: Colors.grey.shade500,
                      iconEnabledColor: Colors.white,
                      value: title,
                      items: item.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(
                            country,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (country) {
                        setState(() {
                          title = country;
                          FocusScope.of(context).nextFocus();
                        });
                      },
                    ),
                  )),

                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        //  Unitname(username.text);},
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        // Unitname(username.text);},

                        focusNode: ffirst,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: patientid,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Patient Is can not be empty";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

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
                          //floatingLabelBehavior: FloatingLabelBehavior.never,

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Type Patient ID here',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // labelText: 'Password',
                          // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                          floatingLabelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        'Select Date Range',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ))),
                  //SizedBox(width: 20,),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        focusNode: ffrom,
                        // autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: fromdateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "From Date can not be empty";
                          } else {
                            return null;
                          }
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.indigo, // <-- SEE HERE
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface: Colors.indigo, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.indigo, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(),
                            //get today's date
                            firstDate: DateTime(1900),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate:
                                DateTime.now().add(const Duration(days: 0)),
                          );
                          if (pickedDate != null) {
                             //get the picked date in the format => 2022-07-04 00:00:00.000
                            String formattedDate = DateFormat('dd/MM/yyyy').format(
                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(
                                formattedDate); //formatted date output using intl package =>  2022-07-04
                            //You can format date as per your need

                            setState(() {
                              fromdateController.text = formattedDate;
                            });
                          } else {
                            debugPrint("From Date is not selected");
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'From Date',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // labelText: 'Password',
                          // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                          floatingLabelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: TextFormField(
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        focusNode: fto,
                        //  autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: todateContoller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "To Date can not be empty";
                          } else {
                            return null;
                          }
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Colors.indigo, // <-- SEE HERE
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface: Colors.indigo, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.indigo, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(),
                            //get today's date
                            firstDate: DateTime(1900),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate:
                                DateTime.now().add(const Duration(days: 0)),
                          );
                          if (pickedDate != null) {
                             //get the picked date in the format => 2022-07-04 00:00:00.000
                            String formattedDate = DateFormat('dd/MM/yyyy').format(
                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(
                                formattedDate); //formatted date output using intl package =>  2022-07-04
                            //You can format date as per your need

                            setState(() {
                              todateContoller.text = formattedDate;
                            });
                          } else {
                            debugPrint("To Date is not selected");
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          //hintText: 'Enter Username',
                          hintStyle: const TextStyle(fontSize: 14),
                          label: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'To Date',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // labelText: 'Password',
                          // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                          floatingLabelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                // fromdate.text=current!;
                                // todate.text=current!;
                                // callfrom='today';
                                // customr=Colors.transparent;
                                // yesterday=Colors.transparent;
                                // month=Colors.transparent;
                                // today=Colurs.blue.withOpacity(0.6);
                                // last7=Colors.transparent;
                                // lstmonth=Colors.transparent;

                                fromdateController.text = "";
                                todateContoller.text = "";
                                patientid.text = "";
                              });
                            },
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  border: Border.all(color: Colors.white30),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Reset',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
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
                            //   searchPatient(firstname.text);

                            DateTime parsedFromDate = DateFormat('dd/MM/yyyy')
                                .parse(fromdateController.text);
                            DateTime parsedToDate = DateFormat('dd/MM/yyyy')
                                .parse(todateContoller.text);

                            // Format the parsed date to the desired format
                            String reformattedFromDate =
                                DateFormat('yyyy-MM-dd').format(parsedFromDate);
                            String reformattedToDate =
                                DateFormat('yyyy-MM-dd').format(parsedToDate);

                            // DateTime parsedDate = DateFormat('yyyy/MM/dd').parse(fromdateController.text);
                            // DateTime parsedDate2 = DateFormat('yyyy/MM/dd').parse(todateContoller.text);
                            //
                            // // Format the parsed date to the desired format
                            // String reformattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                            // String reformattedDate1 = DateFormat('yyyy-MM-dd').format(parsedDate2);
                            var param;
                            if (title == "Patient Id") {
                              param = 'byId';
                            } else {
                              param = 'byName';
                            }

                            patientid.text.trim().isEmpty
                                ? serachByToAndFromDate(
                                    reformattedFromDate, reformattedToDate)
                                : searchByIdAndName(patientid.text, param);
                          },
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: AppColours.orange,
                                border: Border.all(color: Colors.white30),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Results',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
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
                  //  SizedBox(height: 300,),
                ],
              ),
            )),
            offlineChild: Offline()));
  }

  searchByIdAndName(patid, searchBy) async {
    // debugPrint('11$decode');

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    //getuser();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.SEARCHBYIDANDNAMEGENERATERECEIPT}?searchText=$patid&searchBy=$searchBy&unitId=${decode!['unitMasterId']}&userType=${decode!['userType']}&userCustomerId=${decode!['customerId']}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    if (response.statusCode == 200) {
      Map<String, dynamic> value = jsonDecode(response.body);
      debugPrint(response.body);
      setState(() {
        IPD = value['list'];
        load = false;
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => GenerateReceipt(IPD)));
      });
    } else {
      CustomMessage.toast('Failed to load');
    }

  }

  serachByToAndFromDate(fromDate, toDate) async {
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
    response.statusCode == 200
        ? {
      setState(() {
        IPD = value['list'];

        load = false;
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GenerateReceipt(IPD),
            ));

        IPD = value['list'];
        load = false;
      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    userUnitId = prefs.get("UnitId");

    setState(() {
      user = json.decode(encodedMap!);
      decode = user!;

      //FetchData(current,current);
    });
  }
}
