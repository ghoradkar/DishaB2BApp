import 'dart:async';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dishabtob/global/url.dart' as url;


class DownloadBill extends StatefulWidget {

var b2bBillRecId;
  DownloadBill(this.b2bBillRecId, {super.key});

  @override
  DownloadBillState createState() => DownloadBillState();
}

class DownloadBillState extends State<DownloadBill> {
  bool select = false;
  int _selectedValue = 1;

  bool load = false;

  @override
  void initState() {
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
                  height: MediaQuery.of(context).size.height * 0.4,
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
                                      'debugPrint Report',
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            // Create a RadioListTile for option 1
                            RadioListTile(
                              activeColor: Colors.white,
                              hoverColor: Colors.white,
                              title: const Text(
                                'Without Header',
                                style: TextStyle(color: Colors.white),
                              ),

                              value: 1,

                              groupValue: _selectedValue,

                              onChanged: (value) {
                                setState(() {
                                  select = true;
                                  _selectedValue = value!;

                                });
                              },
                            ),

                            RadioListTile(
                              activeColor: Colors.white,
                              hoverColor: Colors.white,
                              title: const Text(
                                'With Header',
                                style: TextStyle(color: Colors.white),
                              ),

                              value: 2,

                              groupValue: _selectedValue,

                              onChanged: (value) {
                                setState(() {
                                  select = true;
                                  _selectedValue =
                                  value!;
                                });
                              },
                            ),

                            // Create a RadioListTile for option 3
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                                onTap: () {

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
                                          'Cancel',
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
                                if (_selectedValue == 1) {
                                  printReport(widget.b2bBillRecId,"N");


                                } else {
                                  printReport(widget.b2bBillRecId,"Y");

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
                                        'Print',
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

                    ],
                  ),
                )),
            offlineChild: Offline()));
  }

  printReport(receipt_id,header) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final uri = Uri.parse(
        '${url.baseurl}${url.DOWNLOADBILL}?receipt_id=$receipt_id&header=$header');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,
      //encoding: encoding,
    );

    // Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(value);
    response.statusCode == 200
        ? {
      setState(() {
        // List t = value['result'];
        // Map<String, dynamic> report = t.first;

        var uri = Uri.parse('${url.baseurl}${url.DOWNLOADBILL}?receipt_id=$receipt_id&header=$header');
        _launchUrl(
            uri);
        load = false;
      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
