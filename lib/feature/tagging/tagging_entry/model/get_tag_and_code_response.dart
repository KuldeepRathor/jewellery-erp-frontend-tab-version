import 'dart:convert';

class GetTagAndCodeResponse {
  String? itemCode;
  String? itemId;
  String? codeType;
  int? tag;

  GetTagAndCodeResponse({
    this.itemCode,
    this.itemId,
    this.codeType,
    this.tag,
  });

  factory GetTagAndCodeResponse.fromRawJson(String str) =>
      GetTagAndCodeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTagAndCodeResponse.fromJson(Map<String, dynamic> json) =>
      GetTagAndCodeResponse(
        itemCode: json["item_code"],
        itemId: json["item_id"],
        codeType: json["code_type"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "item_code": itemCode,
        "item_id": itemId,
        "code_type": codeType,
        "tag": tag,
      };
}
