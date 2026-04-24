import 'dart:convert';

class MakingChargesTypeValue {
  String? id;
  String? typeName;

  MakingChargesTypeValue({
    this.id,
    this.typeName,
  });

  factory MakingChargesTypeValue.fromRawJson(String str) =>
      MakingChargesTypeValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MakingChargesTypeValue.fromJson(Map<String, dynamic> json) =>
      MakingChargesTypeValue(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}
