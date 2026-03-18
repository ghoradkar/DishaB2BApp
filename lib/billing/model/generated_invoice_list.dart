

import 'dart:convert';

GeneratedInvoiceList generatedInvoiceListFromJson(String str) => GeneratedInvoiceList.fromJson(json.decode(str));

String generatedInvoiceListToJson(GeneratedInvoiceList data) => json.encode(data.toJson());

class GeneratedInvoiceList {
    GeneratedInvoiceList({
        required this.totalInvoiceRemainAmount,
        required this.totalPatient,
        required this.totalTds,
        required this.regDate,
        required this.vatPercent,
        required this.totalRemain,
        required this.totalGrossRemain,
        required this.customerType,
        required this.customerId,
        required this.centerCode,
        required this.unitId,
        required this.totalInvoiceAmount,
        this.lstbusinesscustomerinvoice,
        required this.totalGrossPayable,
        required this.inchargeName,
        required this.totalTest,
        required this.totalInvoiceReceivedAmount,
        required this.totalNetAmount,
        required this.totalPaid,
        this.lstBusinessCustomerInvoiceForExcel,
        required this.customerTypeName,
        required this.totalAmount,
        required this.deleted,
        required this.totalDiscount,
        required this.vatAmout,
        required this.centerName,
        this.invoiceFromDate,
        this.toDate,
        this.invoiceDate,
        this.fromDate,
        this.invoiceToDate,
        this.invoiceId,
        this.status,
    });

    double totalInvoiceRemainAmount;
    int totalPatient;
    double totalTds;
    String regDate;
    int vatPercent;
    double totalRemain;
    double totalGrossRemain;
    int customerType;
    int customerId;
    String centerCode;
    int unitId;
    double totalInvoiceAmount;
    List<GeneratedInvoiceList>? lstbusinesscustomerinvoice;
    double totalGrossPayable;
    String inchargeName;
    int totalTest;
    double totalInvoiceReceivedAmount;
    double totalNetAmount;
    double totalPaid;
    List<dynamic>? lstBusinessCustomerInvoiceForExcel;
    String customerTypeName;
    double totalAmount;
    String deleted;
    double totalDiscount;
    double vatAmout;
    String centerName;
    String? invoiceFromDate;
    String? toDate;
    String? invoiceDate;
    String? fromDate;
    String? invoiceToDate;
    int? invoiceId;
    String? status;
    double controllerValue = 0.0;

    factory GeneratedInvoiceList.fromJson(Map<dynamic, dynamic> json) => GeneratedInvoiceList(
        totalInvoiceRemainAmount: json["totalInvoiceRemainAmount"],
        totalPatient: json["totalPatient"],
        totalTds: json["totalTds"],
        regDate: json["regDate"],
        vatPercent: json["vatPercent"],
        totalRemain: json["totalRemain"],
        totalGrossRemain: json["totalGrossRemain"],
        customerType: json["customerType"],
        customerId: json["customerId"],
        centerCode: json["centerCode"],
        unitId: json["unitId"],
        totalInvoiceAmount: json["totalInvoiceAmount"],
        lstbusinesscustomerinvoice: json["lstbusinesscustomerinvoice"] == null ? [] : List<GeneratedInvoiceList>.from(json["lstbusinesscustomerinvoice"]!.map((x) => GeneratedInvoiceList.fromJson(x))),
        totalGrossPayable: json["totalGrossPayable"],
        inchargeName: json["inchargeName"],
        totalTest: json["totalTest"],
        totalInvoiceReceivedAmount: json["totalInvoiceReceivedAmount"],
        totalNetAmount: json["totalNetAmount"],
        totalPaid: json["totalPaid"],
        lstBusinessCustomerInvoiceForExcel: json["lstBusinessCustomerInvoiceForExcel"] == null ? [] : List<dynamic>.from(json["lstBusinessCustomerInvoiceForExcel"]!.map((x) => x)),
        customerTypeName: json["customerTypeName"],
        totalAmount: json["totalAmount"],
        deleted: json["deleted"],
        totalDiscount: json["totalDiscount"],
        vatAmout: json["vatAmout"],
        centerName: json["centerName"],
        invoiceFromDate: json["invoiceFromDate"],
        toDate: json["toDate"],
        invoiceDate: json["invoiceDate"],
        fromDate: json["fromDate"],
        invoiceToDate: json["invoiceToDate"],
        invoiceId: json["invoiceId"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "totalInvoiceRemainAmount": totalInvoiceRemainAmount,
        "totalPatient": totalPatient,
        "totalTds": totalTds,
        "regDate": regDate,
        "vatPercent": vatPercent,
        "totalRemain": totalRemain,
        "totalGrossRemain": totalGrossRemain,
        "customerType": customerType,
        "customerId": customerId,
        "centerCode": centerCode,
        "unitId": unitId,
        "totalInvoiceAmount": totalInvoiceAmount,
        "lstbusinesscustomerinvoice": lstbusinesscustomerinvoice == null ? [] : List<dynamic>.from(lstbusinesscustomerinvoice!.map((x) => x.toJson())),
        "totalGrossPayable": totalGrossPayable,
        "inchargeName": inchargeName,
        "totalTest": totalTest,
        "totalInvoiceReceivedAmount": totalInvoiceReceivedAmount,
        "totalNetAmount": totalNetAmount,
        "totalPaid": totalPaid,
        "lstBusinessCustomerInvoiceForExcel": lstBusinessCustomerInvoiceForExcel == null ? [] : List<dynamic>.from(lstBusinessCustomerInvoiceForExcel!.map((x) => x)),
        "customerTypeName": customerTypeName,
        "totalAmount": totalAmount,
        "deleted": deleted,
        "totalDiscount": totalDiscount,
        "vatAmout": vatAmout,
        "centerName": centerName,
        "invoiceFromDate": invoiceFromDate,
        "toDate": toDate,
        "invoiceDate": invoiceDate,
        "fromDate": fromDate,
        "invoiceToDate": invoiceToDate,
        "invoiceId": invoiceId,
        "status": status,
    };
}
