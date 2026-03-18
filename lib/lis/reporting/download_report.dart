import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dishabtob/Global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/io_client.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DownloadReport extends StatefulWidget {
  final String? savedFile;
  final int? Patid;
  final String? unitMasterId;
  final String? masterId;
  final String? unitcode;

  const DownloadReport(this.savedFile, this.Patid, this.unitMasterId,
      this.masterId, this.unitcode,
      {super.key});

  @override
  DownloadReportState createState() => DownloadReportState();
}

class DownloadReportState extends State<DownloadReport> {
  bool select = false;
  int _selectedValue = 1;

  bool load = false;
  final mediaStorePlugin = MediaStore();

  // int? _platformSDKVersion;

  @override
  void initState() {
    initPermission();
    initPlatformState();
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
                              'Download Reports',
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
                          // Display the title for option 1
                          // Display a subtitle for option 1
                          value: 1,
                          // Assign a value of 1 to this option
                          groupValue: _selectedValue,
                          // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            setState(() {
                              select = true;
                              _selectedValue = value!;
                              // Update _selectedValue when option 1 is selected
                            });
                          },
                        ),

                        // Create a RadioListTile for option 2
                        RadioListTile(
                          activeColor: Colors.white,
                          hoverColor: Colors.white,
                          title: const Text(
                            'With Header',
                            style: TextStyle(color: Colors.white),
                          ),
                          // Display the title for option 2
                          // Display a subtitle for option 2
                          value: 2,
                          // Assign a value of 2 to this option
                          groupValue: _selectedValue,
                          // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            setState(() {
                              select = true;
                              _selectedValue =
                                  value!; // Update _selectedValue when option 2 is selected
                            });
                          },
                        ),


                        Visibility(
                          visible: FlavorConfig.instance.name != "B2BLifenity",
                          child: RadioListTile(
                            activeColor: Colors.white,
                            hoverColor: Colors.white,
                            title: const Text(
                              'With B2B Header',
                              style: TextStyle(color: Colors.white),
                            ),
                            // Display the title for option 2
                            // Display a subtitle for option 2
                            value: 3,
                            // Assign a value of 2 to this option
                            groupValue: _selectedValue,
                            // Use _selectedValue to track the selected option
                            onChanged: (value) {
                              setState(() {
                                select = true;
                                _selectedValue =
                                    value!; // Update _selectedValue when option 2 is selected
                              });
                            },
                          ),
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
                              Navigator.pop(context);
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
                          onTap: load == false
                              ? () {
                                  if (FlavorConfig.instance.name !=
                                      "B2BLifenity") {
                                    if (_selectedValue == 1) {
                                      printReport(widget.masterId, widget.Patid,
                                          "withoutheader", '');
                                    } else if (_selectedValue == 2) {
                                      printReport(widget.masterId, widget.Patid,
                                          "withheader", '');
                                    } else if (_selectedValue == 3) {
                                      printReport(widget.masterId, widget.Patid,
                                          "b2bheader", '');
                                    }
                                  } else {
                                    if (_selectedValue == 1) {
                                      printReport(widget.masterId, widget.Patid,
                                          "withoutheader", 'N');
                                    } else if (_selectedValue == 2) {
                                      printReport(widget.masterId, widget.Patid,
                                          "withheader", 'Y');
                                    }
                                  }
                                }
                              : null,
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: AppColours.orange,
                                border: Border.all(color: Colors.white),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: load == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                        Text(
                                          'Download',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
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
                  // const SizedBox(
                  //   height: 300,
                  // ),
                ],
              ),
            )),
            offlineChild: Offline()));
  }

  initPermission() async {
    List<Permission> permissions = [
      Permission.storage,
    ];

    if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
      permissions.add(Permission.storage);
    }

    await permissions.request();

    MediaStore.appFolder = FlavorConfig.instance.name!;
  }

  Future<void> initPlatformState() async {
    int platformSDKVersion;

    try {
      platformSDKVersion = await mediaStorePlugin.getPlatformSDKInt();
    } on PlatformException {
      platformSDKVersion = -1;
    }

    if (!mounted) return;

    print((await mediaStorePlugin.getFilePathFromUri(
        uriString: 'content://media/external/images/media/1000000056')));
    print((await mediaStorePlugin.getFilePathFromUri(
        uriString:
            'content://media/external_primary/images/media/1000000057')));
  }

  Future<void> printReport(masterId, patientId, reportFlag, headerFlag) async {
    load = true;
    setState(() {});

    IOClient ioClient = IOClient(ByPassCert().httpClient);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? encodedMap = prefs.getString('user');
      if (encodedMap == null) {
        CustomMessage.toast('User not found');
        load = false;
        setState(() {});
        return;
      }
      var uri;
      final decode = json.decode(encodedMap);
      if (FlavorConfig.instance.name != "B2BLifenity") {
        uri = Uri.parse(
          '${url.baseurl}${url.REPORT_PDF}?masterId=$masterId&patientId=$patientId&envFlag=&unitId=${decode['unitMasterId']}&reportFlag=$reportFlag&headerFlag',
        );
      } else {
        uri = Uri.parse(
          '${url.baseurl}${url.REPORT_PDF}?masterId=$masterId&patientId=$patientId&envFlag=&unitId=${decode['unitMasterId']}&reportFlag=$reportFlag&headerFlag=$headerFlag&uId=${decode['userId']}&uName=${decode['userName']}&unitCode=${widget.unitcode}',
        );
      }

      final response = await ioClient.post(uri);
      if (response.statusCode != 200) {
        CustomMessage.toast('Failed to load report');
        load = false;
        setState(() {});
        return;
      }

      final resultList = jsonDecode(response.body)['result'];
      final finalDoc = PdfDocument();
      final docProcessor = PdfDocument();

      for (final item in resultList) {
        final pdfUrl = item['url'];
        if (pdfUrl == null || pdfUrl.toString().isEmpty) continue;

        final pdfResponse = await ioClient.get(Uri.parse(pdfUrl));
        if (pdfResponse.statusCode != 200) continue;

        final tempDir = await getTemporaryDirectory();
        final tempFilePath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(pdfResponse.bodyBytes);

        if (await tempFile.length() < 1000) {
          debugPrint("Skipping too small or empty PDF: ${tempFile.path}");
          continue;
        }

        final importedDoc =
            PdfDocument(inputBytes: await tempFile.readAsBytes());

        for (int i = 0; i < importedDoc.pages.count; i++) {
          final page = importedDoc.pages[i];
          final newPage = finalDoc.pages.add();

          final template = page.createTemplate();

          final destSize = Size(
              newPage.getClientSize().width, newPage.getClientSize().height);
          final srcSize = Size(template.size.width, template.size.height);

          final double scaleX = destSize.width / srcSize.width;
          final double scaleY = destSize.height / srcSize.height;
          final double scale = min(scaleX, scaleY);

          final double offsetX = (destSize.width - srcSize.width * scale) / 2;
          final double offsetY = (destSize.height - srcSize.height * scale) / 2;

          newPage.graphics.drawPdfTemplate(
            template,
            Offset(offsetX, offsetY),
            Size(srcSize.width * scale, srcSize.height * scale),
          );
        }

        importedDoc.dispose();
      }

      final dir = await getTemporaryDirectory();
      final outputPath = '${dir.path}/merged_report.pdf';
      final file = File(outputPath);
      await file.writeAsBytes(await finalDoc.save());
      finalDoc.dispose();

      load = false;
      setState(() {});

      if (!mounted) return;

      await OpenFile.open(file.path);
    } catch (e) {
      debugPrint('printReport error: $e');
      CustomMessage.toast('Unexpected error occurred');
      load = false;
      setState(() {});
    }
  }

  void openExternalStorageFolder(String s) async {
    // Specify the path to the external storage directory
    String externalStoragePath = s; // Adjust the path as needed
    // Open the folder in external storage using the open_file package
    OpenFile.open(externalStoragePath);
  }
}
