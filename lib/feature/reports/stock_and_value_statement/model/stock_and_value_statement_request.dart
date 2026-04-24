import 'dart:convert';

class StockAndValueStatementReportRequest {
  List<MetalType>? metalType;
  List<String>? purities;
  List<String>? branchIds;
  DateTime? dateFrom;
  DateTime? dateTo;

  StockAndValueStatementReportRequest({
    this.metalType,
    this.purities,
    this.branchIds,
    this.dateFrom,
    this.dateTo,
  });

  factory StockAndValueStatementReportRequest.fromRawJson(String str) =>
      StockAndValueStatementReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockAndValueStatementReportRequest.fromJson(
          Map<String, dynamic> json) =>
      StockAndValueStatementReportRequest(
        metalType: json["metal_type"] == null
            ? []
            : List<MetalType>.from(
                json["metal_type"]!.map((x) => MetalType.fromJson(x))),
        purities: json["purities"] == null
            ? []
            : List<String>.from(json["purities"]!.map((x) => x)),
        branchIds: json["branch_ids"] == null
            ? []
            : List<String>.from(json["branch_ids"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
      );

  Map<String, dynamic> toJson() => {
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x.toJson())),
        "purities":
            purities == null ? [] : List<dynamic>.from(purities!.map((x) => x)),
        "branch_ids": branchIds == null
            ? []
            : List<dynamic>.from(branchIds!.map((x) => x)),
        "date_from":
            "${dateFrom!.year.toString().padLeft(4, '0')}-${dateFrom!.month.toString().padLeft(2, '0')}-${dateFrom!.day.toString().padLeft(2, '0')}",
        "date_to":
            "${dateTo!.year.toString().padLeft(4, '0')}-${dateTo!.month.toString().padLeft(2, '0')}-${dateTo!.day.toString().padLeft(2, '0')}",
      };
}

class MetalType {
  String? id;

  MetalType({
    this.id,
  });

  factory MetalType.fromRawJson(String str) =>
      MetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalType.fromJson(Map<String, dynamic> json) => MetalType(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
