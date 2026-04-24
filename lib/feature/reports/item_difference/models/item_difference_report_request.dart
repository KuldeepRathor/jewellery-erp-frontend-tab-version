import 'dart:convert';

class ItemDifferenceReportRequest {
  String? organizationId;
  List<String>? metalType;
  List<String>? ornamentType;
  List<String>? weightGroup;
  List<String>? stockHead;
  List<String>? design;
  List<String>? purity;
  List<String>? branch;
  List<String>? counterId;
  List<String>? sizeGroups;
  List<String>? partyId;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<String>? status;
  List<String>? taggedBy;
  int? minRecordNumber;
  int? maxRecordNumber;
  int? minLotNumber;
  int? maxLotNumber;

  ItemDifferenceReportRequest({
    this.organizationId,
    this.metalType,
    this.ornamentType,
    this.weightGroup,
    this.stockHead,
    this.design,
    this.purity,
    this.branch,
    this.counterId,
    this.sizeGroups,
    this.partyId,
    this.dateFrom,
    this.dateTo,
    this.status,
    this.taggedBy,
    this.minRecordNumber,
    this.maxRecordNumber,
    this.minLotNumber,
    this.maxLotNumber,
  });

  factory ItemDifferenceReportRequest.fromRawJson(String str) =>
      ItemDifferenceReportRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemDifferenceReportRequest.fromJson(Map<String, dynamic> json) =>
      ItemDifferenceReportRequest(
        organizationId: json["organization_id"],
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
        ornamentType: json["ornament_type"] == null
            ? []
            : List<String>.from(json["ornament_type"]!.map((x) => x)),
        weightGroup: json["weight_group"] == null
            ? []
            : List<String>.from(json["weight_group"]!.map((x) => x)),
        stockHead: json["stock_head"] == null
            ? []
            : List<String>.from(json["stock_head"]!.map((x) => x)),
        design: json["design"] == null
            ? []
            : List<String>.from(json["design"]!.map((x) => x)),
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        branch: json["branch"] == null
            ? []
            : List<String>.from(json["branch"]!.map((x) => x)),
        counterId: json["counter_id"] == null
            ? []
            : List<String>.from(json["counter_id"]!.map((x) => x)),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<String>.from(json["size_groups"]!.map((x) => x)),
        partyId: json["party_id"] == null
            ? []
            : List<String>.from(json["party_id"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        status: json["status"] == null
            ? []
            : List<String>.from(json["status"]!.map((x) => x)),
        taggedBy: json["tagged_by"] == null
            ? []
            : List<String>.from(json["tagged_by"]!.map((x) => x)),
        minRecordNumber: json["min_record_number"],
        maxRecordNumber: json["max_record_number"],
        minLotNumber: json["min_lot_number"],
        maxLotNumber: json["max_lot_number"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "ornament_type": ornamentType == null
            ? []
            : List<dynamic>.from(ornamentType!.map((x) => x)),
        "weight_group": weightGroup == null
            ? []
            : List<dynamic>.from(weightGroup!.map((x) => x)),
        "stock_head": stockHead == null
            ? []
            : List<dynamic>.from(stockHead!.map((x) => x)),
        "design":
            design == null ? [] : List<dynamic>.from(design!.map((x) => x)),
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "branch":
            branch == null ? [] : List<dynamic>.from(branch!.map((x) => x)),
        "counter_id": counterId == null
            ? []
            : List<dynamic>.from(counterId!.map((x) => x)),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x)),
        "party_id":
            partyId == null ? [] : List<dynamic>.from(partyId!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "status":
            status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
        "tagged_by":
            taggedBy == null ? [] : List<dynamic>.from(taggedBy!.map((x) => x)),
        "min_record_number": minRecordNumber,
        "max_record_number": maxRecordNumber,
        "min_lot_number": minLotNumber,
        "max_lot_number": maxLotNumber,
      };
}
