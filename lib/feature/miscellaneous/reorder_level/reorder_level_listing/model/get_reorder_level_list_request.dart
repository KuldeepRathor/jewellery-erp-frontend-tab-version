import 'dart:convert';

class GetReorderLevelRequest {
  List<String>? purity;
  List<String>? stockHead;
  List<String>? vendor;
  List<String>? metalType;

  GetReorderLevelRequest({
    this.purity,
    this.stockHead,
    this.vendor,
    this.metalType,
  });

  factory GetReorderLevelRequest.fromRawJson(String str) =>
      GetReorderLevelRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReorderLevelRequest.fromJson(Map<String, dynamic> json) =>
      GetReorderLevelRequest(
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        stockHead: json["stock_head"] == null
            ? []
            : List<String>.from(json["stock_head"]!.map((x) => x)),
        vendor: json["vendor"] == null
            ? []
            : List<String>.from(json["vendor"]!.map((x) => x)),
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "stock_head": stockHead == null
            ? []
            : List<dynamic>.from(stockHead!.map((x) => x)),
        "vendor":
            vendor == null ? [] : List<dynamic>.from(vendor!.map((x) => x)),
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
      };
}
