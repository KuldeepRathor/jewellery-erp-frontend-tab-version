import 'dart:convert';

class EditOrnamnetTypeValues {
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  String? metalType;
  String? openingWeight;
  String? openingAmount;
  int? openingQuantity;
  String? gst;

  EditOrnamnetTypeValues({
    this.name,
    this.code,
    this.organizationId,
    this.hsnSac,
    this.metalType,
    this.openingWeight,
    this.openingAmount,
    this.openingQuantity,
    this.gst,
  });

  factory EditOrnamnetTypeValues.fromRawJson(String str) =>
      EditOrnamnetTypeValues.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditOrnamnetTypeValues.fromJson(Map<String, dynamic> json) =>
      EditOrnamnetTypeValues(
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType: json["metal_type"],
        openingWeight: json["opening_weight"]?.toString(),
        openingAmount: json["opening_amount"]?.toString(),
        openingQuantity: json["opening_quantity"],
        gst: json["gst"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (name != null) "name": name,
        if (code != null) "code": code,
        if (organizationId != null) "organization_id": organizationId,
        if (hsnSac != null) "hsn_sac": hsnSac,
        if (metalType != null) "metal_type": metalType,
        if (openingWeight != null) "opening_weight": openingWeight,
        if (openingAmount != null) "opening_amount": openingAmount,
        if (openingQuantity != null) "opening_quantity": openingQuantity,
        if (gst != null) "gst": gst,
      };
}
