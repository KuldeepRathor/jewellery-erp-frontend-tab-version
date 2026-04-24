import 'dart:convert';

class GetWantedListResponse {
  List<GetWantedListResponseValue>? values;

  GetWantedListResponse({
    this.values,
  });

  factory GetWantedListResponse.fromRawJson(String str) =>
      GetWantedListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWantedListResponse.fromJson(Map<String, dynamic> json) =>
      GetWantedListResponse(
        values: json["values"] == null
            ? []
            : List<GetWantedListResponseValue>.from(json["values"]!
                .map((x) => GetWantedListResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetWantedListResponseValue {
  String? designName;
  String? weight;
  String? size;
  String? purity;
  String? min;
  String? inStock;
  String? wanted;
  String? quantityType;

  GetWantedListResponseValue({
    this.designName,
    this.weight,
    this.size,
    this.purity,
    this.min,
    this.inStock,
    this.wanted,
    this.quantityType,
  });

  factory GetWantedListResponseValue.fromRawJson(String str) =>
      GetWantedListResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWantedListResponseValue.fromJson(Map<String, dynamic> json) =>
      GetWantedListResponseValue(
        designName: json["design_name"],
        weight: json["weight"],
        size: json["size"],
        purity: json["purity"],
        min: json["min"],
        inStock: json["in_stock"],
        wanted: json["wanted"],
        quantityType: json["quantity_type"],
      );

  Map<String, dynamic> toJson() => {
        "design_name": designName,
        "weight": weight,
        "size": size,
        "purity": purity,
        "min": min,
        "in_stock": inStock,
        "wanted": wanted,
        "quantity_type": quantityType,
      };
}
