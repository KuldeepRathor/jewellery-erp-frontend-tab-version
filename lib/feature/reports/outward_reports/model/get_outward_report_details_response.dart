import 'dart:convert';

class GetOutwardReportDetailsResponse {
  List<GetOutwardReportDetailsResponseValue>? values;

  GetOutwardReportDetailsResponse({
    this.values,
  });

  factory GetOutwardReportDetailsResponse.fromRawJson(String str) =>
      GetOutwardReportDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetOutwardReportDetailsResponse(
        values: json["values"] == null
            ? []
            : List<GetOutwardReportDetailsResponseValue>.from(json["values"]!
                .map((x) => GetOutwardReportDetailsResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetOutwardReportDetailsResponseValue {
  String? id;
  DateTime? createdAt;
  String? code;
  int? tagNumber;
  String? tagBarcode;
  String? description;
  int? pieces;
  String? purity;
  String? grossWeight;
  String? netWeight;
  String? va;
  String? mc;
  String? stoneCarats;
  String? stoneAmount;
  String? transactionType;
  String? voucherNumber;
  String? taggingId;

  GetOutwardReportDetailsResponseValue({
    this.id,
    this.createdAt,
    this.code,
    this.tagNumber,
    this.tagBarcode,
    this.description,
    this.pieces,
    this.purity,
    this.grossWeight,
    this.netWeight,
    this.va,
    this.mc,
    this.stoneCarats,
    this.stoneAmount,
    this.transactionType,
    this.voucherNumber,
    this.taggingId,
  });

  factory GetOutwardReportDetailsResponseValue.fromRawJson(String str) =>
      GetOutwardReportDetailsResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOutwardReportDetailsResponseValue.fromJson(
          Map<String, dynamic> json) =>
      GetOutwardReportDetailsResponseValue(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        code: json["code"],
        tagNumber: json["tag_number"],
        tagBarcode: json["tag_barcode"],
        description: json["description"],
        pieces: json["pieces"],
        purity: json["purity"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        va: json["va"],
        mc: json["mc"],
        stoneCarats: json["stone_carats"],
        stoneAmount: json["stone_amount"],
        transactionType: json["transaction_type"],
        voucherNumber: json["voucher_number"],
        taggingId: json["tagging_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "code": code,
        "tag_number": tagNumber,
        "tag_barcode": tagBarcode,
        "description": description,
        "pieces": pieces,
        "purity": purity,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "va": va,
        "mc": mc,
        "stone_carats": stoneCarats,
        "stone_amount": stoneAmount,
        "transaction_type": transactionType,
        "voucher_number": voucherNumber,
        "tagging_id": taggingId,
      };
}
