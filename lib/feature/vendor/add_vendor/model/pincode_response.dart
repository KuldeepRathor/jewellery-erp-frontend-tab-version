import 'dart:convert';

class PincodeResponse {
  String? pincode;
  String? city;
  String? state;

  PincodeResponse({
    this.pincode,
    this.city,
    this.state,
  });

  factory PincodeResponse.fromRawJson(String str) =>
      PincodeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PincodeResponse.fromJson(Map<String, dynamic> json) =>
      PincodeResponse(
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "pincode": pincode,
        "city": city,
        "state": state,
      };
}
