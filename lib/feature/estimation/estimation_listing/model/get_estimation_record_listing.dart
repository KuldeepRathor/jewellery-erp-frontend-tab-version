import 'dart:convert';

class GetEstimationRecordListing {
  List<GetEstimationRecordValue>? values;
  Pagination? pagination;

  GetEstimationRecordListing({
    this.values,
    this.pagination,
  });

  factory GetEstimationRecordListing.fromRawJson(String str) =>
      GetEstimationRecordListing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEstimationRecordListing.fromJson(Map<String, dynamic> json) =>
      GetEstimationRecordListing(
        values: json["values"] == null
            ? []
            : List<GetEstimationRecordValue>.from(json["values"]!
                .map((x) => GetEstimationRecordValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  dynamic next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class GetEstimationRecordValue {
  String? id;
  String? estimateNumber;
  int? totalPieces;
  String? totalAmount;
  String? oldGoldAmount;
  String? oldGoldNetWeight;
  String? oldGoldGrossWeight;
  String? jewelleryPlanAmount;
  String? advanceBookingAmount;

  GetEstimationRecordValue({
    this.id,
    this.estimateNumber,
    this.totalPieces,
    this.totalAmount,
    this.oldGoldAmount,
    this.oldGoldNetWeight,
    this.oldGoldGrossWeight,
    this.jewelleryPlanAmount,
    this.advanceBookingAmount,
  });

  factory GetEstimationRecordValue.fromRawJson(String str) =>
      GetEstimationRecordValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEstimationRecordValue.fromJson(Map<String, dynamic> json) =>
      GetEstimationRecordValue(
        id: json["id"],
        estimateNumber: json["estimate_number"],
        totalPieces: json["total_pieces"],
        totalAmount: json["total_amount"],
        oldGoldAmount: json["old_gold_amount"],
        oldGoldNetWeight: json["old_gold_net_weight"],
        oldGoldGrossWeight: json["old_gold_gross_weight"],
        jewelleryPlanAmount: json["jewellery_plan_amount"],
        advanceBookingAmount: json["advance_booking_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estimate_number": estimateNumber,
        "total_pieces": totalPieces,
        "total_amount": totalAmount,
        "old_gold_amount": oldGoldAmount,
        "old_gold_net_weight": oldGoldNetWeight,
        "old_gold_gross_weight": oldGoldGrossWeight,
        "jewellery_plan_amount": jewelleryPlanAmount,
        "advance_booking_amount": advanceBookingAmount,
      };
}
