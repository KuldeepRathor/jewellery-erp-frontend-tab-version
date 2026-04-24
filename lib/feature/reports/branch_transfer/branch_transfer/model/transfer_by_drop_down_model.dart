import 'dart:convert';

class TransferByDropDownModel {
  List<Value>? values;
  Pagination? pagination;

  TransferByDropDownModel({
    this.values,
    this.pagination,
  });

  TransferByDropDownModel copyWith({
    List<Value>? values,
    Pagination? pagination,
  }) =>
      TransferByDropDownModel(
        values: values ?? this.values,
        pagination: pagination ?? this.pagination,
      );

  factory TransferByDropDownModel.fromRawJson(String str) =>
      TransferByDropDownModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransferByDropDownModel.fromJson(Map<String, dynamic> json) =>
      TransferByDropDownModel(
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
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

  Pagination copyWith({
    int? totalCount,
    int? pageCount,
    dynamic next,
  }) =>
      Pagination(
        totalCount: totalCount ?? this.totalCount,
        pageCount: pageCount ?? this.pageCount,
        next: next ?? this.next,
      );

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

class Value {
  String? id;
  String? organizationId;
  String? employeeId;
  String? shopId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountryCode;

  Value({
    this.id,
    this.organizationId,
    this.employeeId,
    this.shopId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountryCode,
  });

  Value copyWith({
    String? id,
    String? organizationId,
    String? employeeId,
    String? shopId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? phoneCountryCode,
  }) =>
      Value(
        id: id ?? this.id,
        organizationId: organizationId ?? this.organizationId,
        employeeId: employeeId ?? this.employeeId,
        shopId: shopId ?? this.shopId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      );

  factory Value.fromRawJson(String str) => Value.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"],
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
        "id": id,
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
