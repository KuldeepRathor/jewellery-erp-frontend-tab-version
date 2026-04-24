import 'dart:convert';

class SendOtpResponse {
  bool? success;
  String? message;
  String? otp;

  SendOtpResponse({
    this.success,
    this.message,
    this.otp,
  });

  factory SendOtpResponse.fromRawJson(String str) =>
      SendOtpResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(
        success: json["success"],
        message: json["message"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "otp": otp,
      };
}
