import 'dart:convert';

class GetPurchaseReportTransactionWiseReponse {
  List<Ornament>? ornaments;

  GetPurchaseReportTransactionWiseReponse({
    this.ornaments,
  });

  factory GetPurchaseReportTransactionWiseReponse.fromRawJson(String str) =>
      GetPurchaseReportTransactionWiseReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReportTransactionWiseReponse.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReportTransactionWiseReponse(
        ornaments: json["ornaments"] == null
            ? []
            : List<Ornament>.from(
                json["ornaments"]!.map((x) => Ornament.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ornaments": ornaments == null
            ? []
            : List<dynamic>.from(ornaments!.map((x) => x.toJson())),
      };
}

class Ornament {
  String? ornamentId;
  String? ornamentName;
  List<OrnamentValue>? values;

  Ornament({
    this.ornamentId,
    this.ornamentName,
    this.values,
  });

  factory Ornament.fromRawJson(String str) =>
      Ornament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ornament.fromJson(Map<String, dynamic> json) => Ornament(
        ornamentId: json["ornament_id"],
        ornamentName: json["ornament_name"],
        values: json["values"] == null
            ? []
            : List<OrnamentValue>.from(
                json["values"]!.map((x) => OrnamentValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ornament_id": ornamentId,
        "ornament_name": ornamentName,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class OrnamentValue {
  DateTime? createdAt;
  String? invoinceNumber;
  String? itemDescription;
  int? pieces;
  String? netWeight;
  String? grossWeight;
  String? amount;
  String? gst;
  String? tdsTcs;
  String? roundOff;
  String? total;
  String? cash;
  dynamic debitNote;
  String? bank;

  OrnamentValue({
    this.createdAt,
    this.invoinceNumber,
    this.itemDescription,
    this.pieces,
    this.netWeight,
    this.grossWeight,
    this.amount,
    this.gst,
    this.tdsTcs,
    this.roundOff,
    this.total,
    this.cash,
    this.debitNote,
    this.bank,
  });

  factory OrnamentValue.fromRawJson(String str) =>
      OrnamentValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrnamentValue.fromJson(Map<String, dynamic> json) => OrnamentValue(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        invoinceNumber: json["invoince_number"],
        itemDescription: json["item_description"],
        pieces: json["pieces"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        amount: json["amount"],
        gst: json["gst"],
        tdsTcs: json["tds_tcs"],
        roundOff: json["round_off"],
        total: json["total"],
        cash: json["cash"],
        debitNote: json["debit_note"],
        bank: json["bank"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "invoince_number": invoinceNumber,
        "item_description": itemDescription,
        "pieces": pieces,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "amount": amount,
        "gst": gst,
        "tds_tcs": tdsTcs,
        "round_off": roundOff,
        "total": total,
        "cash": cash,
        "debit_note": debitNote,
        "bank": bank,
      };
}
