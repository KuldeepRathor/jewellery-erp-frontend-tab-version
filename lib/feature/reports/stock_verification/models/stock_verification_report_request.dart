import 'dart:convert';

class StockVerificationReportRequest {
  List<String>? metalType;
  List<String>? ornamentIds;
  List<String>? stockHeadIds;
  List<String>? weightGroupIds;
  List<String>? designIds;
  List<String>? purity;
  List<String>? counterIds;
  List<String>? vendorIds;
  List<String>? taggedByIds;
  int? minNetWeight;
  int? maxNetWeight;
  int? minGrossWeight;
  int? maxGrossWeight;
  DateTime? dateFrom;
  DateTime? dateTo;
  String? minRecordNumber;
  String? maxRecordNumber;
  StockType? stockType;

  StockVerificationReportRequest({
    this.metalType,
    this.ornamentIds,
    this.stockHeadIds,
    this.weightGroupIds,
    this.designIds,
    this.purity,
    this.counterIds,
    this.vendorIds,
    this.taggedByIds,
    this.minNetWeight,
    this.maxNetWeight,
    this.minGrossWeight,
    this.maxGrossWeight,
    this.dateFrom,
    this.dateTo,
    this.minRecordNumber,
    this.maxRecordNumber,
    this.stockType,
  });

  factory StockVerificationReportRequest.fromRawJson(String str) =>
      StockVerificationReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockVerificationReportRequest.fromJson(Map<String, dynamic> json) =>
      StockVerificationReportRequest(
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
        ornamentIds: json["ornament_ids"] == null
            ? []
            : List<String>.from(json["ornament_ids"]!.map((x) => x)),
        stockHeadIds: json["stock_head_ids"] == null
            ? []
            : List<String>.from(json["stock_head_ids"]!.map((x) => x)),
        weightGroupIds: json["weight_group_ids"] == null
            ? []
            : List<String>.from(json["weight_group_ids"]!.map((x) => x)),
        designIds: json["design_ids"] == null
            ? []
            : List<String>.from(json["design_ids"]!.map((x) => x)),
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        counterIds: json["counter_ids"] == null
            ? []
            : List<String>.from(json["counter_ids"]!.map((x) => x)),
        vendorIds: json["vendor_ids"] == null
            ? []
            : List<String>.from(json["vendor_ids"]!.map((x) => x)),
        taggedByIds: json["tagged_by_ids"] == null
            ? []
            : List<String>.from(json["tagged_by_ids"]!.map((x) => x)),
        stockType: json["stock_type"] == null
            ? null
            : StockType.fromJson(json["stock_type"]),
        minNetWeight: json["min_net_weight"],
        maxNetWeight: json["max_net_weight"],
        minGrossWeight: json["min_gross_weight"],
        maxGrossWeight: json["max_gross_weight"],
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        minRecordNumber: json["min_record_number"],
        maxRecordNumber: json["max_record_number"],
      );

  // Fix for the toJson() method in StockVerificationReportRequest.dart
  Map<String, dynamic> toJson() => {
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "ornament_ids": ornamentIds == null
            ? []
            : List<dynamic>.from(ornamentIds!.map((x) => x)),
        "stock_head_ids": stockHeadIds == null
            ? []
            : List<dynamic>.from(stockHeadIds!.map((x) => x)),
        "weight_group_ids": weightGroupIds == null
            ? []
            : List<dynamic>.from(weightGroupIds!.map((x) => x)),
        "design_ids": designIds == null
            ? []
            : List<dynamic>.from(designIds!.map((x) => x)),
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "counter_ids": counterIds == null
            ? []
            : List<dynamic>.from(counterIds!.map((x) => x)),
        "vendor_ids": vendorIds == null
            ? []
            : List<dynamic>.from(vendorIds!.map((x) => x)),
        "tagged_by_ids": taggedByIds == null
            ? []
            : List<dynamic>.from(taggedByIds!.map((x) => x)),
        "min_net_weight": minNetWeight,
        "max_net_weight": maxNetWeight,
        "min_gross_weight": minGrossWeight,
        "max_gross_weight": maxGrossWeight,
        // Fix: Only add date_from if it's not null
        if (dateFrom != null)
          "date_from":
              "${dateFrom!.year.toString().padLeft(4, '0')}-${dateFrom!.month.toString().padLeft(2, '0')}-${dateFrom!.day.toString().padLeft(2, '0')}",
        // Fix: Only add date_to if it's not null
        if (dateTo != null)
          "date_to":
              "${dateTo!.year.toString().padLeft(4, '0')}-${dateTo!.month.toString().padLeft(2, '0')}-${dateTo!.day.toString().padLeft(2, '0')}",
        "min_record_number": minRecordNumber,
        "max_record_number": maxRecordNumber,
        "stock_type": stockType?.toJson(),
      };
}

class StockType {
  bool? live;
  bool? order;
  bool? approval;

  StockType({
    this.live,
    this.order,
    this.approval,
  });

  factory StockType.fromRawJson(String str) =>
      StockType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockType.fromJson(Map<String, dynamic> json) => StockType(
        live: json["live"],
        order: json["order"],
        approval: json["approval"],
      );

  Map<String, dynamic> toJson() => {
        "live": live,
        "order": order,
        "approval": approval,
      };
}
