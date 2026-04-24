import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/design_line_item_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/design_making_charge_type_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';

class PostDesignRequestModel {
  // String? code;
  String? name;
  String? stockHead;

  bool? tagRequired;
  String? tagCode;
  bool? stoneRequired;
  bool? hasSameImage;
  DesignMakingChargeTypeRequestModel? makingChargeType;
  List<ImageRequestModel>? images;
  List<DesignLineItemRequestModel>? lineItems;
  String? remarks;

  PostDesignRequestModel({
    // this.code,
    this.name,
    this.stockHead,
    this.tagRequired,
    this.tagCode,
    this.stoneRequired,
    this.hasSameImage,
    this.makingChargeType,
    this.images,
    this.lineItems,
    this.remarks,
  });

  factory PostDesignRequestModel.fromRawJson(String str) =>
      PostDesignRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostDesignRequestModel.fromJson(Map<String, dynamic> json) =>
      PostDesignRequestModel(
        // code: json["code"],
        name: json["name"],
        stockHead: json["stock_head"],
        tagRequired: json["tag_required"],
        tagCode: json["tag_code"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType:
            json["making_charge_type"] == null
                ? null
                : DesignMakingChargeTypeRequestModel.fromJson(
                  json["making_charge_type"],
                ),
        images:
            json["images"] == null
                ? []
                : List<ImageRequestModel>.from(
                  json["images"]!.map((x) => ImageRequestModel.fromJson(x)),
                ),
        lineItems:
            json["line_items"] == null
                ? []
                : List<DesignLineItemRequestModel>.from(
                  json["line_items"]!.map(
                    (x) => DesignLineItemRequestModel.fromJson(x),
                  ),
                ),
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
    // "code": code,
    "name": name,
    "stock_head": stockHead,
    "tag_required": tagRequired,
    "tag_code": tagCode,
    "stone_required": stoneRequired,
    "has_same_image": hasSameImage,
    "making_charge_type": makingChargeType?.toJson(),
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
    "remarks": remarks,
  };
}
