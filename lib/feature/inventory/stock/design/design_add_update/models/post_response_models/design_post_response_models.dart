import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_images_upload_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_line_items_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/making_charges_type_value.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_value.dart';

class PostDesignResponseModel {
  String? id;
  String? code;
  String? name;
  String? organizationId;
  StockHeadValue? stockHead;
  OrnamnetTypeValues? ornament;
  bool? tagRequired;
  bool? stoneRequired;
  bool? hasSameImage;
  MakingChargesTypeValue? makingChargeType;
  List<ImageResponseModel>? images;
  List<DesignLineItemsModel>? lineItems;

  PostDesignResponseModel({
    this.id,
    this.code,
    this.name,
    this.organizationId,
    this.stockHead,
    this.ornament,
    this.tagRequired,
    this.stoneRequired,
    this.hasSameImage,
    this.makingChargeType,
    this.images,
    this.lineItems,
  });

  factory PostDesignResponseModel.fromRawJson(String str) =>
      PostDesignResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostDesignResponseModel.fromJson(Map<String, dynamic> json) =>
      PostDesignResponseModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        organizationId: json["organization_id"],
        stockHead:
            json["stock_head"] == null
                ? null
                : StockHeadValue.fromJson(json["stock_head"]),
        ornament:
            json["ornament"] == null
                ? null
                : OrnamnetTypeValues.fromJson(json["ornament"]),
        tagRequired: json["tag_required"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType:
            json["making_charge_type"] == null
                ? null
                : MakingChargesTypeValue.fromJson(json["making_charge_type"]),
        images:
            json["images"] == null
                ? []
                : List<ImageResponseModel>.from(
                  json["images"]!.map((x) => ImageResponseModel.fromJson(x)),
                ),
        lineItems:
            json["line_items"] == null
                ? []
                : List<DesignLineItemsModel>.from(
                  json["line_items"]!.map(
                    (x) => DesignLineItemsModel.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "organization_id": organizationId,
    "stock_head": stockHead?.toJson(),
    "ornament": ornament?.toJson(),
    "tag_required": tagRequired,
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
  };
}
