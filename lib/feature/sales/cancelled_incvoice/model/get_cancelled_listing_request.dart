import 'dart:convert';

class GetCancelReportRequest {
  String? authorization;
  String? organizationId;
  String? shopId;
  String? query;
  List<String>? branch;
  DateTime? dateFrom;
  DateTime? dateTo;

  GetCancelReportRequest({
    this.authorization,
    this.organizationId,
    this.shopId,
    this.query,
    this.branch,
    this.dateFrom,
    this.dateTo,
  });

  factory GetCancelReportRequest.fromRawJson(String str) =>
      GetCancelReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCancelReportRequest.fromJson(Map<String, dynamic> json) =>
      GetCancelReportRequest(
        authorization: json["authorization"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        query: json["query"],
        branch: json["branch"] == null
            ? []
            : List<String>.from(json["branch"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
      );

  Map<String, dynamic> toJson() => {
        "authorization": authorization,
        "organization_id": organizationId,
        "shop_id": shopId,
        "query": query,
        "branch":
            branch == null ? [] : List<dynamic>.from(branch!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
      };
}
