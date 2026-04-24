import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/add_role_request_model.dart';

class GetRolesResponse {
  List<GetRolesResponseValue>? values;
  Pagination? pagination;

  GetRolesResponse({this.values, this.pagination});

  factory GetRolesResponse.fromRawJson(String str) =>
      GetRolesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRolesResponse.fromJson(Map<String, dynamic> json) =>
      GetRolesResponse(
        values:
            json["values"] == null
                ? []
                : List<GetRolesResponseValue>.from(
                  json["values"]!.map((x) => GetRolesResponseValue.fromJson(x)),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class GetRolesResponseValue {
  String? id;
  String? roleName;
  RoleType? roleType;
  String? readableId;
  BranchValue? shop;
  String? shopId;
  String? organizationId;
  bool? isTwoFactorAuthEnabled;
  String? phoneNumber;
  Organization? organization;

  GetRolesResponseValue({
    this.id,
    this.roleName,
    this.roleType,
    this.readableId,
    this.shop,
    this.shopId,
    this.organizationId,
    this.isTwoFactorAuthEnabled,
    this.phoneNumber,
    this.organization,
  });

  factory GetRolesResponseValue.fromRawJson(String str) =>
      GetRolesResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRolesResponseValue.fromJson(Map<String, dynamic> json) =>
      GetRolesResponseValue(
        id: json["id"],
        roleName: json["role_name"],
        roleType:
            json["role_type"] == null
                ? null
                : RoleType.fromJson(json["role_type"]),
        readableId: json["readable_id"],
        shop: json["shop"] == null ? null : BranchValue.fromJson(json["shop"]),
        shopId: json["shop_id"],
        organizationId: json["organization_id"],
        isTwoFactorAuthEnabled: json["is_two_factor_auth_enabled"],
        phoneNumber: json["phone_number"],
        organization:
            json["organization"] == null
                ? null
                : Organization.fromJson(json["organization"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_name": roleName,
    "role_type": roleType?.toJson(),
    "readable_id": readableId,
    "shop": shop?.toJson(),
    "shop_id": shopId,
    "organization_id": organizationId,
    "is_two_factor_auth_enabled": isTwoFactorAuthEnabled,
    "phone_number": phoneNumber,
    "organization": organization?.toJson(),
  };
}

class Organization {
  String? id;
  String? name;
  String? type;
  String? status;
  String? description;

  Organization({this.id, this.name, this.type, this.status, this.description});

  factory Organization.fromRawJson(String str) =>
      Organization.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    status: json["status"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "status": status,
    "description": description,
  };
}
