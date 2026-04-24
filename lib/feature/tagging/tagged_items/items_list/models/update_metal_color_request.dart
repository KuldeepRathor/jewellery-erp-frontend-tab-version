import 'dart:convert';

class UpdateMetalColorRequest {
  String? taggingLineItemId;
  String? metalColorId;

  UpdateMetalColorRequest({
    this.taggingLineItemId,
    this.metalColorId,
  });

  factory UpdateMetalColorRequest.fromRawJson(String str) =>
      UpdateMetalColorRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMetalColorRequest.fromJson(Map<String, dynamic> json) =>
      UpdateMetalColorRequest(
        taggingLineItemId: json["tagging_line_item_id"],
        metalColorId: json["metal_color_id"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item_id": taggingLineItemId,
        "metal_color_id": metalColorId,
      };
}
