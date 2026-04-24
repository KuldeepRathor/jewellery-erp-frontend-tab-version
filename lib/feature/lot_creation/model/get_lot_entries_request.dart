import 'dart:convert';

class GetLotEntriesRequest {
  DateTime? dateFrom;
  DateTime? dateTo;
  int? minNetWeight;
  int? maxNetWeight;
  int? minGrossWeight;
  int? maxGrossWeight;
  String? minLotNumber;
  String? maxLotNumber;
  List<String>? purity;
  List<String>? branchIds;
  String? status;

  GetLotEntriesRequest({
    this.dateFrom,
    this.dateTo,
    this.minNetWeight,
    this.maxNetWeight,
    this.minGrossWeight,
    this.maxGrossWeight,
    this.minLotNumber,
    this.maxLotNumber,
    this.purity,
    this.branchIds,
    this.status,
  });

  factory GetLotEntriesRequest.fromRawJson(String str) =>
      GetLotEntriesRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLotEntriesRequest.fromJson(Map<String, dynamic> json) =>
      GetLotEntriesRequest(
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        minNetWeight: json["min_net_weight"],
        maxNetWeight: json["max_net_weight"],
        minGrossWeight: json["min_gross_weight"],
        maxGrossWeight: json["max_gross_weight"],
        minLotNumber: json["min_lot_number"],
        maxLotNumber: json["max_lot_number"],
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        branchIds: json["branch_ids"] == null
            ? []
            : List<String>.from(json["branch_ids"]!.map((x) => x)),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "min_net_weight": minNetWeight,
        "max_net_weight": maxNetWeight,
        "min_gross_weight": minGrossWeight,
        "max_gross_weight": maxGrossWeight,
        "min_lot_number": minLotNumber,
        "max_lot_number": maxLotNumber,
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "branch_ids": branchIds == null
            ? []
            : List<dynamic>.from(branchIds!.map((x) => x)),
        "status": status,
      };
}
