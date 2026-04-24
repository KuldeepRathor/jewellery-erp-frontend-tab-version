import 'dart:convert';

class ApprovalReceiptRecordRequest {
  List<LineItem>? lineItems;
  String? partyId;
  String? partyType;
  String? receiptDate;
  String? remarks;

  ApprovalReceiptRecordRequest({
    this.lineItems,
    this.partyId,
    this.partyType,
    this.receiptDate,
    this.remarks,
  });

  factory ApprovalReceiptRecordRequest.fromRawJson(String str) =>
      ApprovalReceiptRecordRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApprovalReceiptRecordRequest.fromJson(Map<String, dynamic> json) =>
      ApprovalReceiptRecordRequest(
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        partyId: json["party_id"],
        partyType: json["party_type"],
        receiptDate: json["receipt_date"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "party_id": partyId,
        "party_type": partyType,
        "receipt_date": receiptDate,
        "remarks": remarks,
      };
}

class LineItem {
  String? code;
  String? description;
  String? discount;
  String? finalMc;
  String? finalVa;
  String? grossWeight;
  String? hallMark;
  String? lineItemId;
  String? netWeight;
  int? pieces;
  String? salesAmount;
  String? stoneCost;
  String? tag;
  String? taggingId;
  String? taggingMc;
  String? taggingVa;
  String? totalAmount;

  LineItem({
    this.code,
    this.description,
    this.discount,
    this.finalMc,
    this.finalVa,
    this.grossWeight,
    this.hallMark,
    this.lineItemId,
    this.netWeight,
    this.pieces,
    this.salesAmount,
    this.stoneCost,
    this.tag,
    this.taggingId,
    this.taggingMc,
    this.taggingVa,
    this.totalAmount,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        code: json["code"],
        description: json["description"],
        discount: json["discount"],
        finalMc: json["final_mc"],
        finalVa: json["final_va"],
        grossWeight: json["gross_weight"],
        hallMark: json["hall_mark"],
        lineItemId: json["line_item_id"],
        netWeight: json["net_weight"],
        pieces: json["pieces"],
        salesAmount: json["sales_amount"],
        stoneCost: json["stone_cost"],
        tag: json["tag"],
        taggingId: json["tagging_id"],
        taggingMc: json["tagging_mc"],
        taggingVa: json["tagging_va"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "discount": discount,
        "final_mc": finalMc,
        "final_va": finalVa,
        "gross_weight": grossWeight,
        "hall_mark": hallMark,
        "line_item_id": lineItemId,
        "net_weight": netWeight,
        "pieces": pieces,
        "sales_amount": salesAmount,
        "stone_cost": stoneCost,
        "tag": tag,
        "tagging_id": taggingId,
        "tagging_mc": taggingMc,
        "tagging_va": taggingVa,
        "total_amount": totalAmount,
      };
}
