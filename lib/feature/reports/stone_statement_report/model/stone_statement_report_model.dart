import 'dart:convert';

class StoneStatementReportResponse {
  List<StoneStatementReportValue>? values;
  dynamic salesReturn;

  StoneStatementReportResponse({
    this.values,
    this.salesReturn,
  });

  factory StoneStatementReportResponse.fromRawJson(String str) =>
      StoneStatementReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoneStatementReportResponse.fromJson(Map<String, dynamic> json) =>
      StoneStatementReportResponse(
        values: json["values"] == null
            ? []
            : List<StoneStatementReportValue>.from(json["values"]!
                .map((x) => StoneStatementReportValue.fromJson(x))),
        salesReturn: json["sales_return"],
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "sales_return": salesReturn,
      };
}

class StoneStatementReportValue {
  String? stoneId;
  String? stoneCode;
  String? stoneName;
  int? openingPieces;
  String? openingWeight;
  String? openingAmount;
  int? inwardPieces;
  String? inwardWeight;
  String? inwardAmount;
  int? outwardPieces;
  String? outwardWeight;
  String? outwardAmount;
  int? stockIssuePieces;
  String? stockIssueWeight;
  String? stockIssueAmount;
  int? closingPieces;
  String? closingWeight;
  String? closingAmount;

  StoneStatementReportValue({
    this.stoneId,
    this.stoneCode,
    this.stoneName,
    this.openingPieces,
    this.openingWeight,
    this.openingAmount,
    this.inwardPieces,
    this.inwardWeight,
    this.inwardAmount,
    this.outwardPieces,
    this.outwardWeight,
    this.outwardAmount,
    this.stockIssuePieces,
    this.stockIssueWeight,
    this.stockIssueAmount,
    this.closingPieces,
    this.closingWeight,
    this.closingAmount,
  });

  factory StoneStatementReportValue.fromRawJson(String str) =>
      StoneStatementReportValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoneStatementReportValue.fromJson(Map<String, dynamic> json) =>
      StoneStatementReportValue(
        stoneId: json["stone_id"],
        stoneCode: json["stone_code"],
        stoneName: json["stone_name"],
        openingPieces: json["opening_pieces"],
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        inwardPieces: json["inward_pieces"],
        inwardWeight: json["inward_weight"],
        inwardAmount: json["inward_amount"],
        outwardPieces: json["outward_pieces"],
        outwardWeight: json["outward_weight"],
        outwardAmount: json["outward_amount"],
        stockIssuePieces: json["stock_issue_pieces"],
        stockIssueWeight: json["stock_issue_weight"],
        stockIssueAmount: json["stock_issue_amount"],
        closingPieces: json["closing_pieces"],
        closingWeight: json["closing_weight"],
        closingAmount: json["closing_amount"],
      );

  Map<String, dynamic> toJson() => {
        "stone_id": stoneId,
        "stone_code": stoneCode,
        "stone_name": stoneName,
        "opening_pieces": openingPieces,
        "opening_weight": openingWeight,
        "opening_amount": openingAmount,
        "inward_pieces": inwardPieces,
        "inward_weight": inwardWeight,
        "inward_amount": inwardAmount,
        "outward_pieces": outwardPieces,
        "outward_weight": outwardWeight,
        "outward_amount": outwardAmount,
        "stock_issue_pieces": stockIssuePieces,
        "stock_issue_weight": stockIssueWeight,
        "stock_issue_amount": stockIssueAmount,
        "closing_pieces": closingPieces,
        "closing_weight": closingWeight,
        "closing_amount": closingAmount,
      };
}
