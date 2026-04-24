import 'dart:convert';

class UpdateDesignLineItemRequestModel {
  String? id;
  String? purity;
  String? minWeight;
  String? maxWeight;
  String? wastageType;
  String? wastage;
  String? makingCharges;
  String? minVa;
  String? minMc;
  String? makingChargesType;
  String? ornamentId;

  UpdateDesignLineItemRequestModel({
    this.id,
    this.purity,
    this.minWeight,
    this.maxWeight,
    this.wastageType,
    this.wastage,
    this.makingCharges,
    this.minVa,
    this.minMc,
    this.makingChargesType,
    this.ornamentId,
  });

  factory UpdateDesignLineItemRequestModel.fromRawJson(String str) =>
      UpdateDesignLineItemRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateDesignLineItemRequestModel.fromJson(
          Map<String, dynamic> json) =>
      UpdateDesignLineItemRequestModel(
        id: json["id"],
        purity: json["purity"],
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
        wastageType: json["wastage_type"],
        wastage: json["wastage"],
        makingCharges: json["making_charges"],
        minVa: json["min_va"],
        minMc: json["min_mc"],
        makingChargesType: json["making_charges_type"],
        ornamentId: json["ornament_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purity": purity,
        "min_weight": minWeight,
        "max_weight": maxWeight,
        "wastage_type": wastageType,
        "wastage": wastage,
        "making_charges": makingCharges,
        "min_va": minVa,
        "min_mc": minMc,
        "making_charges_type": makingChargesType,
        "ornament_id": ornamentId,
      };
}
