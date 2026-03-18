/// unitId : 2
/// businessType : 1
/// patientId : 31682
/// treatmentId : 33328
/// billDetailsId : 0
/// barcode : ""
/// callFrom : "savePackage"
/// labSampleWiseMasterDtoList : [{"subServiceId":"153","sampleTypeId":"4","barCode":"liam1234767647"},{"subServiceId":"274","sampleTypeId":"4","barCode":"liam1234767647"},{"subServiceId":"252","sampleTypeId":"4","barCode":"liam1234767647"},{"subServiceId":"99","sampleTypeId":"39","barCode":"peter124545345"}]

class CheckDuplicatePackageModel {
  CheckDuplicatePackageModel({
      int? unitId,
      int? businessType,
      int? patientId,
      int? treatmentId,
      int? billDetailsId,
      String? barcode, 
      String? callFrom, 
      List<LabSampleWiseMasterDtoList>? labSampleWiseMasterDtoList,}){
    _unitId = unitId;
    _businessType = businessType;
    _patientId = patientId;
    _treatmentId = treatmentId;
    _billDetailsId = billDetailsId;
    _barcode = barcode;
    _callFrom = callFrom;
    _labSampleWiseMasterDtoList = labSampleWiseMasterDtoList;
}

  CheckDuplicatePackageModel.fromJson(dynamic json) {
    _unitId = json['unitId'];
    _businessType = json['businessType'];
    _patientId = json['patientId'];
    _treatmentId = json['treatmentId'];
    _billDetailsId = json['billDetailsId'];
    _barcode = json['barcode'];
    _callFrom = json['callFrom'];
    if (json['labSampleWiseMasterDtoList'] != null) {
      _labSampleWiseMasterDtoList = [];
      json['labSampleWiseMasterDtoList'].forEach((v) {
        _labSampleWiseMasterDtoList?.add(LabSampleWiseMasterDtoList.fromJson(v));
      });
    }
  }
  int? _unitId;
  int? _businessType;
  int? _patientId;
  int? _treatmentId;
  int? _billDetailsId;
  String? _barcode;
  String? _callFrom;
  List<LabSampleWiseMasterDtoList>? _labSampleWiseMasterDtoList;
CheckDuplicatePackageModel copyWith({  int? unitId,
  int? businessType,
  int? patientId,
  int? treatmentId,
  int? billDetailsId,
  String? barcode,
  String? callFrom,
  List<LabSampleWiseMasterDtoList>? labSampleWiseMasterDtoList,
}) => CheckDuplicatePackageModel(  unitId: unitId ?? _unitId,
  businessType: businessType ?? _businessType,
  patientId: patientId ?? _patientId,
  treatmentId: treatmentId ?? _treatmentId,
  billDetailsId: billDetailsId ?? _billDetailsId,
  barcode: barcode ?? _barcode,
  callFrom: callFrom ?? _callFrom,
  labSampleWiseMasterDtoList: labSampleWiseMasterDtoList ?? _labSampleWiseMasterDtoList,
);
  int? get unitId => _unitId;
  int? get businessType => _businessType;
  int? get patientId => _patientId;
  int? get treatmentId => _treatmentId;
  int? get billDetailsId => _billDetailsId;
  String? get barcode => _barcode;
  String? get callFrom => _callFrom;
  List<LabSampleWiseMasterDtoList>? get labSampleWiseMasterDtoList => _labSampleWiseMasterDtoList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitId'] = _unitId;
    map['businessType'] = _businessType;
    map['patientId'] = _patientId;
    map['treatmentId'] = _treatmentId;
    map['billDetailsId'] = _billDetailsId;
    map['barcode'] = _barcode;
    map['callFrom'] = _callFrom;
    if (_labSampleWiseMasterDtoList != null) {
      map['labSampleWiseMasterDtoList'] = _labSampleWiseMasterDtoList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// subServiceId : "153"
/// sampleTypeId : "4"
/// barCode : "liam1234767647"

class LabSampleWiseMasterDtoList {
  LabSampleWiseMasterDtoList({
      String? subServiceId, 
      String? sampleTypeId, 
      String? barCode,}){
    _subServiceId = subServiceId;
    _sampleTypeId = sampleTypeId;
    _barCode = barCode;
}

  LabSampleWiseMasterDtoList.fromJson(dynamic json) {
    _subServiceId = json['subServiceId'];
    _sampleTypeId = json['sampleTypeId'];
    _barCode = json['barCode'];
  }
  String? _subServiceId;
  String? _sampleTypeId;
  String? _barCode;
LabSampleWiseMasterDtoList copyWith({  String? subServiceId,
  String? sampleTypeId,
  String? barCode,
}) => LabSampleWiseMasterDtoList(  subServiceId: subServiceId ?? _subServiceId,
  sampleTypeId: sampleTypeId ?? _sampleTypeId,
  barCode: barCode ?? _barCode,
);
  String? get subServiceId => _subServiceId;
  String? get sampleTypeId => _sampleTypeId;
  String? get barCode => _barCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subServiceId'] = _subServiceId;
    map['sampleTypeId'] = _sampleTypeId;
    map['barCode'] = _barCode;
    return map;
  }

}