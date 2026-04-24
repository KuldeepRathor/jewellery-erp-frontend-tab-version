// To parse this JSON data, do
//
//     final branchInReportResponse = branchInReportResponseFromJson(jsonString);

import 'dart:convert';

BranchInReportResponse branchInReportResponseFromJson(String str) =>
    BranchInReportResponse.fromJson(json.decode(str));

String branchInReportResponseToJson(BranchInReportResponse data) =>
    json.encode(data.toJson());

class BranchInReportResponse {
  final List<Value> values;
  final Pagination pagination;

  BranchInReportResponse({
    required this.values,
    required this.pagination,
  });

  BranchInReportResponse copyWith({
    List<Value>? values,
    Pagination? pagination,
  }) =>
      BranchInReportResponse(
        values: values ?? this.values,
        pagination: pagination ?? this.pagination,
      );

  factory BranchInReportResponse.fromJson(Map<String, dynamic> json) =>
      BranchInReportResponse(
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  final int totalCount;
  final int pageCount;
  final dynamic next;

  Pagination({
    required this.totalCount,
    required this.pageCount,
    required this.next,
  });

  Pagination copyWith({
    int? totalCount,
    int? pageCount,
    dynamic next,
  }) =>
      Pagination(
        totalCount: totalCount ?? this.totalCount,
        pageCount: pageCount ?? this.pageCount,
        next: next ?? this.next,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class Value {
  final String? employeeId;
  final String? employeeName;
  final String? transferFromBranch;
  final String? branchName;
  final DateTime? date;
  final int? itemCount;
  final String branchTransferNumber;
  final String? grossWeight;
  final String? netWeight;
  final List<ValueLineItem> lineItems;

  Value({
    this.employeeId,
    this.employeeName,
    this.transferFromBranch,
    this.branchName,
    this.date,
    this.itemCount,
    required this.branchTransferNumber,
    this.grossWeight,
    this.netWeight,
    required this.lineItems,
  });

  Value copyWith({
    String? employeeId,
    String? employeeName,
    String? transferFromBranch,
    String? branchName,
    DateTime? date,
    int? itemCount,
    String? branchTransferNumber,
    String? grossWeight,
    String? netWeight,
    List<ValueLineItem>? lineItems,
  }) =>
      Value(
        employeeId: employeeId ?? this.employeeId,
        employeeName: employeeName ?? this.employeeName,
        transferFromBranch: transferFromBranch ?? this.transferFromBranch,
        branchName: branchName ?? this.branchName,
        date: date ?? this.date,
        itemCount: itemCount ?? this.itemCount,
        branchTransferNumber: branchTransferNumber ?? this.branchTransferNumber,
        grossWeight: grossWeight ?? this.grossWeight,
        netWeight: netWeight ?? this.netWeight,
        lineItems: lineItems ?? this.lineItems,
      );

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        transferFromBranch: json["transfer_from_branch"],
        branchName: json["branch_name"],
        date: json["date"] != null ? DateTime.parse(json["date"]) : null,
        itemCount: json["item_count"],
        branchTransferNumber: json["branch_transfer_number"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        lineItems: json["line_items"] != null
            ? List<ValueLineItem>.from(
                json["line_items"].map((x) => ValueLineItem.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "employee_name": employeeName,
        "transfer_from_branch": transferFromBranch,
        "branch_name": branchName,
        "date": date != null
            ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
            : null,
        "item_count": itemCount,
        "branch_transfer_number": branchTransferNumber,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "line_items": List<dynamic>.from(lineItems.map((x) => x.toJson())),
      };
}

class ValueLineItem {
  final String? id;
  final String? organizationId;
  final String? shopId;
  final String? status;
  final String? vendorId;
  final String? code;
  final String? codeId;
  final String? tagBarcode;
  final int? tagNumber;
  final int? pieces;
  final String? grossWeight;
  final String? netWeight;
  final String? va;
  final String? mc;
  final String? rate;
  final String? huid;
  final String? purity;
  final Design? design;
  final SizeGroup? sizeGroup;
  final Counter? counter;
  final List<dynamic>? images;
  final List<LineStone>? lineStones;

  ValueLineItem({
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
    this.images,
    this.lineStones,
  });

  ValueLineItem copyWith({
    String? id,
    String? organizationId,
    String? shopId,
    String? status,
    String? vendorId,
    String? code,
    String? codeId,
    String? tagBarcode,
    int? tagNumber,
    int? pieces,
    String? grossWeight,
    String? netWeight,
    String? va,
    String? mc,
    String? rate,
    String? huid,
    String? purity,
    Design? design,
    SizeGroup? sizeGroup,
    Counter? counter,
    List<dynamic>? images,
    List<LineStone>? lineStones,
  }) =>
      ValueLineItem(
        id: id ?? this.id,
        organizationId: organizationId ?? this.organizationId,
        shopId: shopId ?? this.shopId,
        status: status ?? this.status,
        vendorId: vendorId ?? this.vendorId,
        code: code ?? this.code,
        codeId: codeId ?? this.codeId,
        tagBarcode: tagBarcode ?? this.tagBarcode,
        tagNumber: tagNumber ?? this.tagNumber,
        pieces: pieces ?? this.pieces,
        grossWeight: grossWeight ?? this.grossWeight,
        netWeight: netWeight ?? this.netWeight,
        va: va ?? this.va,
        mc: mc ?? this.mc,
        rate: rate ?? this.rate,
        huid: huid ?? this.huid,
        purity: purity ?? this.purity,
        design: design ?? this.design,
        sizeGroup: sizeGroup ?? this.sizeGroup,
        counter: counter ?? this.counter,
        images: images ?? this.images,
        lineStones: lineStones ?? this.lineStones,
      );

  factory ValueLineItem.fromJson(Map<String, dynamic> json) => ValueLineItem(
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
        design: json["design"] != null ? Design.fromJson(json["design"]) : null,
        sizeGroup: json["size_group"] != null
            ? SizeGroup.fromJson(json["size_group"])
            : null,
        counter:
            json["counter"] != null ? Counter.fromJson(json["counter"]) : null,
        images: json["images"] != null
            ? List<dynamic>.from(json["images"].map((x) => x))
            : [],
        lineStones: json["line_stones"] != null
            ? List<LineStone>.from(
                json["line_stones"].map((x) => LineStone.fromJson(x)))
            : [],
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
        "images":
            images != null ? List<dynamic>.from(images!.map((x) => x)) : [],
        "line_stones": lineStones != null
            ? List<dynamic>.from(lineStones!.map((x) => x.toJson()))
            : [],
      };
}

class Counter {
  final String? id;
  final String? code;
  final String? counterName;
  final String? organizationId;
  final bool? isDefault;
  final int? totalItems;
  final String? totalWeight;

  Counter({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  Counter copyWith({
    String? id,
    String? code,
    String? counterName,
    String? organizationId,
    bool? isDefault,
    int? totalItems,
    String? totalWeight,
  }) =>
      Counter(
        id: id ?? this.id,
        code: code ?? this.code,
        counterName: counterName ?? this.counterName,
        organizationId: organizationId ?? this.organizationId,
        isDefault: isDefault ?? this.isDefault,
        totalItems: totalItems ?? this.totalItems,
        totalWeight: totalWeight ?? this.totalWeight,
      );

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
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

class Design {
  final String? id;
  final String? code;
  final String? name;
  final String? organizationId;
  final StockHead? stockHead;
  final Ornament? ornament;
  final bool? tagRequired;
  final bool? stoneRequired;
  final bool? hasSameImage;
  final Type? makingChargeType;
  final List<Image>? images;
  final String? remarks;
  final List<DesignLineItem>? lineItems;

  Design({
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

  Design copyWith({
    String? id,
    String? code,
    String? name,
    String? organizationId,
    StockHead? stockHead,
    Ornament? ornament,
    bool? tagRequired,
    bool? stoneRequired,
    bool? hasSameImage,
    Type? makingChargeType,
    List<Image>? images,
    String? remarks,
    List<DesignLineItem>? lineItems,
  }) =>
      Design(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        organizationId: organizationId ?? this.organizationId,
        stockHead: stockHead ?? this.stockHead,
        ornament: ornament ?? this.ornament,
        tagRequired: tagRequired ?? this.tagRequired,
        stoneRequired: stoneRequired ?? this.stoneRequired,
        hasSameImage: hasSameImage ?? this.hasSameImage,
        makingChargeType: makingChargeType ?? this.makingChargeType,
        images: images ?? this.images,
        remarks: remarks ?? this.remarks,
        lineItems: lineItems ?? this.lineItems,
      );

  factory Design.fromJson(Map<String, dynamic> json) => Design(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        organizationId: json["organization_id"],
        stockHead: json["stock_head"] != null
            ? StockHead.fromJson(json["stock_head"])
            : null,
        ornament: json["ornament"] != null
            ? Ornament.fromJson(json["ornament"])
            : null,
        tagRequired: json["tag_required"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType: json["making_charge_type"] != null
            ? Type.fromJson(json["making_charge_type"])
            : null,
        images: json["images"] != null
            ? List<Image>.from(json["images"].map((x) => Image.fromJson(x)))
            : [],
        remarks: json["remarks"],
        lineItems: json["line_items"] != null
            ? List<DesignLineItem>.from(
                json["line_items"].map((x) => DesignLineItem.fromJson(x)))
            : [],
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
        "images": images != null
            ? List<dynamic>.from(images!.map((x) => x.toJson()))
            : [],
        "remarks": remarks,
        "line_items": lineItems != null
            ? List<dynamic>.from(lineItems!.map((x) => x.toJson()))
            : [],
      };
}

class Image {
  final String? id;
  final String? fileName;
  final String? fileType;
  final String? s3Key;
  final String? presignedUrl;

  Image({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  Image copyWith({
    String? id,
    String? fileName,
    String? fileType,
    String? s3Key,
    String? presignedUrl,
  }) =>
      Image(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        fileType: fileType ?? this.fileType,
        s3Key: s3Key ?? this.s3Key,
        presignedUrl: presignedUrl ?? this.presignedUrl,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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

class DesignLineItem {
  final String? id;
  final String? organizationId;
  final String? purity;
  final String? minWeight;
  final String? maxWeight;
  final String? wastageType;
  final String? wastage;
  final String? makingCharges;
  final String? makingChargesType;
  final String? minVa;
  final String? minMc;
  final Ornament? ornament;

  DesignLineItem({
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
  });

  DesignLineItem copyWith({
    String? id,
    String? organizationId,
    String? purity,
    String? minWeight,
    String? maxWeight,
    String? wastageType,
    String? wastage,
    String? makingCharges,
    String? makingChargesType,
    String? minVa,
    String? minMc,
    Ornament? ornament,
  }) =>
      DesignLineItem(
        id: id ?? this.id,
        organizationId: organizationId ?? this.organizationId,
        purity: purity ?? this.purity,
        minWeight: minWeight ?? this.minWeight,
        maxWeight: maxWeight ?? this.maxWeight,
        wastageType: wastageType ?? this.wastageType,
        wastage: wastage ?? this.wastage,
        makingCharges: makingCharges ?? this.makingCharges,
        makingChargesType: makingChargesType ?? this.makingChargesType,
        minVa: minVa ?? this.minVa,
        minMc: minMc ?? this.minMc,
        ornament: ornament ?? this.ornament,
      );

  factory DesignLineItem.fromJson(Map<String, dynamic> json) => DesignLineItem(
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
        ornament: json["ornament"] != null
            ? Ornament.fromJson(json["ornament"])
            : null,
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
      };
}

class Type {
  final String? id;
  final String? typeName;

  Type({
    this.id,
    this.typeName,
  });

  Type copyWith({
    String? id,
    String? typeName,
  }) =>
      Type(
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
      );

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}

class Ornament {
  final String? id;
  final String? name;
  final String? code;
  final String? organizationId;
  final String? hsnSac;
  final MetalType? metalType;
  final String? openingWeight;
  final String? openingAmount;
  final String? gst;
  final DateTime? createdAt;

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
    this.createdAt,
  });

  Ornament copyWith({
    String? id,
    String? name,
    String? code,
    String? organizationId,
    String? hsnSac,
    MetalType? metalType,
    String? openingWeight,
    String? openingAmount,
    String? gst,
    DateTime? createdAt,
  }) =>
      Ornament(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        organizationId: organizationId ?? this.organizationId,
        hsnSac: hsnSac ?? this.hsnSac,
        metalType: metalType ?? this.metalType,
        openingWeight: openingWeight ?? this.openingWeight,
        openingAmount: openingAmount ?? this.openingAmount,
        gst: gst ?? this.gst,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Ornament.fromJson(Map<String, dynamic> json) => Ornament(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType: json["metal_type"] != null
            ? MetalType.fromJson(json["metal_type"])
            : null,
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        gst: json["gst"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
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
        "created_at": createdAt?.toIso8601String(),
      };
}

class MetalType {
  final String? id;
  final String? typeName;
  final String? codeType;

  MetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  MetalType copyWith({
    String? id,
    String? typeName,
    String? codeType,
  }) =>
      MetalType(
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        codeType: codeType ?? this.codeType,
      );

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
  final String? id;
  final String? name;
  final String? code;
  final String? organizationId;
  final Category? category;
  final bool? isNetWeight;
  final String? hallmarkExtraCharge;
  final Type? metalType;
  final bool? sizeRequired;
  final List<WeightGroup>? weightGroups;
  final List<SizeGroup>? sizeGroups;

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

  StockHead copyWith({
    String? id,
    String? name,
    String? code,
    String? organizationId,
    Category? category,
    bool? isNetWeight,
    String? hallmarkExtraCharge,
    Type? metalType,
    bool? sizeRequired,
    List<WeightGroup>? weightGroups,
    List<SizeGroup>? sizeGroups,
  }) =>
      StockHead(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        organizationId: organizationId ?? this.organizationId,
        category: category ?? this.category,
        isNetWeight: isNetWeight ?? this.isNetWeight,
        hallmarkExtraCharge: hallmarkExtraCharge ?? this.hallmarkExtraCharge,
        metalType: metalType ?? this.metalType,
        sizeRequired: sizeRequired ?? this.sizeRequired,
        weightGroups: weightGroups ?? this.weightGroups,
        sizeGroups: sizeGroups ?? this.sizeGroups,
      );

  factory StockHead.fromJson(Map<String, dynamic> json) => StockHead(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        category: json["category"] != null
            ? Category.fromJson(json["category"])
            : null,
        isNetWeight: json["is_net_weight"],
        hallmarkExtraCharge: json["hallmark_extra_charge"],
        metalType: json["metal_type"] != null
            ? Type.fromJson(json["metal_type"])
            : null,
        sizeRequired: json["size_required"],
        weightGroups: json["weight_groups"] != null
            ? List<WeightGroup>.from(
                json["weight_groups"].map((x) => WeightGroup.fromJson(x)))
            : [],
        sizeGroups: json["size_groups"] != null
            ? List<SizeGroup>.from(
                json["size_groups"].map((x) => SizeGroup.fromJson(x)))
            : [],
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
        "weight_groups": weightGroups != null
            ? List<dynamic>.from(weightGroups!.map((x) => x.toJson()))
            : [],
        "size_groups": sizeGroups != null
            ? List<dynamic>.from(sizeGroups!.map((x) => x.toJson()))
            : [],
      };
}

class Category {
  final String? id;
  final String? categoryName;

  Category({
    this.id,
    this.categoryName,
  });

  Category copyWith({
    String? id,
    String? categoryName,
  }) =>
      Category(
        id: id ?? this.id,
        categoryName: categoryName ?? this.categoryName,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class SizeGroup {
  final String? id;
  final String? code;
  final String? size;

  SizeGroup({
    this.id,
    this.code,
    this.size,
  });

  SizeGroup copyWith({
    String? id,
    String? code,
    String? size,
  }) =>
      SizeGroup(
        id: id ?? this.id,
        code: code ?? this.code,
        size: size ?? this.size,
      );

  factory SizeGroup.fromJson(Map<String, dynamic> json) => SizeGroup(
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

class WeightGroup {
  final String? id;
  final String? name;
  final String? code;
  final String? minWeight;
  final String? maxWeight;

  WeightGroup({
    this.id,
    this.name,
    this.code,
    this.minWeight,
    this.maxWeight,
  });

  WeightGroup copyWith({
    String? id,
    String? name,
    String? code,
    String? minWeight,
    String? maxWeight,
  }) =>
      WeightGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        minWeight: minWeight ?? this.minWeight,
        maxWeight: maxWeight ?? this.maxWeight,
      );

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

class LineStone {
  final String? id;
  final String? organizationId;
  final dynamic referenceStoneId;
  final String? taggingLineItemId;
  final String? name;
  final int? pieces;
  final String? carat;
  final dynamic weight;
  final String? rate;
  final String? total;

  LineStone({
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

  LineStone copyWith({
    String? id,
    String? organizationId,
    dynamic referenceStoneId,
    String? taggingLineItemId,
    String? name,
    int? pieces,
    String? carat,
    dynamic weight,
    String? rate,
    String? total,
  }) =>
      LineStone(
        id: id ?? this.id,
        organizationId: organizationId ?? this.organizationId,
        referenceStoneId: referenceStoneId ?? this.referenceStoneId,
        taggingLineItemId: taggingLineItemId ?? this.taggingLineItemId,
        name: name ?? this.name,
        pieces: pieces ?? this.pieces,
        carat: carat ?? this.carat,
        weight: weight ?? this.weight,
        rate: rate ?? this.rate,
        total: total ?? this.total,
      );

  factory LineStone.fromJson(Map<String, dynamic> json) => LineStone(
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
