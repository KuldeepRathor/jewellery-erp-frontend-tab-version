import 'dart:convert';

class UpdateGenderRequest {
  String? taggingLineItemId;
  String? gender;

  UpdateGenderRequest({
    this.taggingLineItemId,
    this.gender,
  });

  factory UpdateGenderRequest.fromRawJson(String str) =>
      UpdateGenderRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateGenderRequest.fromJson(Map<String, dynamic> json) =>
      UpdateGenderRequest(
        taggingLineItemId: json["tagging_line_item_id"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item_id": taggingLineItemId,
        "gender": gender,
      };
}
