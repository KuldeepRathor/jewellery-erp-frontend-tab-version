import 'dart:convert';

class GetInwardReportResponse {
  List<GetInwardReportResponseValue>? values;
  List<GetInwardReportStoneData>? stoneData;
  GetInwardReportStoneTotal? stoneTotal;

  GetInwardReportResponse({
    this.values,
    this.stoneData,
    this.stoneTotal,
  });

  factory GetInwardReportResponse.fromRawJson(String str) =>
      GetInwardReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetInwardReportResponse.fromJson(Map<String, dynamic> json) =>
      GetInwardReportResponse(
        values: json["values"] == null
            ? []
            : List<GetInwardReportResponseValue>.from(json["values"]!
                .map((x) => GetInwardReportResponseValue.fromJson(x))),
        stoneData: json["stone_data"] == null
            ? []
            : List<GetInwardReportStoneData>.from(json["stone_data"]!
                .map((x) => GetInwardReportStoneData.fromJson(x))),
        stoneTotal: json["stone_total"] == null
            ? null
            : GetInwardReportStoneTotal.fromJson(json["stone_total"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "stone_data": stoneData == null
            ? []
            : List<dynamic>.from(stoneData!.map((x) => x.toJson())),
        "stone_total": stoneTotal?.toJson(),
      };
}

class GetInwardReportStoneData {
  String? stoneId;
  String? stoneCode;
  String? stoneName;
  String? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  GetInwardReportStoneData({
    this.stoneId,
    this.stoneCode,
    this.stoneName,
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory GetInwardReportStoneData.fromRawJson(String str) =>
      GetInwardReportStoneData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetInwardReportStoneData.fromJson(Map<String, dynamic> json) =>
      GetInwardReportStoneData(
        stoneId: json["stone_id"],
        stoneCode: json["stone_code"],
        stoneName: json["stone_name"],
        pieces: json["pieces"],
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "stone_id": stoneId,
        "stone_code": stoneCode,
        "stone_name": stoneName,
        "pieces": pieces,
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
      };
}

class GetInwardReportStoneTotal {
  String? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  GetInwardReportStoneTotal({
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory GetInwardReportStoneTotal.fromRawJson(String str) =>
      GetInwardReportStoneTotal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetInwardReportStoneTotal.fromJson(Map<String, dynamic> json) =>
      GetInwardReportStoneTotal(
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

class GetInwardReportResponseValue {
  dynamic counterId;
  dynamic counterName;
  Total? total;
  List<StockHead>? stockHeads;

  GetInwardReportResponseValue({
    this.counterId,
    this.counterName,
    this.total,
    this.stockHeads,
  });

  factory GetInwardReportResponseValue.fromRawJson(String str) =>
      GetInwardReportResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetInwardReportResponseValue.fromJson(Map<String, dynamic> json) =>
      GetInwardReportResponseValue(
        counterId: json["counter_id"],
        counterName: json["counter_name"],
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        stockHeads: json["stock_heads"] == null
            ? []
            : List<StockHead>.from(
                json["stock_heads"]!.map((x) => StockHead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "counter_id": counterId,
        "counter_name": counterName,
        "total": total?.toJson(),
        "stock_heads": stockHeads == null
            ? []
            : List<dynamic>.from(stockHeads!.map((x) => x.toJson())),
      };
}

class StockHead {
  String? stockHead;
  String? stockHeadName;
  String? stockHeadCode;
  Total? total;
  List<TaggingCode>? taggingCodes;

  StockHead({
    this.stockHead,
    this.stockHeadName,
    this.stockHeadCode,
    this.total,
    this.taggingCodes,
  });

  factory StockHead.fromRawJson(String str) =>
      StockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHead.fromJson(Map<String, dynamic> json) => StockHead(
        stockHead: json["stock_head"],
        stockHeadName: json["stock_head_name"],
        stockHeadCode: json["stock_head_code"],
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        taggingCodes: json["tagging_codes"] == null
            ? []
            : List<TaggingCode>.from(
                json["tagging_codes"]!.map((x) => TaggingCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stock_head": stockHead,
        "stock_head_name": stockHeadName,
        "stock_head_code": stockHeadCode,
        "total": total?.toJson(),
        "tagging_codes": taggingCodes == null
            ? []
            : List<dynamic>.from(taggingCodes!.map((x) => x.toJson())),
      };
}

class TaggingCode {
  String? taggingCode;
  String? inwardQt;
  String? inwardNetWeight;
  String? inwardGrossWeight;
  String? inwardAmount;
  String? finalVa;
  String? finalMc;
  String? taggingVa;
  String? taggingMc;
  String? linestoneWeight;
  String? linestoneAmount;
  String? weightGroupName;
  String? codeType;
  String? codeId;

  TaggingCode({
    this.taggingCode,
    this.inwardQt,
    this.inwardNetWeight,
    this.inwardGrossWeight,
    this.inwardAmount,
    this.finalVa,
    this.finalMc,
    this.taggingVa,
    this.taggingMc,
    this.linestoneWeight,
    this.linestoneAmount,
    this.weightGroupName,
    this.codeType,
    this.codeId,
  });

  factory TaggingCode.fromRawJson(String str) =>
      TaggingCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggingCode.fromJson(Map<String, dynamic> json) => TaggingCode(
        taggingCode: json["tagging_code"],
        inwardQt: json["inward_qt"],
        inwardNetWeight: json["inward_net_weight"],
        inwardGrossWeight: json["inward_gross_weight"],
        inwardAmount: json["inward_amount"],
        finalVa: json["final_va"],
        finalMc: json["final_mc"],
        taggingVa: json["tagging_va"],
        taggingMc: json["tagging_mc"],
        linestoneWeight: json["linestone_weight"],
        linestoneAmount: json["linestone_amount"],
        weightGroupName: json["weight_group_name"],
        codeType: json["code_type"],
        codeId: json["code_id"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_code": taggingCode,
        "inward_qt": inwardQt,
        "inward_net_weight": inwardNetWeight,
        "inward_gross_weight": inwardGrossWeight,
        "inward_amount": inwardAmount,
        "final_va": finalVa,
        "final_mc": finalMc,
        "tagging_va": taggingVa,
        "tagging_mc": taggingMc,
        "linestone_weight": linestoneWeight,
        "linestone_amount": linestoneAmount,
        "weight_group_name": weightGroupName,
        "code_type": codeType,
        "code_id": codeId,
      };
}

class Total {
  String? inwardQt;
  String? inwardNetWeight;
  String? inwardGrossWeight;
  String? inwardAmount;
  String? finalVa;
  String? finalMc;
  String? taggingVa;
  String? taggingMc;
  String? linestoneWeight;
  String? linestoneAmount;

  Total({
    this.inwardQt,
    this.inwardNetWeight,
    this.inwardGrossWeight,
    this.inwardAmount,
    this.finalVa,
    this.finalMc,
    this.taggingVa,
    this.taggingMc,
    this.linestoneWeight,
    this.linestoneAmount,
  });

  factory Total.fromRawJson(String str) => Total.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        inwardQt: json["inward_qt"],
        inwardNetWeight: json["inward_net_weight"],
        inwardGrossWeight: json["inward_gross_weight"],
        inwardAmount: json["inward_amount"],
        finalVa: json["final_va"],
        finalMc: json["final_mc"],
        taggingVa: json["tagging_va"],
        taggingMc: json["tagging_mc"],
        linestoneWeight: json["linestone_weight"],
        linestoneAmount: json["linestone_amount"],
      );

  Map<String, dynamic> toJson() => {
        "inward_qt": inwardQt,
        "inward_net_weight": inwardNetWeight,
        "inward_gross_weight": inwardGrossWeight,
        "inward_amount": inwardAmount,
        "final_va": finalVa,
        "final_mc": finalMc,
        "tagging_va": taggingVa,
        "tagging_mc": taggingMc,
        "linestone_weight": linestoneWeight,
        "linestone_amount": linestoneAmount,
      };
}
