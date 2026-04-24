import 'dart:convert';

class GetCatalogueListingResponse {
  List<GetCatalogueListingValue>? values;
  Pagination? pagination;

  GetCatalogueListingResponse({
    this.values,
    this.pagination,
  });

  factory GetCatalogueListingResponse.fromRawJson(String str) =>
      GetCatalogueListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCatalogueListingResponse.fromJson(Map<String, dynamic> json) =>
      GetCatalogueListingResponse(
        values: json["values"] == null
            ? []
            : List<GetCatalogueListingValue>.from(json["values"]!
                .map((x) => GetCatalogueListingValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  int? totalPages;
  int? currentPage;
  int? nextPage;
  dynamic previousPage;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        previousPage: json["previous_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "total_pages": totalPages,
        "current_page": currentPage,
        "next_page": nextPage,
        "previous_page": previousPage,
      };
}

class GetCatalogueListingValue {
  String? id;
  String? organizationId;
  String? shopId;
  String? designName;
  Design? design;
  String? minWeight;
  String? maxWeight;
  String? stoneWeight;
  String? rate;
  List<MetalColour>? metalColours;
  List<Purity>? purity;
  List<Gemstone>? gemstones;
  List<CatalogueImage>? images;
  String? stoneRate;
  String? stoneRateType;
  bool? isWebstore;
  bool? isSelected;
  List<String>? collectionNames;

  GetCatalogueListingValue({
    this.id,
    this.organizationId,
    this.shopId,
    this.designName,
    this.design,
    this.minWeight,
    this.maxWeight,
    this.stoneWeight,
    this.rate,
    this.metalColours,
    this.purity,
    this.gemstones,
    this.images,
    this.stoneRate,
    this.stoneRateType,
    this.isWebstore,
    this.isSelected = false,
    this.collectionNames,
  });

  factory GetCatalogueListingValue.fromRawJson(String str) =>
      GetCatalogueListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCatalogueListingValue.fromJson(Map<String, dynamic> json) =>
      GetCatalogueListingValue(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        designName: json["design_name"],
        design: json["design"] == null ? null : Design.fromJson(json["design"]),
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
        stoneWeight: json["stone_weight"],
        rate: "${json["rate"] ?? "0"}",
        metalColours: json["metal_colours"] == null
            ? []
            : List<MetalColour>.from(
                json["metal_colours"]!.map((x) => MetalColour.fromJson(x))),
        purity: json["purity"] == null
            ? []
            : List<Purity>.from(json["purity"]!.map((x) => Purity.fromJson(x))),
        gemstones: json["gemstones"] == null
            ? []
            : List<Gemstone>.from(
                json["gemstones"]!.map((x) => Gemstone.fromJson(x))),
        images: json["images"] == null
            ? []
            : List<CatalogueImage>.from(
                json["images"]!.map((x) => CatalogueImage.fromJson(x))),
        stoneRate: json["stone_rate"],
        stoneRateType: json["stone_rate_type"],
        isWebstore: json["is_webstore"],
        isSelected: json["is_selected"] ?? false,
        collectionNames: json["collection_names"] == null
            ? []
            : List<String>.from(json["collection_names"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "design_name": designName,
        "design": design?.toJson(),
        "min_weight": minWeight,
        "max_weight": maxWeight,
        "metal_colours": metalColours == null
            ? []
            : List<dynamic>.from(metalColours!.map((x) => x.toJson())),
        "purity": purity == null
            ? []
            : List<dynamic>.from(purity!.map((x) => x.toJson())),
        "gemstones": gemstones == null
            ? []
            : List<dynamic>.from(gemstones!.map((x) => x.toJson())),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "stone_rate": stoneRate,
        "stone_rate_type": stoneRateType,
        "is_webstore": isWebstore,
        "is_selected": isSelected,
        "collection_names": collectionNames == null
            ? []
            : List<dynamic>.from(collectionNames!.map((x) => x)),
      };
}

class Design {
  String? id;
  String? code;
  String? name;
  String? organizationId;
  StockHead? stockHead;
  bool? tagRequired;
  dynamic tagCode;
  bool? stoneRequired;
  bool? hasSameImage;
  Type? makingChargeType;
  List<dynamic>? images;
  String? remarks;
  List<LineItem>? lineItems;

  Design({
    this.id,
    this.code,
    this.name,
    this.organizationId,
    this.stockHead,
    this.tagRequired,
    this.tagCode,
    this.stoneRequired,
    this.hasSameImage,
    this.makingChargeType,
    this.images,
    this.remarks,
    this.lineItems,
  });

  factory Design.fromRawJson(String str) => Design.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Design.fromJson(Map<String, dynamic> json) => Design(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        organizationId: json["organization_id"],
        stockHead: json["stock_head"] == null
            ? null
            : StockHead.fromJson(json["stock_head"]),
        tagRequired: json["tag_required"],
        tagCode: json["tag_code"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType: json["making_charge_type"] == null
            ? null
            : Type.fromJson(json["making_charge_type"]),
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "organization_id": organizationId,
        "stock_head": stockHead?.toJson(),
        "tag_required": tagRequired,
        "tag_code": tagCode,
        "stone_required": stoneRequired,
        "has_same_image": hasSameImage,
        "making_charge_type": makingChargeType?.toJson(),
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
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
  Ornament? ornament;
  List<dynamic>? valueCounts;

  LineItem({
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
    this.ornament,
    this.valueCounts,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
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
        ornament: json["ornament"] == null
            ? null
            : Ornament.fromJson(json["ornament"]),
        valueCounts: json["value_counts"] == null
            ? []
            : List<dynamic>.from(json["value_counts"]!.map((x) => x)),
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
        "ornament": ornament?.toJson(),
        "value_counts": valueCounts == null
            ? []
            : List<dynamic>.from(valueCounts!.map((x) => x)),
      };
}

class Ornament {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  MetalType? metalType;
  String? openingWeight;
  String? openingAmount;
  int? openingQuantity;
  String? gst;
  DateTime? createdAt;
  bool? isStone;
  bool? isOldGold;
  bool? isService;
  String? purity;

  Ornament({
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
    this.isStone,
    this.isOldGold,
    this.isService,
    this.purity,
  });

  factory Ornament.fromRawJson(String str) =>
      Ornament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ornament.fromJson(Map<String, dynamic> json) => Ornament(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType: json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        openingQuantity: json["opening_quantity"],
        gst: json["gst"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isStone: json["is_stone"],
        isOldGold: json["is_old_gold"],
        isService: json["is_service"],
        purity: json["purity"],
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
        "is_stone": isStone,
        "is_old_gold": isOldGold,
        "is_service": isService,
        "purity": purity,
      };
}

class MetalType {
  String? id;
  String? typeName;
  String? codeType;

  MetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory MetalType.fromRawJson(String str) =>
      MetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalType.fromJson(Map<String, dynamic> json) => MetalType(
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

class Type {
  String? id;
  String? typeName;

  Type({
    this.id,
    this.typeName,
  });

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}

class StockHead {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  Category? category;
  bool? isNetWeight;
  String? hallmarkExtraCharge;
  Type? metalType;
  bool? sizeRequired;
  List<WeightGroup>? weightGroups;
  List<dynamic>? sizeGroups;

  StockHead({
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

  factory StockHead.fromRawJson(String str) =>
      StockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHead.fromJson(Map<String, dynamic> json) => StockHead(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        isNetWeight: json["is_net_weight"],
        hallmarkExtraCharge: json["hallmark_extra_charge"],
        metalType: json["metal_type"] == null
            ? null
            : Type.fromJson(json["metal_type"]),
        sizeRequired: json["size_required"],
        weightGroups: json["weight_groups"] == null
            ? []
            : List<WeightGroup>.from(
                json["weight_groups"]!.map((x) => WeightGroup.fromJson(x))),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<dynamic>.from(json["size_groups"]!.map((x) => x)),
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
            : List<dynamic>.from(sizeGroups!.map((x) => x)),
      };
}

class Category {
  String? id;
  String? categoryName;
  String? organizationId;
  bool? isWebstore;
  List<dynamic>? images;

  Category({
    this.id,
    this.categoryName,
    this.organizationId,
    this.isWebstore,
    this.images,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        organizationId: json["organization_id"],
        isWebstore: json["is_webstore"],
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "organization_id": organizationId,
        "is_webstore": isWebstore,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}

class WeightGroup {
  String? id;
  String? name;
  String? code;
  String? minWeight;
  String? maxWeight;

  WeightGroup({
    this.id,
    this.name,
    this.code,
    this.minWeight,
    this.maxWeight,
  });

  factory WeightGroup.fromRawJson(String str) =>
      WeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightGroup.fromJson(Map<String, dynamic> json) => WeightGroup(
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

class Gemstone {
  String? id;
  String? code;
  String? name;
  String? rateType;
  String? rate;
  String? color;
  String? cut;
  String? clarity;
  String? buyBackPercentage;
  dynamic ornament;

  Gemstone({
    this.id,
    this.code,
    this.name,
    this.rateType,
    this.rate,
    this.color,
    this.cut,
    this.clarity,
    this.buyBackPercentage,
    this.ornament,
  });

  factory Gemstone.fromRawJson(String str) =>
      Gemstone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gemstone.fromJson(Map<String, dynamic> json) => Gemstone(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        rateType: json["rate_type"],
        rate: json["rate"],
        color: json["color"],
        cut: json["cut"],
        clarity: json["clarity"],
        buyBackPercentage: json["buy_back_percentage"],
        ornament: json["ornament"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "rate_type": rateType,
        "rate": rate,
        "color": color,
        "cut": cut,
        "clarity": clarity,
        "buy_back_percentage": buyBackPercentage,
        "ornament": ornament,
      };
}

class CatalogueImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  CatalogueImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory CatalogueImage.fromRawJson(String str) =>
      CatalogueImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CatalogueImage.fromJson(Map<String, dynamic> json) => CatalogueImage(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3Key,
        "presigned_url": presignedUrl,
        "is_webstore": isWebstore,
      };
}

class MetalColour {
  String? id;
  String? metalColourId;
  String? colourName;

  MetalColour({
    this.id,
    this.metalColourId,
    this.colourName,
  });

  factory MetalColour.fromRawJson(String str) =>
      MetalColour.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalColour.fromJson(Map<String, dynamic> json) => MetalColour(
        id: json["id"],
        metalColourId: json["metal_colour_id"],
        colourName: json["colour_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "metal_colour_id": metalColourId,
        "colour_name": colourName,
      };
}

class Purity {
  String? id;
  String? purityType;

  Purity({
    this.id,
    this.purityType,
  });

  factory Purity.fromRawJson(String str) => Purity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Purity.fromJson(Map<String, dynamic> json) => Purity(
        id: json["id"],
        purityType: json["purity_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purity_type": purityType,
      };
}
