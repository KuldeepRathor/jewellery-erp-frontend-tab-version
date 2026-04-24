import 'dart:convert';

class GetOrnamentTypeDropdownVoucherResponse {
  String? id;
  String? typeName;
  String? codeType;
  String? dropdownId;

  GetOrnamentTypeDropdownVoucherResponse({
    this.id,
    this.typeName,
    this.codeType,
    this.dropdownId,
  });

  factory GetOrnamentTypeDropdownVoucherResponse.fromRawJson(String str) =>
      GetOrnamentTypeDropdownVoucherResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrnamentTypeDropdownVoucherResponse.fromJson(
          Map<String, dynamic> json) =>
      GetOrnamentTypeDropdownVoucherResponse(
        id: json["id"],
        typeName: json["type_name"],
        codeType: json["code_type"],
        dropdownId: json["dropdown_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "code_type": codeType,
        "dropdown_id": dropdownId,
      };
}
