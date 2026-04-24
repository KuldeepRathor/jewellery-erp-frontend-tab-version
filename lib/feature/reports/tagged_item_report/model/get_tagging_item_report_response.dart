import 'dart:convert';

class GetTaggingItemReportResponse {
  List<GetTaggingItemReportValue>? values;
  List<GetTaggingItemReportStoneData>? stoneData;
  Total? total;
  StoneTotal? stoneTotal;

  GetTaggingItemReportResponse({
    this.values,
    this.stoneData,
    this.total,
    this.stoneTotal,
  });

  factory GetTaggingItemReportResponse.fromRawJson(String str) =>
      GetTaggingItemReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingItemReportResponse.fromJson(Map<String, dynamic> json) =>
      GetTaggingItemReportResponse(
        values: json["values"] == null
            ? []
            : List<GetTaggingItemReportValue>.from(json["values"]!
                .map((x) => GetTaggingItemReportValue.fromJson(x))),
        stoneData: json["stone_data"] == null
            ? []
            : List<GetTaggingItemReportStoneData>.from(json["stone_data"]!
                .map((x) => GetTaggingItemReportStoneData.fromJson(x))),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        stoneTotal: json["stone_total"] == null
            ? null
            : StoneTotal.fromJson(json["stone_total"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "stone_data": stoneData == null
            ? []
            : List<dynamic>.from(stoneData!.map((x) => x.toJson())),
        "total": total?.toJson(),
        "stone_total": stoneTotal?.toJson(),
      };
}

class StoneTotal {
  int? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  StoneTotal({
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory StoneTotal.fromRawJson(String str) =>
      StoneTotal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoneTotal.fromJson(Map<String, dynamic> json) => StoneTotal(
        pieces: json["pieces"],
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "pieces": pieces,
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
      };
}

class Total {
  int? totalPieces;
  String? totalGrossWeight;
  String? totalNetWeight;
  String? totalStoneCts;
  String? totalStoneAmount;
  String? totalVa;

  Total({
    this.totalPieces,
    this.totalGrossWeight,
    this.totalNetWeight,
    this.totalStoneCts,
    this.totalStoneAmount,
    this.totalVa,
  });

  factory Total.fromRawJson(String str) => Total.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        totalPieces: json["total_pieces"],
        totalGrossWeight: json["total_gross_weight"],
        totalNetWeight: json["total_net_weight"],
        totalStoneCts: json["total_stone_cts"],
        totalStoneAmount: json["total_stone_amount"],
        totalVa: json["total_va"],
      );

  Map<String, dynamic> toJson() => {
        "total_pieces": totalPieces,
        "total_gross_weight": totalGrossWeight,
        "total_net_weight": totalNetWeight,
        "total_stone_cts": totalStoneCts,
        "total_stone_amount": totalStoneAmount,
        "total_va": totalVa,
      };
}

class GetTaggingItemReportStoneData {
  String? stoneId;
  String? stoneName;
  int? pieces; // FIXED: Changed from String? to int?
  String? weight;
  String? carat;
  String? totalAmount;

  GetTaggingItemReportStoneData({
    this.stoneId,
    this.stoneName,
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory GetTaggingItemReportStoneData.fromRawJson(String str) =>
      GetTaggingItemReportStoneData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingItemReportStoneData.fromJson(Map<String, dynamic> json) =>
      GetTaggingItemReportStoneData(
        stoneId: json["stone_id"],
        stoneName: json["stone_name"],
        pieces: json["pieces"], // Now correctly parsing as int
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "stone_id": stoneId,
        "stone_name": stoneName,
        "pieces": pieces, // Now correctly encoding as int
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
      };
}

class GetTaggingItemReportValue {
  String? stockHeadName;
  String? stockHeadId;
  List<WeightGroup>? weightGroups;
  Total? total;

  GetTaggingItemReportValue({
    this.stockHeadName,
    this.stockHeadId,
    this.weightGroups,
    this.total,
  });

  factory GetTaggingItemReportValue.fromRawJson(String str) =>
      GetTaggingItemReportValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingItemReportValue.fromJson(Map<String, dynamic> json) =>
      GetTaggingItemReportValue(
        stockHeadName: json["stock_head_name"],
        stockHeadId: json["stock_head_id"],
        weightGroups: json["weight_groups"] == null
            ? []
            : List<WeightGroup>.from(
                json["weight_groups"]!.map((x) => WeightGroup.fromJson(x))),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "stock_head_name": stockHeadName,
        "stock_head_id": stockHeadId,
        "weight_groups": weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x.toJson())),
        "total": total?.toJson(),
      };
}

class WeightGroup {
  String? weightGroupId;
  String? weight;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? stoneCts;
  String? stoneAmount;
  String? va;

  WeightGroup({
    this.weightGroupId,
    this.weight,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.stoneCts,
    this.stoneAmount,
    this.va,
  });

  factory WeightGroup.fromRawJson(String str) =>
      WeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightGroup.fromJson(Map<String, dynamic> json) => WeightGroup(
        weightGroupId: json["weight_group_id"],
        weight: json["weight"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneCts: json["stone_cts"],
        stoneAmount: json["stone_amount"],
        va: json["va"],
      );

  Map<String, dynamic> toJson() => {
        "weight_group_id": weightGroupId,
        "weight": weight,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stone_cts": stoneCts,
        "stone_amount": stoneAmount,
        "va": va,
      };
}
