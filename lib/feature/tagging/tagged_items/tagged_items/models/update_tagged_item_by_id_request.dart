import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_request_models/image_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/models/get_tagged_item_by_id_response.dart';

class UpdateTaggedItemsByIdRequest {
  String? id;
  String? organizationId;
  String? shopId;
  String? recordNumber;
  String? taggedById;
  List<UpdateTaggedItemsByIdRequestLineItem>? lineItems;

  UpdateTaggedItemsByIdRequest({
    this.id,
    this.organizationId,
    this.shopId,
    this.recordNumber,
    this.taggedById,
    this.lineItems,
  });

  factory UpdateTaggedItemsByIdRequest.fromRawJson(String str) =>
      UpdateTaggedItemsByIdRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateTaggedItemsByIdRequest.fromJson(Map<String, dynamic> json) =>
      UpdateTaggedItemsByIdRequest(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        recordNumber: json["record_number"],
        taggedById: json["tagged_by_id"],
        lineItems:
            json["line_items"] == null
                ? []
                : List<UpdateTaggedItemsByIdRequestLineItem>.from(
                  json["line_items"]!.map(
                    (x) => UpdateTaggedItemsByIdRequestLineItem.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "shop_id": shopId,
    "record_number": recordNumber,
    "tagged_by_id": taggedById,
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
  };
}

class UpdateTaggedItemsByIdRequestLineItem {
  String? id;
  String? vendorId;
  String? code;
  String? codeId;
  String? tagBarcode;
  double? pieces;
  double? grossWeight;
  double? netWeight;
  double? va;
  double? mc;
  double? rate;
  String? huid;
  String? purity;
  ObjectWithOnlyId? design;
  ObjectWithOnlyId? sizeGroup;
  ObjectWithOnlyId? counter;
  // List<GetTaggedItemsByIdResponseImage>? images;
  List<ImageRequestModel>? images;
  List<GetTaggedItemsByIdResponseLineStone>? lineStones;

  UpdateTaggedItemsByIdRequestLineItem({
    this.id,
    this.vendorId,
    this.code,
    this.codeId,
    this.tagBarcode,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.va,
    this.mc,
    this.rate,
    this.huid,
    this.purity,
    this.design,
    this.sizeGroup,
    this.counter,
    this.images,
    this.lineStones,
  });

  factory UpdateTaggedItemsByIdRequestLineItem.fromRawJson(String str) =>
      UpdateTaggedItemsByIdRequestLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateTaggedItemsByIdRequestLineItem.fromJson(
    Map<String, dynamic> json,
  ) => UpdateTaggedItemsByIdRequestLineItem(
    id: json["id"],
    vendorId: json["vendor_id"],
    code: json["code"],
    codeId: json["code_id"],
    tagBarcode: json["tag_barcode"],
    pieces: json["pieces"],
    grossWeight: json["gross_weight"],
    netWeight: json["net_weight"],
    va: json["va"],
    mc: json["mc"],
    rate: json["rate"],
    huid: json["huid"],
    purity: json["purity"],
    design:
        json["design"] == null
            ? null
            : ObjectWithOnlyId.fromJson(json["design"]),
    sizeGroup:
        json["size_group"] == null
            ? null
            : ObjectWithOnlyId.fromJson(json["size_group"]),
    counter:
        json["counter"] == null
            ? null
            : ObjectWithOnlyId.fromJson(json["counter"]),
    images:
        json["images"] == null
            ? []
            : List<ImageRequestModel>.from(
              json["images"]!.map((x) => ImageRequestModel.fromJson(x)),
            ),
    lineStones:
        json["line_stones"] == null
            ? []
            : List<GetTaggedItemsByIdResponseLineStone>.from(
              json["line_stones"]!.map(
                (x) => GetTaggedItemsByIdResponseLineStone.fromJson(x),
              ),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_id": vendorId,
    "code": code,
    "code_id": codeId,
    "tag_barcode": tagBarcode,
    "pieces": pieces,
    "gross_weight": grossWeight,
    "net_weight": netWeight,
    "va": va,
    "mc": mc,
    "rate": rate,
    "huid": huid,
    "purity": purity,
    "design": design?.toJson(),
    "size_group": sizeGroup?.toJson(),
    "counter": counter?.toJson(),
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "line_stones":
        lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
  };
}

class ObjectWithOnlyId {
  String? id;

  ObjectWithOnlyId({this.id});

  factory ObjectWithOnlyId.fromRawJson(String str) =>
      ObjectWithOnlyId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ObjectWithOnlyId.fromJson(Map<String, dynamic> json) =>
      ObjectWithOnlyId(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}
