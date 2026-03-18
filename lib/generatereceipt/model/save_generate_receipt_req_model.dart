/// listEhatB2bBillReceiptMaster : [{"id":"30","patientId":"31679","patientName":"MISS. swati balpande","gender":"Female","contact":"8744236874","age":"22Y/0M/0D","billCategory":"self"}]
/// listEhatBb2bBillReceiptSlave : [{"bill_details_id":"48142","sample_type_id":"13","sample_type_name":"Urine","sub_service_name":"Calcium Urine 24hr","barcode":"45645645645645","actualRate":"200","rate":"200","quantity":"1","amount":"200","discount":"0"}]

class SaveGenerateReceiptModel {
  SaveGenerateReceiptModel({
      List<ListEhatB2bBillReceiptMaster>? listEhatB2bBillReceiptMaster, 
      List<ListEhatBb2bBillReceiptSlave>? listEhatBb2bBillReceiptSlave,}){
    _listEhatB2bBillReceiptMaster = listEhatB2bBillReceiptMaster;
    _listEhatBb2bBillReceiptSlave = listEhatBb2bBillReceiptSlave;
}

  SaveGenerateReceiptModel.fromJson(dynamic json) {
    if (json['listEhatB2bBillReceiptMaster'] != null) {
      _listEhatB2bBillReceiptMaster = [];
      json['listEhatB2bBillReceiptMaster'].forEach((v) {
        _listEhatB2bBillReceiptMaster?.add(ListEhatB2bBillReceiptMaster.fromJson(v));
      });
    }
    if (json['listEhatBb2bBillReceiptSlave'] != null) {
      _listEhatBb2bBillReceiptSlave = [];
      json['listEhatBb2bBillReceiptSlave'].forEach((v) {
        _listEhatBb2bBillReceiptSlave?.add(ListEhatBb2bBillReceiptSlave.fromJson(v));
      });
    }
  }
  List<ListEhatB2bBillReceiptMaster>? _listEhatB2bBillReceiptMaster;
  List<ListEhatBb2bBillReceiptSlave>? _listEhatBb2bBillReceiptSlave;
SaveGenerateReceiptModel copyWith({  List<ListEhatB2bBillReceiptMaster>? listEhatB2bBillReceiptMaster,
  List<ListEhatBb2bBillReceiptSlave>? listEhatBb2bBillReceiptSlave,
}) => SaveGenerateReceiptModel(  listEhatB2bBillReceiptMaster: listEhatB2bBillReceiptMaster ?? _listEhatB2bBillReceiptMaster,
  listEhatBb2bBillReceiptSlave: listEhatBb2bBillReceiptSlave ?? _listEhatBb2bBillReceiptSlave,
);
  List<ListEhatB2bBillReceiptMaster>? get listEhatB2bBillReceiptMaster => _listEhatB2bBillReceiptMaster;
  List<ListEhatBb2bBillReceiptSlave>? get listEhatBb2bBillReceiptSlave => _listEhatBb2bBillReceiptSlave;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_listEhatB2bBillReceiptMaster != null) {
      map['listEhatB2bBillReceiptMaster'] = _listEhatB2bBillReceiptMaster?.map((v) => v.toJson()).toList();
    }
    if (_listEhatBb2bBillReceiptSlave != null) {
      map['listEhatBb2bBillReceiptSlave'] = _listEhatBb2bBillReceiptSlave?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// bill_details_id : "48142"
/// sample_type_id : "13"
/// sample_type_name : "Urine"
/// sub_service_name : "Calcium Urine 24hr"
/// barcode : "45645645645645"
/// actualRate : "200"
/// rate : "200"
/// quantity : "1"
/// amount : "200"
/// discount : "0"

class ListEhatBb2bBillReceiptSlave {
  ListEhatBb2bBillReceiptSlave({
      String? billDetailsId, 
      String? sampleTypeId, 
      String? sampleTypeName, 
      String? subServiceName, 
      String? barcode, 
      String? actualRate, 
      String? rate, 
      String? quantity, 
      String? amount, 
      String? discount,
  }){
    _billDetailsId = billDetailsId;
    _sampleTypeId = sampleTypeId;
    _sampleTypeName = sampleTypeName;
    _subServiceName = subServiceName;
    _barcode = barcode;
    _actualRate = actualRate;
    _rate = rate;
    _quantity = quantity;
    _amount = amount;
    _discount = discount;
}

  ListEhatBb2bBillReceiptSlave.fromJson(dynamic json) {
    _billDetailsId = json['bill_details_id'];
    _sampleTypeId = json['sample_type_id'];
    _sampleTypeName = json['sample_type_name'];
    _subServiceName = json['sub_service_name'];
    _barcode = json['barcode'];
    _actualRate = json['actualRate'];
    _rate = json['rate'];
    _quantity = json['quantity'];
    _amount = json['amount'];
    _discount = json['discount'];
  }
  String? _billDetailsId;
  String? _sampleTypeId;
  String? _sampleTypeName;
  String? _subServiceName;
  String? _barcode;
  String? _actualRate;
  String? _rate;
  String? _quantity;
  String? _amount;
  String? _discount;
ListEhatBb2bBillReceiptSlave copyWith({  String? billDetailsId,
  String? sampleTypeId,
  String? sampleTypeName,
  String? subServiceName,
  String? barcode,
  String? actualRate,
  String? rate,
  String? quantity,
  String? amount,
  String? discount,
}) => ListEhatBb2bBillReceiptSlave(  billDetailsId: billDetailsId ?? _billDetailsId,
  sampleTypeId: sampleTypeId ?? _sampleTypeId,
  sampleTypeName: sampleTypeName ?? _sampleTypeName,
  subServiceName: subServiceName ?? _subServiceName,
  barcode: barcode ?? _barcode,
  actualRate: actualRate ?? _actualRate,
  rate: rate ?? _rate,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  discount: discount ?? _discount,
);
  String? get billDetailsId => _billDetailsId;
  String? get sampleTypeId => _sampleTypeId;
  String? get sampleTypeName => _sampleTypeName;
  String? get subServiceName => _subServiceName;
  String? get barcode => _barcode;
  String? get actualRate => _actualRate;
  String? get rate => _rate;
  String? get quantity => _quantity;
  String? get amount => _amount;
  String? get discount => _discount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bill_details_id'] = _billDetailsId;
    map['sample_type_id'] = _sampleTypeId;
    map['sample_type_name'] = _sampleTypeName;
    map['sub_service_name'] = _subServiceName;
    map['barcode'] = _barcode;
    map['actualRate'] = _actualRate;
    map['rate'] = _rate;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    map['discount'] = _discount;
    return map;
  }

}

/// id : "30"
/// patientId : "31679"
/// patientName : "MISS. swati balpande"
/// gender : "Female"
/// contact : "8744236874"
/// age : "22Y/0M/0D"
/// billCategory : "self"

class ListEhatB2bBillReceiptMaster {
  ListEhatB2bBillReceiptMaster({
      String? id, 
      String? patientId, 
      String? patientName, 
      String? gender, 
      String? contact, 
      String? age, 
      String? billCategory,
  }){
    _id = id;
    _patientId = patientId;
    _patientName = patientName;
    _gender = gender;
    _contact = contact;
    _age = age;
    _billCategory = billCategory;
}

  ListEhatB2bBillReceiptMaster.fromJson(dynamic json) {
    _id = json['id'];
    _patientId = json['patientId'];
    _patientName = json['patientName'];
    _gender = json['gender'];
    _contact = json['contact'];
    _age = json['age'];
    _billCategory = json['billCategory'];
  }
  String? _id;
  String? _patientId;
  String? _patientName;
  String? _gender;
  String? _contact;
  String? _age;
  String? _billCategory;
ListEhatB2bBillReceiptMaster copyWith({  String? id,
  String? patientId,
  String? patientName,
  String? gender,
  String? contact,
  String? age,
  String? billCategory,
}) => ListEhatB2bBillReceiptMaster(  id: id ?? _id,
  patientId: patientId ?? _patientId,
  patientName: patientName ?? _patientName,
  gender: gender ?? _gender,
  contact: contact ?? _contact,
  age: age ?? _age,
  billCategory: billCategory ?? _billCategory,
);
  String? get id => _id;
  String? get patientId => _patientId;
  String? get patientName => _patientName;
  String? get gender => _gender;
  String? get contact => _contact;
  String? get age => _age;
  String? get billCategory => _billCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['patientId'] = _patientId;
    map['patientName'] = _patientName;
    map['gender'] = _gender;
    map['contact'] = _contact;
    map['age'] = _age;
    map['billCategory'] = _billCategory;
    return map;
  }

}