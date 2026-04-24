import 'dart:convert';

class GetEmployeesResponse {
  List<GetEmployeesValue>? values;
  Pagination? pagination;

  GetEmployeesResponse({
    this.values,
    this.pagination,
  });

  factory GetEmployeesResponse.fromRawJson(String str) =>
      GetEmployeesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEmployeesResponse.fromJson(Map<String, dynamic> json) =>
      GetEmployeesResponse(
        values: json["values"] == null
            ? []
            : List<GetEmployeesValue>.from(
                json["values"]!.map((x) => GetEmployeesValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  dynamic next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class GetEmployeesValue {
  String? id;
  String? organizationId;
  String? employeeId;
  String? shopId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountryCode;
  String? code;

  GetEmployeesValue({
    this.id,
    this.organizationId,
    this.employeeId,
    this.shopId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountryCode,
    this.code,
  });

  factory GetEmployeesValue.fromRawJson(String str) =>
      GetEmployeesValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEmployeesValue.fromJson(Map<String, dynamic> json) =>
      GetEmployeesValue(
          id: json["id"],
          organizationId: json["organization_id"],
          employeeId: json["employee_id"],
          shopId: json["shop_id"],
          firstName: json["first_name"],
          lastName: json["last_name"],
          email: json["email"],
          phoneNumber: json["phone_number"],
          phoneCountryCode: json["phone_country_code"],
          code: json["code"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "employee_id": employeeId,
        "shop_id": shopId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
        "code": code,
      };
}
