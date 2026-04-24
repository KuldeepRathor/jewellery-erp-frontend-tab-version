import 'dart:convert';

ItemStatementReportResponseModel itemStatementReportResponseModelFromJson(
        String str) =>
    ItemStatementReportResponseModel.fromJson(json.decode(str));

String itemStatementReportResponseModelToJson(
        ItemStatementReportResponseModel data) =>
    json.encode(data.toJson());

class ItemStatementReportResponseModel {
  final List<ItemValue>? values;

  ItemStatementReportResponseModel({
    this.values,
  });

  ItemStatementReportResponseModel copyWith({
    List<ItemValue>? values,
  }) =>
      ItemStatementReportResponseModel(
        values: values ?? this.values,
      );

  factory ItemStatementReportResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ItemStatementReportResponseModel(
        values: json["values"] == null
            ? []
            : List<ItemValue>.from(
                json["values"]!.map((x) => ItemValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class ItemValue {
  final String? counterId;
  final String? counterName;
  final Total? total;
  final List<StockHead>? stockHeads;

  ItemValue({
    this.counterId,
    this.counterName,
    this.total,
    this.stockHeads,
  });

  ItemValue copyWith({
    String? counterId,
    String? counterName,
    Total? total,
    List<StockHead>? stockHeads,
  }) =>
      ItemValue(
        counterId: counterId ?? this.counterId,
        counterName: counterName ?? this.counterName,
        total: total ?? this.total,
        stockHeads: stockHeads ?? this.stockHeads,
      );

  factory ItemValue.fromJson(Map<String, dynamic> json) => ItemValue(
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
  String? weightGroupName;
  String? stockHeadCode;
  Total? total;
  List<Total>? taggingCodes;
  String? diffNetWeight;
  String? diffGrossWeight;

  StockHead({
    this.stockHead,
    this.stockHeadName,
    this.weightGroupName,
    this.stockHeadCode,
    this.total,
    this.taggingCodes,
    this.diffNetWeight,
    this.diffGrossWeight,
  });

  factory StockHead.fromRawJson(String str) =>
      StockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHead.fromJson(Map<String, dynamic> json) => StockHead(
        stockHead: json["stock_head"],
        stockHeadName: json["stock_head_name"],
        weightGroupName: json["weight_group_name"],
        stockHeadCode: json["stock_head_code"],
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        taggingCodes: json["tagging_codes"] == null
            ? []
            : List<Total>.from(
                json["tagging_codes"]!.map((x) => Total.fromJson(x))),
        diffNetWeight: json["diff_net_weight"],
        diffGrossWeight: json["diff_gross_weight"],
      );

  Map<String, dynamic> toJson() => {
        "stock_head": stockHead,
        "stock_head_name": stockHeadName,
        "weight_group_name": weightGroupName,
        "stock_head_code": stockHeadCode,
        "total": total?.toJson(),
        "tagging_codes": taggingCodes == null
            ? []
            : List<dynamic>.from(taggingCodes!.map((x) => x.toJson())),
        "diff_net_weight": diffNetWeight,
        "diff_gross_weight": diffGrossWeight,
      };
}

class Total {
  String? taggingCode;
  String? codeId;
  String? code;
  String? codeType;
  String? openingQuantity;
  String? openingNetWeight;
  String? openingGrossWeight;
  String? openingAmount;
  String? inwardQt;
  String? outwardQt;
  String? inwardNetWeight;
  String? outwardNetWeight;
  String? inwardGrossWeight;
  String? outwardGrossWeight;
  String? inwardAmount;
  String? outwardAmount;
  String? closingQt;
  String? closingNetWeight;
  String? closingGrossWeight;
  String? closingAmount;
  String? outwardStockIssueQuantity;
  String? outwardStockIssueNetWeight;
  String? outwardStockIssueGrossWeight;
  String? outwardStockIssueAmount;
  String? diffNetWeight;
  String? diffGrossWeight;

  Total({
    this.taggingCode,
    this.codeId,
    this.code,
    this.codeType,
    this.openingQuantity,
    this.openingNetWeight,
    this.openingGrossWeight,
    this.openingAmount,
    this.inwardQt,
    this.outwardQt,
    this.inwardNetWeight,
    this.outwardNetWeight,
    this.inwardGrossWeight,
    this.outwardGrossWeight,
    this.inwardAmount,
    this.outwardAmount,
    this.closingQt,
    this.closingNetWeight,
    this.closingGrossWeight,
    this.closingAmount,
    this.outwardStockIssueQuantity,
    this.outwardStockIssueNetWeight,
    this.outwardStockIssueGrossWeight,
    this.outwardStockIssueAmount,
    this.diffNetWeight,
    this.diffGrossWeight,
  });

  factory Total.fromRawJson(String str) => Total.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        taggingCode: json["tagging_code"],
        codeId: json["code_id"],
        code: json["code"],
        codeType: json["code_type"],
        openingQuantity: json["opening_quantity"],
        openingNetWeight: json["opening_net_weight"],
        openingGrossWeight: json["opening_gross_weight"],
        openingAmount: json["opening_amount"],
        inwardQt: json["inward_qt"],
        outwardQt: json["outward_qt"],
        inwardNetWeight: json["inward_net_weight"],
        outwardNetWeight: json["outward_net_weight"],
        inwardGrossWeight: json["inward_gross_weight"],
        outwardGrossWeight: json["outward_gross_weight"],
        inwardAmount: json["inward_amount"],
        outwardAmount: json["outward_amount"],
        closingQt: json["closing_qt"],
        closingNetWeight: json["closing_net_weight"],
        closingGrossWeight: json["closing_gross_weight"],
        closingAmount: json["closing_amount"],
        outwardStockIssueQuantity: json["outward_stock_issue_quantity"],
        outwardStockIssueNetWeight: json["outward_stock_issue_net_weight"],
        outwardStockIssueGrossWeight: json["outward_stock_issue_gross_weight"],
        outwardStockIssueAmount: json["outward_stock_issue_amount"],
        diffNetWeight: json["diff_net_weight"],
        diffGrossWeight: json["diff_gross_weight"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_code": taggingCode,
        "code_id": codeId,
        "code": code,
        "code_type": codeType,
        "opening_quantity": openingQuantity,
        "opening_net_weight": openingNetWeight,
        "opening_gross_weight": openingGrossWeight,
        "opening_amount": openingAmount,
        "inward_qt": inwardQt,
        "outward_qt": outwardQt,
        "inward_net_weight": inwardNetWeight,
        "outward_net_weight": outwardNetWeight,
        "inward_gross_weight": inwardGrossWeight,
        "outward_gross_weight": outwardGrossWeight,
        "inward_amount": inwardAmount,
        "outward_amount": outwardAmount,
        "closing_qt": closingQt,
        "closing_net_weight": closingNetWeight,
        "closing_gross_weight": closingGrossWeight,
        "closing_amount": closingAmount,
        "outward_stock_issue_quantity": outwardStockIssueQuantity,
        "outward_stock_issue_net_weight": outwardStockIssueNetWeight,
        "outward_stock_issue_gross_weight": outwardStockIssueGrossWeight,
        "outward_stock_issue_amount": outwardStockIssueAmount,
        "diff_net_weight": diffNetWeight,
        "diff_gross_weight": diffGrossWeight,
      };
}
