class GeneratedReportModel {
  bool checkBox = false;

  GeneratedReportModel({
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

  GeneratedReportModel.fromJson(dynamic json) {
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
    list = json['list'];
    listGeneratedReports = json['listGeneratedReports'];
  }
  dynamic sampleName;
  String? barCode;
  double? amount;
  double? rate;
  double? quantity;
  dynamic subServiceId;
  String? categoryName;
  dynamic patientId;
  dynamic treatmentId;
  double? editableRate;
  dynamic prefix;
  dynamic fName;
  dynamic lName;
  dynamic mobile;
  dynamic admissionDate;
  dynamic patientName;
  String? sampleTypeName;
  int? billDetailsId;
  dynamic gender;
  dynamic contact;
  dynamic age;
  int? sampleTypeId;
  dynamic b2bReceiptFlag;
  int? b2bBillRecId;
  double? actualRate;
  double? discount;
  dynamic list;
  dynamic listGeneratedReports;

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
    map['list'] = list;
    map['listGeneratedReports'] = listGeneratedReports;
    return map;
  }

}