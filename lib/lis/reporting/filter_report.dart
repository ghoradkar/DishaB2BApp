import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterReport extends StatelessWidget {
  final Function callBy;
  final Function onReset;
  final Function onTapFromD;
  final Function onTapToD;
  final Function onChangedFirstName;
  final Function onChangedSearchBy;
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  final TextEditingController firstname;
  final String title;
  final List<String> item;
  const FilterReport({super.key, required this.callBy, required this.onReset, required this.onTapFromD, required this.onTapToD, required this.onChangedFirstName, required this.onChangedSearchBy, required this.fromDateController, required this.toDateController, required this.firstname, required this.title, required this.item});

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
                                // setState(() {
                                //   title = country;
                                //   FocusScope.of(context).nextFocus();
                                // });
                                onChangedSearchBy(country);
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

                            textInputAction: TextInputAction.done,
                            controller: firstname,
                            // controller: firstname,
                            onChanged: (value) {
                              onChangedFirstName(value);
                            },
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
                            textInputAction: TextInputAction.done,
                            controller: fromDateController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                      colorScheme:  ColorScheme.light(
                                        primary: AppColours.blue, // <-- SEE HERE
                                        onPrimary: Colors.white, // <-- SEE HERE
                                        onSurface:AppColours.blue, // <-- SEE HERE
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                          AppColours.blue, // button text color
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
                                String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                                debugPrint(formattedDate);

                                // fromDateController.text = formattedDate;

                                onTapFromD(formattedDate);

                                // String formattedDate = DateFormat('dd/MM/yyyy').format(
                                //     pickedDate);
                                // debugPrint(
                                //     formattedDate);
                                //
                                // setState(() {
                                //   fromdate.text = formattedDate;
                                // });
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
                            textInputAction: TextInputAction.done,
                            controller: toDateController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                      colorScheme:  ColorScheme.light(
                                        primary: AppColours.blue, // <-- SEE HERE
                                        onPrimary: Colors.white, // <-- SEE HERE
                                        onSurface: AppColours.blue, // <-- SEE HERE
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                          AppColours.blue, // button text color
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

                                String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                                debugPrint(formattedDate);

                                // toDateController.text =formattedDate;
                                onTapToD(formattedDate);
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
                                  onReset();
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
                                var text;
                                //   searchPatient(firstname.text);
                                if (title == "Patient Id") {
                                  text = "byId";
                                  callBy(text);
                                } else {
                                  text = "byName";
                                  callBy(text);
                                }

                                // firstname.text.trim().isEmpty
                                //     ? searchReportByDate(
                                //         fromdate.text, todate.text, firstname.text)
                                //     : searchReportByIdAndName(firstname.text, text);
                              },
                              child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: AppColours.orange.withOpacity(0.7),
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
}





