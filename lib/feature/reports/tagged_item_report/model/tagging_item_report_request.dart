import 'dart:convert';

class TaggingItemReportRequest {
  List<String>? metalType;
  List<String>? stockHead;
  List<String>? weightGroup;
  List<String>? design;
  List<String>? partyId;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<String>? counterId;
  List<String>? purity;
  List<String>? status;
  List<String>? taggedBy;
  List<String>? ornamentType;
  List<String>? branch;
  List<String>? sizeGroups;
  int? minNetWeight;
  int? maxNetWeight;
  int? minGrossWeight;
  int? maxGrossWeight;
  String? minRecordNumber;
  String? maxRecordNumber;
  String? minLotNumber;
  String? maxLotNumber;

  TaggingItemReportRequest({
    this.metalType,
    this.stockHead,
    this.weightGroup,
    this.design,
    this.partyId,
    this.dateFrom,
    this.dateTo,
    this.counterId,
    this.purity,
    this.status,
    this.taggedBy,
    this.ornamentType,
    this.branch,
    this.sizeGroups,
    this.minNetWeight,
    this.maxNetWeight,
    this.minGrossWeight,
    this.maxGrossWeight,
    this.minRecordNumber,
    this.maxRecordNumber,
    this.minLotNumber,
    this.maxLotNumber,
  });

  factory TaggingItemReportRequest.fromRawJson(String str) =>
      TaggingItemReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggingItemReportRequest.fromJson(Map<String, dynamic> json) =>
      TaggingItemReportRequest(
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
        stockHead: json["stock_head"] == null
            ? []
            : List<String>.from(json["stock_head"]!.map((x) => x)),
        weightGroup: json["weight_group"] == null
            ? []
            : List<String>.from(json["weight_group"]!.map((x) => x)),
        design: json["design"] == null
            ? []
            : List<String>.from(json["design"]!.map((x) => x)),
        partyId: json["party_id"] == null
            ? []
            : List<String>.from(json["party_id"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        counterId: json["counter_id"] == null
            ? []
            : List<String>.from(json["counter_id"]!.map((x) => x)),
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        status: json["status"] == null
            ? []
            : List<String>.from(json["status"]!.map((x) => x)),
        taggedBy: json["tagged_by"] == null
            ? []
            : List<String>.from(json["tagged_by"]!.map((x) => x)),
        ornamentType: json["ornament_type"] == null
            ? []
            : List<String>.from(json["ornament_type"]!.map((x) => x)),
        branch: json["branch"] == null
            ? []
            : List<String>.from(json["branch"]!.map((x) => x)),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<String>.from(json["size_groups"]!.map((x) => x)),
        minNetWeight: json["min_net_weight"],
        maxNetWeight: json["max_net_weight"],
        minGrossWeight: json["min_gross_weight"],
        maxGrossWeight: json["max_gross_weight"],
        minRecordNumber: json["min_record_number"],
        maxRecordNumber: json["max_record_number"],
        minLotNumber: json["min_lot_number"],
        maxLotNumber: json["max_lot_number"],
      );

  Map<String, dynamic> toJson() => {
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "stock_head": stockHead == null
            ? []
            : List<dynamic>.from(stockHead!.map((x) => x)),
        "weight_group": weightGroup == null
            ? []
            : List<dynamic>.from(weightGroup!.map((x) => x)),
        "design":
            design == null ? [] : List<dynamic>.from(design!.map((x) => x)),
        "party_id":
            partyId == null ? [] : List<dynamic>.from(partyId!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "counter_id": counterId == null
            ? []
            : List<dynamic>.from(counterId!.map((x) => x)),
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "status":
            status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
        "tagged_by":
            taggedBy == null ? [] : List<dynamic>.from(taggedBy!.map((x) => x)),
        "ornament_type": ornamentType == null
            ? []
            : List<dynamic>.from(ornamentType!.map((x) => x)),
        "branch":
            branch == null ? [] : List<dynamic>.from(branch!.map((x) => x)),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x)),
        "min_net_weight": minNetWeight,
        "max_net_weight": maxNetWeight,
        "min_gross_weight": minGrossWeight,
        "max_gross_weight": maxGrossWeight,
        "min_record_number": minRecordNumber,
        "max_record_number": maxRecordNumber,
        "min_lot_number": minLotNumber,
        "max_lot_number": maxLotNumber,
      };
}
