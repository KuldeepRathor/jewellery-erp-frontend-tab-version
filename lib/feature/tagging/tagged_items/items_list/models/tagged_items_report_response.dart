import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';

class GetTaggedItemsReportResponse {
  Pagination? pagination;
  List<TaggedItemReportValueResponse>? values;

  GetTaggedItemsReportResponse({this.pagination, this.values});

  factory GetTaggedItemsReportResponse.fromRawJson(String str) =>
      GetTaggedItemsReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsReportResponse.fromJson(Map<String, dynamic> json) =>
      GetTaggedItemsReportResponse(
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
        values:
            json["values"] == null
                ? []
                : List<TaggedItemReportValueResponse>.from(
                  json["values"]!.map(
                    (x) => TaggedItemReportValueResponse.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

class TaggedItemReportValueResponse {
  String? code;
  bool? isWebstore;
  String? codeId;
  TaggedItemReportCounterResponse? counter;
  TaggedItemReportDesignResponse? design;
  String? grossWeight;
  String? huid;
  String? id;
  List<TaggedItemReportImageResponse>? images;
  List<TaggedItemReportLineStoneResponse>? lineStones;
  String? mc;
  String? netWeight;
  String? organizationId;
  int? pieces;
  String? purity;
  String? rate;
  String? shopId;
  TaggedItemReportSizeGroupResponse? sizeGroup;
  int? tagNumber;
  String? tagBarcode;
  String? va;
  String? vendorId;
  String? vendorCode;
  String? taggedById;
  DateTime? lastScannedAt;

  TaggedItemReportValueResponse({
    this.code,
    this.isWebstore,
    this.codeId,
    this.counter,
    this.design,
    this.grossWeight,
    this.huid,
    this.id,
    this.images,
    this.lineStones,
    this.mc,
    this.netWeight,
    this.organizationId,
    this.pieces,
    this.purity,
    this.rate,
    this.shopId,
    this.sizeGroup,
    this.tagNumber,
    this.tagBarcode,
    this.va,
    this.vendorId,
    this.vendorCode,
    this.taggedById,
    this.lastScannedAt,
  });

  factory TaggedItemReportValueResponse.fromRawJson(String str) =>
      TaggedItemReportValueResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportValueResponse.fromJson(Map<String, dynamic> json) =>
      TaggedItemReportValueResponse(
        code: json["code"],
        isWebstore: json["is_webstore"],
        codeId: json["code_id"],
        counter:
            json["counter"] == null
                ? null
                : TaggedItemReportCounterResponse.fromJson(json["counter"]),
        design:
            json["design"] == null
                ? null
                : TaggedItemReportDesignResponse.fromJson(json["design"]),
        grossWeight: json["gross_weight"],
        huid: json["huid"],
        id: json["id"],
        images:
            json["images"] == null
                ? []
                : List<TaggedItemReportImageResponse>.from(
                  json["images"]!.map(
                    (x) => TaggedItemReportImageResponse.fromJson(x),
                  ),
                ),
        lineStones:
            json["line_stones"] == null
                ? []
                : List<TaggedItemReportLineStoneResponse>.from(
                  json["line_stones"]!.map(
                    (x) => TaggedItemReportLineStoneResponse.fromJson(x),
                  ),
                ),
        mc: json["mc"],
        netWeight: json["net_weight"],
        organizationId: json["organization_id"],
        pieces: json["pieces"],
        purity: json["purity"],
        rate: json["rate"],
        shopId: json["shop_id"],
        sizeGroup:
            json["size_group"] == null
                ? null
                : TaggedItemReportSizeGroupResponse.fromJson(
                  json["size_group"],
                ),
        tagNumber: json["tag_number"],
        tagBarcode: json["tag_barcode"],
        va: json["va"],
        vendorId: json["vendor_id"],
        vendorCode: json["vendor_code"],
        taggedById: json["tagged_by_id"],
        lastScannedAt:
            json["last_scanned_at"] == null
                ? null
                : DateTime.parse(json["last_scanned_at"]),
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "is_webstore": isWebstore,
    "code_id": codeId,
    "counter": counter?.toJson(),
    "design": design?.toJson(),
    "gross_weight": grossWeight,
    "huid": huid,
    "id": id,
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "line_stones":
        lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
    "mc": mc,
    "net_weight": netWeight,
    "organization_id": organizationId,
    "pieces": pieces,
    "purity": purity,
    "rate": rate,
    "shop_id": shopId,
    "size_group": sizeGroup?.toJson(),
    "tag_number": tagNumber,
    "tag_barcode": tagBarcode,
    "va": va,
    "vendor_id": vendorId,
    "vendor_code": vendorCode,
    "tagged_by_id": taggedById,
    "last_scanned_at": lastScannedAt?.toIso8601String(),
  };
}

class TaggedItemReportCounterResponse {
  String? code;
  String? counterName;
  String? id;
  bool? isDefault;
  String? organizationId;
  int? totalItems;
  String? totalWeight;

  TaggedItemReportCounterResponse({
    this.code,
    this.counterName,
    this.id,
    this.isDefault,
    this.organizationId,
    this.totalItems,
    this.totalWeight,
  });

  factory TaggedItemReportCounterResponse.fromRawJson(String str) =>
      TaggedItemReportCounterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportCounterResponse.fromJson(Map<String, dynamic> json) =>
      TaggedItemReportCounterResponse(
        code: json["code"],
        counterName: json["counter_name"],
        id: json["id"],
        isDefault: json["is_default"],
        organizationId: json["organization_id"],
        totalItems: json["total_items"],
        totalWeight: json["total_weight"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "counter_name": counterName,
    "id": id,
    "is_default": isDefault,
    "organization_id": organizationId,
    "total_items": totalItems,
    "total_weight": totalWeight,
  };
}

class TaggedItemReportDesignResponse {
  String? code;
  bool? hasSameImage;
  String? id;
  List<TaggedItemReportImageResponse>? images;
  List<TaggedItemReportLineItemResponse>? lineItems;
  String? name;
  String? organizationId;
  TaggedItemReportOrnamentResponse? ornament;
  String? remarks;
  TaggedItemReportStockHeadResponse? stockHead;
  bool? stoneRequired;
  bool? tagRequired;

  TaggedItemReportDesignResponse({
    this.code,
    this.hasSameImage,
    this.id,
    this.images,
    this.lineItems,
    this.name,
    this.organizationId,
    this.ornament,
    this.remarks,
    this.stockHead,
    this.stoneRequired,
    this.tagRequired,
  });

  factory TaggedItemReportDesignResponse.fromRawJson(String str) =>
      TaggedItemReportDesignResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportDesignResponse.fromJson(Map<String, dynamic> json) =>
      TaggedItemReportDesignResponse(
        code: json["code"],
        hasSameImage: json["has_same_image"],
        id: json["id"],
        images:
            json["images"] == null
                ? []
                : List<TaggedItemReportImageResponse>.from(
                  json["images"]!.map(
                    (x) => TaggedItemReportImageResponse.fromJson(x),
                  ),
                ),
        lineItems:
            json["line_items"] == null
                ? []
                : List<TaggedItemReportLineItemResponse>.from(
                  json["line_items"]!.map(
                    (x) => TaggedItemReportLineItemResponse.fromJson(x),
                  ),
                ),
        name: json["name"],
        organizationId: json["organization_id"],
        ornament:
            json["ornament"] == null
                ? null
                : TaggedItemReportOrnamentResponse.fromJson(json["ornament"]),
        remarks: json["remarks"],
        stockHead:
            json["stock_head"] == null
                ? null
                : TaggedItemReportStockHeadResponse.fromJson(
                  json["stock_head"],
                ),
        stoneRequired: json["stone_required"],
        tagRequired: json["tag_required"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "has_same_image": hasSameImage,
    "id": id,
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
    "name": name,
    "organization_id": organizationId,
    "ornament": ornament?.toJson(),
    "remarks": remarks,
    "stock_head": stockHead?.toJson(),
    "stone_required": stoneRequired,
    "tag_required": tagRequired,
  };
}

class TaggedItemReportImageResponse {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  TaggedItemReportImageResponse({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory TaggedItemReportImageResponse.fromRawJson(String str) =>
      TaggedItemReportImageResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportImageResponse.fromJson(Map<String, dynamic> json) =>
      TaggedItemReportImageResponse(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_name": fileName,
    "file_type": fileType,
    "s3_key": s3Key,
    "presigned_url": presignedUrl,
  };
}

class TaggedItemReportLineItemResponse {
  String? id;
  String? organizationId;
  String? purity;
  String? minWeight;
  String? maxWeight;
  String? wastageType;
  String? wastage;
  String? makingCharges;
  String? makingChargesType;
  String? minVa;
  String? minMc;

  TaggedItemReportLineItemResponse({
    this.id,
    this.organizationId,
    this.purity,
    this.minWeight,
    this.maxWeight,
    this.wastageType,
    this.wastage,
    this.makingCharges,
    this.makingChargesType,
    this.minVa,
    this.minMc,
  });

  factory TaggedItemReportLineItemResponse.fromRawJson(String str) =>
      TaggedItemReportLineItemResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportLineItemResponse.fromJson(
    Map<String, dynamic> json,
  ) => TaggedItemReportLineItemResponse(
    id: json["id"],
    organizationId: json["organization_id"],
    purity: json["purity"],
    minWeight: json["min_weight"],
    maxWeight: json["max_weight"],
    wastageType: json["wastage_type"],
    wastage: json["wastage"],
    makingCharges: json["making_charges"],
    makingChargesType: json["making_charges_type"],
    minVa: json["min_va"],
    minMc: json["min_mc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "purity": purity,
    "min_weight": minWeight,
    "max_weight": maxWeight,
    "wastage_type": wastageType,
    "wastage": wastage,
    "making_charges": makingCharges,
    "making_charges_type": makingChargesType,
    "min_va": minVa,
    "min_mc": minMc,
  };
}

class TaggedItemReportOrnamentResponse {
  String? id;
  String? type;

  TaggedItemReportOrnamentResponse({this.id, this.type});

  factory TaggedItemReportOrnamentResponse.fromRawJson(String str) =>
      TaggedItemReportOrnamentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportOrnamentResponse.fromJson(
    Map<String, dynamic> json,
  ) => TaggedItemReportOrnamentResponse(id: json["id"], type: json["type"]);

  Map<String, dynamic> toJson() => {"id": id, "type": type};
}

class TaggedItemReportStockHeadResponse {
  String? id;
  String? name;

  TaggedItemReportStockHeadResponse({this.id, this.name});

  factory TaggedItemReportStockHeadResponse.fromRawJson(String str) =>
      TaggedItemReportStockHeadResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportStockHeadResponse.fromJson(
    Map<String, dynamic> json,
  ) => TaggedItemReportStockHeadResponse(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class TaggedItemReportLineStoneResponse {
  String? carat;
  String? id;
  String? name;
  int? pieces;
  String? rate;
  String? total;
  String? weight;

  TaggedItemReportLineStoneResponse({
    this.carat,
    this.id,
    this.name,
    this.pieces,
    this.rate,
    this.total,
    this.weight,
  });

  factory TaggedItemReportLineStoneResponse.fromRawJson(String str) =>
      TaggedItemReportLineStoneResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportLineStoneResponse.fromJson(
    Map<String, dynamic> json,
  ) => TaggedItemReportLineStoneResponse(
    carat: json["carat"],
    id: json["id"],
    name: json["name"],
    pieces: json["pieces"],
    rate: json["rate"],
    total: json["total"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "carat": carat,
    "id": id,
    "name": name,
    "pieces": pieces,
    "rate": rate,
    "total": total,
    "weight": weight,
  };
}

class TaggedItemReportSizeGroupResponse {
  String? code;
  String? id;
  String? size;

  TaggedItemReportSizeGroupResponse({this.code, this.id, this.size});

  factory TaggedItemReportSizeGroupResponse.fromRawJson(String str) =>
      TaggedItemReportSizeGroupResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemReportSizeGroupResponse.fromJson(
    Map<String, dynamic> json,
  ) => TaggedItemReportSizeGroupResponse(
    code: json["code"],
    id: json["id"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {"code": code, "id": id, "size": size};
}
