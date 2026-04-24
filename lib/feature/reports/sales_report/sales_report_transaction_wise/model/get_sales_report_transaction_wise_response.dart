import 'dart:convert';

class GetSalesReportTransactionWiseReponse {
  List<GetSalesReportTransactionWiseValue>? values;

  GetSalesReportTransactionWiseReponse({
    this.values,
  });

  factory GetSalesReportTransactionWiseReponse.fromRawJson(String str) =>
      GetSalesReportTransactionWiseReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportTransactionWiseReponse.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReportTransactionWiseReponse(
        values: json["values"] == null
            ? []
            : List<GetSalesReportTransactionWiseValue>.from(json["values"]!
                .map((x) => GetSalesReportTransactionWiseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetSalesReportTransactionWiseValue {
  DateTime? createdAt;
  String? invoinceNumber;
  String? code;
  String? tagNumber;
  String? ornamentId;
  String? ornamentName;
  String? description;
  int? pieces;
  String? netWeight;
  String? grossWeight;
  String? cgst;
  String? sgst;
  String? igst;
  String? amount;
  String? stoneAmount;
  String? total;
  dynamic oldGoldWeight;
  String? oldGoldAmount;
  String? received;
  String? cash;
  String? upiImps;
  String? neftRtgs;
  String? cheque;
  String? advance;
  dynamic creditNote;
  dynamic benefit;
  String? balance;

  GetSalesReportTransactionWiseValue({
    this.createdAt,
    this.invoinceNumber,
    this.code,
    this.tagNumber,
    this.ornamentId,
    this.ornamentName,
    this.description,
    this.pieces,
    this.netWeight,
    this.grossWeight,
    this.cgst,
    this.sgst,
    this.igst,
    this.amount,
    this.stoneAmount,
    this.total,
    this.oldGoldWeight,
    this.oldGoldAmount,
    this.received,
    this.cash,
    this.upiImps,
    this.neftRtgs,
    this.cheque,
    this.advance,
    this.creditNote,
    this.benefit,
    this.balance,
  });

  factory GetSalesReportTransactionWiseValue.fromRawJson(String str) =>
      GetSalesReportTransactionWiseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportTransactionWiseValue.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReportTransactionWiseValue(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        invoinceNumber: json["invoince_number"],
        code: json["code"],
        tagNumber: json["tag_number"],
        ornamentId: json["ornament_id"],
        ornamentName: json["ornament_name"],
        description: json["description"],
        pieces: json["pieces"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        amount: json["amount"],
        stoneAmount: json["stone_amount"],
        total: json["total"],
        oldGoldWeight: json["old_gold_weight"],
        oldGoldAmount: json["old_gold_amount"],
        received: json["received"],
        cash: json["cash"],
        upiImps: json["upi_imps"],
        neftRtgs: json["neft_rtgs"],
        cheque: json["cheque"],
        advance: json["advance"],
        creditNote: json["credit_note"],
        benefit: json["benefit"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "invoince_number": invoinceNumber,
        "code": code,
        "tag_number": tagNumber,
        "ornament_id": ornamentId,
        "ornament_name": ornamentName,
        "description": description,
        "pieces": pieces,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "cgst": cgst,
        "sgst": sgst,
        "igst": igst,
        "amount": amount,
        "stone_amount": stoneAmount,
        "total": total,
        "old_gold_weight": oldGoldWeight,
        "old_gold_amount": oldGoldAmount,
        "received": received,
        "cash": cash,
        "upi_imps": upiImps,
        "neft_rtgs": neftRtgs,
        "cheque": cheque,
        "advance": advance,
        "credit_note": creditNote,
        "benefit": benefit,
        "balance": balance,
      };
}
