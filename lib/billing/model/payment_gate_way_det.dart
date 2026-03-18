/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
import 'dart:convert';
PaymentGateWayDet paymentGateWayDetFromJson(String str) => PaymentGateWayDet.fromJson(json.decode(str));
String paymentGateWayDetToJson(PaymentGateWayDet data) => json.encode(data.toJson());
class PaymentGateWayDet {
    PaymentGateWayDet({
        required this.result,
        required this.message,
        required this.status,
    });

    List<Result> result;
    String message;
    String status;

    factory PaymentGateWayDet.fromJson(Map<dynamic, dynamic> json) => PaymentGateWayDet(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Result {
    Result({
        required this.keyId,
        required this.dynamicKey,
        required this.keySecret,
    });

    String keyId;
    String dynamicKey;
    String keySecret;

    factory Result.fromJson(Map<dynamic, dynamic> json) => Result(
        keyId: json["key_id"],
        dynamicKey: json["dynamic_key"],
        keySecret: json["key_secret"],
    );

    Map<dynamic, dynamic> toJson() => {
        "key_id": keyId,
        "dynamic_key": dynamicKey,
        "key_secret": keySecret,
    };
}
