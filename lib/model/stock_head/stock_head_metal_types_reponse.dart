import 'dart:convert';

class StockHeadMetalTypesResponse {
  String? id;
  String? typeName;

  StockHeadMetalTypesResponse({
    this.id,
    this.typeName,
  });

  factory StockHeadMetalTypesResponse.fromRawJson(String str) =>
      StockHeadMetalTypesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHeadMetalTypesResponse.fromJson(Map<String, dynamic> json) =>
      StockHeadMetalTypesResponse(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}
