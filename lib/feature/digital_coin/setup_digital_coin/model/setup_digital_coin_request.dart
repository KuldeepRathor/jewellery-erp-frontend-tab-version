import 'dart:convert';

class SetupDigitalCoinRequest {
  String? status;
  String? hsnCode;
  String? vaPercentage;
  String? invoicePrefix;
  String? description;

  SetupDigitalCoinRequest({
    this.status,
    this.hsnCode,
    this.vaPercentage,
    this.invoicePrefix,
    this.description,
  });

  factory SetupDigitalCoinRequest.fromRawJson(String str) =>
      SetupDigitalCoinRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SetupDigitalCoinRequest.fromJson(Map<String, dynamic> json) =>
      SetupDigitalCoinRequest(
        status: json["status"],
        hsnCode: json["hsn_code"],
        vaPercentage: json["va_percentage"],
        invoicePrefix: json["invoice_prefix"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "hsn_code": hsnCode,
        "va_percentage": vaPercentage,
        "invoice_prefix": invoicePrefix,
        "description": description,
      };
}
