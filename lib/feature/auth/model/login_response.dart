import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginResponse {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  bool? isTwoFactorAuthEnabled;

  // Add decoded payload fields
  String? id;
  String? roleReadableId;
  String? roleName;
  String? roleType;
  String? shopId;
  String? organizationId;
  String? organizationName;
  String? branchReadableId;

  String? branchAddressLine1;
  String? branchAddressLine2;
  String? branchCity;
  String? branchCountry;
  String? branchPincode;
  List<int>? modules;
  int? userId;
  DateTime? expirationDate;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.isTwoFactorAuthEnabled,
    this.id,
    this.roleReadableId,
    this.roleName,
    this.roleType,
    this.shopId,
    this.organizationId,
    this.organizationName,
    this.branchReadableId,
    this.branchAddressLine1,
    this.branchAddressLine2,
    this.branchCity,
    this.branchCountry,
    this.branchPincode,
    this.modules,
    this.userId,
    this.expirationDate,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    LoginResponse response = LoginResponse(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      tokenType: json["token_type"],
      isTwoFactorAuthEnabled: json["is_two_factor_auth_enabled"],
    );

    // Decode JWT token if available
    if (response.accessToken != null) {
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(response.accessToken!);

      response.id = decodedToken["id"];
      response.userId = decodedToken["user_id"];
      response.roleReadableId = decodedToken["role_readable_id"];
      response.roleName = decodedToken["role_name"];
      response.roleType = decodedToken["role_type"];
      response.shopId = decodedToken["shop_id"];
      response.organizationId = decodedToken["organization_id"];
      response.organizationName = decodedToken["organization_name"];
      response.branchReadableId = decodedToken["branch_readable_id"];
      response.branchAddressLine1 = decodedToken["branch_address_line_1"];
      response.branchAddressLine2 = decodedToken["branch_address_line_2"];
      response.branchCity = decodedToken["branch_city"];
      response.branchCountry = decodedToken["branch_country"];
      response.branchPincode = decodedToken["branch_pincode"];

      // Handle modules list
      if (decodedToken["modules"] != null) {
        response.modules = List<int>.from(decodedToken["modules"]);
      }

      response.expirationDate =
          JwtDecoder.getExpirationDate(response.accessToken!);
    }

    return response;
  }

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "token_type": tokenType,
        "is_two_factor_auth_enabled": isTwoFactorAuthEnabled,
        // Include decoded fields in JSON
        "id": id,
        "user_id": userId,
        "role_readable_id": roleReadableId,
        "role_name": roleName,
        "role_type": roleType,
        "shop_id": shopId,
        "organization_id": organizationId,
        "organization_name": organizationName,
        "branch_readable_id": branchReadableId,
        "branch_address_line1": branchAddressLine1,
        "branch_address_line2": branchAddressLine2,
        "branch_city": branchCity,
        "branch_country": branchCountry,
        "branch_pincode": branchPincode,
        "modules": modules,
        "expiration_date": expirationDate?.toIso8601String(),
      };
}
