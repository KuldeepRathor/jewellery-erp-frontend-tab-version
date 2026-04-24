import 'dart:convert';

class PermissionObject {
  List<ModulePermission>? modules;

  PermissionObject({
    this.modules,
  });

  factory PermissionObject.fromRawJson(String str) =>
      PermissionObject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PermissionObject.fromJson(Map<String, dynamic> json) =>
      PermissionObject(
        modules: json["modules"] == null
            ? []
            : List<ModulePermission>.from(
                json["modules"]!.map((x) => ModulePermission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "modules": modules == null
            ? []
            : List<dynamic>.from(modules!.map((x) => x.toJson())),
      };
}

class ModulePermission {
  // String? id;
  int? moduleId;
  String? name;
  String? displayName;
  bool? isActive;
  List<PagePermission>? pages;

  ModulePermission({
    // this.id,
    this.moduleId,
    this.name,
    this.displayName,
    this.isActive,
    this.pages,
  });

  factory ModulePermission.fromRawJson(String str) =>
      ModulePermission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModulePermission.fromJson(Map<String, dynamic> json) =>
      ModulePermission(
        // id: json["id"],
        moduleId: json["module_id"],
        name: json["name"],
        displayName: json["display_name"],
        isActive: json["is_active"],
        pages: json["pages"] == null
            ? []
            : List<PagePermission>.from(
                json["pages"]!.map((x) => PagePermission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "module_id": moduleId,
        "name": name,
        "display_name": displayName,
        "is_active": isActive,
        "pages": pages == null
            ? []
            : List<dynamic>.from(pages!.map((x) => x.toJson())),
      };
}

class PagePermission {
  // String? id;
  int? pageId;
  String? name;
  String? displayName;
  bool? isActive;
  List<ActionPermission>? actions;

  PagePermission({
    // this.id,
    this.pageId,
    this.name,
    this.displayName,
    this.isActive,
    this.actions,
  });

  factory PagePermission.fromRawJson(String str) =>
      PagePermission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PagePermission.fromJson(Map<String, dynamic> json) => PagePermission(
        // id: json["id"],
        pageId: json["page_id"],
        name: json["name"],
        displayName: json["display_name"],
        isActive: json["is_active"],
        actions: json["actions"] == null
            ? []
            : List<ActionPermission>.from(
                json["actions"]!.map((x) => ActionPermission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "page_id": pageId,
        "name": name,
        "display_name": displayName,
        "is_active": isActive,
        "actions": actions == null
            ? []
            : List<dynamic>.from(actions!.map((x) => x.toJson())),
      };
}

class ActionPermission {
  // String? id;
  int? actionId;
  String? name;
  String? displayName;
  bool? isActive;

  ActionPermission({
    // this.id,
    this.actionId,
    this.name,
    this.displayName,
    this.isActive,
  });

  factory ActionPermission.fromRawJson(String str) =>
      ActionPermission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActionPermission.fromJson(Map<String, dynamic> json) =>
      ActionPermission(
        // id: json["id"],
        actionId: json["action_id"],
        name: json["name"],
        displayName: json["display_name"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "action_id": actionId,
        "name": name,
        "display_name": displayName,
        "is_active": isActive,
      };
}
