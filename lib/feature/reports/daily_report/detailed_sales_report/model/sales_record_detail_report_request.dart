import 'dart:convert';

class SalesRecordDetailReportRequest {
  List<String>? branch;
  List<int>? metalType;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<String>? users;

  SalesRecordDetailReportRequest({
    this.branch,
    this.metalType,
    this.dateFrom,
    this.dateTo,
    this.users,
  });

  factory SalesRecordDetailReportRequest.fromRawJson(String str) =>
      SalesRecordDetailReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesRecordDetailReportRequest.fromJson(Map<String, dynamic> json) =>
      SalesRecordDetailReportRequest(
        branch: json["branch"] == null
            ? []
            : List<String>.from(json["branch"]!.map((x) => x)),
        metalType: json["metal_type"] == null
            ? []
            : List<int>.from(json["metal_type"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        users: json["users"] == null
            ? []
            : List<String>.from(json["users"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "branch":
            branch == null ? [] : List<dynamic>.from(branch!.map((x) => x)),
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
      };
}
