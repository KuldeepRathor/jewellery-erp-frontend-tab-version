import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/post_response_models/design_images_upload_response.dart';

class NewPagination {
  int? totalCount;
  int? totalPages;
  int? currentPage;
  int? nextPage;
  int? previousPage;

  NewPagination({
    this.totalCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  factory NewPagination.fromRawJson(String str) =>
      NewPagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewPagination.fromJson(Map<String, dynamic> json) => NewPagination(
    totalCount: json["total_count"],
    totalPages: json["total_pages"],
    currentPage: json["current_page"],
    nextPage: json["next_page"],
    previousPage: json["previous_page"],
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount,
    "total_pages": totalPages,
    "current_page": currentPage,
    "next_page": nextPage,
    "previous_page": previousPage,
  };
}

class PaginatedDesignListingResponse {
  List<GetDesignResponseModel>? values;
  NewPagination? pagination;

  PaginatedDesignListingResponse({this.values, this.pagination});

  factory PaginatedDesignListingResponse.fromRawJson(String str) =>
      PaginatedDesignListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedDesignListingResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedDesignListingResponse(
        values:
            json["values"] == null
                ? []
                : List<GetDesignResponseModel>.from(
                  json["values"]!.map(
                    (x) => GetDesignResponseModel.fromJson(x),
                  ),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : NewPagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class GetDesignResponseModel {
  String? id;
  String? code;
  String? name;
  String? organizationId;
  StockHead? stockHead;

  bool? tagRequired;
  String? tagCode;
  bool? stoneRequired;
  bool? hasSameImage;
  GetDesignResponseModelType? makingChargeType;
  List<ImageResponseModel>? images;
  List<LineItem>? lineItems;
  String? remarks;

  GetDesignResponseModel({
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
    this.lineItems,
    this.remarks,
  });

  factory GetDesignResponseModel.fromRawJson(String str) =>
      GetDesignResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignResponseModel.fromJson(Map<String, dynamic> json) =>
      GetDesignResponseModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        organizationId: json["organization_id"],
        stockHead:
            json["stock_head"] == null
                ? null
                : StockHead.fromJson(json["stock_head"]),
        tagRequired: json["tag_required"],
        tagCode: json["tag_code"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType:
            json["making_charge_type"] == null
                ? null
                : GetDesignResponseModelType.fromJson(
                  json["making_charge_type"],
                ),
        images:
            json["images"] == null
                ? []
                : List<ImageResponseModel>.from(
                  json["images"]!.map((x) => ImageResponseModel.fromJson(x)),
                ),
        lineItems:
            json["line_items"] == null
                ? []
                : List<LineItem>.from(
                  json["line_items"]!.map((x) => LineItem.fromJson(x)),
                ),
        remarks: json["remarks"],
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

class LineItem {
  String? id;
  String? organizationId;
  String? purity;
  String? minWeight;
  String? maxWeight;
  String? wastageType;
  String? wastage;
  String? makingCharges;
  String? minVa;
  String? minMc;
  String? makingChargesType;
  Ornament? ornament;
  LineItem({
    this.id,
    this.organizationId,
    this.purity,
    this.minWeight,
    this.maxWeight,
    this.wastageType,
    this.wastage,
    this.makingCharges,
    this.minVa,
    this.minMc,
    this.makingChargesType,
    this.ornament,
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
    minVa: json["min_va"],
    minMc: json["min_mc"],
    makingChargesType: json["making_charges_type"],
    ornament:
        json["ornament"] == null ? null : Ornament.fromJson(json["ornament"]),
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
    "min_va": minVa,
    "min_mc": minMc,
    "making_charges_type": makingChargesType,
    "ornament": ornament?.toJson(),
  };
}

class GetDesignResponseModelType {
  String? id;
  String? typeName;

  GetDesignResponseModelType({this.id, this.typeName});

  factory GetDesignResponseModelType.fromRawJson(String str) =>
      GetDesignResponseModelType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignResponseModelType.fromJson(Map<String, dynamic> json) =>
      GetDesignResponseModelType(id: json["id"], typeName: json["type_name"]);

  Map<String, dynamic> toJson() => {"id": id, "type_name": typeName};
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
  String? gst;

  Ornament({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.hsnSac,
    this.metalType,
    this.openingWeight,
    this.openingAmount,
    this.gst,
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
    metalType:
        json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
    openingWeight: json["opening_weight"],
    openingAmount: json["opening_amount"],
    gst: json["gst"],
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
    "gst": gst,
  };
}

class MetalType {
  String? id;
  String? typeName;
  String? codeType;

  MetalType({this.id, this.typeName, this.codeType});

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

class StockHead {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  Category? category;
  String? hallmarkExtraCharge;
  GetDesignResponseModelType? metalType;
  bool? sizeRequired;
  List<WeightGroup>? weightGroups;
  List<SizeGroup>? sizeGroups;

  StockHead({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.category,
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
    category:
        json["category"] == null ? null : Category.fromJson(json["category"]),
    hallmarkExtraCharge: json["hallmark_extra_charge"],
    metalType:
        json["metal_type"] == null
            ? null
            : GetDesignResponseModelType.fromJson(json["metal_type"]),
    sizeRequired: json["size_required"],
    weightGroups:
        json["weight_groups"] == null
            ? []
            : List<WeightGroup>.from(
              json["weight_groups"]!.map((x) => WeightGroup.fromJson(x)),
            ),
    sizeGroups:
        json["size_groups"] == null
            ? []
            : List<SizeGroup>.from(
              json["size_groups"]!.map((x) => SizeGroup.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "organization_id": organizationId,
    "category": category?.toJson(),
    "hallmark_extra_charge": hallmarkExtraCharge,
    "metal_type": metalType?.toJson(),
    "size_required": sizeRequired,
    "weight_groups":
        weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x.toJson())),
    "size_groups":
        sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x.toJson())),
  };
}

class Category {
  String? id;
  String? categoryName;

  Category({this.id, this.categoryName});

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], categoryName: json["category_name"]);

  Map<String, dynamic> toJson() => {"id": id, "category_name": categoryName};
}

class SizeGroup {
  String? id;
  String? code;
  String? size;

  SizeGroup({this.id, this.code, this.size});

  factory SizeGroup.fromRawJson(String str) =>
      SizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SizeGroup.fromJson(Map<String, dynamic> json) =>
      SizeGroup(id: json["id"], code: json["code"], size: json["size"]);

  Map<String, dynamic> toJson() => {"id": id, "code": code, "size": size};
}

class WeightGroup {
  String? id;
  String? name;
  String? code;
  bool? isNetWeight;
  String? minWeight;
  String? maxWeight;

  WeightGroup({
    this.id,
    this.name,
    this.code,
    this.isNetWeight,
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
    isNetWeight: json["is_net_weight"],
    minWeight: json["min_weight"],
    maxWeight: json["max_weight"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "is_net_weight": isNetWeight,
    "min_weight": minWeight,
    "max_weight": maxWeight,
  };
}
