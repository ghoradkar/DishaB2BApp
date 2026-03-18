class TestPackageData {
  TestPackageData({
      this.billDetailsId, 
      this.treatmentId, 
      this.patienttId, 
      this.departmentId, 
      this.businessType, 
      this.customerType, 
      this.customerId, 
      this.pay, 
      this.coPay, 
      this.paidFlag, 
      this.billId, 
      this.doctorId, 
      this.sourceTypeId, 
      this.serviceId, 
      this.subServiceId, 
      this.rate, 
      this.quantity, 
      this.concession, 
      this.otherRate, 
      this.amount, 
      this.discount, 
      this.deleted, 
      this.cancle, 
      this.otherAmount, 
      this.otherPay, 
      this.otherConcession, 
      this.otherCoPay, 
      this.createdBy, 
      this.createdDateTime, 
      this.updatedBy, 
      this.updatedDateTime, 
      this.deletedBy, 
      this.deletedDateTime, 
      this.unitId, 
      this.clinicalnotes, 
      this.instructions, 
      this.urgentflag, 
      this.drdeskflag, 
      this.deleteFrom, 
      this.sndToRisFlag, 
      this.accountStatusOpdDiagno, 
      this.sampleTypeId, 
      this.sampleName, 
      this.sampleId,
      this.barCode,
      this.referredSource, 
      this.inOutHouse, 
      this.histopathLab, 
      this.sampleCount, 
      this.invoiceGenerateFlag, 
      this.invoiceRemainAmount, 
      this.prepaidReceiptId, 
      this.collectionDate, 
      this.collectionTime, 
      this.regRefDocId, 
      this.templateWise, 
      this.remark, 
      this.b2bReceiptFlag, 
      this.preCreditedFlag, 
      this.custReceiptMasterIid, 
      this.b2bPaymentFlag, 
      this.recSlaveId, 
      this.callfrom, 
      this.masterReceiptId, 
      this.subservicesname, 
      this.iscombination, 
      this.sponsorId, 
      this.chargesSlaveId, 
      this.concessionOnPerc, 
      this.receiptOf, 
      this.narrationid, 
      this.rFlag, 
      this.narrationidBill, 
      this.emrPer, 
      this.sndToLabFlag, 
      this.sendToRisFlag, 
      this.opdIpdNo, 
      this.patientName, 
      this.age, 
      this.gender, 
      this.serviceName, 
      this.subServiceName, 
      this.doctorName, 
      this.parentuUtilizeAmount, 
      this.listBillDetails, 
      this.paidByCashFlag, 
      this.canceledBy, 
      this.canceledDateTime, 
      this.sendtohistoflag, 
      this.b2bNowPay, 
      this.b2bDisocunt, 
      this.b2bDisocuntPer, 
      this.b2bAuthorizedBy, 
      this.alternateTestName, 
      this.parentUtilizationFlag, 
      this.parentCustomerId, 
      this.parentUtilizationAmount,});

  TestPackageData.fromMap(Map<String, dynamic> map)
      : sampleTypeId = map['sampleId'];

  TestPackageData.fromJson(dynamic json) {
    billDetailsId = json['billDetailsId'];
    treatmentId = json['treatmentId'];
    patienttId = json['patienttId'];
    departmentId = json['departmentId'];
    businessType = json['businessType'];
    customerType = json['customerType'];
    customerId = json['customerId'];
    pay = json['pay'];
    coPay = json['coPay'];
    paidFlag = json['paidFlag'];
    billId = json['billId'];
    doctorId = json['doctorId'];
    sourceTypeId = json['sourceTypeId'];
    serviceId = json['serviceId'];
    subServiceId = json['subServiceId'];
    rate = json['rate'];
    quantity = json['quantity'];
    concession = json['concession'];
    otherRate = json['otherRate'];
    amount = json['amount'];
    discount = json['discount'];
    deleted = json['deleted'];
    cancle = json['cancle'];
    otherAmount = json['otherAmount'];
    otherPay = json['otherPay'];
    otherConcession = json['otherConcession'];
    otherCoPay = json['otherCoPay'];
    createdBy = json['createdBy'];
    createdDateTime = json['createdDateTime'];
    updatedBy = json['updatedBy'];
    updatedDateTime = json['updatedDateTime'];
    deletedBy = json['deletedBy'];
    deletedDateTime = json['deletedDateTime'];
    unitId = json['unitId'];
    clinicalnotes = json['clinicalnotes'];
    instructions = json['instructions'];
    urgentflag = json['urgentflag'];
    drdeskflag = json['drdeskflag'];
    deleteFrom = json['deleteFrom'];
    sndToRisFlag = json['sndToRisFlag'];
    accountStatusOpdDiagno = json['accountStatusOpdDiagno'];
    sampleTypeId = json['sampleTypeId'];
    sampleName = json['sampleName'];
    sampleId = json['sampleId'];
    barCode = json['barCode'];
    referredSource = json['referredSource'];
    inOutHouse = json['inOutHouse'];
    histopathLab = json['histopathLab'];
    sampleCount = json['sampleCount'];
    invoiceGenerateFlag = json['invoiceGenerateFlag'];
    invoiceRemainAmount = json['invoiceRemainAmount'];
    prepaidReceiptId = json['prepaidReceiptId'];
    collectionDate = json['collectionDate'];
    collectionTime = json['collectionTime'];
    regRefDocId = json['regRefDocId'];
    templateWise = json['templateWise'];
    remark = json['remark'];
    b2bReceiptFlag = json['b2bReceiptFlag'];
    preCreditedFlag = json['preCreditedFlag'];
    custReceiptMasterIid = json['custReceiptMasterIid'];
    b2bPaymentFlag = json['b2bPaymentFlag'];
    recSlaveId = json['recSlaveId'];
    callfrom = json['callfrom'];
    masterReceiptId = json['masterReceiptId'];
    subservicesname = json['subservicesname'];
    iscombination = json['iscombination'];
    sponsorId = json['sponsorId'];
    chargesSlaveId = json['chargesSlaveId'];
    concessionOnPerc = json['concessionOnPerc'];
    receiptOf = json['receiptOf'];
    narrationid = json['narrationid'];
    rFlag = json['rFlag'];
    narrationidBill = json['narrationidBill'];
    emrPer = json['emrPer'];
    sndToLabFlag = json['sndToLabFlag'];
    sendToRisFlag = json['sendToRisFlag'];
    opdIpdNo = json['opdIpdNo'];
    patientName = json['patientName'];
    age = json['age'];
    gender = json['gender'];
    serviceName = json['serviceName'];
    subServiceName = json['subServiceName'];
    doctorName = json['doctorName'];
    parentuUtilizeAmount = json['parentuUtilizeAmount'];
    listBillDetails = json['listBillDetails'];
    paidByCashFlag = json['paidByCashFlag'];
    canceledBy = json['canceledBy'];
    canceledDateTime = json['canceledDateTime'];
    sendtohistoflag = json['sendtohistoflag'];
    b2bNowPay = json['b2bNowPay'];
    b2bDisocunt = json['b2bDisocunt'];
    b2bDisocuntPer = json['b2bDisocuntPer'];
    b2bAuthorizedBy = json['b2bAuthorizedBy'];
    alternateTestName = json['alternateTestName'];
    parentUtilizationFlag = json['parentUtilizationFlag'];
    parentCustomerId = json['parentCustomerId'];
    parentUtilizationAmount = json['parentUtilizationAmount'];
  }
  int? billDetailsId;
  int? treatmentId;
  int? patienttId;
  int? departmentId;
  int? businessType;
  int? customerType;
  int? customerId;
  double? pay;
  double? coPay;
  String? paidFlag;
  int? billId;
  int? doctorId;
  int? sourceTypeId;
  int? serviceId;
  int? subServiceId;
  double? rate;
  double? quantity;
  double? concession;
  double? otherRate;
  double? amount;
  double? discount;
  String? deleted;
  String? cancle;
  double? otherAmount;
  double? otherPay;
  double? otherConcession;
  double? otherCoPay;
  int? createdBy;
  int? createdDateTime;
  int? updatedBy;
  dynamic updatedDateTime;
  int? deletedBy;
  dynamic deletedDateTime;
  int? unitId;
  String? clinicalnotes;
  String? instructions;
  String? urgentflag;
  String? drdeskflag;
  String? deleteFrom;
  String? sndToRisFlag;
  String? accountStatusOpdDiagno;
  int? sampleTypeId;
  String? sampleName;
  int? sampleId;
  String? barCode;
  int? referredSource;
  int? inOutHouse;
  String? histopathLab;
  int? sampleCount;
  String? invoiceGenerateFlag;
  double? invoiceRemainAmount;
  double? prepaidReceiptId;
  String? collectionDate;
  String? collectionTime;
  int? regRefDocId;
  String? templateWise;
  dynamic remark;
  String? b2bReceiptFlag;
  String? preCreditedFlag;
  int? custReceiptMasterIid;
  String? b2bPaymentFlag;
  dynamic recSlaveId;
  dynamic callfrom;
  dynamic masterReceiptId;
  dynamic subservicesname;
  dynamic iscombination;
  dynamic sponsorId;
  dynamic chargesSlaveId;
  double? concessionOnPerc;
  dynamic receiptOf;
  dynamic narrationid;
  String? rFlag;
  String? narrationidBill;
  double? emrPer;
  String? sndToLabFlag;
  dynamic sendToRisFlag;
  dynamic opdIpdNo;
  dynamic patientName;
  dynamic age;
  dynamic gender;
  dynamic serviceName;
  String? subServiceName;
  dynamic doctorName;
  double? parentuUtilizeAmount;
  dynamic listBillDetails;
  String? paidByCashFlag;
  double? canceledBy;
  dynamic canceledDateTime;
  String? sendtohistoflag;
  double? b2bNowPay;
  double? b2bDisocunt;
  double? b2bDisocuntPer;
  int? b2bAuthorizedBy;
  String? alternateTestName;
  String? parentUtilizationFlag;
  int? parentCustomerId;
  double? parentUtilizationAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['billDetailsId'] = billDetailsId;
    map['treatmentId'] = treatmentId;
    map['patienttId'] = patienttId;
    map['departmentId'] = departmentId;
    map['businessType'] = businessType;
    map['customerType'] = customerType;
    map['customerId'] = customerId;
    map['pay'] = pay;
    map['coPay'] = coPay;
    map['paidFlag'] = paidFlag;
    map['billId'] = billId;
    map['doctorId'] = doctorId;
    map['sourceTypeId'] = sourceTypeId;
    map['serviceId'] = serviceId;
    map['subServiceId'] = subServiceId;
    map['rate'] = rate;
    map['quantity'] = quantity;
    map['concession'] = concession;
    map['otherRate'] = otherRate;
    map['amount'] = amount;
    map['discount'] = discount;
    map['deleted'] = deleted;
    map['cancle'] = cancle;
    map['otherAmount'] = otherAmount;
    map['otherPay'] = otherPay;
    map['otherConcession'] = otherConcession;
    map['otherCoPay'] = otherCoPay;
    map['createdBy'] = createdBy;
    map['createdDateTime'] = createdDateTime;
    map['updatedBy'] = updatedBy;
    map['updatedDateTime'] = updatedDateTime;
    map['deletedBy'] = deletedBy;
    map['deletedDateTime'] = deletedDateTime;
    map['unitId'] = unitId;
    map['clinicalnotes'] = clinicalnotes;
    map['instructions'] = instructions;
    map['urgentflag'] = urgentflag;
    map['drdeskflag'] = drdeskflag;
    map['deleteFrom'] = deleteFrom;
    map['sndToRisFlag'] = sndToRisFlag;
    map['accountStatusOpdDiagno'] = accountStatusOpdDiagno;
    map['sampleTypeId'] = sampleTypeId;
    map['sampleName'] = sampleName;
    map['sampleId'] = sampleId;
    map['barCode'] = barCode;
    map['referredSource'] = referredSource;
    map['inOutHouse'] = inOutHouse;
    map['histopathLab'] = histopathLab;
    map['sampleCount'] = sampleCount;
    map['invoiceGenerateFlag'] = invoiceGenerateFlag;
    map['invoiceRemainAmount'] = invoiceRemainAmount;
    map['prepaidReceiptId'] = prepaidReceiptId;
    map['collectionDate'] = collectionDate;
    map['collectionTime'] = collectionTime;
    map['regRefDocId'] = regRefDocId;
    map['templateWise'] = templateWise;
    map['remark'] = remark;
    map['b2bReceiptFlag'] = b2bReceiptFlag;
    map['preCreditedFlag'] = preCreditedFlag;
    map['custReceiptMasterIid'] = custReceiptMasterIid;
    map['b2bPaymentFlag'] = b2bPaymentFlag;
    map['recSlaveId'] = recSlaveId;
    map['callfrom'] = callfrom;
    map['masterReceiptId'] = masterReceiptId;
    map['subservicesname'] = subservicesname;
    map['iscombination'] = iscombination;
    map['sponsorId'] = sponsorId;
    map['chargesSlaveId'] = chargesSlaveId;
    map['concessionOnPerc'] = concessionOnPerc;
    map['receiptOf'] = receiptOf;
    map['narrationid'] = narrationid;
    map['rFlag'] = rFlag;
    map['narrationidBill'] = narrationidBill;
    map['emrPer'] = emrPer;
    map['sndToLabFlag'] = sndToLabFlag;
    map['sendToRisFlag'] = sendToRisFlag;
    map['opdIpdNo'] = opdIpdNo;
    map['patientName'] = patientName;
    map['age'] = age;
    map['gender'] = gender;
    map['serviceName'] = serviceName;
    map['subServiceName'] = subServiceName;
    map['doctorName'] = doctorName;
    map['parentuUtilizeAmount'] = parentuUtilizeAmount;
    map['listBillDetails'] = listBillDetails;
    map['paidByCashFlag'] = paidByCashFlag;
    map['canceledBy'] = canceledBy;
    map['canceledDateTime'] = canceledDateTime;
    map['sendtohistoflag'] = sendtohistoflag;
    map['b2bNowPay'] = b2bNowPay;
    map['b2bDisocunt'] = b2bDisocunt;
    map['b2bDisocuntPer'] = b2bDisocuntPer;
    map['b2bAuthorizedBy'] = b2bAuthorizedBy;
    map['alternateTestName'] = alternateTestName;
    map['parentUtilizationFlag'] = parentUtilizationFlag;
    map['parentCustomerId'] = parentCustomerId;
    map['parentUtilizationAmount'] = parentUtilizationAmount;
    return map;
  }

}