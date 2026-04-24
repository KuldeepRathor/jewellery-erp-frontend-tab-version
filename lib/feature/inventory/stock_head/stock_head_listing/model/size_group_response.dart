import 'dart:convert';

class SizeGroup {
  String? id;
  String? name;
  String? code;
  String? size;

  SizeGroup({
    this.id,
    this.name,
    this.code,
    this.size,
  });

  factory SizeGroup.fromRawJson(String str) =>
      SizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SizeGroup.fromJson(Map<String, dynamic> json) => SizeGroup(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "size": size,
      };
}
