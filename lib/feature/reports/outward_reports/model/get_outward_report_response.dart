import 'dart:convert';

class GetOutwardReportResponse {
  List<GetOutwardReportResponseValue>? values;
  List<GetOutwardReportStoneData>? stoneData;
  GetOutwardReportStoneTotal? stoneTotal;

  GetOutwardReportResponse({
    this.values,
    this.stoneData,
    this.stoneTotal,
  });

  factory GetOutwardReportResponse.fromRawJson(String str) =>
      GetOutwardReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportResponse.fromJson(Map<String, dynamic> json) =>
      GetOutwardReportResponse(
        values: json["values"] == null
            ? []
            : List<GetOutwardReportResponseValue>.from(json["values"]!
                .map((x) => GetOutwardReportResponseValue.fromJson(x))),
        stoneData: json["stone_data"] == null
            ? []
            : List<GetOutwardReportStoneData>.from(json["stone_data"]!
                .map((x) => GetOutwardReportStoneData.fromJson(x))),
        stoneTotal: json["stone_total"] == null
            ? null
            : GetOutwardReportStoneTotal.fromJson(json["stone_total"]),
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

class GetOutwardReportStoneData {
  String? stoneId;
  String? stoneName;
  String? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  GetOutwardReportStoneData({
    this.stoneId,
    this.stoneName,
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory GetOutwardReportStoneData.fromRawJson(String str) =>
      GetOutwardReportStoneData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportStoneData.fromJson(Map<String, dynamic> json) =>
      GetOutwardReportStoneData(
        stoneId: json["stone_id"],
        stoneName: json["stone_name"],
        pieces: json["pieces"],
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "stone_id": stoneId,
        "stone_name": stoneName,
        "pieces": pieces,
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
      };
}

class GetOutwardReportStoneTotal {
  String? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  GetOutwardReportStoneTotal({
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory GetOutwardReportStoneTotal.fromRawJson(String str) =>
      GetOutwardReportStoneTotal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportStoneTotal.fromJson(Map<String, dynamic> json) =>
      GetOutwardReportStoneTotal(
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

class GetOutwardReportResponseValue {
  String? counterId;
  String? counterName;
  Total? total;
  List<GetOutwardReportResponseStockHead>? stockHeads;

  GetOutwardReportResponseValue({
    this.counterId,
    this.counterName,
    this.total,
    this.stockHeads,
  });

  factory GetOutwardReportResponseValue.fromRawJson(String str) =>
      GetOutwardReportResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportResponseValue.fromJson(Map<String, dynamic> json) =>
      GetOutwardReportResponseValue(
        counterId: json["counter_id"],
        counterName: json["counter_name"],
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        stockHeads: json["stock_heads"] == null
            ? []
            : List<GetOutwardReportResponseStockHead>.from(json["stock_heads"]!
                .map((x) => GetOutwardReportResponseStockHead.fromJson(x))),
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

class GetOutwardReportResponseStockHead {
  String? stockHead;
  String? stockHeadName;
  String? stockHeadCode;
  Total? total;
  List<TaggingCode>? taggingCodes;

  GetOutwardReportResponseStockHead({
    this.stockHead,
    this.stockHeadName,
    this.total,
    this.taggingCodes,
    this.stockHeadCode,
  });

  factory GetOutwardReportResponseStockHead.fromRawJson(String str) =>
      GetOutwardReportResponseStockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportResponseStockHead.fromJson(
          Map<String, dynamic> json) =>
      GetOutwardReportResponseStockHead(
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
  String? outwardQt;
  String? outwardNetWeight;
  String? outwardGrossWeight;
  String? outwardAmount;
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
    this.outwardQt,
    this.outwardNetWeight,
    this.outwardGrossWeight,
    this.outwardAmount,
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
        outwardQt: json["outward_qt"],
        outwardNetWeight: json["outward_net_weight"],
        outwardGrossWeight: json["outward_gross_weight"],
        outwardAmount: json["outward_amount"],
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
        "outward_qt": outwardQt,
        "outward_net_weight": outwardNetWeight,
        "outward_gross_weight": outwardGrossWeight,
        "outward_amount": outwardAmount,
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
  String? outwardQt;
  String? outwardNetWeight;
  String? outwardGrossWeight;
  String? outwardAmount;
  String? finalVa;
  String? finalMc;
  String? taggingVa;
  String? taggingMc;
  String? linestoneWeight;
  String? linestoneAmount;

  Total({
    this.outwardQt,
    this.outwardNetWeight,
    this.outwardGrossWeight,
    this.outwardAmount,
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
        outwardQt: json["outward_qt"],
        outwardNetWeight: json["outward_net_weight"],
        outwardGrossWeight: json["outward_gross_weight"],
        outwardAmount: json["outward_amount"],
        finalVa: json["final_va"],
        finalMc: json["final_mc"],
        taggingVa: json["tagging_va"],
        taggingMc: json["tagging_mc"],
        linestoneWeight: json["linestone_weight"],
        linestoneAmount: json["linestone_amount"],
      );

  Map<String, dynamic> toJson() => {
        "outward_qt": outwardQt,
        "outward_net_weight": outwardNetWeight,
        "outward_gross_weight": outwardGrossWeight,
        "outward_amount": outwardAmount,
        "final_va": finalVa,
        "final_mc": finalMc,
        "tagging_va": taggingVa,
        "tagging_mc": taggingMc,
        "linestone_weight": linestoneWeight,
        "linestone_amount": linestoneAmount,
      };
}
