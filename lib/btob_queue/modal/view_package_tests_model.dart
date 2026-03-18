class ViewPackageTestsModel {
  ViewPackageTestsModel({
      this.otherBillDetailsId, 
      this.treatmentId, 
      this.billDetailsId, 
      this.patienttId, 
      this.departmentId, 
      this.serviceId, 
      this.subServiceId, 
      this.childSubServiceId, 
      this.docId, 
      this.docName, 
      this.rate, 
      this.amount, 
      this.quantity, 
      this.paidFlag, 
      this.pay, 
      this.coPay, 
      this.concession, 
      this.cancle, 
      this.isModify, 
      this.createdDateTime, 
      this.categoryName, 
      this.chargesId, 
      this.chargesSlaveId, 
      this.extraFlag, 
      this.iscombination, 
      this.childServiceId, 
      this.otherAmount, 
      this.otherRate, 
      this.otherPay, 
      this.otherConcession, 
      this.otherCoPay, 
      this.sampleTypeId, 
      this.sampleTypeName, 
      this.barcode, 
      this.templateWise, 
      this.gender, 
      this.listOpdPackageDto,});

  ViewPackageTestsModel.fromJson(dynamic json) {
    otherBillDetailsId = json['otherBillDetailsId'];
    treatmentId = json['treatmentId'];
    billDetailsId = json['billDetailsId'];
    patienttId = json['patienttId'];
    departmentId = json['departmentId'];
    serviceId = json['serviceId'];
    subServiceId = json['subServiceId'];
    childSubServiceId = json['childSubServiceId'];
    docId = json['docId'];
    docName = json['docName'];
    rate = json['rate'];
    amount = json['amount'];
    quantity = json['quantity'];
    paidFlag = json['paidFlag'];
    pay = json['pay'];
    coPay = json['coPay'];
    concession = json['concession'];
    cancle = json['cancle'];
    isModify = json['isModify'];
    createdDateTime = json['createdDateTime'];
    categoryName = json['categoryName'];
    chargesId = json['chargesId'];
    chargesSlaveId = json['chargesSlaveId'];
    extraFlag = json['extraFlag'];
    iscombination = json['iscombination'];
    childServiceId = json['childServiceId'];
    otherAmount = json['otherAmount'];
    otherRate = json['otherRate'];
    otherPay = json['otherPay'];
    otherConcession = json['otherConcession'];
    otherCoPay = json['otherCoPay'];
    sampleTypeId = json['sampleTypeId'];
    sampleTypeName = json['sampleTypeName'];
    barcode = json['barcode'];
    templateWise = json['templateWise'];
    gender = json['gender'];
    if (json['listOpdPackageDto'] != null) {
      listOpdPackageDto = [];
      json['listOpdPackageDto'].forEach((v) {
        listOpdPackageDto?.add(ListOpdPackageDto.fromJson(v));
      });
    }
  }
  dynamic otherBillDetailsId;
  dynamic treatmentId;
  dynamic billDetailsId;
  dynamic patienttId;
  dynamic departmentId;
  dynamic serviceId;
  dynamic subServiceId;
  dynamic childSubServiceId;
  dynamic docId;
  dynamic docName;
  double? rate;
  double? amount;
  double? quantity;
  String? paidFlag;
  double? pay;
  double? coPay;
  double? concession;
  String? cancle;
  dynamic isModify;
  dynamic createdDateTime;
  dynamic categoryName;
  dynamic chargesId;
  dynamic chargesSlaveId;
  dynamic extraFlag;
  dynamic iscombination;
  dynamic childServiceId;
  double? otherAmount;
  double? otherRate;
  double? otherPay;
  double? otherConcession;
  double? otherCoPay;
  dynamic sampleTypeId;
  dynamic sampleTypeName;
  dynamic barcode;
  String? templateWise;
  dynamic gender;
  List<ListOpdPackageDto>? listOpdPackageDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otherBillDetailsId'] = otherBillDetailsId;
    map['treatmentId'] = treatmentId;
    map['billDetailsId'] = billDetailsId;
    map['patienttId'] = patienttId;
    map['departmentId'] = departmentId;
    map['serviceId'] = serviceId;
    map['subServiceId'] = subServiceId;
    map['childSubServiceId'] = childSubServiceId;
    map['docId'] = docId;
    map['docName'] = docName;
    map['rate'] = rate;
    map['amount'] = amount;
    map['quantity'] = quantity;
    map['paidFlag'] = paidFlag;
    map['pay'] = pay;
    map['coPay'] = coPay;
    map['concession'] = concession;
    map['cancle'] = cancle;
    map['isModify'] = isModify;
    map['createdDateTime'] = createdDateTime;
    map['categoryName'] = categoryName;
    map['chargesId'] = chargesId;
    map['chargesSlaveId'] = chargesSlaveId;
    map['extraFlag'] = extraFlag;
    map['iscombination'] = iscombination;
    map['childServiceId'] = childServiceId;
    map['otherAmount'] = otherAmount;
    map['otherRate'] = otherRate;
    map['otherPay'] = otherPay;
    map['otherConcession'] = otherConcession;
    map['otherCoPay'] = otherCoPay;
    map['sampleTypeId'] = sampleTypeId;
    map['sampleTypeName'] = sampleTypeName;
    map['barcode'] = barcode;
    map['templateWise'] = templateWise;
    map['gender'] = gender;
    if (listOpdPackageDto != null) {
      map['listOpdPackageDto'] = listOpdPackageDto?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ListOpdPackageDto {
  ListOpdPackageDto({
      this.otherBillDetailsId, 
      this.treatmentId, 
      this.billDetailsId, 
      this.patienttId, 
      this.departmentId, 
      this.serviceId, 
      this.subServiceId, 
      this.childSubServiceId, 
      this.docId, 
      this.docName, 
      this.rate, 
      this.amount, 
      this.quantity, 
      this.paidFlag, 
      this.pay, 
      this.coPay, 
      this.concession, 
      this.cancle, 
      this.isModify, 
      // this.createdDateTime,
      this.categoryName, 
      this.chargesId, 
      this.chargesSlaveId, 
      this.extraFlag, 
      this.iscombination, 
      this.childServiceId, 
      this.otherAmount, 
      this.otherRate, 
      this.otherPay, 
      this.otherConcession, 
      this.otherCoPay, 
      this.sampleTypeId, 
      this.sampleTypeName, 
      this.barcode, 
      this.templateWise, 
      this.gender, 
      this.listOpdPackageDto,});

  ListOpdPackageDto.fromJson(dynamic json) {
    otherBillDetailsId = json['otherBillDetailsId'];
    treatmentId = json['treatmentId'];
    billDetailsId = json['billDetailsId'];
    patienttId = json['patienttId'];
    departmentId = json['departmentId'];
    serviceId = json['serviceId'];
    subServiceId = json['subServiceId'];
    childSubServiceId = json['childSubServiceId'];
    docId = json['docId'];
    docName = json['docName'];
    rate = json['rate'];
    amount = json['amount'];
    quantity = json['quantity'];
    paidFlag = json['paidFlag'];
    pay = json['pay'];
    coPay = json['coPay'];
    concession = json['concession'];
    cancle = json['cancle'];
    isModify = json['isModify'];
    // createdDateTime = json['createdDateTime'] is String ? ;
    categoryName = json['categoryName'];
    chargesId = json['chargesId'];
    chargesSlaveId = json['chargesSlaveId'];
    extraFlag = json['extraFlag'];
    iscombination = json['iscombination'];
    childServiceId = json['childServiceId'];
    otherAmount = json['otherAmount'];
    otherRate = json['otherRate'];
    otherPay = json['otherPay'];
    otherConcession = json['otherConcession'];
    otherCoPay = json['otherCoPay'];
    sampleTypeId = json['sampleTypeId'];
    sampleTypeName = json['sampleTypeName'];
    barcode = json['barcode'];
    templateWise = json['templateWise'];
    gender = json['gender'];
    listOpdPackageDto = json['listOpdPackageDto'];
  }
  int? otherBillDetailsId;
  int? treatmentId;
  int? billDetailsId;
  int? patienttId;
  int? departmentId;
  int? serviceId;
  int? subServiceId;
  int? childSubServiceId;
  dynamic docId;
  dynamic docName;
  double? rate;
  double? amount;
  double? quantity;
  String? paidFlag;
  double? pay;
  double? coPay;
  double? concession;
  String? cancle;
  String? isModify;
  // int? createdDateTime;
  String? categoryName;
  int? chargesId;
  int? chargesSlaveId;
  String? extraFlag;
  String? iscombination;
  int? childServiceId;
  double? otherAmount;
  double? otherRate;
  double? otherPay;
  double? otherConcession;
  double? otherCoPay;
  int? sampleTypeId;
  String? sampleTypeName;
  String? barcode;
  String? templateWise;
  dynamic gender;
  dynamic listOpdPackageDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otherBillDetailsId'] = otherBillDetailsId;
    map['treatmentId'] = treatmentId;
    map['billDetailsId'] = billDetailsId;
    map['patienttId'] = patienttId;
    map['departmentId'] = departmentId;
    map['serviceId'] = serviceId;
    map['subServiceId'] = subServiceId;
    map['childSubServiceId'] = childSubServiceId;
    map['docId'] = docId;
    map['docName'] = docName;
    map['rate'] = rate;
    map['amount'] = amount;
    map['quantity'] = quantity;
    map['paidFlag'] = paidFlag;
    map['pay'] = pay;
    map['coPay'] = coPay;
    map['concession'] = concession;
    map['cancle'] = cancle;
    map['isModify'] = isModify;
    // map['createdDateTime'] = createdDateTime;
    map['categoryName'] = categoryName;
    map['chargesId'] = chargesId;
    map['chargesSlaveId'] = chargesSlaveId;
    map['extraFlag'] = extraFlag;
    map['iscombination'] = iscombination;
    map['childServiceId'] = childServiceId;
    map['otherAmount'] = otherAmount;
    map['otherRate'] = otherRate;
    map['otherPay'] = otherPay;
    map['otherConcession'] = otherConcession;
    map['otherCoPay'] = otherCoPay;
    map['sampleTypeId'] = sampleTypeId;
    map['sampleTypeName'] = sampleTypeName;
    map['barcode'] = barcode;
    map['templateWise'] = templateWise;
    map['gender'] = gender;
    map['listOpdPackageDto'] = listOpdPackageDto;
    return map;
  }

}