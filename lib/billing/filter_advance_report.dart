import 'dart:convert';
import 'package:dishabtob/billing/advance_utilization_report.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/custom_message.dart';
import 'package:dishabtob/global/url.dart' as url;
import '../network/network_aware.dart';
import '../network/network_status.dart';
import '../network/offline.dart';


class FilterAdvance extends StatefulWidget {
  const FilterAdvance({super.key});

  @override
  FilterAdvanceState createState() => FilterAdvanceState();
}

class FilterAdvanceState extends State<FilterAdvance> {
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
  FocusNode fto = FocusNode();
  Color yesterday=Colors.transparent;
  Color month=Colors.transparent;
  Color customr=Colors.transparent;
  Color today=AppColours.blue.withOpacity(0.6);
  Color last7=Colors.transparent;
  Color lstmonth=Colors.transparent;

  String? callfrom='today';
  Map<String,dynamic>?decode;
  Map<String,dynamic>?data;
  Map<String,dynamic>? graph;
  String? current;
  // String? title = 'Patient Id';
  String? gen = 'Patient Id';
  bool visible = false;
  String? title = 'Pending';
  List<String> item = ["Pending"];
  FocusNode fpatid =  FocusNode();
  TextEditingController patientid =  TextEditingController();

  Map<String,dynamic>? user;
  FocusNode ffirst =  FocusNode();
  TextEditingController firstname =  TextEditingController();
//  HomePage p=model HomePage();
  bool load=false;
  //TextEditingController editingController = TextEditingController();
  List<dynamic>? IPD;


  @override
  void initState() {
    current=   DateFormat('yyyy-MM-dd').format(
        DateTime.now());
    fromdate.text=current!;
    todate.text=current!;
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
            onlineChild: SingleChildScrollView(child: Container(


              decoration: const BoxDecoration(
                //color: Colors.black.withAlpha(1),
                  borderRadius: BorderRadius.only(
                      topRight:Radius.circular(30),
                      topLeft:Radius.circular(30))),
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children:  <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:[const SizedBox(width: 30,),
                        const Padding(padding:EdgeInsets.all(20) ,child:
                        Center(child:Text('Filter By',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),))),
                        //SizedBox(width: 20,),
                        IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.clear,color: Colors.white,))



                      ]),



                  Center(
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.85,
                      height: MediaQuery.of(context).size.height*0.07,
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
                                  colorScheme: ColorScheme.light(
                                    primary:
                                    AppColours.blue, // <-- SEE HERE
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface:
                                    AppColours.blue, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColours.blue, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                1900), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime.now().add(const Duration(days: 0)),
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
                            padding:
                            const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: (){},
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
                  const SizedBox(height: 20,),
                  Center(
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.85,
                      height: MediaQuery.of(context).size.height*0.07,
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
                                  colorScheme: ColorScheme.light(
                                    primary:
                                    AppColours.blue, // <-- SEE HERE
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface:
                                    AppColours.blue, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:AppColours.blue, // button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                1900), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime.now().add(const Duration(days: 0)),
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
                            padding:
                            const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: (){},
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
                  // SizedBox(height: 20,),
                  // Center(
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.grey,
                  //           ),
                  //           color: Colors.white10,
                  //           borderRadius: BorderRadius.all(
                  //               Radius.circular(10))),
                  //       width:
                  //       MediaQuery.of(context).size.width * 0.85,
                  //       height:
                  //       MediaQuery.of(context).size.height * 0.07,
                  //       child: DropdownButton(
                  //
                  //         underline: Container(
                  //           color: Colors.white10,
                  //         ),
                  //         //disabledHint: Text('search bu'),
                  //         hint: RichText(
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: 'Prefix',
                  //                 style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 14),
                  //               ),
                  //               TextSpan(
                  //                 text: '*',
                  //                 style: TextStyle(color: Colors.red),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         autofocus: true,
                  //         padding: EdgeInsets.all(5),
                  //         isExpanded: true,
                  //         dropdownColor: Colors.grey.shade500,
                  //         iconEnabledColor: Colors.white,
                  //         value: title,
                  //         items: item.map((country) {
                  //           return DropdownMenuItem(
                  //             child: Text(
                  //               country,
                  //               style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 15),
                  //             ),
                  //             value: country,
                  //           );
                  //         }).toList(),
                  //         onChanged: (country) {
                  //
                  //           setState(() {
                  //             title = country;
                  //             FocusScope.of(context)
                  //                 .nextFocus();
                  //           });
                  //
                  //         },
                  //       ),
                  //     )),

                  const SizedBox(height: 20,),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: (){
                              setState(() {
                                Navigator.pop(context);




                              });

                            },
                            child:
                            Container(height: 30,width: MediaQuery.of(context).size.width*0.4,
                              decoration: BoxDecoration(color: Colors.white10,
                                  border: Border.all(color: Colors.white30),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:[Text('Reset',style: TextStyle(color: Colors.white,fontSize: 12),),
                                    Icon(Icons.arrow_forward,color: Colors.white,size: 20,)

                                  ]),)),
                        GestureDetector(
                          onTap: (){
                            fetchInvoiceList(decode,fromdate.text, todate.text);
                            //   searchPatient(firstname.text);


                          },
                          child:Container(height: 30,width: MediaQuery.of(context).size.width*0.4,
                            decoration: BoxDecoration(color: AppColours.orange,
                                border: Border.all(color: Colors.white30),
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:[Text('Results',style: TextStyle(color: Colors.white,fontSize: 12),),
                                  Icon(Icons.arrow_forward,color: Colors.white,size: 20,)

                                ]),),





                        )]),
                 // SizedBox(height: 300,),



                ],

              ),)), offlineChild: Offline()));





  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      user = json.decode(encodedMap!);
      decode=user!;

      //FetchData(current,current);
    });
  }

  fetchInvoiceList(decode,fromdate,todate) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.ADVANCE_UTILIZATION}?callFrom=btnSearch&fromDate=$fromdate&toDate=$todate');
    debugPrint(uri.path);
    final body={
      "customerType": decode!['customerType'],
      "customerId": decode!['customerId'],
      "unitId": decode!['unitMasterId']
    };
    var jsonbody=json.encode(body);
    debugPrint(jsonbody);
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATE_RECEIPT}/18402/0');
    // debugPrint(uri);

    final response = await ioClient.post(
        uri,
        headers: headers,
        body:jsonbody


      //encoding: encoding,
    );
    debugPrint(response.body);
    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(value);
    response.statusCode == 200
        ? {
      setState(() {
        data= value;
        load = false;
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AdvanceUtilization(data,fromD: fromdate,toD: todate)));
      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }
}