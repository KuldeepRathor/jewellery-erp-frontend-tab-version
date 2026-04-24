import 'dart:convert';

class OldGoldRequest {
  List<OldGoldRequestValue>? values;
  String? organizationId;
  String? shopId;

  OldGoldRequest({
    this.values,
    this.organizationId,
    this.shopId,
  });

  factory OldGoldRequest.fromRawJson(String str) =>
      OldGoldRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OldGoldRequest.fromJson(Map<String, dynamic> json) => OldGoldRequest(
        values: json["values"] == null
            ? []
            : List<OldGoldRequestValue>.from(
                json["values"]!.map((x) => OldGoldRequestValue.fromJson(x))),
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "organization_id": organizationId,
        "shop_id": shopId,
      };
}

class OldGoldRequestValue {
  dynamic organizationId;
  dynamic shopId;
  String? code;
  String? description;
  String? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purity;
  String? purityType;
  String? metalType;
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  dynamic isReceived;

  OldGoldRequestValue({
    this.organizationId,
    this.shopId,
    this.code,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.less,
    this.purity,
    this.purityType,
    this.metalType,
    this.ornamentId,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
  });

  factory OldGoldRequestValue.fromRawJson(String str) =>
      OldGoldRequestValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OldGoldRequestValue.fromJson(Map<String, dynamic> json) =>
      OldGoldRequestValue(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        less: json["less"],
        purity: json["purity"],
        purityType: json["purity_type"],
        metalType: json["metal_type"],
        ornamentId: json["ornament_id"],
        rate: json["rate"],
        amount: json["amount"],
        roundOff: json["round_off"],
        total: json["total"],
        isReceived: json["is_received"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "code": code,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "less": less,
        "purity": purity,
        "purity_type": purityType,
        "metal_type": metalType,
        "ornament_id": ornamentId,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
      };
}
