import 'dart:convert';

class CreateVendorPocRequest {
  String? organizationId;
  String? shopId;
  String? phoneNumber;
  String? fullName;
  String? vendorPocCode;
  String? vendorPocEmail;
  String? vendorPocDesignation;

  CreateVendorPocRequest({
    this.organizationId,
    this.shopId,
    this.phoneNumber,
    this.fullName,
    this.vendorPocCode,
    this.vendorPocEmail,
    this.vendorPocDesignation,
  });

  factory CreateVendorPocRequest.fromRawJson(String str) =>
      CreateVendorPocRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateVendorPocRequest.fromJson(Map<String, dynamic> json) =>
      CreateVendorPocRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        phoneNumber: json["phone_number"],
        fullName: json["full_name"],
        vendorPocCode: json["vendor_poc_code"],
        vendorPocEmail: json["vendor_poc_email"],
        vendorPocDesignation: json["vendor_poc_designation"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "phone_number": phoneNumber,
        "full_name": fullName,
        "vendor_poc_code": vendorPocCode,
        "vendor_poc_email": vendorPocEmail,
        "vendor_poc_designation": vendorPocDesignation,
      };
}
