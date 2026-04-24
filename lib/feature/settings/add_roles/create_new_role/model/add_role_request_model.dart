import 'dart:convert';

import 'modules_response.dart';

class AddRoleRequestModel {
  String? id;
  RoleType? roleType;
  String? pin;
  String roleName;
  String readableId;
  String shopId;
  bool isTwoFactorAuthEnabled;
  String phoneNumber;
  String? organizationId;
  List<ModulePermission> modules; // Added modules field

  AddRoleRequestModel({
    this.id,
    required this.roleType,
    required this.pin,
    required this.roleName,
    required this.readableId,
    required this.shopId,
    required this.isTwoFactorAuthEnabled,
    required this.phoneNumber,
    this.organizationId,
    required this.modules,
  });

  // Convert JSON to Dart object
  factory AddRoleRequestModel.fromJson(Map<String, dynamic> json) {
    return AddRoleRequestModel(
      id: json["id"],
      roleType: json["role_type"] == null
          ? null
          : RoleType.fromJson(json["role_type"]),
      pin: json['pin'],
      roleName: json['role_name'],
      readableId: json['readable_id'],
      shopId: json['shop_id'],
      isTwoFactorAuthEnabled: json['is_two_factor_auth_enabled'],
      phoneNumber: json['phone_number'],
      organizationId: json['organization_id'],
      modules: json["modules"],
    );
  }

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role_type": roleType?.toJson(),
      'pin': pin,
      'role_name': roleName,
      'readable_id': readableId,
      'shop_id': shopId,
      'is_two_factor_auth_enabled': isTwoFactorAuthEnabled,
      'phone_number': phoneNumber,
      'organization_id': organizationId,
      "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
    };
  }
}

class RoleType {
  String? id;
  String? name;

  RoleType({
    this.id,
    this.name,
  });

  factory RoleType.fromRawJson(String str) =>
      RoleType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoleType.fromJson(Map<String, dynamic> json) => RoleType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
