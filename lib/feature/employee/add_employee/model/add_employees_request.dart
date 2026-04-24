import 'dart:convert';

class AddEmployeesRequest {
  dynamic organizationId;
  String? employeeId;
  dynamic shopId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountryCode;

  AddEmployeesRequest({
    this.organizationId,
    this.employeeId,
    this.shopId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountryCode,
  });

  factory AddEmployeesRequest.fromRawJson(String str) =>
      AddEmployeesRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddEmployeesRequest.fromJson(Map<String, dynamic> json) =>
      AddEmployeesRequest(
        organizationId: json["organization_id"],
        employeeId: json["employee_id"],
        shopId: json["shop_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "employee_id": employeeId,
        "shop_id": shopId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
      };
}
