import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/model/tagging_record_request.dart';

class PostTaggingLineItemRequest {
  String? id;
  String? organizationId;
  String? shopId;
  String? taggedById;
  TaggingLineItem? lineItems;
  String? lotEntryId;

  PostTaggingLineItemRequest({
    this.id,
    this.shopId,
    this.organizationId,
    this.taggedById,
    this.lineItems,
    this.lotEntryId,
  });

  factory PostTaggingLineItemRequest.fromRawJson(String str) =>
      PostTaggingLineItemRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostTaggingLineItemRequest.fromJson(Map<String, dynamic> json) =>
      PostTaggingLineItemRequest(
        id: json["id"],
        taggedById: json["tagged_by_id"],
        lineItems:
            json["line_items"] == null
                ? null
                : TaggingLineItem.fromJson(json["line_items"]),
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        lotEntryId: json["lot_entry_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "shop_id": shopId,
    "tagged_by_id": taggedById,
    "line_item": lineItems?.toJson(),
    "lot_entry_id": lotEntryId,
  };
}
