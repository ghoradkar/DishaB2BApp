class DashboardCountModel {
  String? status;
  String? message;
  int? patientId;
  List<OutputData>? output;

  DashboardCountModel({
    this.status,
    this.message,
    this.patientId,
    this.output,
  });

  factory DashboardCountModel.fromJson(Map<String, dynamic> json) {
    return DashboardCountModel(
      status: json['status'],
      message: json['message'],
      patientId: json['patientId'],
      output: json['output'] != null
          ? List<OutputData>.from(
              json['output'].map((x) => OutputData.fromJson(x)))
          : null,
    );
  }
}

class OutputData {
  String? customerType;
  int? customerId;
  int? userId;
  int? unitId;
  int? patientRegistered;
  int? servicesRegistered;
  int? approvalPending;
  int? homeVisits;
  String? userType;
  String? fromDate;
  String? toDate;
  double? grossAmount;
  double? discountAmount;
  double? netAmount;
  double? receivedAmount;

  List<DeptCountRevenue>? lstDeptCountRevenue;
  List<DailyCountRevenue>? lstDailycountRevenue;
  List<DailyServicesCount>? lstDailyServicesCount;

  int? btoCCount;
  int? btoBCount;

  OutputData({
    this.customerType,
    this.customerId,
    this.userId,
    this.unitId,
    this.patientRegistered,
    this.servicesRegistered,
    this.approvalPending,
    this.homeVisits,
    this.userType,
    this.fromDate,
    this.toDate,
    this.grossAmount,
    this.discountAmount,
    this.netAmount,
    this.receivedAmount,
    this.lstDeptCountRevenue,
    this.lstDailycountRevenue,
    this.lstDailyServicesCount,
    this.btoCCount,
    this.btoBCount,
  });

  factory OutputData.fromJson(Map<String, dynamic> json) {
    return OutputData(
      customerType: json['customerType'],
      customerId: json['customerId'],
      userId: json['userId'],
      unitId: json['unitId'],
      patientRegistered: json['patientRegistered'],
      servicesRegistered: json['servicesRegistered'],
      approvalPending: json['approvalPending'],
      homeVisits: json['homeVisits'],
      userType: json['userType'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      grossAmount: (json['grossAmount'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      netAmount: (json['netAmount'] ?? 0).toDouble(),
      receivedAmount: (json['receivedAmount'] ?? 0).toDouble(),
      lstDeptCountRevenue: json['lstDeptCountRevenue'] != null
          ? List<DeptCountRevenue>.from(json['lstDeptCountRevenue']
              .map((x) => DeptCountRevenue.fromJson(x)))
          : null,
      lstDailycountRevenue: json['lstDailycountRevenue'] != null
          ? List<DailyCountRevenue>.from(json['lstDailycountRevenue']
              .map((x) => DailyCountRevenue.fromJson(x)))
          : null,
      lstDailyServicesCount: json['lstDailyServicesCount'] != null
          ? List<DailyServicesCount>.from(json['lstDailyServicesCount']
              .map((x) => DailyServicesCount.fromJson(x)))
          : null,
      btoCCount: json['btoCCount'],
      btoBCount: json['btoBCount'],
    );
  }
}

class DeptCountRevenue {
  int? id;
  int? deptCount;
  String? deptName;
  double? deptAmount;

  DeptCountRevenue({
    this.id,
    this.deptCount,
    this.deptName,
    this.deptAmount,
  });

  factory DeptCountRevenue.fromJson(Map<String, dynamic> json) {
    return DeptCountRevenue(
      id: json['id'],
      deptCount: json['deptCount'],
      deptName: json['deptName'],
      deptAmount: (json['deptAmount'] ?? 0).toDouble(),
    );
  }
}

class DailyCountRevenue {
  int? id;
  int? patientCount;
  String? date;
  double? amount;

  DailyCountRevenue({
    this.id,
    this.patientCount,
    this.date,
    this.amount,
  });

  factory DailyCountRevenue.fromJson(Map<String, dynamic> json) {
    return DailyCountRevenue(
      id: json['id'],
      patientCount: json['patientCount'],
      date: json['date'],
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class DailyServicesCount {
  String? date;
  int? serviceCount;
  double? amount;
  int? treatmentCount;
  double? avgCount;

  DailyServicesCount({
    this.date,
    this.serviceCount,
    this.amount,
    this.treatmentCount,
    this.avgCount,
  });

  factory DailyServicesCount.fromJson(Map<String, dynamic> json) {
    return DailyServicesCount(
      date: json['date'],
      serviceCount: json['serviceCount'],
      amount: (json['amount'] ?? 0).toDouble(),
      treatmentCount: json['treatmentCount'],
      avgCount: (json['avgCount'] ?? 0).toDouble(),
    );
  }
}
