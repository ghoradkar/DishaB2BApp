import 'listgeneratedreports.dart';

class NewGeneratedReceiptResponse {
  NewGeneratedReceiptResponse({
      this.sampleName, 
      this.barCode, 
      this.amount, 
      this.rate, 
      this.quantity, 
      this.subServiceId, 
      this.categoryName, 
      this.patientId, 
      this.treatmentId, 
      this.editableRate, 
      this.prefix, 
      this.fName, 
      this.lName, 
      this.mobile, 
      this.admissionDate, 
      this.patientName, 
      this.sampleTypeName, 
      this.billDetailsId, 
      this.gender, 
      this.contact, 
      this.age, 
      this.sampleTypeId, 
      this.b2bReceiptFlag, 
      this.b2bBillRecId, 
      this.actualRate, 
      this.discount, 
      this.list, 
      this.listGeneratedReports,});

  NewGeneratedReceiptResponse.fromJson(dynamic json) {
    sampleName = json['sampleName'];
    barCode = json['barCode'];
    amount = json['amount'];
    rate = json['rate'];
    quantity = json['quantity'];
    subServiceId = json['subServiceId'];
    categoryName = json['categoryName'];
    patientId = json['patientId'];
    treatmentId = json['treatmentId'];
    editableRate = json['editableRate'];
    prefix = json['prefix'];
    fName = json['fName'];
    lName = json['lName'];
    mobile = json['mobile'];
    admissionDate = json['admissionDate'];
    patientName = json['patientName'];
    sampleTypeName = json['sampleTypeName'];
    billDetailsId = json['billDetailsId'];
    gender = json['gender'];
    contact = json['contact'];
    age = json['age'];
    sampleTypeId = json['sampleTypeId'];
    b2bReceiptFlag = json['b2bReceiptFlag'];
    b2bBillRecId = json['b2bBillRecId'];
    actualRate = json['actualRate'];
    discount = json['discount'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(GeneratedReportModel.fromJson(v));
      });
    }
    if (json['listGeneratedReports'] != null) {
      listGeneratedReports = [];
      json['listGeneratedReports'].forEach((v) {
        listGeneratedReports?.add(GeneratedReportModel.fromJson(v));
      });
    }
  }
  dynamic sampleName;
  dynamic barCode;
  double? amount;
  double? rate;
  double? quantity;
  dynamic subServiceId;
  dynamic categoryName;
  int? patientId;
  dynamic treatmentId;
  double? editableRate;
  dynamic prefix;
  dynamic fName;
  dynamic lName;
  dynamic mobile;
  dynamic admissionDate;
  String? patientName;
  dynamic sampleTypeName;
  dynamic billDetailsId;
  String? gender;
  String? contact;
  String? age;
  dynamic sampleTypeId;
  dynamic b2bReceiptFlag;
  dynamic b2bBillRecId;
  double? actualRate;
  double? discount;
  List<GeneratedReportModel>? list;
  List<GeneratedReportModel>? listGeneratedReports;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sampleName'] = sampleName;
    map['barCode'] = barCode;
    map['amount'] = amount;
    map['rate'] = rate;
    map['quantity'] = quantity;
    map['subServiceId'] = subServiceId;
    map['categoryName'] = categoryName;
    map['patientId'] = patientId;
    map['treatmentId'] = treatmentId;
    map['editableRate'] = editableRate;
    map['prefix'] = prefix;
    map['fName'] = fName;
    map['lName'] = lName;
    map['mobile'] = mobile;
    map['admissionDate'] = admissionDate;
    map['patientName'] = patientName;
    map['sampleTypeName'] = sampleTypeName;
    map['billDetailsId'] = billDetailsId;
    map['gender'] = gender;
    map['contact'] = contact;
    map['age'] = age;
    map['sampleTypeId'] = sampleTypeId;
    map['b2bReceiptFlag'] = b2bReceiptFlag;
    map['b2bBillRecId'] = b2bBillRecId;
    map['actualRate'] = actualRate;
    map['discount'] = discount;
    if (list != null) {
      map['list'] = list?.map((v) => v.toJson()).toList();
    }
    if (listGeneratedReports != null) {
      map['listGeneratedReports'] = listGeneratedReports?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}