import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/create_new_role/model/modules_response.dart';

class GetRoleTypesResponse {
  String? id;
  String? roleType;
  List<ModulePermission>? modules;

  GetRoleTypesResponse({this.id, this.roleType, this.modules});

  factory GetRoleTypesResponse.fromRawJson(String str) =>
      GetRoleTypesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRoleTypesResponse.fromJson(Map<String, dynamic> json) =>
      GetRoleTypesResponse(
        id: json["id"],
        roleType: json["role_type"],
        modules:
            json["modules"] == null
                ? []
                : List<ModulePermission>.from(
                  json["modules"]!.map((x) => ModulePermission.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_type": roleType,
    "modules":
        modules == null
            ? []
            : List<dynamic>.from(modules!.map((x) => x.toJson())),
  };
}
