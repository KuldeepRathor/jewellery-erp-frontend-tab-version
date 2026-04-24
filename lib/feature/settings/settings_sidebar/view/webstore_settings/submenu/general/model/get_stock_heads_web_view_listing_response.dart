import 'dart:convert';

class GetStockHeadsWebViewListingResponse {
  List<GetStockHeadsWebViewValue>? values;

  GetStockHeadsWebViewListingResponse({
    this.values,
  });

  factory GetStockHeadsWebViewListingResponse.fromRawJson(String str) =>
      GetStockHeadsWebViewListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStockHeadsWebViewListingResponse.fromJson(
          Map<String, dynamic> json) =>
      GetStockHeadsWebViewListingResponse(
        values: json["values"] == null
            ? []
            : List<GetStockHeadsWebViewValue>.from(json["values"]!
                .map((x) => GetStockHeadsWebViewValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetStockHeadsWebViewValue {
  String? id;
  String? name;
  String? code;
  bool? isWebstore;

  GetStockHeadsWebViewValue({
    this.id,
    this.name,
    this.code,
    this.isWebstore,
  });

  factory GetStockHeadsWebViewValue.fromRawJson(String str) =>
      GetStockHeadsWebViewValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStockHeadsWebViewValue.fromJson(Map<String, dynamic> json) =>
      GetStockHeadsWebViewValue(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "is_webstore": isWebstore,
      };
}
