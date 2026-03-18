import 'test_package_data.dart';

class TestAndPackageList {
  TestAndPackageList({
      this.status, 
      this.responses, 
      this.data,});

  TestAndPackageList.fromJson(dynamic json) {
    status = json['status'];
    responses = json['responses'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TestPackageData.fromJson(v));
      });
    }
  }
  String? status;
  dynamic responses;
  List<TestPackageData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['responses'] = responses;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}