import 'dart:convert';

class GetPaginatedTaggedItemsRequest {
  List<String>? taggedByIds;
  List<String>? branchIds;
  DateRange? dateRange;
  Range? grossWeightRange;
  Range? nettWeightRange;
  Range? lotNumberRange;
  Range? tagRecordNumberRange;

  GetPaginatedTaggedItemsRequest({
    this.taggedByIds,
    this.branchIds,
    this.dateRange,
    this.grossWeightRange,
    this.nettWeightRange,
    this.lotNumberRange,
    this.tagRecordNumberRange,
  });

  factory GetPaginatedTaggedItemsRequest.fromRawJson(String str) =>
      GetPaginatedTaggedItemsRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaginatedTaggedItemsRequest.fromJson(Map<String, dynamic> json) =>
      GetPaginatedTaggedItemsRequest(
        taggedByIds: json["tagged_by_ids"] == null
            ? []
            : List<String>.from(json["tagged_by_ids"]!.map((x) => x)),
        branchIds: json["branch_ids"] == null
            ? []
            : List<String>.from(json["branch_ids"]!.map((x) => x)),
        dateRange: json["date_range"] == null
            ? null
            : DateRange.fromJson(json["date_range"]),
        grossWeightRange: json["gross_weight_range"] == null
            ? null
            : Range.fromJson(json["gross_weight_range"]),
        nettWeightRange: json["nett_weight_range"] == null
            ? null
            : Range.fromJson(json["nett_weight_range"]),
        lotNumberRange: json["lot_number_range"] == null
            ? null
            : Range.fromJson(json["lot_number_range"]),
        tagRecordNumberRange: json["tag_record_number_range"] == null
            ? null
            : Range.fromJson(json["tag_record_number_range"]),
      );

  Map<String, dynamic> toJson() => {
        "tagged_by_ids": taggedByIds == null
            ? []
            : List<dynamic>.from(taggedByIds!.map((x) => x)),
        "branch_ids": branchIds == null
            ? []
            : List<dynamic>.from(branchIds!.map((x) => x)),
        "date_range": dateRange?.toJson(),
        "gross_weight_range": grossWeightRange?.toJson(),
        "nett_weight_range": nettWeightRange?.toJson(),
        "lot_number_range": lotNumberRange?.toJson(),
        "tag_record_number_range": tagRecordNumberRange?.toJson(),
      };
}

class DateRange {
  DateTime? rangeFrom;
  DateTime? rangeTo;

  DateRange({
    this.rangeFrom,
    this.rangeTo,
  });

  factory DateRange.fromRawJson(String str) =>
      DateRange.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DateRange.fromJson(Map<String, dynamic> json) => DateRange(
        rangeFrom: json["range_from"] == null
            ? null
            : DateTime.parse(json["range_from"]),
        rangeTo:
            json["range_to"] == null ? null : DateTime.parse(json["range_to"]),
      );

  Map<String, dynamic> toJson() => {
        "range_from":
            "${rangeFrom!.year.toString().padLeft(4, '0')}-${rangeFrom!.month.toString().padLeft(2, '0')}-${rangeFrom!.day.toString().padLeft(2, '0')}",
        "range_to":
            "${rangeTo!.year.toString().padLeft(4, '0')}-${rangeTo!.month.toString().padLeft(2, '0')}-${rangeTo!.day.toString().padLeft(2, '0')}",
      };
}

class Range {
  String? rangeFrom;
  String? rangeTo;

  Range({
    this.rangeFrom,
    this.rangeTo,
  });

  factory Range.fromRawJson(String str) => Range.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        rangeFrom: json["range_from"],
        rangeTo: json["range_to"],
      );

  Map<String, dynamic> toJson() => {
        "range_from": rangeFrom,
        "range_to": rangeTo,
      };
}
