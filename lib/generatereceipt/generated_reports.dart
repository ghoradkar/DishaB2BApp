import 'dart:convert';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/generatereceipt/model/listgeneratedreports.dart';
import 'package:dishabtob/generatereceipt/model/newgeneratedrecieptresponse.dart';
import 'package:dishabtob/generatereceipt/model/save_generate_receipt_req_model.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';


class GeneratedReports extends StatefulWidget {
  final Map<String, dynamic>? patient;
  final List<GeneratedReportModel> generateReportsList;
  final bool fromPage;
  final NewGeneratedReceiptResponse? generateReceiptModel;

  const GeneratedReports(this.patient, this.generateReportsList, this.fromPage,
      this.generateReceiptModel,
      {super.key});

  @override
  GeneratedReportsState createState() => GeneratedReportsState();
}

class GeneratedReportsState extends State<GeneratedReports> {
  List? IPD;
  bool load = false;

  bool _selectAll = false;

  @override
  void initState() {
    // debugPrint(widget.generateReportsList[0]);
    setState(() {
      load = true;
    });
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
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: (widget.generateReportsList.isNotEmpty)
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                  activeColor: AppColours.orange,
                                      value: _selectAll,
                                      onChanged: (value) {
                                        toggleSelectAll(value);
                                      }),
                                  const Text("Select All"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                // itemCount: widget.generateReportsList?.length,
                                itemCount: widget.generateReportsList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.32,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.93,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  237, 245, 250, 0.9),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    const Icon(
                                                      Icons.edit,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Sample Type',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          widget
                                                                  .generateReportsList[
                                                                      index]
                                                                  .sampleTypeName ??
                                                              "-",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 25,
                                                    ),
                                                    const Spacer(),
                                                    Checkbox(
                                                        activeColor: AppColours.orange,

                                                        value: widget
                                                                .generateReportsList[
                                                                    index]
                                                                .checkBox,
                                                        onChanged: (value) {
                                                          toggleTodoCheck(
                                                              index, value);
                                                        })
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    const Icon(
                                                      Icons.settings,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Sub Service Name',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          widget
                                                                  .generateReportsList[
                                                                      index]
                                                                  .categoryName ??
                                                              "-",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 25,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    const Icon(
                                                      Icons.document_scanner,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Barcode',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            widget
                                                                .generateReportsList[
                                                                    index]
                                                                .barCode
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                    ),
                                                    const Icon(
                                                      Icons.money,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Actual Rate',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          widget
                                                              .generateReportsList[
                                                                  index]
                                                              .actualRate
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                        child: TextFormField(
                                                          initialValue: widget
                                                              .generateReportsList[
                                                                  index]
                                                              .rate
                                                              .toString(),
                                                          readOnly:
                                                              widget.fromPage,
                                                          onChanged: (value) {
                                                            var rate = value
                                                                    .trim()
                                                                    .isNotEmpty
                                                                ? double.parse(
                                                                    value)
                                                                : 0.0;
                                                            widget
                                                                .generateReportsList[
                                                                    index]
                                                                .rate = rate;
                                                            widget
                                                                    .generateReportsList[
                                                                        index]
                                                                    .amount =
                                                                rate -
                                                                    (widget.generateReportsList[index]
                                                                            .discount ??
                                                                        0.0);
                                                            setState(() {});
                                                          },
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .nextFocus();
                                                          // },
                                                          //  Unitname(username.text);},
                                                          // onFieldSubmitted:
                                                          //     (value) {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .nextFocus();
                                                          // },
                                                          // Unitname(username.text);},

                                                          // focusNode: frate,
                                                          //autofocus: true,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          cursorColor:
                                                              Colors.black,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.money,
                                                              color: Colors
                                                                  .black54,
                                                            ),

                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            disabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                            //hintText: 'Enter Username',
                                                            hintStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),
                                                            label: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Rate',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87
                                                                            .withOpacity(
                                                                                0.7),
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // labelText: 'Password',
                                                            // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                            floatingLabelStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                        child: TextFormField(
                                                          onChanged: (value) {
                                                            var discount = value
                                                                    .trim()
                                                                    .isNotEmpty
                                                                ? double.parse(
                                                                    value)
                                                                : 0.0;
                                                            widget
                                                                    .generateReportsList[
                                                                        index]
                                                                    .discount =
                                                                discount;
                                                            widget
                                                                .generateReportsList[
                                                                    index]
                                                                .amount = (widget
                                                                        .generateReportsList[
                                                                            index]
                                                                        .rate ??
                                                                    0.0) -
                                                                discount;
                                                            setState(() {});
                                                          },
                                                          readOnly:
                                                              widget.fromPage,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          // onEditingComplete:
                                                          //     () {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .nextFocus();
                                                          // },
                                                          //  Unitname(username.text);},
                                                          // onFieldSubmitted:
                                                          //     (value) {
                                                          //   FocusScope.of(
                                                          //           context)
                                                          //       .nextFocus();
                                                          // },
                                                          // Unitname(username.text);},

                                                          // focusNode: fdiscount,
                                                          //autofocus: true,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          cursorColor:
                                                              Colors.black,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,

                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            disabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            //floatingLabelBehavior: FloatingLabelBehavior.never,

                                                            prefixIcon: Image.asset(
                                                                'assets/discount.png'),
                                                            //hintText: 'Enter Username',
                                                            hintStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),

                                                            label: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Discount',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87
                                                                            .withOpacity(
                                                                                0.7),
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // labelText: 'Password',
                                                            // labelStyle: TextStyle(color: Colors.grey,fontSize:14),
                                                            floatingLabelStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                    const Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Qty',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            widget
                                                                .generateReportsList[
                                                                    index]
                                                                .quantity
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                    ),
                                                    const Icon(
                                                      Icons.money,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Amount',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          widget
                                                              .generateReportsList[
                                                                  index]
                                                              .amount
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            left: 10,
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: const BoxDecoration(
                                                  color: Colors.indigo,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Center(
                                                  child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                        ]),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: widget.fromPage == false,
                              child: InkWell(
                                  onTap: () async {
                                    if (_selectAll ||
                                        isAnySingleCheckboxSelected()) {
                                      List<ListEhatB2bBillReceiptMaster>
                                      listEhatB2bBillReceiptMaster = [];
                                      List<ListEhatBb2bBillReceiptSlave>
                                      listEhatBb2bBillReceiptSlave = [];
                                      SaveGenerateReceiptModel save =
                                      SaveGenerateReceiptModel(
                                          listEhatB2bBillReceiptMaster:
                                          listEhatB2bBillReceiptMaster,
                                          listEhatBb2bBillReceiptSlave:
                                          listEhatBb2bBillReceiptSlave);

                                      var ls = widget.generateReportsList
                                          .where((e) => e.checkBox == true)
                                          .toList();

                                      listEhatB2bBillReceiptMaster
                                          .add(ListEhatB2bBillReceiptMaster(
                                        id: widget.patient?["b2bBillRecId"]
                                            .toString(),
                                        patientName: widget
                                            .generateReceiptModel!.patientName
                                            .toString(),
                                        patientId: widget
                                            .generateReceiptModel!.patientId
                                            .toString(),
                                        gender:
                                        widget.generateReceiptModel!.gender,
                                        age: widget.generateReceiptModel!.age
                                            .toString(),
                                        contact: widget
                                            .generateReceiptModel!.contact
                                            .toString(),
                                        billCategory: "self",
                                      ));
                                      for (int i = 0; i < ls.length; i++) {
                                        listEhatBb2bBillReceiptSlave
                                            .add(ListEhatBb2bBillReceiptSlave(
                                          billDetailsId:
                                          ls[i].billDetailsId.toString(),
                                          sampleTypeId:
                                          ls[i].sampleTypeId.toString(),
                                          sampleTypeName: ls[i].sampleTypeName,
                                          subServiceName: ls[i].categoryName,
                                          barcode: ls[i].barCode.toString(),
                                          actualRate: ls[i].actualRate.toString(),
                                          rate: ls[i].rate.toString(),
                                          quantity: ls[i].quantity.toString(),
                                          amount: ls[i].amount.toString(),
                                          discount: ls[i].discount.toString(),
                                        ));
                                      }

                                      String saveDet = jsonEncode(save);
                                      debugPrint(saveDet);
                                      await saveAndGenerateReport(saveDet);
                                      // saveGeneratedReceipt("","");
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: AppColours.blue,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Save & Generate Receipt",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                            Visibility(
                              visible: widget.fromPage == false,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible: widget.fromPage == false,
                              child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        // color: const Color(0xffEC6A38),
                                        border: Border.all(
                                            color: const Color(0xffC9C9C9)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Color(0xffC9C9C9)),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Color(0xffC9C9C9),
                                        )
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        )
                      : const DataNotFound(),
                )),
            offlineChild: Offline()));
  }


  saveGeneratedReceipt(masterList, slaveList) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // final uri = Uri.parse(
    //     '${url.baseurl}${url.GENERATERECEIPT}?fromDate=2024-05-20&toDate=2024-05-22&unitId=$userUnitId&customerId=${decode!['customerId']}');

    final uri = Uri.parse(
        '${url.baseurl}${url.SAVEGENERATEDRECEIPT}?masterList=$masterList&slaveList=$slaveList');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    if (response.statusCode == 200) {
      var value = jsonDecode(response.body);
      // generateReceiptModel = GenerateReceiptModel.fromJson(value);
      debugPrint(value);
      setState(() {
        load = false;
      });
    } else {
      CustomMessage.toast('Failed');
      setState(() {
        load = false;
      });
    }
  }

  void toggleSelectAll(bool? value) {
    _selectAll = value ?? false;
    for (int i = 0; i < widget.generateReportsList.length; i++) {
      widget.generateReportsList[i].checkBox = _selectAll;
    }
    setState(() {});
  }

  void toggleTodoCheck(int index, bool? value) {
    widget.generateReportsList[index].checkBox = value ?? false;
    _selectAll = widget.generateReportsList
        .every((element) => element.checkBox);
    setState(() {});
  }

  saveAndGenerateReport(jsonB) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await ioClient.post(
        Uri.parse('${url.baseurl}${url.SAVEGENERATEDRECEIPT}'),
        body: jsonB,
        headers: headers);

    if (response.statusCode == 200) {
      if (response.body == "Success") {
        CustomMessage.toast(response.body);
        Navigator.pop(context);
        setState(() {
          load = false;
        });
      }
    } else {
      CustomMessage.toast('Failed');
      setState(() {
        load = false;
      });
    }
  }

  bool isAnySingleCheckboxSelected() {
    // Check if exactly one item has the `checkBox` value as `true`.
    int selectedCount =
        widget.generateReportsList.where((e) => e.checkBox == true).length;
    return selectedCount == 1;
  }
}
