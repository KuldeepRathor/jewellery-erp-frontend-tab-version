import 'dart:convert';

class GstDetailsResponse {
  String? gst_number;
  String? gst_type;
  String? code;
  String? store_name;
  String? address1;
  String? address2;
  String? city;
  String? pin_code;
  String? pan;
  String? state;

  GstDetailsResponse({
    this.gst_number,
    this.gst_type,
    this.code,
    this.store_name,
    this.address1,
    this.address2,
    this.city,
    this.pin_code,
    this.pan,
    this.state,
  });

  factory GstDetailsResponse.fromRawJson(String str) =>
      GstDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GstDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GstDetailsResponse(
        gst_number: json["gst_number"],
        gst_type: json["gst_type"],
        code: json["code"],
        store_name: json["store_name"],
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        pin_code: json["pin_code"],
        pan: json["pan"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "gst_number": gst_number,
        "gst_type": gst_type,
        "code": code,
        "store_name": store_name,
        "address1": address1,
        "address2": address2,
        "city": city,
        "pin_code": pin_code,
        "pan": pan,
        "state": state,
      };
}
