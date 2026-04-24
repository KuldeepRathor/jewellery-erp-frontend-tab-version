import 'dart:convert';

class GetVoucherSectionResponse {
  String? id;
  String? name;

  GetVoucherSectionResponse({
    this.id,
    this.name,
  });

  factory GetVoucherSectionResponse.fromRawJson(String str) =>
      GetVoucherSectionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetVoucherSectionResponse.fromJson(Map<String, dynamic> json) =>
      GetVoucherSectionResponse(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
