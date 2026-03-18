import 'dart:convert';
import 'package:dishabtob/dashboard/b2b_previous_bill_list.dart';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/btob_queue/previous_bill.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterBills extends StatefulWidget {
  final bool callFrom;
  final Function? callB;

  const FilterBills({super.key, required this.callFrom, this.callB});

  @override
  FilterBillsState createState() => FilterBillsState();
}

class FilterBillsState extends State<FilterBills> {
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
  FocusNode fto = FocusNode();
  Map<String, dynamic>? decode;
  String? current;
  String? title = 'Patient Id';
  String? gen = 'Patient Id';
  List<String> item = ["Patient Id", "Patient Name"];
  Map<String, dynamic>? user;
  FocusNode ffirst = FocusNode();
  String? unitid;
  TextEditingController firstname = TextEditingController();
  bool load = false;
  bool naame = false;
  List<dynamic>? IPD;

  @override
  void initState() {
    setState(() {
      load = true;
      naame = true;
    });
    current = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fromdate.text = current!;
    todate.text = current!;
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
              height: MediaQuery.of(context).size.height * 0.5,
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
                        controller: firstname,
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
                                  text: 'Type here',
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
                    height: 10,
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.41,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: TextFormField(
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              focusNode: ffrom,
                              // autofocus: true,
                              textInputAction: TextInputAction.done,
                              controller: fromdate,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                        colorScheme: ColorScheme.light(
                                          primary: AppColours.blue,
                                          // <-- SEE HERE
                                          onPrimary: Colors.white,
                                          // <-- SEE HERE
                                          onSurface:
                                              AppColours.blue, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColours
                                                .blue, // button text color
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
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 0)),
                                );
                                if (pickedDate != null) {
                                  //get the picked date in the format => 2022-07-04 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  debugPrint(
                                      formattedDate); //formatted date output using intl package =>  2022-07-04
                                  //You can format date as per your need

                                  setState(() {
                                    fromdate.text = formattedDate;
                                  });
                                } else {
                                  debugPrint("From Date is not selected");
                                }
                              },
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                        // SizedBox(width: 10,),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.41,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: TextFormField(
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              focusNode: fto,
                              //  autofocus: true,
                              textInputAction: TextInputAction.done,
                              controller: todate,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                        colorScheme: ColorScheme.light(
                                          primary: AppColours.blue,
                                          // <-- SEE HERE
                                          onPrimary: Colors.white,
                                          // <-- SEE HERE
                                          onSurface:
                                              AppColours.blue, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColours
                                                .blue, // button text color
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
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 0)),
                                );
                                if (pickedDate != null) {
                                  //get the picked date in the format => 2022-07-04 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  debugPrint(
                                      formattedDate); //formatted date output using intl package =>  2022-07-04
                                  //You can format date as per your need

                                  setState(() {
                                    todate.text = formattedDate;
                                  });
                                } else {
                                  debugPrint("To Date is not selected");
                                }
                              },
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                        const SizedBox()
                      ]),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                // fromdate.text=current!;
                                // todate.text=current!;
                                // callfrom='today';
                                // customr=Colors.transparent;
                                // yesterday=Colors.transparent;
                                // month=Colors.transparent;
                                // today=Colurs.blue.withOpacity(0.6);
                                // last7=Colors.transparent;
                                // lstmonth=Colors.transparent;
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
                            firstname.text.isNotEmpty && title == 'Patient Name'
                                ? searchBillName(firstname.text, 'byName')
                                : firstname.text.isNotEmpty &&
                                        title == 'Patient Id'
                                    ? searchBillbyid(firstname.text, 'byId')
                                    : searchbillbydate(fromdate.text.toString(),
                                        todate.text.toString());
                          },
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: AppColours.orange,
                                border: Border.all(color: Colors.white),
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
                  //SizedBox(height: 200,),
                ],
              ),
            )),
            offlineChild: Offline()));
  }

  searchBillName(patid, type) async {
    getuser();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // final uri = Uri.parse(
    // debugPrint(uri);
    final uri = Uri.parse(
        '${url.baseurl}${url.B2B_PREVIOUS_BILL_SEARCH}?startIndex=0&searchBy=$type&searchText=$patid&usertype=undefined&businessType=1&deptId=1&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&loginUserType=${decode!['userType']}&unitId=$unitid&fromdate=2023-01-01&toDate=$current');

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(uri.path);
    debugPrint(response.body);

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    value['status'] == 'failed'
        ? {
            CustomMessage.toast(value['response']),
            Navigator.pop(context),
            if (widget.callFrom)
              {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PreviousBill([]))),
              }
            else
              {widget.callB!([])}
          }
        : {
            setState(() {
              Map<String, dynamic> value1 = jsonDecode(value['response']);

              IPD = value1['lstRegviewDto'];

              load = false;
              Navigator.pop(context);
              if (widget.callFrom) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviousBill(IPD!)));
              } else {
                widget.callB!(IPD);
              }
            }),
          };
  }

  searchBillbyid(patid, type) async {
    getuser();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.B2B_PREVIOUS_BILL_SEARCH}?startIndex=0&searchBy=$type&searchText=$patid&usertype=undefined&businessType=1&deptId=1&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&loginUserType=${decode!['userType']}&unitId=$unitid&fromdate=2023-01-01&toDate=$current');

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(uri.path);
    debugPrint(response.body);

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    value['status'] == 'failed'
        ? {
            CustomMessage.toast(value['response']),
            Navigator.pop(context),
            if (widget.callFrom)
              {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PreviousBill([]))),
              }
            else
              {widget.callB!([])}
          }
        : {
            setState(() {
              Map<String, dynamic> value1 = jsonDecode(value['response']);

              IPD = value1['lstRegviewDto'];

              load = false;
              Navigator.pop(context);
              if (widget.callFrom) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviousBill(IPD ?? [])));
              } else {
                widget.callB!(IPD);
              }

              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => Registration({},'',1,IPD,0)));
            }),
            // Navigator.pop(context);
            //  Navigator.of(context).push(
            //    MaterialPageRoute(
            //        builder: (context) => Get_Patient(IPD)),
            //  );
          };
  }

  searchbillbydate(fromdate, todate) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse(
        '${url.baseurl}${url.PREVIOUS_BILL}?inputFromDate=$fromdate&inputToDate=$todate&deptId=1&startIndex=0&businessType=1&userType=${decode!['userType']}&userFor=other&userId=${decode!['userId']}&unitId=$unitid');

    // final uri = Uri.parse(
    //     '${url.baseurl}${url.PREVIOUS_BILL}?inputFromDate=$fromdate&inputToDate=$todate&deptId=1&startIndex=0&businessType=1&userType=receptionist&userFor=other&userId=163&unitId=2');
    // debugPrint(uri);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(response.body);

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(jsonDecode(response.body));
    value['status'] == 'failed'
        ? {
            CustomMessage.toast(value['response']),
            Navigator.pop(context),
            if (widget.callFrom)
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviousBill(const []))),
              }
            else
              {widget.callB!([])}
          }
        : {
            setState(() {
              IPD = value['lstRegviewDto'];

              load = false;
              Navigator.pop(context);
              if (widget.callFrom) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviousBill(IPD ?? [])));
              } else {
                widget.callB!(IPD);
              }

              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => Registration({},'',1,IPD,0)));
            }),
          };
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      user = json.decode(encodedMap!);
      decode = user!;
      unitid = prefs.getString('UnitId');

      //FetchData(current,current);
    });
  }
}
