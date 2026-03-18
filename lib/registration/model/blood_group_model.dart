class BloodGroupModel {
  BloodGroupModel({
      this.status, 
      this.message, 
      this.result,});

  BloodGroupModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(BloodGroupResult.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<BloodGroupResult>? result;

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

class BloodGroupResult {
  BloodGroupResult({
      this.bloodGroupId, 
      this.bloodGroupName,});

  BloodGroupResult.fromJson(dynamic json) {
    bloodGroupId = json['bloodGroup_id'];
    bloodGroupName = json['bloodGroup_name'];
  }
  int? bloodGroupId;
  String? bloodGroupName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bloodGroup_id'] = bloodGroupId;
    map['bloodGroup_name'] = bloodGroupName;
    return map;
  }

}