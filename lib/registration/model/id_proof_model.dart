class IdProofModel {
  IdProofModel({
      this.status, 
      this.message, 
      this.result,});

  IdProofModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(IdProofResult.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<IdProofResult>? result;

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

class IdProofResult {
  IdProofResult({
      this.idproofId, 
      this.idProofName,});

  IdProofResult.fromJson(dynamic json) {
    idproofId = json['idproof_id'];
    idProofName = json['idProof_name'];
  }
  int? idproofId;
  String? idProofName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idproof_id'] = idproofId;
    map['idProof_name'] = idProofName;
    return map;
  }

}