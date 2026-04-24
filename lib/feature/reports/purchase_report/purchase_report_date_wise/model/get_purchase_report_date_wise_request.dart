import 'dart:convert';

class GetPurchaseReportDateWiseRequest {
  DateTime? dateFrom;
  DateTime? dateTo;

  GetPurchaseReportDateWiseRequest({
    this.dateFrom,
    this.dateTo,
  });

  factory GetPurchaseReportDateWiseRequest.fromRawJson(String str) =>
      GetPurchaseReportDateWiseRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReportDateWiseRequest.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReportDateWiseRequest(
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
      );

  Map<String, dynamic> toJson() => {
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
      };
}
