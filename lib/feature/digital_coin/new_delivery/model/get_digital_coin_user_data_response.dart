import 'dart:convert';

class GetDigitalCoinUserDataResponse {
  Data? data;

  GetDigitalCoinUserDataResponse({
    this.data,
  });

  factory GetDigitalCoinUserDataResponse.fromRawJson(String str) =>
      GetDigitalCoinUserDataResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDigitalCoinUserDataResponse.fromJson(Map<String, dynamic> json) =>
      GetDigitalCoinUserDataResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? firstName;
  DateTime? dob;
  String? email;
  String? gender;
  String? address;
  dynamic pincode;
  String? state;

  Data({
    this.id,
    this.firstName,
    this.dob,
    this.email,
    this.gender,
    this.address,
    this.pincode,
    this.state,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["first_name"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        email: json["email"],
        gender: json["gender"],
        address: json["address"],
        pincode: json["pincode"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "email": email,
        "gender": gender,
        "address": address,
        "pincode": pincode,
        "state": state,
      };
}
