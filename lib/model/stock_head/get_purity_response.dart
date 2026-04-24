import 'dart:convert';

class GetPurityResponse {
  String? id;
  String? organizationId;
  List<String>? values;

  GetPurityResponse({
    this.id,
    this.organizationId,
    this.values,
  });

  factory GetPurityResponse.fromRawJson(String str) =>
      GetPurityResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurityResponse.fromJson(Map<String, dynamic> json) =>
      GetPurityResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        values: json["values"] == null
            ? []
            : List<String>.from(json["values"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "values":
            values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
      };
}
