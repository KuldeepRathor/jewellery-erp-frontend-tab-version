import 'dart:convert';

class PostTaggingLineItemResponse {
  String? id;
  String? organizationId;
  String? recordNumber;
  String? taggedById;
  List<PostTaggingLineItemResponseLineItem>? lineItems;

  PostTaggingLineItemResponse({
    this.id,
    this.organizationId,
    this.recordNumber,
    this.taggedById,
    this.lineItems,
  });

  factory PostTaggingLineItemResponse.fromRawJson(String str) =>
      PostTaggingLineItemResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostTaggingLineItemResponse.fromJson(Map<String, dynamic> json) =>
      PostTaggingLineItemResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        recordNumber: json["record_number"],
        taggedById: json["tagged_by_id"],
        lineItems: json["line_items"] == null
            ? []
            : List<PostTaggingLineItemResponseLineItem>.from(json["line_items"]!
                .map((x) => PostTaggingLineItemResponseLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "record_number": recordNumber,
        "tagged_by_id": taggedById,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class PostTaggingLineItemResponseLineItem {
  String? id;
  String? organizationId;
  String? shopId;
  String? status;
  String? vendorId;
  String? code;
  String? codeId;
  String? tagBarcode;
  int? tagNumber;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? va;
  String? mc;
  String? rate;
  String? huid;
  String? purity;
  PosTaggingLineItemResponseDesign? design;
  PosTaggingLineItemResponseSizeGroup? sizeGroup;
  PosTaggingLineItemResponseCounter? counter;
  PosTaggingLineItemResponseCounter? startCounter;
  List<PosTaggingLineItemResponseImage>? images;
  List<PosTaggingLineItemResponseLineStone>? lineStones;
  String? vendorCode;

  PostTaggingLineItemResponseLineItem({
    this.id,
    this.organizationId,
    this.shopId,
    this.status,
    this.vendorId,
    this.code,
    this.codeId,
    this.tagBarcode,
    this.tagNumber,
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
    this.startCounter,
    this.images,
    this.lineStones,
    this.vendorCode,
  });

  factory PostTaggingLineItemResponseLineItem.fromRawJson(String str) =>
      PostTaggingLineItemResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostTaggingLineItemResponseLineItem.fromJson(
          Map<String, dynamic> json) =>
      PostTaggingLineItemResponseLineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        status: json["status"],
        vendorId: json["vendor_id"],
        code: json["code"],
        codeId: json["code_id"],
        tagBarcode: json["tag_barcode"],
        tagNumber: json["tag_number"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        va: json["va"],
        mc: json["mc"],
        rate: json["rate"],
        huid: json["huid"],
        purity: json["purity"],
        design: json["design"] == null
            ? null
            : PosTaggingLineItemResponseDesign.fromJson(json["design"]),
        sizeGroup: json["size_group"] == null
            ? null
            : PosTaggingLineItemResponseSizeGroup.fromJson(json["size_group"]),
        counter: json["counter"] == null
            ? null
            : PosTaggingLineItemResponseCounter.fromJson(json["counter"]),
        startCounter: json["start_counter"] == null
            ? null
            : PosTaggingLineItemResponseCounter.fromJson(json["start_counter"]),
        images: json["images"] == null
            ? []
            : List<PosTaggingLineItemResponseImage>.from(json["images"]!
                .map((x) => PosTaggingLineItemResponseImage.fromJson(x))),
        lineStones: json["line_stones"] == null
            ? []
            : List<PosTaggingLineItemResponseLineStone>.from(
                json["line_stones"]!.map(
                    (x) => PosTaggingLineItemResponseLineStone.fromJson(x))),
        vendorCode: json["vendor_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "status": status,
        "vendor_id": vendorId,
        "code": code,
        "code_id": codeId,
        "tag_barcode": tagBarcode,
        "tag_number": tagNumber,
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
        "start_counter": startCounter?.toJson(),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
        "vendor_code": vendorCode,
      };
}

class PosTaggingLineItemResponseCounter {
  String? id;
  String? code;
  String? counterName;
  String? organizationId;
  bool? isDefault;
  int? totalItems;
  String? totalWeight;

  PosTaggingLineItemResponseCounter({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  factory PosTaggingLineItemResponseCounter.fromRawJson(String str) =>
      PosTaggingLineItemResponseCounter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseCounter.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseCounter(
        id: json["id"],
        code: json["code"],
        counterName: json["counter_name"],
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        totalItems: json["total_items"],
        totalWeight: json["total_weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "counter_name": counterName,
        "organization_id": organizationId,
        "is_default": isDefault,
        "total_items": totalItems,
        "total_weight": totalWeight,
      };
}

class PosTaggingLineItemResponseDesign {
  String? id;
  String? code;
  String? name;
  String? organizationId;
  PosTaggingLineItemResponseStockHead? stockHead;
  PosTaggingLineItemResponseOrnament? ornament;
  bool? tagRequired;
  bool? stoneRequired;
  bool? hasSameImage;
  PosTaggingLineItemResponseType? makingChargeType;
  List<PosTaggingLineItemResponseImage>? images;
  String? remarks;
  List<PosTaggingLineItemResponseDesignLineItem>? lineItems;

  PosTaggingLineItemResponseDesign({
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
    this.remarks,
    this.lineItems,
  });

  factory PosTaggingLineItemResponseDesign.fromRawJson(String str) =>
      PosTaggingLineItemResponseDesign.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseDesign.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseDesign(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        organizationId: json["organization_id"],
        stockHead: json["stock_head"] == null
            ? null
            : PosTaggingLineItemResponseStockHead.fromJson(json["stock_head"]),
        ornament: json["ornament"] == null
            ? null
            : PosTaggingLineItemResponseOrnament.fromJson(json["ornament"]),
        tagRequired: json["tag_required"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType: json["making_charge_type"] == null
            ? null
            : PosTaggingLineItemResponseType.fromJson(
                json["making_charge_type"]),
        images: json["images"] == null
            ? []
            : List<PosTaggingLineItemResponseImage>.from(json["images"]!
                .map((x) => PosTaggingLineItemResponseImage.fromJson(x))),
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<PosTaggingLineItemResponseDesignLineItem>.from(
                json["line_items"]!.map((x) =>
                    PosTaggingLineItemResponseDesignLineItem.fromJson(x))),
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
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class PosTaggingLineItemResponseImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  PosTaggingLineItemResponseImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory PosTaggingLineItemResponseImage.fromRawJson(String str) =>
      PosTaggingLineItemResponseImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseImage.fromJson(Map<String, dynamic> json) =>
      PosTaggingLineItemResponseImage(
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

class PosTaggingLineItemResponseDesignLineItem {
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

  PosTaggingLineItemResponseDesignLineItem({
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

  factory PosTaggingLineItemResponseDesignLineItem.fromRawJson(String str) =>
      PosTaggingLineItemResponseDesignLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseDesignLineItem.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseDesignLineItem(
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

class PosTaggingLineItemResponseType {
  String? id;
  String? typeName;

  PosTaggingLineItemResponseType({
    this.id,
    this.typeName,
  });

  factory PosTaggingLineItemResponseType.fromRawJson(String str) =>
      PosTaggingLineItemResponseType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseType.fromJson(Map<String, dynamic> json) =>
      PosTaggingLineItemResponseType(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}

class PosTaggingLineItemResponseOrnament {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  PosTaggingLineItemResponseMetalType? metalType;
  String? openingWeight;
  String? openingAmount;
  int? openingQuantity;
  String? gst;
  DateTime? createdAt;

  PosTaggingLineItemResponseOrnament({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.hsnSac,
    this.metalType,
    this.openingWeight,
    this.openingAmount,
    this.openingQuantity,
    this.gst,
    this.createdAt,
  });

  factory PosTaggingLineItemResponseOrnament.fromRawJson(String str) =>
      PosTaggingLineItemResponseOrnament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseOrnament.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseOrnament(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType: json["metal_type"] == null
            ? null
            : PosTaggingLineItemResponseMetalType.fromJson(json["metal_type"]),
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        openingQuantity: json["opening_quantity"],
        gst: json["gst"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "organization_id": organizationId,
        "hsn_sac": hsnSac,
        "metal_type": metalType?.toJson(),
        "opening_weight": openingWeight,
        "opening_amount": openingAmount,
        "opening_quantity": openingQuantity,
        "gst": gst,
        "created_at": createdAt?.toIso8601String(),
      };
}

class PosTaggingLineItemResponseMetalType {
  String? id;
  String? typeName;
  String? codeType;

  PosTaggingLineItemResponseMetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory PosTaggingLineItemResponseMetalType.fromRawJson(String str) =>
      PosTaggingLineItemResponseMetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseMetalType.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseMetalType(
        id: json["id"],
        typeName: json["type_name"],
        codeType: json["code_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "code_type": codeType,
      };
}

class PosTaggingLineItemResponseStockHead {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  PosTaggingLineItemResponseCategory? category;
  bool? isNetWeight;
  String? hallmarkExtraCharge;
  PosTaggingLineItemResponseType? metalType;
  bool? sizeRequired;
  List<PosTaggingLineItemResponseWeightGroup>? weightGroups;
  List<PosTaggingLineItemResponseSizeGroup>? sizeGroups;

  PosTaggingLineItemResponseStockHead({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.category,
    this.isNetWeight,
    this.hallmarkExtraCharge,
    this.metalType,
    this.sizeRequired,
    this.weightGroups,
    this.sizeGroups,
  });

  factory PosTaggingLineItemResponseStockHead.fromRawJson(String str) =>
      PosTaggingLineItemResponseStockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseStockHead.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseStockHead(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        category: json["category"] == null
            ? null
            : PosTaggingLineItemResponseCategory.fromJson(json["category"]),
        isNetWeight: json["is_net_weight"],
        hallmarkExtraCharge: json["hallmark_extra_charge"],
        metalType: json["metal_type"] == null
            ? null
            : PosTaggingLineItemResponseType.fromJson(json["metal_type"]),
        sizeRequired: json["size_required"],
        weightGroups: json["weight_groups"] == null
            ? []
            : List<PosTaggingLineItemResponseWeightGroup>.from(
                json["weight_groups"]!.map(
                    (x) => PosTaggingLineItemResponseWeightGroup.fromJson(x))),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<PosTaggingLineItemResponseSizeGroup>.from(
                json["size_groups"]!.map(
                    (x) => PosTaggingLineItemResponseSizeGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "organization_id": organizationId,
        "category": category?.toJson(),
        "is_net_weight": isNetWeight,
        "hallmark_extra_charge": hallmarkExtraCharge,
        "metal_type": metalType?.toJson(),
        "size_required": sizeRequired,
        "weight_groups": weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x.toJson())),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x.toJson())),
      };
}

class PosTaggingLineItemResponseCategory {
  String? id;
  String? categoryName;

  PosTaggingLineItemResponseCategory({
    this.id,
    this.categoryName,
  });

  factory PosTaggingLineItemResponseCategory.fromRawJson(String str) =>
      PosTaggingLineItemResponseCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseCategory.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseCategory(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class PosTaggingLineItemResponseSizeGroup {
  String? id;
  String? code;
  String? size;

  PosTaggingLineItemResponseSizeGroup({
    this.id,
    this.code,
    this.size,
  });

  factory PosTaggingLineItemResponseSizeGroup.fromRawJson(String str) =>
      PosTaggingLineItemResponseSizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseSizeGroup.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseSizeGroup(
        id: json["id"],
        code: json["code"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "size": size,
      };
}

class PosTaggingLineItemResponseWeightGroup {
  String? id;
  String? name;
  String? code;
  String? minWeight;
  String? maxWeight;

  PosTaggingLineItemResponseWeightGroup({
    this.id,
    this.name,
    this.code,
    this.minWeight,
    this.maxWeight,
  });

  factory PosTaggingLineItemResponseWeightGroup.fromRawJson(String str) =>
      PosTaggingLineItemResponseWeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseWeightGroup.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseWeightGroup(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "min_weight": minWeight,
        "max_weight": maxWeight,
      };
}

class PosTaggingLineItemResponseLineStone {
  String? id;
  String? organizationId;
  String? referenceStoneId;
  String? taggingLineItemId;
  String? name;
  int? pieces;
  String? carat;
  String? weight;
  String? rate;
  String? total;

  PosTaggingLineItemResponseLineStone({
    this.id,
    this.organizationId,
    this.referenceStoneId,
    this.taggingLineItemId,
    this.name,
    this.pieces,
    this.carat,
    this.weight,
    this.rate,
    this.total,
  });

  factory PosTaggingLineItemResponseLineStone.fromRawJson(String str) =>
      PosTaggingLineItemResponseLineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosTaggingLineItemResponseLineStone.fromJson(
          Map<String, dynamic> json) =>
      PosTaggingLineItemResponseLineStone(
        id: json["id"],
        organizationId: json["organization_id"],
        referenceStoneId: json["reference_stone_id"],
        taggingLineItemId: json["tagging_line_item_id"],
        name: json["name"],
        pieces: json["pieces"],
        carat: json["carat"],
        weight: json["weight"],
        rate: json["rate"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "reference_stone_id": referenceStoneId,
        "tagging_line_item_id": taggingLineItemId,
        "name": name,
        "pieces": pieces,
        "carat": carat,
        "weight": weight,
        "rate": rate,
        "total": total,
      };
}
