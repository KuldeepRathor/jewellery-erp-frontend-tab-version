import 'dart:convert';

class SaveStockVerificationRequest {
  List<SaveStockVerificationValue>? values;
  String? organizationId;
  String? shopId;

  SaveStockVerificationRequest({
    this.values,
    this.organizationId,
    this.shopId,
  });

  factory SaveStockVerificationRequest.fromRawJson(String str) =>
      SaveStockVerificationRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaveStockVerificationRequest.fromJson(Map<String, dynamic> json) =>
      SaveStockVerificationRequest(
        values: json["values"] == null
            ? []
            : List<SaveStockVerificationValue>.from(json["values"]!
                .map((x) => SaveStockVerificationValue.fromJson(x))),
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "organization_id": organizationId,
        "shop_id": shopId,
      };
}

class SaveStockVerificationValue {
  String? taggingId;
  bool? isScanned;

  SaveStockVerificationValue({
    this.taggingId,
    this.isScanned,
  });

  factory SaveStockVerificationValue.fromRawJson(String str) =>
      SaveStockVerificationValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaveStockVerificationValue.fromJson(Map<String, dynamic> json) =>
      SaveStockVerificationValue(
        taggingId: json["tagging_id"],
        isScanned: json["is_scanned"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_id": taggingId,
        "is_scanned": isScanned,
      };
}
