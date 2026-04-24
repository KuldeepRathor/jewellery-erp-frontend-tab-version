import 'dart:convert';

class GetDetailedTaggingItemRequest {
  List<String>? metalTypeIds;
  List<String>? ornamentIds;
  List<String>? weightGroupIds;
  List<String>? stockHeadIds;
  List<String>? designIds;
  List<String>? purities;
  List<String>? counterIds;
  List<String>? vendorIds;
  WeightRange? grossWeightRange;
  WeightRange? nettWeightRange;

  GetDetailedTaggingItemRequest({
    this.metalTypeIds,
    this.ornamentIds,
    this.weightGroupIds,
    this.stockHeadIds,
    this.designIds,
    this.purities,
    this.counterIds,
    this.vendorIds,
    this.grossWeightRange,
    this.nettWeightRange,
  });

  factory GetDetailedTaggingItemRequest.fromRawJson(String str) =>
      GetDetailedTaggingItemRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDetailedTaggingItemRequest.fromJson(Map<String, dynamic> json) =>
      GetDetailedTaggingItemRequest(
        metalTypeIds: json["metal_type_ids"] == null
            ? []
            : List<String>.from(json["metal_type_ids"]!.map((x) => x)),
        ornamentIds: json["ornament_ids"] == null
            ? []
            : List<String>.from(json["ornament_ids"]!.map((x) => x)),
        weightGroupIds: json["weight_group_ids"] == null
            ? []
            : List<String>.from(json["weight_group_ids"]!.map((x) => x)),
        stockHeadIds: json["stock_head_ids"] == null
            ? []
            : List<String>.from(json["stock_head_ids"]!.map((x) => x)),
        designIds: json["design_ids"] == null
            ? []
            : List<String>.from(json["design_ids"]!.map((x) => x)),
        purities: json["purities"] == null
            ? []
            : List<String>.from(json["purities"]!.map((x) => x)),
        counterIds: json["counter_ids"] == null
            ? []
            : List<String>.from(json["counter_ids"]!.map((x) => x)),
        vendorIds: json["vendor_ids"] == null
            ? []
            : List<String>.from(json["vendor_ids"]!.map((x) => x)),
        grossWeightRange: json["gross_weight_range"] == null
            ? null
            : WeightRange.fromJson(json["gross_weight_range"]),
        nettWeightRange: json["nett_weight_range"] == null
            ? null
            : WeightRange.fromJson(json["nett_weight_range"]),
      );

  Map<String, dynamic> toJson() => {
        "metal_type_ids": metalTypeIds == null
            ? []
            : List<dynamic>.from(metalTypeIds!.map((x) => x)),
        "ornament_ids": ornamentIds == null
            ? []
            : List<dynamic>.from(ornamentIds!.map((x) => x)),
        "weight_group_ids": weightGroupIds == null
            ? []
            : List<dynamic>.from(weightGroupIds!.map((x) => x)),
        "stock_head_ids": stockHeadIds == null
            ? []
            : List<dynamic>.from(stockHeadIds!.map((x) => x)),
        "design_ids": designIds == null
            ? []
            : List<dynamic>.from(designIds!.map((x) => x)),
        "purities":
            purities == null ? [] : List<dynamic>.from(purities!.map((x) => x)),
        "counter_ids": counterIds == null
            ? []
            : List<dynamic>.from(counterIds!.map((x) => x)),
        "vendor_ids": vendorIds == null
            ? []
            : List<dynamic>.from(vendorIds!.map((x) => x)),
        "gross_weight_range": grossWeightRange?.toJson(),
        "nett_weight_range": nettWeightRange?.toJson(),
      };
}

class WeightRange {
  int? rangeFrom;
  int? rangeTo;

  WeightRange({
    this.rangeFrom,
    this.rangeTo,
  });

  factory WeightRange.fromRawJson(String str) =>
      WeightRange.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightRange.fromJson(Map<String, dynamic> json) => WeightRange(
        rangeFrom: json["range_from"],
        rangeTo: json["range_to"],
      );

  Map<String, dynamic> toJson() => {
        "range_from": rangeFrom,
        "range_to": rangeTo,
      };
}
