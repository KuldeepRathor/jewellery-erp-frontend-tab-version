import 'dart:convert';

class GetQuickOldGoldByEstimateNumberResponse {
  List<GetQuickOldGoldByEstimateNumberResponseValue>? values;

  GetQuickOldGoldByEstimateNumberResponse({
    this.values,
  });

  factory GetQuickOldGoldByEstimateNumberResponse.fromRawJson(String str) =>
      GetQuickOldGoldByEstimateNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetQuickOldGoldByEstimateNumberResponse.fromJson(
          Map<String, dynamic> json) =>
      GetQuickOldGoldByEstimateNumberResponse(
        values: json["values"] == null
            ? []
            : List<GetQuickOldGoldByEstimateNumberResponseValue>.from(
                json["values"]!.map((x) =>
                    GetQuickOldGoldByEstimateNumberResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetQuickOldGoldByEstimateNumberResponseValue {
  String? id;
  String? oldGoldEstimateNumber;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;

  GetQuickOldGoldByEstimateNumberResponseValue({
    this.id,
    this.oldGoldEstimateNumber,
    this.organizationId,
    this.shopId,
    this.code,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.less,
    this.purityType,
    this.ornamentId,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
  });

  factory GetQuickOldGoldByEstimateNumberResponseValue.fromRawJson(
          String str) =>
      GetQuickOldGoldByEstimateNumberResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetQuickOldGoldByEstimateNumberResponseValue.fromJson(
          Map<String, dynamic> json) =>
      GetQuickOldGoldByEstimateNumberResponseValue(
        id: json["id"],
        oldGoldEstimateNumber: json["old_gold_estimate_number"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        less: json["less"],
        purityType: json["purity_type"],
        ornamentId: json["ornament_id"],
        rate: json["rate"],
        amount: json["amount"],
        roundOff: json["round_off"],
        total: json["total"],
        isReceived: json["is_received"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "old_gold_estimate_number": oldGoldEstimateNumber,
        "organization_id": organizationId,
        "shop_id": shopId,
        "code": code,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "less": less,
        "purity_type": purityType,
        "ornament_id": ornamentId,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
      };
}
