import 'dart:convert';

class UpdateCollectionRequest {
  String? taggingLineItemId;
  String? collection;

  UpdateCollectionRequest({
    this.taggingLineItemId,
    this.collection,
  });

  factory UpdateCollectionRequest.fromRawJson(String str) =>
      UpdateCollectionRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCollectionRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCollectionRequest(
        taggingLineItemId: json["tagging_line_item_id"],
        collection: json["collection"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item_id": taggingLineItemId,
        "collection": collection,
      };
}
