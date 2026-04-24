import 'dart:convert';

class GetStockIssueListingResponse {
  List<StockIssueListingValue>? values;

  GetStockIssueListingResponse({
    this.values,
  });

  factory GetStockIssueListingResponse.fromRawJson(String str) =>
      GetStockIssueListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStockIssueListingResponse.fromJson(Map<String, dynamic> json) =>
      GetStockIssueListingResponse(
        values: json["values"] == null
            ? []
            : List<StockIssueListingValue>.from(
                json["values"]!.map((x) => StockIssueListingValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class StockIssueListingValue {
  String? id;
  String? issueNo;
  DateTime? issueDate;
  String? reason;
  num? tagNo;
  String? tagCode;
  String? tagBarcode;
  String? itemDescription;
  double? grossWeight;
  double? netWeight;
  String? stockIssueRecordId;
  String? createdBy;
  String? issuedByName;
  double? pieces;

  StockIssueListingValue({
    this.id,
    this.issueNo,
    this.issueDate,
    this.reason,
    this.tagNo,
    this.tagCode,
    this.tagBarcode,
    this.itemDescription,
    this.grossWeight,
    this.netWeight,
    this.stockIssueRecordId,
    this.createdBy,
    this.issuedByName,
    this.pieces,
  });

  factory StockIssueListingValue.fromJson(Map<String, dynamic> json) =>
      StockIssueListingValue(
        id: json["id"],
        issueNo: json["issue_no"],
        issueDate: json["issue_date"] == null
            ? null
            : DateTime.parse(json["issue_date"]),
        reason: json["reason"],
        tagNo: json["tag_no"] == null
            ? null
            : num.parse(json["tag_no"].toString()),
        tagCode: json["tag_code"],
        tagBarcode: json["tag_barcode"],
        itemDescription: json["item_description"],
        grossWeight: json["gross_weight"] == null
            ? null
            : double.parse(json["gross_weight"].toString()),
        netWeight: json["net_weight"] == null
            ? null
            : double.parse(json["net_weight"].toString()),
        stockIssueRecordId: json["stock_issue_record_id"],
        createdBy: json["created_by"],
        issuedByName: json["issued_by_name"],
        pieces: json["pieces"] == null
            ? null
            : double.parse(json["pieces"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "issue_no": issueNo,
        "issue_date": issueDate?.toIso8601String(),
        "reason": reason,
        "tag_no": tagNo,
        "tag_code": tagCode,
        "tag_barcode": tagBarcode,
        "item_description": itemDescription,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stock_issue_record_id": stockIssueRecordId,
        "created_by": createdBy,
        "issued_by_name": issuedByName,
        "pieces": pieces,
      };
}
