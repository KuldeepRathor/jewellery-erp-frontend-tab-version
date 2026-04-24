import 'dart:convert';

class StockIssueRecordRequest {
  String issueDate;
  String? organizationId;
  String? shopId;
  String? issuedBy;
  String reason;
  String remarks;
  List<LineItem> lineItems;

  StockIssueRecordRequest({
    required this.issueDate,
    this.organizationId,
    this.shopId,
    required this.issuedBy,
    required this.reason,
    required this.remarks,
    required this.lineItems,
  });

  Map<String, dynamic> toJson() => {
        "issue_date": issueDate,
        "organization_id": organizationId,
        "shop_id": shopId,
        "issued_by": issuedBy,
        "reason": reason,
        "remarks": remarks,
        "line_items": lineItems.map((x) => x.toJson()).toList(),
      };
}

class LineItem {
  String? taggingLineItem;
  int? pieces;
  double? grossWeight;
  double? netWeight;
  double? value;

  LineItem({
    this.taggingLineItem,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.value,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        taggingLineItem: json["tagging_line_item"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"]?.toDouble(),
        netWeight: json["net_weight"]?.toDouble(),
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item": taggingLineItem,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "value": value,
      };
}
