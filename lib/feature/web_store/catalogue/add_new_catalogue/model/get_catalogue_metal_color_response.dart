import 'dart:convert';

class GetCatalogMetalColorResponse {
  String? id;
  String? colourName;

  GetCatalogMetalColorResponse({
    this.id,
    this.colourName,
  });

  factory GetCatalogMetalColorResponse.fromRawJson(String str) =>
      GetCatalogMetalColorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCatalogMetalColorResponse.fromJson(Map<String, dynamic> json) =>
      GetCatalogMetalColorResponse(
        id: json["id"],
        colourName: json["colour_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "colour_name": colourName,
      };
}
