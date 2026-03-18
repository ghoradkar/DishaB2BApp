// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class ReportView extends StatelessWidget {
//   final String filePath;
//   const ReportView({super.key, required this.filePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Merged Report')),
//       body: SfPdfViewer.file(File(filePath)),
//     );
//   }
// }
import 'dart:io';
import 'package:dishabtob/lis/reporting/download_report.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/user/datanotfound.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReportView extends StatefulWidget {
  final int? Patid;
  final String? unitMasterId;
  final String? masterId;
  final String? file;
  final String? unitcode;

  const ReportView(this.Patid, this.unitMasterId, this.masterId,
      {super.key, this.file, this.unitcode});

  @override
  ReportViewState createState() => ReportViewState();
}

class ReportViewState extends State<ReportView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  bool load = false;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    // debugPrint(widget.networkLink);
    // widget.networkLink == null ? load = true : load = false;
    widget.file == null ? load = true : load = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColours.blue, AppColours.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'View Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColours.orange.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                      ),
                      onPressed: () {
                        if (widget.file != null) {
                          showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.7),
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            builder: (context) => DownloadReport(
                              widget.file,
                              widget.Patid,
                              widget.unitMasterId,
                              widget.masterId,widget.unitcode
                            ),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Download',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          Icon(Icons.download, color: Colors.white, size: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PDF Viewer Section
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(0),
                  // Remove padding that might cut content
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: load
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColours.dark_blue,
                          ),
                        )
                      : widget.file == null
                          ? const Center(child: DataNotFound())
                          : SfPdfViewer.file(
                              File(widget.file!),
                              key: _pdfViewerKey,
                              onDocumentLoadFailed: (details) {
                                debugPrint(
                                    "Failed to load document: ${details.description}");
                                debugPrint(
                                    "Failed to load document: ${details.error}");
                              },
                            )),
            ),
          ],
        ),
      ),
    );
  }
}
//
// // class ReportView extends StatefulWidget {
// //   final String? networkLink;
// //   final int? Patid;
// //   final String? unitMasterId;
// //   final String? masterId;
// //
// //   final String? file;
// //
// //   const ReportView(
// //       this.networkLink, this.Patid, this.unitMasterId, this.masterId,
// //       {super.key, this.file});
// //
// //   @override
// //   ReportViewState createState() => ReportViewState();
// // }
// //
// // class ReportViewState extends State<ReportView> {
// //   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
// //
// //   // final Uint8List _bytes = Uint8List(0);
// //   // final GlobalKey _webViewKey = GlobalKey();
// //   dynamic selected = 0;
// //   late File Pfile;
// //   bool load = false;
// //   bool isLoading = false;
// //   bool isvisible = false;
// //
// //   @override
// //   void initState() {
// //     setState(() {
// //       debugPrint(widget.networkLink);
// //       widget.networkLink == null ? load = true : load = false;
// //       widget.file == null ? load = true : load = false;
// //     });
// //
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamProvider<NetworkStatus>(
// //         create: (context) =>
// //             NetworkStatusService().networkStatusController.stream,
// //         initialData: NetworkStatus.Online,
// //         child: NetworkAwareWidget(
// //             onlineChild: Scaffold(
// //                 backgroundColor: Colors.white,
// //                 resizeToAvoidBottomInset: false,
// //                 body: SizedBox(
// //                     height: MediaQuery.of(context).size.height,
// //                     width: MediaQuery.of(context).size.width,
// //                     child: Stack(children: [
// //                       Container(
// //                           padding: const EdgeInsets.only(
// //                             bottom: 20,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             gradient: LinearGradient(
// //                                 colors: [AppColours.blue, AppColours.orange],
// //                                 begin: const FractionalOffset(0.0, 0.0),
// //                                 end: const FractionalOffset(0.0, 1.0),
// //                                 stops: const [0.0, 1.0],
// //                                 tileMode: TileMode.clamp),
// //                           ),
// //                           height: MediaQuery.of(context).size.height * 0.2,
// //                           child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                               children: [
// //                                 IconButton(
// //                                     onPressed: () {
// //                                       Navigator.pop(context);
// //                                     },
// //                                     icon: const Icon(
// //                                       Icons.arrow_back,
// //                                       color: Colors.white,
// //                                     )),
// //                                 //  SizedBox(width: 5,),
// //                                 const Text(
// //                                   'View Report',
// //                                   style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 16),
// //                                 ),
// //                                 //  SizedBox(width: 20,),
// //                                 SizedBox(
// //                                     width:
// //                                         MediaQuery.of(context).size.width * 0.4,
// //                                     height: MediaQuery.of(context).size.height *
// //                                         0.04,
// //                                     child: TextButton(
// //                                       style: ButtonStyle(
// //                                         side: MaterialStateProperty.all(
// //                                           const BorderSide(
// //                                               color: Colors
// //                                                   .white), // Border color and width
// //                                         ),
// //                                         shape: MaterialStateProperty.all<
// //                                                 RoundedRectangleBorder>(
// //                                             RoundedRectangleBorder(
// //                                           borderRadius:
// //                                               BorderRadius.circular(20.0),
// //                                           // side: BorderSide(color: Colors.red)
// //                                         )),
// //                                         backgroundColor:
// //                                             MaterialStateProperty.all<Color>(
// //                                                 AppColours.orange
// //                                                     .withOpacity(0.9)),
// //                                       ),
// //                                       onPressed: () async {
// //                                         if(widget.file != null){
// //                                           showModalBottomSheet<void>(
// //                                               barrierColor:
// //                                               Colors.black.withOpacity(0.7),
// //                                               backgroundColor:
// //                                               Colors.grey.withOpacity(0.5),
// //
// //                                               // context and builder are
// //                                               // required properties in this widget
// //                                               context: context,
// //                                               builder: (BuildContext context) {
// //                                                 return DownloadReport(
// //                                                     widget.networkLink,
// //                                                     widget.file,
// //                                                     widget.Patid,
// //                                                     widget.unitMasterId,
// //                                                     widget.masterId);
// //                                               });
// //                                         }
// //
// //                                       },
// //                                       child: const Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.spaceBetween,
// //                                           children: [
// //                                             Text(
// //                                               'Download Reports',
// //                                               style: TextStyle(
// //                                                   fontWeight: FontWeight.bold,
// //                                                   color: Colors.white,
// //                                                   fontSize: 10),
// //                                             ),
// //                                             Icon(
// //                                               Icons.download,
// //                                               color: Colors.white,
// //                                               size: 15,
// //                                             )
// //                                           ]),
// //                                     ))
// //                               ])),
// //                       Positioned(
// //                           bottom: MediaQuery.of(context).size.height * 0.02,
// //                           child: Container(
// //                             height: MediaQuery.of(context).size.height -
// //                                 MediaQuery.of(context).size.height * 0.15,
// //                             width: MediaQuery.of(context).size.width,
// //                             padding: const EdgeInsets.all(10),
// //                             decoration: const BoxDecoration(
// //                                 color: Colors.white,
// //                                 borderRadius: BorderRadius.only(
// //                                     topLeft: Radius.circular(30),
// //                                     topRight: Radius.circular(30))),
// //                             child: load
// //                                 ? Padding(
// //                                     padding: EdgeInsets.only(
// //                                         top:
// //                                             MediaQuery.of(context).size.height *
// //                                                 0.35,
// //                                         left:
// //                                             MediaQuery.of(context).size.width *
// //                                                 0.06),
// //                                     child: const CircularProgressIndicator(
// //                                       color: AppColours.dark_blue,
// //                                     ))
// //                                 : widget.file == null
// //                                     ? Container(
// //                                         color: Colors.white,
// //                                         alignment: Alignment.center,
// //                                         height:
// //                                             MediaQuery.of(context).size.height *
// //                                                 0.7,
// //                                         child: const DataNotFound())
// //                                     : SfPdfViewer.file(
// //                                         File(widget.file!),
// //                                         key: _pdfViewerKey,
// //                                         onDocumentLoadFailed: (details) {
// //                                           debugPrint(
// //                                               "Failed to load document: ${details.description}");
// //                                           debugPrint(
// //                                               "Failed to load document: ${details.error}");
// //                                         },
// //                                       ),
// //                           )),
// //                     ]))),
// //             offlineChild: Offline()));
// //   }
// // }
