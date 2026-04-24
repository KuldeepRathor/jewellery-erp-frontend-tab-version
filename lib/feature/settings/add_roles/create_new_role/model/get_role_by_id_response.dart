import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/add_role_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/modules_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/roles_listing/models/get_roles_response.dart';

class GetRoleByIdResponse {
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
  List<ModulePermission>? modules;

  GetRoleByIdResponse({
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
    this.modules,
  });

  factory GetRoleByIdResponse.fromRawJson(String str) =>
      GetRoleByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRoleByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetRoleByIdResponse(
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
        modules:
            json["modules"] == null
                ? []
                : List<ModulePermission>.from(
                  json["modules"]!.map((x) => ModulePermission.fromJson(x)),
                ),
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
    "modules":
        modules == null
            ? []
            : List<dynamic>.from(modules!.map((x) => x.toJson())),
  };
}
