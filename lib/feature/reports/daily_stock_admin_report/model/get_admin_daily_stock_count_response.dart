import 'dart:convert';

class GetAdminDailyStockCountResponse {
  List<GetAdminDailyStockCountResponseValue>? values;

  GetAdminDailyStockCountResponse({
    this.values,
  });

  factory GetAdminDailyStockCountResponse.fromRawJson(String str) =>
      GetAdminDailyStockCountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAdminDailyStockCountResponse.fromJson(Map<String, dynamic> json) =>
      GetAdminDailyStockCountResponse(
        values: json["values"] == null
            ? []
            : List<GetAdminDailyStockCountResponseValue>.from(json["values"]!
                .map((x) => GetAdminDailyStockCountResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAdminDailyStockCountResponseValue {
  String? counterId;
  String? counterName;
  int? totalCount;
  int? totalManualCount;
  List<StockHead>? stockHeads;

  GetAdminDailyStockCountResponseValue({
    this.counterId,
    this.counterName,
    this.totalCount,
    this.totalManualCount,
    this.stockHeads,
  });

  factory GetAdminDailyStockCountResponseValue.fromRawJson(String str) =>
      GetAdminDailyStockCountResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAdminDailyStockCountResponseValue.fromJson(
          Map<String, dynamic> json) =>
      GetAdminDailyStockCountResponseValue(
        counterId: json["counter_id"],
        counterName: json["counter_name"],
        totalCount: json["total_count"],
        totalManualCount: json["total_manual_count"],
        stockHeads: json["stock_heads"] == null
            ? []
            : List<StockHead>.from(
                json["stock_heads"]!.map((x) => StockHead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "counter_id": counterId,
        "counter_name": counterName,
        "total_count": totalCount,
        "total_manual_count": totalManualCount,
        "stock_heads": stockHeads == null
            ? []
            : List<dynamic>.from(stockHeads!.map((x) => x.toJson())),
      };
}

class StockHead {
  String? stockHeadId;
  String? stockHeadName;
  String? stockHeadCode;
  int? count;
  int? manualCount;

  StockHead({
    this.stockHeadId,
    this.stockHeadName,
    this.stockHeadCode,
    this.count,
    this.manualCount,
  });

  factory StockHead.fromRawJson(String str) =>
      StockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHead.fromJson(Map<String, dynamic> json) => StockHead(
        stockHeadId: json["stock_head_id"],
        stockHeadName: json["stock_head_name"],
        stockHeadCode: json["stock_head_code"],
        count: json["count"],
        manualCount: json["manual_count"],
      );

  Map<String, dynamic> toJson() => {
        "stock_head_id": stockHeadId,
        "stock_head_name": stockHeadName,
        "stock_head_code": stockHeadCode,
        "count": count,
        "manual_count": manualCount,
      };
}
