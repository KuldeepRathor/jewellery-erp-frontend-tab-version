import 'dart:convert';

class GetSalesReportDateWiseRequest {
  DateTime? dateFrom;
  DateTime? dateTo;

  GetSalesReportDateWiseRequest({
    this.dateFrom,
    this.dateTo,
  });

  factory GetSalesReportDateWiseRequest.fromRawJson(String str) =>
      GetSalesReportDateWiseRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportDateWiseRequest.fromJson(Map<String, dynamic> json) =>
      GetSalesReportDateWiseRequest(
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
