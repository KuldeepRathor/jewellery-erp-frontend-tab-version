import 'dart:convert';

class VendorType {
  String? id;
  String? vendorType;

  VendorType({
    this.id,
    this.vendorType,
  });

  factory VendorType.fromJson(Map<String, dynamic> json) => VendorType(
        id: json["id"],
        vendorType: json["vendor_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_type": vendorType,
      };
}

class VendorTypesResponse {
  List<VendorType> vendorTypes;

  VendorTypesResponse({
    required this.vendorTypes,
  });

  factory VendorTypesResponse.fromRawJson(String str) =>
      VendorTypesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VendorTypesResponse.fromJson(Map<String, dynamic> json) =>
      VendorTypesResponse(
        vendorTypes: List<VendorType>.from(
            json["vendor_types"].map((x) => VendorType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vendor_types": List<dynamic>.from(vendorTypes.map((x) => x.toJson())),
      };
}
