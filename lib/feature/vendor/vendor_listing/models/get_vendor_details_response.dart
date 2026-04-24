import 'dart:convert';

class GetVendorListingDetailsResponse {
  int? sn;
  String? name;
  String? code;
  String? gst;
  int? credit;
  int? debit;
  double? materialIn;
  double? materialOut;

  GetVendorListingDetailsResponse({
    this.sn,
    this.name,
    this.code,
    this.gst,
    this.credit,
    this.debit,
    this.materialIn,
    this.materialOut,
  });

  factory GetVendorListingDetailsResponse.fromRawJson(String str) =>
      GetVendorListingDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetVendorListingDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetVendorListingDetailsResponse(
        sn: json["sn"],
        name: json["name"],
        code: json["code"],
        gst: json["gst"],
        credit: json["credit"],
        debit: json["debit"],
        materialIn: json["material_in"]?.toDouble(),
        materialOut: json["material_out"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "sn": sn,
        "name": name,
        "code": code,
        "gst": gst,
        "credit": credit,
        "debit": debit,
        "material_in": materialIn,
        "material_out": materialOut,
      };
}
