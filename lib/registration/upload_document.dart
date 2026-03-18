import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dishabtob/global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishabtob/global/url.dart' as url;

class UploadDocument extends StatefulWidget {
  // final List<dynamic>? patient;
  final Map<String, dynamic>? patient;

  const UploadDocument(this.patient, {super.key});

  @override
  UploadDocumentState createState() => UploadDocumentState();
}

class UploadDocumentState extends State<UploadDocument> {
  FocusNode fcomment = FocusNode();
  TextEditingController comment = TextEditingController();
  List<PlatformFile> files = [];

  bool load = false;
  bool fileselected = false;
  Map<String, dynamic>? decode;

  @override
  void initState() {
    debugPrint('doc');
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
            onlineChild: SingleChildScrollView(
                child: Container(
              decoration: const BoxDecoration(
                  //color: Colors.black.withAlpha(1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              height: MediaQuery.of(context).size.height,
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
                              'Upload Documents',
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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Select a file to Upload | File Size : Max 5 mb',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          addDocument();
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Browse',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                                Icon(
                                  Icons.folder_copy,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ]),
                        )),
                  ),
                  fileselected
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 30),
                          child: ListView.builder(
                              itemCount: files.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                // Map<String, dynamic> g = files[index];
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.file_present_rounded,
                                        color: Colors.white,
                                      ),
                                      Flexible(
                                          child: Text(
                                        '${files[index].name} | ${getFileSizeString(bytes: files[index].size)}',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )),
                                      IconButton(
                                          onPressed: () {
                                            files.removeAt(index);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                          ))
                                    ]);
                              }),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        //  Unitname(username.text);},
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).nextFocus();
                        },
                        // Unitname(username.text);},

                        focusNode: fcomment,
                        //autofocus: true,
                        maxLines: 8,
                        textInputAction: TextInputAction.done,
                        controller: comment,
                        //focusNode: fpassword,
                        //obscureText: _obscured,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Comments can not be empty";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                          ),
                          //floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              //   onTap: _toggleObscured,
                              child: const Icon(
                                Icons.edit,
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
                                  text: 'Comment',
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
                    height: 50,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              height: 40,
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
                            fileselected
                                ? fileUpload(comment.text)
                                : CustomMessage.toast('Please Select Files');
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.43,
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
                                    'Upload Document',
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
                    height: 100,
                  ),
                ],
              ),
            )),
            offlineChild: Offline()));
  }

  getUser() async {
    debugPrint('dashboard');
    String? encodedMap;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    encodedMap = prefs.getString('user');
    setState(() {
      decode = json.decode(encodedMap!);
    });
  }

  Future<void> fileUpload(String comment) async {
    // Create an IOClient from the singleton's HttpClient
    IOClient ioClient = IOClient(ByPassCert().httpClient);

    // Format the current date
    var date = DateTime.now().toString().substring(0, 10);
    debugPrint(date);

    // Prepare the request URL
    var uri = Uri.parse(
        '${url.baseurl}${url.UPLOAD_DOCUMENT}?userId=${decode!['userId']}&tID=0&note=$comment&svDate=$date&PatID=${FlavorConfig.instance.name == "B2BLifenity" ? widget.patient!['ptId'] : widget.patient!['ptId']}&inventoryID=');

    // Create the multipart request
    var request = http.MultipartRequest('POST', uri);

    // Add files to the request
    for (var i = 0; i < files.length; i++) {
      request.files
          .add(await http.MultipartFile.fromPath('file', files[i].path!));
    }

    try {
      // Send the request
      var response = await ioClient.send(request);

      // Get the response as a regular HTTP response
      var result = await http.Response.fromStream(response);

      // Handle the response
      if (response.statusCode == 200) {
        debugPrint("Uploaded!");
        debugPrint('Response body: ${result.body}');
        CustomMessage.toast(result.body);

        // Reset the UI state
        setState(() {
          fileselected = false;
          files.clear();
        });
        Navigator.pop(context);
      } else {
        debugPrint("Error: ${response.reasonPhrase}");
        CustomMessage.toast(result.body);
      }
    } catch (e) {
      // Handle any errors
      debugPrint("Error occurred during upload: $e");
      CustomMessage.toast('Upload failed');
    }
  }

  addDocument() async {
    double _sizeKbs = 0;
    const int maxSizeKbs = 1024 * 1024 * 5;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
      allowCompression: true,
    );

    // final ImagePicker _picker = ImagePicker();
    // XFile? image=await _picker.pickImage(source: ImageSource.camera,imageQuality: 20);

    setState(() {
      if (result != null) {
        List l = result.files;
        List e = [];
        double size = 0;
        List ext = ['jpg', 'jpeg', 'png', 'pdf', 'docx'];

        for (var i = 0; i < l.length; i++) {
          final bytes = File(l[i].path).readAsBytesSync().lengthInBytes;
          final kb = bytes / 1024;
          size = size + kb / 1024;
          e.add(result.files[i].extension);
        }
        setState(() {
          size;
          e;
        });
        // final size = result.files.first.size;
        _sizeKbs = size / 1024;

        if (size > 5) {
          CustomMessage.toast('File size should be less than 5 MB');
          debugPrint('size should be less than $maxSizeKbs MB');
        } else {
          if (e.every((item) => ext.contains(item))) {
            fileselected = true;
            // _image = File(result.files.first.path!);
            files = result.files;
          } else {
            CustomMessage.toast('File Format Not Allowed');
          }
        }

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Preview(
        //           watermarkedImgBytes: _image!, patient: widget.patient,
        //         )));
      }
    });
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = [" b", " kb", " mb", " gb", " tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}
