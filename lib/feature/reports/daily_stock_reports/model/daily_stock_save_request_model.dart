import 'dart:convert';

class DailyStockSaveRequestModel {
  String? date;
  String? counterId;
  List<LineItem>? lineItems;

  DailyStockSaveRequestModel({
    this.date,
    this.counterId,
    this.lineItems,
  });

  factory DailyStockSaveRequestModel.fromRawJson(String str) =>
      DailyStockSaveRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyStockSaveRequestModel.fromJson(Map<String, dynamic> json) =>
      DailyStockSaveRequestModel(
        date: json["date"],
        counterId: json["counter_id"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "counter_id": counterId,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? stockHeadId;
  int? count;
  int? manualCount;

  LineItem({
    this.stockHeadId,
    this.count,
    this.manualCount,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        stockHeadId: json["stock_head_id"],
        count: json["count"],
        manualCount: json["manual_count"],
      );

  Map<String, dynamic> toJson() => {
        "stock_head_id": stockHeadId,
        "count": count,
        "manual_count": manualCount,
      };
}
