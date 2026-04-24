import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';

class OrnamentTypeResponse {
  List<OrnamnetTypeValues>? values;

  OrnamentTypeResponse({this.values});

  factory OrnamentTypeResponse.fromRawJson(String str) =>
      OrnamentTypeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrnamentTypeResponse.fromJson(Map<String, dynamic> json) =>
      OrnamentTypeResponse(
        values:
            json["values"] == null
                ? []
                : List<OrnamnetTypeValues>.from(
                  json["values"]!.map((x) => OrnamnetTypeValues.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

class OrnamnetTypeValues {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  MetalTypeResponse? metalType;
  String? openingWeight;
  String? openingAmount;
  int? openingQuantity;
  String? gst;
  DateTime? createdAt;
  bool? isStone;
  bool? isOldGold;
  bool? isService;
  String? purity;

  OrnamnetTypeValues({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.hsnSac,
    this.metalType,
    this.openingWeight,
    this.openingAmount,
    this.openingQuantity,
    this.gst,
    this.createdAt,
    this.isStone,
    this.isOldGold,
    this.isService,
    this.purity,
  });

  factory OrnamnetTypeValues.fromRawJson(String str) =>
      OrnamnetTypeValues.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrnamnetTypeValues.fromJson(Map<String, dynamic> json) =>
      OrnamnetTypeValues(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType:
            json["metal_type"] == null
                ? null
                : MetalTypeResponse.fromJson(json["metal_type"]),
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        openingQuantity: json["opening_quantity"],
        gst: json["gst"],
        createdAt:
            json["created_at"] == null
                ? null
                : DateTime.parse(json["created_at"]),
        isStone: json["is_stone"],
        isOldGold: json["is_old_gold"],
        isService: json["is_service"],
        purity: json["purity"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "organization_id": organizationId,
    "hsn_sac": hsnSac,
    "metal_type": metalType?.toJson(),
    "opening_weight": openingWeight,
    "opening_amount": openingAmount,
    "opening_quantity": openingQuantity,
    "gst": gst,
    "created_at": createdAt?.toIso8601String(),
    "is_stone": isStone,
    "is_old_gold": isOldGold,
    "is_service": isService,
    "purity": purity,
  };
}
