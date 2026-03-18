class PostPaidLedgerDetails {
  PostPaidLedgerDetails({
      this.status, 
      this.message, 
      this.result,});

  PostPaidLedgerDetails.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<Result>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Result {
  Result({
      this.createdDate, 
      this.credit, 
      this.debit, 
      this.voucherNo, 
      this.centreName, 
      this.voucherType, 
      this.customerId, 
      this.unitId, 
      this.date, 
      this.getPostPaidLedgerList,});

  Result.fromJson(dynamic json) {
    createdDate = json['createdDate'];
    credit = json['credit'];
    debit = json['debit'];
    voucherNo = json['voucherNo'];
    centreName = json['centreName'];
    voucherType = json['voucherType'];
    customerId = json['customerId'];
    unitId = json['unitId'];
    date = json['date'];
    getPostPaidLedgerList = json['getPostPaidLedgerList'];
  }
  dynamic createdDate;
  double? credit;
  double? debit;
  int? voucherNo;
  String? centreName;
  String? voucherType;
  int? customerId;
  int? unitId;
  String? date;
  dynamic getPostPaidLedgerList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdDate'] = createdDate;
    map['credit'] = credit;
    map['debit'] = debit;
    map['voucherNo'] = voucherNo;
    map['centreName'] = centreName;
    map['voucherType'] = voucherType;
    map['customerId'] = customerId;
    map['unitId'] = unitId;
    map['date'] = date;
    map['getPostPaidLedgerList'] = getPostPaidLedgerList;
    return map;
  }

}