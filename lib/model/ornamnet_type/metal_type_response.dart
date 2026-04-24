import 'dart:convert';

class MetalTypeResponse {
  String? id;
  String? typeName;
  String? codeType;

  MetalTypeResponse({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory MetalTypeResponse.fromRawJson(String str) =>
      MetalTypeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalTypeResponse.fromJson(Map<String, dynamic> json) =>
      MetalTypeResponse(
        id: json["id"],
        typeName: json["type_name"],
        codeType: json["code_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "type_name": typeName,
        // "code_type": codeType,
      };
}
