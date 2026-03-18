import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/dashboard/homescreen.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
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
  List<dynamic>? user;



  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      // user = json.decode(encodedMap!);  // Decode as Map, not List
      decode = json.decode(encodedMap!);  // Remove `.first`, as `user` is now a Map

      // FetchData(current,current);
    });
  }



  @override
  void initState() {
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
              height: MediaQuery.of(context).size.height * 0.95,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            callfrom = 'today';
                            today = AppColours.blue.withOpacity(0.6);
                            month = Colors.transparent;
                            customr = Colors.transparent;
                            yesterday = Colors.transparent;
                            last7 = Colors.transparent;
                            lstmonth = Colors.transparent;

                            //fromdate.text=DateTime.now().toString();
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime
                                    .now()); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate);
                            fromdate.text = formattedDate;
                            String formattedDate1 = DateFormat('yyyy-MM-dd')
                                .format(DateTime
                                    .now()); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate1);

                            todate.text = formattedDate1;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: today,
                                border: Border.all(color: Colors.white30),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: const Center(
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            callfrom = 'Last7days';
                            today = Colors.transparent;
                            month = Colors.transparent;
                            customr = Colors.transparent;
                            yesterday = Colors.transparent;
                            last7 = AppColours.blue.withOpacity(0.6);
                            lstmonth = Colors.transparent;

                            //fromdate.text=DateTime.now().toString();
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now().subtract(const Duration(
                                    days:
                                        7))); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate);
                            fromdate.text = formattedDate;
                            String formattedDate1 = DateFormat('yyyy-MM-dd')
                                .format(DateTime
                                    .now()); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate1);

                            todate.text = formattedDate1;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: last7,
                                border: Border.all(color: Colors.white30),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: const Center(
                              child: Text(
                                'Last 7 Days',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            callfrom = 'Last Month';
                            today = Colors.transparent;
                            month = Colors.transparent;
                            customr = Colors.transparent;
                            yesterday = Colors.transparent;
                            last7 = Colors.transparent;
                            lstmonth = AppColours.blue.withOpacity(0.6);

                            //fromdate.text=DateTime.now().toString();
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now().subtract(const Duration(
                                    days:
                                        30))); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate);
                            fromdate.text = formattedDate;
                            String formattedDate1 = DateFormat('yyyy-MM-dd')
                                .format(DateTime
                                    .now()); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate1);

                            todate.text = formattedDate1;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: lstmonth,
                                border: Border.all(color: Colors.white30),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: const Center(
                              child: Text(
                                'Last Month',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                      child: Text(
                    'Custom',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            callfrom = 'yesterday';
                            yesterday = AppColours.blue.withOpacity(0.6);
                            month = Colors.transparent;
                            customr = Colors.transparent;
                            today = Colors.transparent;
                            last7 = Colors.transparent;
                            lstmonth = Colors.transparent;

                            //fromdate.text=DateTime.now().toString();
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now().subtract(const Duration(
                                    days:
                                        1))); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate);
                            fromdate.text = formattedDate;
                            String formattedDate1 = DateFormat('yyyy-MM-dd')
                                .format(DateTime.now().subtract(const Duration(
                                    days:
                                        1))); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate1);

                            todate.text = formattedDate1;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: yesterday,
                                border: Border.all(color: Colors.white30),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: const Center(
                              child: Text(
                                'Yesterday',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            callfrom = 'month';
                            month = AppColours.blue.withOpacity(0.6);
                            yesterday = Colors.transparent;
                            customr = Colors.transparent;
                            today = Colors.transparent;
                            last7 = Colors.transparent;
                            lstmonth = Colors.transparent;
                            //fromdate.text=DateTime.now().toString();
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    1)); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate);
                            fromdate.text = formattedDate;
                            String formattedDate1 = DateFormat('yyyy-MM-dd')
                                .format(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month + 1,
                                    0)); // format date in required form here we use yyyy-MM-dd that means time is removed
                            debugPrint(formattedDate1);

                            todate.text = formattedDate1;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: month,
                                border: Border.all(color: Colors.white30),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: const Center(
                              child: Text(
                                'This Month',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            callfrom = 'custom';
                            customr = AppColours.blue.withOpacity(0.6);
                            yesterday = Colors.transparent;
                            month = Colors.transparent;
                            fromdate.text = 'Enter From Date';
                            todate.text = 'Enter To Date';
                            today = Colors.transparent;
                            last7 = Colors.transparent;
                            lstmonth = Colors.transparent;
                            debugPrint(fromdate.text);

                            //fromdate.text=DateTime.now().toString();
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                color: customr,
                                border: Border.all(color: Colors.white30),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: const Center(
                              child: Text(
                                'Custom Range',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                      ),
                    ],
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
                        focusNode: ffrom,
                        // autofocus: true,
                        textInputAction: TextInputAction.done,
                        controller: fromdate,
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
                            String formattedDate = DateFormat('yyyy-MM-dd').format(
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
                        controller: todate,
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
                            String formattedDate = DateFormat('yyyy-MM-dd').format(
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
                                fromdate.text = current!;
                                todate.text = current!;
                                callfrom = 'today';
                                customr = Colors.transparent;
                                yesterday = Colors.transparent;
                                month = Colors.transparent;
                                today = AppColours.blue.withOpacity(0.6);
                                last7 = Colors.transparent;
                                lstmonth = Colors.transparent;
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
                            (fromdate.text.isNotEmpty &&
                                        todate.text.isNotEmpty) &&
                                    (fromdate.text != 'Enter From Date' &&
                                        todate.text != 'Enter To Date')
                                ? Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                            callfrom,
                                            fromdate.text,
                                            todate.text,
                                            decode)),
                                  )
                                : CustomMessage.toast('Please Select Date');
                            // p.s.FetchData(fromdate.text, todate.text,decode,callfrom);
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
                  const SizedBox(
                    height: 300,
                  ),
                ],
              ),
            )),
            offlineChild: Offline()));
  }
}
