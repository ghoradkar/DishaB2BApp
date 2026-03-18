import 'dart:convert';
import 'package:dishabtob/Global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/runner_boy/runnerboy.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishabtob/global/url.dart' as url;



class FilterCollection extends StatefulWidget {
  final int? index;
  const FilterCollection(this.index, {super.key});
  @override
  FilterCollectionState createState() => FilterCollectionState();
}

class FilterCollectionState extends State<FilterCollection> {
  TextEditingController fromdate = TextEditingController();
  FocusNode ffrom = FocusNode();
  TextEditingController todate = TextEditingController();
  FocusNode fto = FocusNode();

  List<bool>?selected;
  String? type_name;
  String? cust_name;
  List<dynamic>?type;
  List<dynamic>?name;
  List<dynamic>?submit;
  Map<String,dynamic>?decode;
  String? current;
  String? title = 'Patient Id';
  List<String> item = ["Patient Id"];
  Map<String,dynamic>? user;
  FocusNode ffirst = FocusNode();
  TextEditingController firstname = TextEditingController();
//  HomePage p=model HomePage();
  bool load=false;
  bool naame=false;
  //TextEditingController editingController = TextEditingController();
  List<dynamic>? IPD;

  @override
  void initState() {
    setState(() {
      load=true;
      naame=true;
    });
    current=   DateFormat('dd/MM/yyyy').format(
        DateTime.now());
    fromdate.text=current!;
    todate.text=current!;
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
            onlineChild: SingleChildScrollView(child: Container(


              decoration: const BoxDecoration(
                //color: Colors.black.withAlpha(1),
                  borderRadius: BorderRadius.only(
                      topRight:Radius.circular(30),
                      topLeft:Radius.circular(30))),
              height: MediaQuery.of(context).size.height,
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
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            // height: MediaQuery.of(context).size.height*0.07,
                            color: Colors.white10,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10))),
                        width:
                        MediaQuery.of(context).size.width * 0.85,
                        height:
                        MediaQuery.of(context).size.height * 0.07,
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
                                      color: Colors.black87
                                          .withOpacity(0.7),
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
                                    color: Colors.white,
                                    fontSize: 15),
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

                  const SizedBox(height: 10,),
                  Center(
                    child: SizedBox(
                      width:
                      MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height *
                          0.07,
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
                          if (value == null ||
                              value.trim().isEmpty) {
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
                            borderRadius:
                            BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(8.0),
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
                                      color: Colors.white,
                                      fontSize: 14),
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
                  const SizedBox(height: 10,),
                  naame?const Center(child: CircularProgressIndicator(color: Colors.white,)):Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: Colors.white10,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10))),
                        width:
                        MediaQuery.of(context).size.width * 0.84,
                        height:
                        MediaQuery.of(context).size.height * 0.075,
                        child: DropdownButton(
                          underline: Container(
                            color: Colors.white10,
                          ),
                          hint: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14),
                                ),

                              ],
                            ),
                          ),
                          autofocus: true,
                          padding: const EdgeInsets.all(5),
                          isExpanded: true,
                          dropdownColor: Colors.grey.shade500,
                          iconEnabledColor: Colors.white,
                          value: cust_name,
                          items: name!.map((country) {
                            return DropdownMenuItem(
                              value: country['name'],
                              child: Text(
                                country['name'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            );
                          }).toList(),
                          onChanged: (country) {

                            setState(() {
                              cust_name = country as String?;
                              FocusScope.of(context)
                                  .nextFocus();

                            });
                          },
                        ),
                      )),
                  const SizedBox(height: 10,),
                  load?const Center(child:CircularProgressIndicator(color: Colors.white,)):Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: Colors.white10,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10))),
                        width:
                        MediaQuery.of(context).size.width * 0.84,
                        height:
                        MediaQuery.of(context).size.height * 0.075,
                        child: DropdownButton(

                          underline: Container(
                            color: Colors.white10,
                          ),
                          //disabledHint: Text('search bu'),
                          hint: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Type',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14),
                                ),

                              ],
                            ),
                          ),
                          autofocus: true,
                          padding: const EdgeInsets.all(5),
                          isExpanded: true,
                          dropdownColor: Colors.grey.shade500,
                          iconEnabledColor: Colors.white,
                          value: type_name,
                          items: type!.map((country) {
                            return DropdownMenuItem(
                              value: country['lookupDetValue'],
                              child: Text(
                                country['lookupDetValue'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            );
                          }).toList(),
                          onChanged: (country) {

                            setState(() {
                              type_name = country as String;
                              FocusScope.of(context)
                                  .nextFocus();
                            });

                          },
                        ),
                      )),
                  // Padding(padding:EdgeInsets.all(20) ,child:
                 // Center(child:Text('Select Date Range',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),))),
                  const SizedBox(height: 10,),
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
                                  colorScheme: const ColorScheme.light(
                                    primary:
                                    Colors.indigo, // <-- SEE HERE
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface:
                                    Colors.indigo, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors
                                          .indigo, // button text color
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
                            String formattedDate = DateFormat('dd/MM/yyyy').format(
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
                  const SizedBox(height: 10,),
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
                                  colorScheme: const ColorScheme.light(
                                    primary:
                                    Colors.indigo, // <-- SEE HERE
                                    onPrimary: Colors.white, // <-- SEE HERE
                                    onSurface:
                                    Colors.indigo, // <-- SEE HERE
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors
                                          .indigo, // button text color
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
                            String formattedDate = DateFormat('dd/MM/yyyy').format(
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

                  const SizedBox(height: 20,),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: (){
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
                            fetchB2BItem(fromdate.text,todate.text);
                            //searchPatient(firstname.text);
                            // ( fromdate.text.isNotEmpty&&todate.text.isNotEmpty)&&(fromdate.text!='Enter From Date'&&todate.text!='Enter To Date')?
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //       builder: (context) => HomePage(callfrom,fromdate.text,todate.text,decode)),
                            // ):
                            // CustomMessage.toast('Please Select Date');
                            // // p.s.FetchData(fromdate.text, todate.text,decode,callfrom);

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
                  const SizedBox(height: 200,),



                ],

              ),)), offlineChild: Offline()));





  }

  fetchB2BItem(fromdate,todate) async {
    // debugPrint('11$decode');
    //getuser();
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri;
    final response;
    Map<String, dynamic>? value;

    var test=widget.index==0?101:102;
    uri = Uri.parse(
        '${url.baseurl}${url.SEARCH_B2BRECORDS}?custTypeId=0&custNameId=0&fromDate=$fromdate&toDate=$todate&searchBy=byDate&startIndex=0&emergencyFlag=All&testStatus=$test&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}&userType=${decode!['usertype']}');
    debugPrint(uri);
    response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    value = jsonDecode(response.body);
    debugPrint(response.body);

    response.statusCode == 200
        ? {
      setState(() {
        IPD = value!['labSampleWiseMasterDtoList'];
        selected=List.generate(IPD!.length, (index) =>false);
        submit=List.generate(IPD!.length, (index) =>[]);
        load = false;

        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RunnerBoy(widget.index!,IPD,selected,submit)));


      }),

    }
        : {CustomMessage.toast('Failed to load')};



  }

  fetchType() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.CUST_TYPE}?userType=${decode!['userType']}&unitId=${decode!['unitMasterId']}&type=0');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(response.body);
    Map<String,dynamic> g=jsonDecode(response.body);

    response.statusCode==200?

    {
      setState(() {
        type=g['tmCmLookupDetLookupList'];
        load=false;

      }),

      //  CustomMessage.toast(unit.first['unitName']),


      // setuser(value['result']),
      //
      //Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(
      //        builder: (context) => Test_List()),
      //  ),

    }:
    CustomMessage.toast('Invalid ');


  }

  fetchName() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final uri = Uri.parse('${url.baseurl}${url.CUST_NAME}?lookupDetValue=B2B&lookupDetId=4&paymentflag=undefined&unitId=${decode!['unitMasterId']}');
    debugPrint(uri.path);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );
    debugPrint(response.body);
    Map<String,dynamic> g=jsonDecode(response.body);

    response.statusCode==200?

    {
      setState(() {
        name=g['businessMasterDto'];
        naame=false;

      }),

      //  CustomMessage.toast(unit.first['unitName']),


      // setuser(value['result']),
      //
      //Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(
      //        builder: (context) => Test_List()),
      //  ),

    }:
    CustomMessage.toast('Invalid ');


  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      user = json.decode(encodedMap!);
      decode=user!;

      fetchName();
      fetchType();
      //FetchData(current,current);
    });
  }
}