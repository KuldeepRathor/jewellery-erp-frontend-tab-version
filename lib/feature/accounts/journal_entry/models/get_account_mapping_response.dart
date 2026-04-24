import 'dart:convert';

class GetAccountMappingResponse {
  List<AccountMapping>? values;

  GetAccountMappingResponse({
    this.values,
  });

  factory GetAccountMappingResponse.fromRawJson(String str) =>
      GetAccountMappingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAccountMappingResponse.fromJson(Map<String, dynamic> json) =>
      GetAccountMappingResponse(
        values: json["values"] == null
            ? []
            : List<AccountMapping>.from(
                json["values"]!.map((x) => AccountMapping.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class AccountMapping {
  int? id;
  String? groupName;
  bool? isMandatory;
  String? groupType;
  dynamic parentGroup;

  AccountMapping({
    this.id,
    this.groupName,
    this.isMandatory,
    this.groupType,
    this.parentGroup,
  });

  factory AccountMapping.fromRawJson(String str) =>
      AccountMapping.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountMapping.fromJson(Map<String, dynamic> json) => AccountMapping(
        id: json["id"],
        groupName: json["group_name"],
        isMandatory: json["is_mandatory"],
        groupType: json["group_type"],
        parentGroup: json["parent_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "is_mandatory": isMandatory,
        "group_type": groupType,
        "parent_group": parentGroup,
      };
}
