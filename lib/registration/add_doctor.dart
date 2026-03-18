import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddDoctor extends StatefulWidget {
  final Function? callB;

  const AddDoctor({super.key, this.callB});

  @override
  AddDoctorState createState() => AddDoctorState();
}

class AddDoctorState extends State<AddDoctor> {
  TextEditingController prefix = TextEditingController();
  TextEditingController doctorName = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController mobile = TextEditingController();

  bool load = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var user;

  var decode;


  @override
  void initState() {
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
            onlineChild: Container(
              decoration: const BoxDecoration(
                  //color: Colors.black.withAlpha(1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.56,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
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
                                'Add Refer Doctor',
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextFormField(
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          controller: prefix,
                          readOnly: true,
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
                            // hintText: 'Dr.',
                            hintStyle: const TextStyle(fontSize: 14),
                            label: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Prefix',
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
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextFormField(
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          controller: specialization,
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
                            prefixIcon: Image.asset("assets/stethoscope.png"),

                            hintText: 'Enter',
                            hintStyle: const TextStyle(fontSize: 14),
                            label: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Specialization',
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
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10), // Limits input to 2 digits
                            FilteringTextInputFormatter.digitsOnly, // Allows only digits
                          ],
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          controller: mobile,
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
                            prefixIcon: Image.asset("assets/stethoscope.png"),
                            hintText: 'Enter',
                            hintStyle: const TextStyle(fontSize: 14),
                            label: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Mobile No',
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
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextFormField(
                          validator: (value) {
                            if (value != null) {
                              if (value.isNotEmpty) {
                                return null;
                              } else {
                                return "Enter Doctor Name";
                              }
                            } else {
                              return "Enter Doctor Name";
                            }
                          },
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          controller: doctorName,
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
                            prefixIcon: Image.asset("assets/device-mobile.png"),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            //floatingLabelBehavior: FloatingLabelBehavior.never,

                            hintText: 'Enter',
                            hintStyle: const TextStyle(fontSize: 14),
                            label: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Doctor Name',
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
                                doctorName.text = "";
                                specialization.text = "";
                                mobile.text = "";

                                setState(() {});
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
                              if (formKey.currentState?.validate() ?? false) {
                                debugPrint("form is vaid");

                                addDoctor(prefix.text, doctorName.text,
                                    specialization.text, mobile.text);
                              } else {
                                debugPrint("form is invaid");
                              }
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
                                      'Save',
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
              ),
            ),
            offlineChild: Offline()));
  }

  getuser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefix.text = "Dr.";
    encodedMap = prefs.getString('user');
    setState(() {
      user = json.decode(encodedMap!);
      decode = user!;

      //FetchData(current,current);
    });
  }


  addDoctor(
      String? firstname,
      String doctorName,
      String? specialization,
      String? mobile,
      ) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final uri = Uri.parse(
        '${url.baseurl}${url.AddDoctor}?doctorId=0&prefix=$firstname&dName=$doctorName&speacialization=$specialization&mob=$mobile&unitId=${decode!['unitMasterId']}');
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
    // var g = jsonDecode(response.body);

    if (response.body == '1') {
      CustomMessage.toast('Doctor Added');
      load = false;
      Navigator.pop(context);
      setState(() {});
      widget.callB!();
    } else {
      CustomMessage.toast("Doctor Adding Failed");
      load = false;
      setState(() {});
    }
  }
}
