import 'dart:convert';

class DesignLineItemsModel {
  String? id;
  String? organizationId;
  String? purity;
  String? minWeight;
  String? maxWeight;
  String? wastageType;
  String? wastage;
  String? makingCharges;
  String? minVa;
  String? minMc;

  DesignLineItemsModel({
    this.id,
    this.organizationId,
    this.purity,
    this.minWeight,
    this.maxWeight,
    this.wastageType,
    this.wastage,
    this.makingCharges,
    this.minVa,
    this.minMc,
  });

  factory DesignLineItemsModel.fromRawJson(String str) =>
      DesignLineItemsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DesignLineItemsModel.fromJson(Map<String, dynamic> json) =>
      DesignLineItemsModel(
        id: json["id"],
        organizationId: json["organization_id"],
        purity: json["purity"],
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
        wastageType: json["wastage_type"],
        wastage: json["wastage"],
        makingCharges: json["making_charges"],
        minVa: json["min_va"],
        minMc: json["min_mc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "purity": purity,
        "min_weight": minWeight,
        "max_weight": maxWeight,
        "wastage_type": wastageType,
        "wastage": wastage,
        "making_charges": makingCharges,
        "min_va": minVa,
        "min_mc": minMc,
      };
}
