import 'dart:convert';

class ItemDifferenceReportResponse {
  List<ItemDifferenceReportValue>? values;
  int? totalPieces;
  String? totalSalesWeight;
  String? totalActualWeight;
  String? totalDifference;
  String? totalAmount;

  ItemDifferenceReportResponse({
    this.values,
    this.totalPieces,
    this.totalSalesWeight,
    this.totalActualWeight,
    this.totalDifference,
    this.totalAmount,
  });

  factory ItemDifferenceReportResponse.fromRawJson(String str) =>
      ItemDifferenceReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemDifferenceReportResponse.fromJson(Map<String, dynamic> json) =>
      ItemDifferenceReportResponse(
        values: json["values"] == null
            ? []
            : List<ItemDifferenceReportValue>.from(json["values"]!
                .map((x) => ItemDifferenceReportValue.fromJson(x))),
        totalPieces: json["total_pieces"],
        totalSalesWeight: json["total_sales_weight"],
        totalActualWeight: json["total_actual_weight"],
        totalDifference: json["total_difference"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "total_pieces": totalPieces,
        "total_sales_weight": totalSalesWeight,
        "total_actual_weight": totalActualWeight,
        "total_difference": totalDifference,
        "total_amount": totalAmount,
      };
}

class ItemDifferenceReportValue {
  DateTime? createdAt;
  String? code;
  String? tag;
  String? tagBarcode;
  String? description;
  String? salesWeight;
  String? actualWeight;
  String? difference;
  String? amount;
  int? pieces;
  String? saleNumber;
  String? partyId;
  String? partyName;
  String? grossWeight;
  String? stoneCost;
  String? counterName;
  String? ornament;
  String? stockHead;

  ItemDifferenceReportValue({
    this.createdAt,
    this.code,
    this.tag,
    this.tagBarcode,
    this.description,
    this.salesWeight,
    this.actualWeight,
    this.difference,
    this.amount,
    this.pieces,
    this.saleNumber,
    this.partyId,
    this.partyName,
    this.grossWeight,
    this.stoneCost,
    this.counterName,
    this.ornament,
    this.stockHead,
  });

  factory ItemDifferenceReportValue.fromRawJson(String str) =>
      ItemDifferenceReportValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemDifferenceReportValue.fromJson(Map<String, dynamic> json) =>
      ItemDifferenceReportValue(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        code: json["code"],
        tag: json["tag"],
        tagBarcode: json["tag_barcode"],
        description: json["description"],
        salesWeight: json["sales_weight"],
        actualWeight: json["actual_weight"],
        difference: json["difference"],
        amount: json["amount"],
        pieces: json["pieces"],
        saleNumber: json["sale_number"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        grossWeight: json["gross_weight"],
        stoneCost: json["stone_cost"],
        counterName: json["counter_name"],
        ornament: json["ornament"],
        stockHead: json["stock_head"],
      );

  Map<String, dynamic> toJson() => {
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "code": code,
        "tag": tag,
        "tag_barcode": tagBarcode,
        "description": description,
        "sales_weight": salesWeight,
        "actual_weight": actualWeight,
        "difference": difference,
        "amount": amount,
        "pieces": pieces,
        "sale_number": saleNumber,
        "party_id": partyId,
        "party_name": partyName,
        "gross_weight": grossWeight,
        "stone_cost": stoneCost,
        "counter_name": counterName,
        "ornament": ornament,
        "stock_head": stockHead,
      };
}
