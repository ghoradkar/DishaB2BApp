import 'dart:convert';
import 'package:dishabtob/Global/custom_message.dart';
import 'package:dishabtob/global/app_colors.dart';
import 'package:dishabtob/global/network_call.dart';
import 'package:dishabtob/global/url.dart' as url;
import 'package:dishabtob/network/network_aware.dart';
import 'package:dishabtob/network/network_status.dart';
import 'package:dishabtob/network/offline.dart';
import 'package:dishabtob/runner_boy/runnerboy.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'nodata.dart';

class B2BSubmission extends StatefulWidget {
  final int? selectedpage;
  final List<dynamic>?IPD;
  final List<dynamic>?selected;
  final List<dynamic>?submit;
  const B2BSubmission(this.selectedpage,this.IPD,this.selected,this.submit, {super.key});


  @override
  B2BSubmissionState createState() => B2BSubmissionState();
}

class B2BSubmissionState extends State<B2BSubmission> {
  List IPD=[];
  bool load=false;
  Map<String,dynamic>?decode;
  bool selectall=false;
  List<bool>selected=[];

  List<dynamic>?type;
  List<dynamic>?name;
  List<dynamic>submit=[];

  TextEditingController fromdate = TextEditingController();

  TextEditingController todate = TextEditingController();

  String? current;
  @override


  void initState() {
    current=   DateFormat('dd/MM/yyyy').format(
        DateTime.now());
    fromdate.text=current!;
    todate.text=current!;
    debugPrint(current!);

    setState(() {

      (widget.selectedpage==1 && widget.IPD!.length==0)?load=false:
      ( widget.selectedpage==1&&widget.IPD!.isNotEmpty)?{load=false,
        selected=List.generate(widget.IPD!.length, (index) =>false)}:
      //submit=List.generate(widget.IPD!.length, (index) =>[])}:
      load = true;

    });
    debugPrint('syeegd');
    getUser();

    String formattedDate = DateFormat('dd/MM/yyyy').format(
        DateTime.now());

    fromdate.text=formattedDate;
    todate.text=formattedDate;
    //fetchB2BList(decode);


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
                resizeToAvoidBottomInset: false,

                body: Stack(children:[Container(height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(0),

                    decoration: const BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child:  Column(children:[

                      Row(children:[Checkbox(
                          activeColor: AppColours.blue,
                          value: selectall,
                          onChanged: (bool? value) {
                            setState(() {
                              selectall == false ? {
                                setState(() {
                                  //amount=amount!+g['totalInvoiceAmount'];
                                  selectall = true;
                                  for(int i=0;i<IPD.length;i++){
                                    submit.contains(IPD[i])?debugPrint(''):
                                    {submit.add(IPD[i]),
                                      selected[i]=true};
                                  }

                                }),

                              } : {
                                setState(() {
                                  // amount=amount!-g['totalInvoiceAmount'];
                                  selectall = false;
                                  for(int i=0;i<selected.length;i++){
                                    selected[i]=false;

                                  }



                                  submit.clear()
                                  ;
                                }),

                                //selectall = value!;


                              };
                            });
                          }),
                        const Text('Select All',style: TextStyle(fontWeight: FontWeight.bold),)]),
                      Expanded(child: load
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigo,
                        ),
                      )
                          :                        // height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.25,
                      IPD.isEmpty&& (widget.selectedpage==1 && widget.IPD!.length==0)
                          ? Center(child: NotFound(),):
                      ( widget.selectedpage==1&&widget.IPD!.isNotEmpty)?
                      smartReport(context,widget.IPD):smartReport(context, IPD)),
                      const SizedBox(height: 50,),


                      // Container(
                      //   margin: EdgeInsets.only(left: 0,right: 10),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.grey.shade900),
                      //       borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                      //           topRight: Radius.circular(10))
                      //   ),
                      //   // color: Colors.blue,
                      //   height: 50,width: MediaQuery.of(context).size.width,)


                    ])

                ),
                  //SizedBox(height: 100,),


                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade100),

                              borderRadius: const BorderRadius.only(topRight:Radius.circular(10) ,
                                  topLeft: Radius.circular(10))),
                          //borderOnForeground: true,
                          color: Colors.white,
                          child: Container(
                            margin: const EdgeInsets.only(left: 0,right: 0),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))
                            ),
                            // color: Colors.blue,
                            height: 50,width: MediaQuery.of(context).size.width,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.clear,color: Colors.red,),
                                GestureDetector(
                                  onTap:(){
    List? l;

    String? m;
    submit.isEmpty?CustomMessage.toast('Data Not Found'):{
    l=[],
    for (int i=0;i<submit.length;i++){
    l.add(submit.elementAt(i)['masterId']),
    },
    m=l.join(','),
    debugPrint(m),
    debugPrint(submit.first),
    debugPrint(submit.first['rejectreason']),

    rejectSample(m,submit.first['teststatus'],submit.first['rejectreason'].toString(),submit.first['rejectedBy']==null?0:submit.first['rejectedBy']),};
                                    },
                                  child:const Text('Reject',style: TextStyle(fontWeight: FontWeight.bold),),),
                                const VerticalDivider(color: Colors.grey,
                                  indent: 10,
                                  endIndent: 10,),
                                const Icon(Icons.arrow_upward,color: Colors.green,),
                                GestureDetector(
                                    onTap:(){
    List l=[];
    List t=[];
    debugPrint('lisgfghnm');

    for (int i=0;i<submit.length;i++){
    debugPrint(submit[i]);
    l.add(submit[i]['masterId']);
    t.add(submit[i]['barCode']);

    }
    String b=t.join(',');
    String m=l.join(',');
    debugPrint(m);
    // debugPrint(submit!.first);
    // debugPrint(submit!.first['rejectreason']);
    // Rejectsample(m,submit!.first['teststatus'],submit!.first['rejectreason'],submit!.first['rejectedBy']);
    submit.isEmpty?CustomMessage.toast('Data Not Found'):
                                        submitSample(
                                            m, submit.first['teststatus']);
                                      // List l=[];
                                      // List t=[];
                                      // String?m;
                                      // submit.isEmpty?CustomMessage.toast('Data Not Found'):{
                                      //   debugPrint(submit),
                                      //   for (int i = 0; i <
                                      //       submit!.length; i++) {
                                      //     l.add(submit![i]['masterId']),
                                      //     //t.add(submit!.elementAt(i)['barCode']);
                                      //
                                      //   },
                                      //   // String b=t.join(',');
                                      //    m = l.join(','),
                                      //   debugPrint(m),
                                      //   debugPrint(submit!.first),
                                      //   debugPrint(submit!.first['rejectreason']),
                                      //   // Rejectsample(m,submit!.first['teststatus'],submit!.first['rejectreason'],submit!.first['rejectedBy']);

                                      },
                                    child:const Text('Submit',style: TextStyle(fontWeight: FontWeight.bold),))
                              ],),)


                      ))
                ])),
            //


            offlineChild: Offline()));

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
    debugPrint('jgh$encodedMap');
    setState(() {

      decode = json.decode(encodedMap!);
      debugPrint('hjghh$decode');
      (widget.selectedpage==1 && widget.IPD!.length==0)?{
        fetchB2BCollectionList(decode,current!),
        fetchName(),
        fetchType(),}:{( widget.selectedpage==1&&widget.IPD!.isNotEmpty)?{fetchType(),
        fetchName()}:" "};



    });
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
    uri = Uri.parse(
        '${url.baseurl}${url.SEARCH_B2BRECORDS}?custTypeId=0&custNameId=0&fromDate=$fromdate&toDate=$todate&searchBy=byDate&startIndex=0&emergencyFlag=All&testStatus=102&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}&userType=${decode!['usertype']}');
    debugPrint(uri);
    response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    value = jsonDecode(response.body);
    debugPrint(response.body);

    response.statusCode == 200
        ? {
      setState(() {
        IPD = value!['labSampleWiseMasterDtoList'];
        selected=List.generate(IPD.length, (index) =>false);
        submit=List.generate(IPD.length, (index) =>[]);
        load = false;
      }),
    }
        : {CustomMessage.toast('Failed to load')};
    // {
    //
    //   uri = Uri.parse(
    //       '${url.baseurl}${url.B2BSEARCH}?deptId=1&letter=MR.V V&usertype=N&businessType=1&customerType=${decode!['customerType']}&customerId=${decode!['customerId']}&userTypeForCall=${decode!['userType']}&userId=${decode!['userId']}&startIndex=0&unitId=${decode!['unitMasterId']}&userFor=other&userType=${decode!['userType']}'),
    //   debugPrint(uri),
    //   response = await http.get(
    //     uri,
    //     headers: headers,
    //
    //     //encoding: encoding,
    //   ),
    //
    //   //final encoding = Encoding.getByName('utf-8');
    //
    //   value = jsonDecode(response.body),
    //   debugPrint(value),
    //   response.statusCode == 200
    //       ? {
    //     setState(() {
    //       IPD = value!['listOpdQueManagmentViewDto'];
    //       load = false;
    //     }),
    //   }
    //       : {CustomMessage.toast('Failed to load')},};


  }

  fetchB2BCollectionList(decode,current) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    debugPrint('inlist');
    // debugPrint('11$decode');
    //getuser();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    String l=decode!['deptId'];
    debugPrint(l.substring(0,1));

    final uri = Uri.parse(
        '${url.baseurl}${url.SEARCH_B2BRECORDS}?custTypeId=${decode['customerType']}&custNameId=${decode['customerId']}&fromDate=$current&toDate=$current&searchBy=byDate&startIndex=0&emergencyFlag=All&testStatus=102&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}&userType=${decode!['userType']}');
    debugPrint(uri.path);


    final response = await ioClient.get(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    Map<String, dynamic> value = jsonDecode(response.body);
    debugPrint(response.body);
    response.statusCode == 200
        ? {
      setState(() {
        IPD = value['labSampleWiseMasterDtoList'];
        selected=List.generate(IPD.length, (index) =>false);
        //submit=List.generate(IPD!.length, (index) =>{});
        load = false;

      }),
    }
        : {CustomMessage.toast('Failed to load')};
  }

  rejectSample(masterid,teststatus,reason,rejectedfrom) async {
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    // debugPrint('11$decode');
    //getuser();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.SAMPLE_REJECT}?masterIds=$masterid&testStatus=$teststatus&reason=$reason&rejectedFrom=$rejectedfrom&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    //Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(value);
    response.statusCode == 200
        ? {
      setState(() {
        CustomMessage.toast(response.body);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context
                    ) => const RunnerBoy(1, [], [], [])));

      }),
    }
        : { CustomMessage.toast(response.body),
      CustomMessage.toast('Failed to load')};
  }
  submitSample(masterid,teststatus) async {
    // debugPrint('11$decode');
    //getuser();
    IOClient ioClient = IOClient(ByPassCert().httpClient);


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final uri = Uri.parse(
        '${url.baseurl}${url.SAMPLE_SUBMIT}?masterIds=$masterid&testStatus=2&unitId=${decode!['unitMasterId']}&userId=${decode!['userId']}');
    debugPrint(uri.path);

    final response = await ioClient.post(
      uri,
      headers: headers,

      //encoding: encoding,
    );

    //final encoding = Encoding.getByName('utf-8');

    // Map<String, dynamic> value = jsonDecode(response.body);
    // debugPrint(value);
    response.statusCode == 200
        ? {
      setState(() {
        CustomMessage.toast(response.body);
        CustomMessage.toast('Sample Collected Successfully!');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context
                    ) => const RunnerBoy(1, [], [], [])));

      }),
    }
        : { CustomMessage.toast(response.body),
      CustomMessage.toast('Failed to load')};
  }

  smartReport(BuildContext context,IPD) {
    return ListView.builder(
        itemCount: IPD!.length,
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map<String, dynamic> g = IPD![index];

          return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 3,
              child:
              Container(
                //  padding: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.shade200)),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  child: CheckboxListTile(
                      activeColor: AppColours.blue,
                      checkColor: Colors.white,
                      //fillColor: MaterialStateColor.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      controlAffinity: ListTileControlAffinity.trailing,
                      dense: true,
                      //isThreeLine: true,
                      title:Column(
                        children: [
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 5),
                              child: Container(
                                height: 30, width: 30,
                                // margin: EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(21, 115, 175, 1),
                                          Color.fromRGBO(236, 106, 56, 1)
                                        ],
                                        begin: FractionalOffset(
                                            0.0, 0.0),
                                        end: FractionalOffset(
                                            1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                child: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),),
                            const SizedBox(width: 10,),
                            Text(
                              g['patientname'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),],),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,top: 5),
                            child:Align(
                              alignment: Alignment.centerLeft,
                              child:Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10),
                                ),
                                    color: Colors.greenAccent.shade100
                                ),
                                child: const Text('Collected',style: TextStyle(fontSize: 10,color: Colors.green),),
                              ),),),


                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              //SizedBox(width: 10,),

                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Icon(
                                        Icons.tag,
                                        size: 18,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        Icons.water_drop_rounded,
                                        size: 18,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Icon(
                                      //   Icons.science,
                                      //   size: 18,
                                      //   color: Colors.black87.withOpacity(0.6),
                                      // ),
                                    ]),
                              ),
                              //SizedBox(width: 10,),

                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    const SizedBox(height: 5,),
                                    const Text(
                                      'Patient ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                    Text(
                                      g['patientId'].toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    //SizedBox(height: 10,),

                                    //SizedBox(width: 20,),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Sample Type',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        g['samplename'],
                                        style: const TextStyle(fontSize: 10),
                                      ),),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Text(
                                    //   'Test Name',
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 10),
                                    // ),
                                    // Text(
                                    //  g['profileName'],
                                    //   style: TextStyle(fontSize: 10),
                                    // ),
                                  ],
                                ),
                              ),

                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.01,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 0,top: MediaQuery.of(context).size.height*0.01),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //SizedBox(height: 10,),


                                      Icon(
                                        Icons.pin_drop,
                                        size: 18,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        Icons.water_drop,
                                        size: 18,
                                        color: Colors.black87.withOpacity(0.6),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),

                                    ]),
                              ),Padding(
                                padding: EdgeInsets.only(left: 0,top: MediaQuery.of(context).size.height*0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    //SizedBox(height: 5,),
                                    const Text(
                                      'Center Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child:  Text(
                                        '${g['centerName']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 10),
                                      ),),
                                    //SizedBox(height: 10,),

                                    //SizedBox(width: 20,),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Sample Container',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                    Text(
                                      '${g["containername"]}',
                                      style: const TextStyle(fontSize: 10),
                                    ),


                                  ],
                                ),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 12,
                              ),
                              Icon(
                                Icons.science,
                                size: 18,
                                color: Colors.black87.withOpacity(0.6),
                              ),
                              const SizedBox(width:20 ,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Test Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                  Text(
                                    g['profileName'],
                                    style: const TextStyle(fontSize: 10),
                                  ),],),
                              // SizedBox(width: 50,)

                            ],)
                        ],),
                      value: selected[index], onChanged: ( value) {
                    selected[index] == false ? {
                      setState(() {
                        //amount=amount!+g['totalInvoiceAmount'];
                        selected[index] = true;
                        submit.add(IPD![index]);
                      }),

                    } : {
                      setState(() {
                        // amount=amount!-g['totalInvoiceAmount'];
                        selected[index] = false;
                        submit.removeAt(index);
                      }),

                    };
                  })
              ));});
  }
}