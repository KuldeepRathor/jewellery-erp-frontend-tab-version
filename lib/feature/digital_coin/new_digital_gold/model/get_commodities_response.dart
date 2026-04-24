import 'dart:convert';

class GetCommoditiesResponse {
  int? id;
  int? shopId;
  String? description;
  String? commodity;
  String? hsnCode;
  dynamic vaPercentage;
  String? invoicePrefix;
  String? status;

  GetCommoditiesResponse({
    this.id,
    this.shopId,
    this.description,
    this.commodity,
    this.hsnCode,
    this.vaPercentage,
    this.invoicePrefix,
    this.status,
  });

  factory GetCommoditiesResponse.fromRawJson(String str) =>
      GetCommoditiesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCommoditiesResponse.fromJson(Map<String, dynamic> json) =>
      GetCommoditiesResponse(
        id: json["id"],
        shopId: json["shop_id"],
        description: json["description"],
        commodity: json["commodity"],
        hsnCode: json["hsn_code"],
        vaPercentage: json["va_percentage"],
        invoicePrefix: json["invoice_prefix"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "description": description,
        "commodity": commodity,
        "hsn_code": hsnCode,
        "va_percentage": vaPercentage,
        "invoice_prefix": invoicePrefix,
        "status": status,
      };
}
