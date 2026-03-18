class IPDModal {
  int billDetailsId;
  int serviceId;
  int subServiceId;
  int sampleTypeId;
  int businessType;
  int customerType;
  int customerId;
  String sndToLabFlag;
  String barCode;
  String collectionDate;
  String collectionTime;
  String templateWise;
  String? isCombination;
  int? regRefDocId;
  String? gender;
  int? inOutHouse;
  double rate;
  bool isSelected;

  IPDModal({
    required this.billDetailsId,
    required this.serviceId,
    required this.subServiceId,
    required this.sampleTypeId,
    required this.businessType,
    required this.customerType,
    required this.customerId,
    required this.sndToLabFlag,
    required this.barCode,
    required this.collectionDate,
    required this.collectionTime,
    required this.templateWise,
    this.isCombination,
    this.regRefDocId,
    this.gender,
    this.inOutHouse,
    required this.rate,
    this.isSelected = false,
  });

  factory IPDModal.fromJson(Map<String, dynamic> json) {
    return IPDModal(
      billDetailsId: json['billDetailsId'],
      serviceId: json['serviceId'],
      subServiceId: json['subServiceId'],
      sampleTypeId: json['sampleTypeId'],
      businessType: json['businessType'],
      customerType: json['customerType'],
      customerId: json['customerId'],
      sndToLabFlag: json['sndToLabFlag'],
      barCode: json['barCode'],
      collectionDate: json['collectionDate'],
      collectionTime: json['collectionTime'],
      templateWise: json['templateWise'],
      isCombination: json['iscombination'],
      regRefDocId: json['regRefDocId'],
      gender: json['gender'],
      inOutHouse: json['inOutHouse'],
      rate: json['rate'],
    );
  }
}
