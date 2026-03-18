class OrderDetailRespModel {
  OrderDetailRespModel({
      this.amount, 
      this.amountDue, 
      this.amountPaid, 
      this.attempts, 
      this.createdAt, 
      this.currency, 
      this.entity, 
      this.id,
      this.offerId, 
      this.receipt, 
      this.status,});

  OrderDetailRespModel.fromJson(dynamic json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
  }
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  dynamic offerId;
  String? receipt;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['amount_due'] = amountDue;
    map['amount_paid'] = amountPaid;
    map['attempts'] = attempts;
    map['created_at'] = createdAt;
    map['currency'] = currency;
    map['entity'] = entity;
    map['id'] = id;

    map['offer_id'] = offerId;
    map['receipt'] = receipt;
    map['status'] = status;
    return map;
  }

}