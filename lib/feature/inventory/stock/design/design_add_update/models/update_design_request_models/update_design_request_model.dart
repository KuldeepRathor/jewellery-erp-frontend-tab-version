import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/update_design_request_models/update_design_line_items_model.dart';

class UpdateDesignRequestModel {
  // String? code;
  String? name;
  String? stockHeadId;

  bool? tagRequired;
  bool? stoneRequired;
  bool? hasSameImage;
  String? makingChargeType;
  List<ImageRequestModel>? images;
  List<UpdateDesignLineItemRequestModel>? lineItems;
  String? remarks;
  bool? changeExistingTags;

  UpdateDesignRequestModel({
    // this.code,
    this.name,
    this.stockHeadId,
    this.tagRequired,
    this.stoneRequired,
    this.hasSameImage,
    this.makingChargeType,
    this.images,
    this.lineItems,
    this.remarks,
    this.changeExistingTags,
  });

  factory UpdateDesignRequestModel.fromRawJson(String str) =>
      UpdateDesignRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateDesignRequestModel.fromJson(Map<String, dynamic> json) =>
      UpdateDesignRequestModel(
        // code: json["code"],
        name: json["name"],
        stockHeadId: json["stock_head_id"],
        tagRequired: json["tag_required"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType: json["making_charge_type"],
        images:
            json["images"] == null
                ? []
                : List<ImageRequestModel>.from(
                  json["images"]!.map((x) => ImageRequestModel.fromJson(x)),
                ),
        lineItems:
            json["line_items"] == null
                ? []
                : List<UpdateDesignLineItemRequestModel>.from(
                  json["line_items"]!.map(
                    (x) => UpdateDesignLineItemRequestModel.fromJson(x),
                  ),
                ),
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
    // "code": code,
    "name": name,
    "stock_head_id": stockHeadId,
    "tag_required": tagRequired,
    "stone_required": stoneRequired,
    "has_same_image": hasSameImage,
    "making_charge_type": makingChargeType,
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
    "remarks": remarks,
    "change_existing_tags": "${changeExistingTags ?? false}",
  };
}
