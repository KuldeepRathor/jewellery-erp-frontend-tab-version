import 'dart:convert';

class GetVoucherTypeResponse {
  String? id;
  String? name;

  GetVoucherTypeResponse({
    this.id,
    this.name,
  });

  factory GetVoucherTypeResponse.fromRawJson(String str) =>
      GetVoucherTypeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetVoucherTypeResponse.fromJson(Map<String, dynamic> json) =>
      GetVoucherTypeResponse(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
