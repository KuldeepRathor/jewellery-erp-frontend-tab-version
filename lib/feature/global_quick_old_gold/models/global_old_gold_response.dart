import 'dart:convert';

class PostGlobalOldGoldResponse {
  List<PostGlobalOldGoldResponseValue>? values;

  PostGlobalOldGoldResponse({
    this.values,
  });

  factory PostGlobalOldGoldResponse.fromRawJson(String str) =>
      PostGlobalOldGoldResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostGlobalOldGoldResponse.fromJson(Map<String, dynamic> json) =>
      PostGlobalOldGoldResponse(
        values: json["values"] == null
            ? []
            : List<PostGlobalOldGoldResponseValue>.from(json["values"]!
                .map((x) => PostGlobalOldGoldResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class PostGlobalOldGoldResponseValue {
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
  String? purity;
  String? purityType;
  MetalType? metalType; // CHANGED: Now accepts object
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;

  PostGlobalOldGoldResponseValue({
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

  factory PostGlobalOldGoldResponseValue.fromRawJson(String str) =>
      PostGlobalOldGoldResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostGlobalOldGoldResponseValue.fromJson(Map<String, dynamic> json) =>
      PostGlobalOldGoldResponseValue(
        id: json["id"],
        oldGoldEstimateNumber: json["old_gold_estimate_number"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"]?.toString(), // 10.0 → "10.0"
        netWeight: json["net_weight"]?.toString(), // 8.0  → "8.0"
        less: json["less"]?.toString(), // 2.0  → "2.0"
        purity: json["purity"]?.toString(), // 100.0 → "100.0"
        purityType: json["purity_type"],
        metalType: json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
        ornamentId: json["ornament_id"],
        rate: json["rate"]?.toString(), // 16000.0 → "16000.0"
        amount: json["amount"]?.toString(), // 128000.0 → "128000.0"
        roundOff: json["round_off"]?.toString(), // 0.0 → "0.0"
        total: json["total"]?.toString(), // 128000.0 → "128000.0"
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
        "purity": purity,
        "purity_type": purityType,
        "metal_type": metalType?.toJson(),
        "ornament_id": ornamentId,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
      };
}

class MetalType {
  String? id;
  String? typeName;
  String? codeType;

  MetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory MetalType.fromJson(Map<String, dynamic> json) => MetalType(
        id: json["id"],
        typeName: json["type_name"],
        codeType: json["code_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "code_type": codeType,
      };
}
