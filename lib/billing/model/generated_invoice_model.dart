class PaymentDetailsModel {
  PaymentDetailsModel({
      this.invoiceId, 
      this.customerType, 
      this.customerId, 
      this.unitId,
      this.payMode,
      this.paidAmt,
      this.createdBy});

  PaymentDetailsModel.fromJson(dynamic json) {
    invoiceId = json['invoiceId'];
    customerType = json['customerType'];
    customerId = json['customerId'];
    unitId = json['unitId'];
    payMode = json['payMode'];
    paidAmt = json['paidAmt'];
    createdBy = json['createdBy'];
  }
  String? invoiceId;
  int? customerType;
  int? customerId;
  int? unitId;
  String? payMode;
  String? paidAmt;
  String? createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['invoiceId'] = invoiceId;
    map['customerType'] = customerType;
    map['customerId'] = customerId;
    map['unitId'] = unitId;
    map['payMode'] = payMode;
    map['paidAmt'] = paidAmt;
    map['createdBy'] = createdBy;
    return map;
  }

}