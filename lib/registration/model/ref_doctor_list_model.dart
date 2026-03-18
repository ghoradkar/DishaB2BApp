import 'package:flutter_flavor/flutter_flavor.dart';

class RefDoctorListModel {
  RefDoctorListModel({
    this.doctorId,
    this.prefix,
    this.dName,
    this.referFees,
    this.speacialization,
    this.hosName,
    this.email,
    this.mob,
    this.address,
    this.deleted,
    this.unitId,
    this.lstDocDetailsDto,
  });

  RefDoctorListModel.fromJson(dynamic json) {
    doctorId = json['doctorId'];
    prefix = json['prefix'];
    dName = json['dName'];
    referFees = json['referFees'];
    speacialization = json['speacialization'];
    hosName = json['hosName'];
    email = json['email'];
    mob = json['mob'];
    address = json['address'];
    deleted = json['deleted'];
    unitId = json['unitId'];
    if (json['lstDocDetailsDto'] != null) {
      lstDocDetailsDto = [];
      json['lstDocDetailsDto'].forEach((v) {
        lstDocDetailsDto?.add(LstDocDetailsDto.fromJson(v));
      });
    }
  }

  dynamic doctorId;
  dynamic prefix;
  dynamic dName;
  dynamic referFees;
  dynamic speacialization;
  dynamic hosName;
  dynamic email;
  dynamic mob;
  dynamic address;
  String? deleted;
  dynamic unitId;
  List<LstDocDetailsDto>? lstDocDetailsDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doctorId'] = doctorId;
    map['prefix'] = prefix;
    map['dName'] = dName;
    map['referFees'] = referFees;
    map['speacialization'] = speacialization;
    map['hosName'] = hosName;
    map['email'] = email;
    map['mob'] = mob;
    map['address'] = address;
    map['deleted'] = deleted;
    map['unitId'] = unitId;
    if (lstDocDetailsDto != null) {
      map['lstDocDetailsDto'] =
          lstDocDetailsDto?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LstDocDetailsDto {
  LstDocDetailsDto({
    this.doctorId,
    this.prefix,
    this.dName,
    this.referFees,
    this.speacialization,
    this.hosName,
    this.email,
    this.mob,
    this.address,
    this.deleted,
    this.unitId,
    this.lstDocDetailsDto,
  });

  LstDocDetailsDto.fromJson(dynamic json) {
    doctorId = json['doctorId'];
    prefix = json['prefix'];
    dName = FlavorConfig.instance.name == "B2BLifenity"
        ? json['docName']
        : json['dName'];
    referFees = json['referFees'];
    speacialization = json['speacialization'];
    hosName = json['hosName'];
    email = json['email'];
    mob = json['mob'];
    address = json['address'];
    deleted = json['deleted'];
    unitId = json['unitId'];
    lstDocDetailsDto = json['lstDocDetailsDto'];
  }

  int? doctorId;
  String? prefix;
  String? dName;
  dynamic referFees;
  String? speacialization;
  String? hosName;
  String? email;
  String? mob;
  String? address;
  String? deleted;
  int? unitId;
  dynamic lstDocDetailsDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doctorId'] = doctorId;
    map['prefix'] = prefix;
    FlavorConfig.instance.name == "B2BLifenity"
        ? map['docName']
        : map['dName'] = dName;
    map['referFees'] = referFees;
    map['speacialization'] = speacialization;
    map['hosName'] = hosName;
    map['email'] = email;
    map['mob'] = mob;
    map['address'] = address;
    map['deleted'] = deleted;
    map['unitId'] = unitId;
    map['lstDocDetailsDto'] = lstDocDetailsDto;
    return map;
  }
}
