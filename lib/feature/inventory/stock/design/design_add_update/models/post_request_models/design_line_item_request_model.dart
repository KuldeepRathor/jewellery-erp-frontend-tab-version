import 'dart:convert';

class DesignLineItemRequestModel {
  String? purity;
  String? minWeight;
  String? maxWeight;
  String? wastageType;
  double? wastage;
  double? makingCharges;
  double? minVa;
  double? minMc;
  String? makingChargesType;
  String? ornament;

  DesignLineItemRequestModel({
    this.purity,
    this.minWeight,
    this.maxWeight,
    this.wastageType,
    this.wastage,
    this.makingCharges,
    this.minVa,
    this.minMc,
    this.makingChargesType,
    this.ornament,
  });

  factory DesignLineItemRequestModel.fromRawJson(String str) =>
      DesignLineItemRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DesignLineItemRequestModel.fromJson(Map<String, dynamic> json) =>
      DesignLineItemRequestModel(
        purity: json["purity"],
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
        wastageType: json["wastage_type"],
        wastage: json["wastage"],
        makingCharges: json["making_charges"],
        minVa: json["min_va"],
        minMc: json["min_mc"],
        makingChargesType: json["making_charges_type"],
        ornament: json["ornament"],
      );

  Map<String, dynamic> toJson() => {
        "purity": purity,
        "min_weight": minWeight,
        "max_weight": maxWeight,
        "wastage_type": wastageType,
        "wastage": wastage,
        "making_charges": makingCharges,
        "min_va": minVa,
        "min_mc": minMc,
        "making_charges_type": makingChargesType,
        "ornament": ornament,
      };
}
