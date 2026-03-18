class PatientTypeModel {
  PatientTypeModel({
      this.status, 
      this.message, 
      this.result,});

  PatientTypeModel.fromJson(dynamic json) {
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
      this.patientTypeId, 
      this.patientTypeName,});

  Result.fromJson(dynamic json) {
    patientTypeId = json['patientType_id'];
    patientTypeName = json['patientType_name'];
  }
  int? patientTypeId;
  String? patientTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientType_id'] = patientTypeId;
    map['patientType_name'] = patientTypeName;
    return map;
  }

}