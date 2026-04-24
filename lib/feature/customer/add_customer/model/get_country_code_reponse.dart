import 'dart:convert';

class GetCountryCodeResponse {
  String? name;
  String? code;

  GetCountryCodeResponse({
    this.name,
    this.code,
  });

  factory GetCountryCodeResponse.fromRawJson(String str) =>
      GetCountryCodeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCountryCodeResponse.fromJson(Map<String, dynamic> json) =>
      GetCountryCodeResponse(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
      };
}
