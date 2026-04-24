import 'dart:convert';

class ItemStatementReportRequest {
  String? type;
  List<String>? metalType;
  List<String>? purity;
  List<String>? stockHead;
  List<String>? weightGroup;
  List<String>? design;
  List<String>? partyType;
  List<String>? branchIds;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<String>? counterId;
  List<String>? vendorIds;
  List<String>? ornamentIds;
  List<int>? status;

  ItemStatementReportRequest({
    this.type,
    this.metalType,
    this.purity,
    this.stockHead,
    this.weightGroup,
    this.design,
    this.partyType,
    this.branchIds,
    this.dateFrom,
    this.dateTo,
    this.counterId,
    this.vendorIds,
    this.ornamentIds,
    this.status,
  });

  factory ItemStatementReportRequest.fromRawJson(String str) =>
      ItemStatementReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemStatementReportRequest.fromJson(Map<String, dynamic> json) =>
      ItemStatementReportRequest(
        type: json["type"],
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        stockHead: json["stock_head"] == null
            ? []
            : List<String>.from(json["stock_head"]!.map((x) => x)),
        weightGroup: json["weight_group"] == null
            ? []
            : List<String>.from(json["weight_group"]!.map((x) => x)),
        design: json["design"] == null
            ? []
            : List<String>.from(json["design"]!.map((x) => x)),
        partyType: json["party_type"] == null
            ? []
            : List<String>.from(json["party_type"]!.map((x) => x)),
        branchIds: json["branch_ids"] == null
            ? []
            : List<String>.from(json["branch_ids"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        counterId: json["counter_id"] == null
            ? []
            : List<String>.from(json["counter_id"]!.map((x) => x)),
        vendorIds: json["vendor_ids"] == null
            ? []
            : List<String>.from(json["vendor_ids"]!.map((x) => x)),
        ornamentIds: json["ornament_ids"] == null
            ? []
            : List<String>.from(json["ornament_ids"]!.map((x) => x)),
        status: json["status"] == null
            ? []
            : List<int>.from(json["status"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "stock_head": stockHead == null
            ? []
            : List<dynamic>.from(stockHead!.map((x) => x)),
        "weight_group": weightGroup == null
            ? []
            : List<dynamic>.from(weightGroup!.map((x) => x)),
        "design":
            design == null ? [] : List<dynamic>.from(design!.map((x) => x)),
        "party_type": partyType == null
            ? []
            : List<dynamic>.from(partyType!.map((x) => x)),
        "branch_ids": branchIds == null
            ? []
            : List<dynamic>.from(branchIds!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "counter_id": counterId == null
            ? []
            : List<dynamic>.from(counterId!.map((x) => x)),
        "vendor_ids": vendorIds == null
            ? []
            : List<dynamic>.from(vendorIds!.map((x) => x)),
        "ornament_ids": ornamentIds == null
            ? []
            : List<dynamic>.from(ornamentIds!.map((x) => x)),
        "status":
            status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
      };
}
