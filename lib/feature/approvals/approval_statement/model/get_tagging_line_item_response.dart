import 'dart:convert';

class GetTaggingLineItemResponse {
  String? id;
  String? organizationId;
  String? shopId;
  String? startShopId;
  String? status;
  String? vendorId;
  String? vendorCode;
  String? code;
  String? codeType;
  String? codeId;
  String? tagBarcode;
  int? tagNumber;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? va;
  String? mc;
  String? mcTotal;
  String? designWastageType;
  String? designMakingChargesType;
  dynamic designMinVa;
  dynamic designMinMc;
  String? rate;
  String? huid;
  String? purity;
  Design? design;
  LineItem? designLineItem;
  SizeGroup? sizeGroup;
  Counter? counter;
  Counter? startCounter;
  List<Image>? images;
  DateTime? createdAt;
  String? taggedById;
  EmployeeDetails? employeeDetails;
  List<GetTaggingLineItemLineStone>? lineStones;
  dynamic lastScannedAt;
  VendorDetails? vendorDetails;

  GetTaggingLineItemResponse({
    this.id,
    this.organizationId,
    this.shopId,
    this.startShopId,
    this.status,
    this.vendorId,
    this.vendorCode,
    this.code,
    this.codeType,
    this.codeId,
    this.tagBarcode,
    this.tagNumber,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.va,
    this.mc,
    this.mcTotal,
    this.designWastageType,
    this.designMakingChargesType,
    this.designMinVa,
    this.designMinMc,
    this.rate,
    this.huid,
    this.purity,
    this.design,
    this.designLineItem,
    this.sizeGroup,
    this.counter,
    this.startCounter,
    this.images,
    this.createdAt,
    this.taggedById,
    this.employeeDetails,
    this.lineStones,
    this.lastScannedAt,
    this.vendorDetails,
  });

  factory GetTaggingLineItemResponse.fromRawJson(String str) =>
      GetTaggingLineItemResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingLineItemResponse.fromJson(Map<String, dynamic> json) =>
      GetTaggingLineItemResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        startShopId: json["start_shop_id"],
        status: json["status"],
        vendorId: json["vendor_id"],
        vendorCode: json["vendor_code"],
        code: json["code"],
        codeType: json["code_type"],
        codeId: json["code_id"],
        tagBarcode: json["tag_barcode"],
        tagNumber: json["tag_number"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        va: json["va"],
        mc: json["mc"],
        mcTotal: json["mc_total"],
        designWastageType: json["design_wastage_type"],
        designMakingChargesType: json["design_making_charges_type"],
        designMinVa: json["design_min_va"],
        designMinMc: json["design_min_mc"],
        rate: json["rate"],
        huid: json["huid"],
        purity: json["purity"],
        design: json["design"] == null ? null : Design.fromJson(json["design"]),
        designLineItem: json["design_line_item"] == null
            ? null
            : LineItem.fromJson(json["design_line_item"]),
        sizeGroup: json["size_group"] == null
            ? null
            : SizeGroup.fromJson(json["size_group"]),
        counter:
            json["counter"] == null ? null : Counter.fromJson(json["counter"]),
        startCounter: json["start_counter"] == null
            ? null
            : Counter.fromJson(json["start_counter"]),
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        taggedById: json["tagged_by_id"],
        employeeDetails: json["employee_details"] == null
            ? null
            : EmployeeDetails.fromJson(json["employee_details"]),
        lineStones: json["line_stones"] == null
            ? []
            : List<GetTaggingLineItemLineStone>.from(json["line_stones"]!
                .map((x) => GetTaggingLineItemLineStone.fromJson(x))),
        lastScannedAt: json["last_scanned_at"],
        vendorDetails: json["vendor_details"] == null
            ? null
            : VendorDetails.fromJson(json["vendor_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "start_shop_id": startShopId,
        "status": status,
        "vendor_id": vendorId,
        "vendor_code": vendorCode,
        "code": code,
        "code_type": codeType,
        "code_id": codeId,
        "tag_barcode": tagBarcode,
        "tag_number": tagNumber,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "va": va,
        "mc": mc,
        "mc_total": mcTotal,
        "design_wastage_type": designWastageType,
        "design_making_charges_type": designMakingChargesType,
        "design_min_va": designMinVa,
        "design_min_mc": designMinMc,
        "rate": rate,
        "huid": huid,
        "purity": purity,
        "design": design?.toJson(),
        "design_line_item": designLineItem?.toJson(),
        "size_group": sizeGroup?.toJson(),
        "counter": counter?.toJson(),
        "start_counter": startCounter?.toJson(),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "tagged_by_id": taggedById,
        "employee_details": employeeDetails?.toJson(),
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
        "last_scanned_at": lastScannedAt,
        "vendor_details": vendorDetails?.toJson(),
      };
}

class SizeGroup {
  String? id;
  String? code;
  String? size;

  SizeGroup({
    this.id,
    this.code,
    this.size,
  });

  factory SizeGroup.fromRawJson(String str) =>
      SizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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

class Counter {
  String? id;
  String? code;
  String? counterName;
  String? organizationId;
  bool? isDefault;
  int? totalItems;
  String? totalWeight;

  Counter({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  factory Counter.fromRawJson(String str) => Counter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
  String? id;
  String? code;
  String? name;
  String? organizationId;
  StockHead? stockHead;
  bool? tagRequired;
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
  dynamic minVa;
  dynamic minMc;
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
    this.makingChargesType,
    this.minVa,
    this.minMc,
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
        makingChargesType: json["making_charges_type"],
        minVa: json["min_va"],
        minMc: json["min_mc"],
        ornament: json["ornament"] == null
            ? null
            : Ornament.fromJson(json["ornament"]),
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
  DateTime? createdAt;
  bool? isStone;
  bool? isOldGold;
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
    this.gst,
    this.createdAt,
    this.isStone,
    this.isOldGold,
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
        gst: json["gst"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isStone: json["is_stone"],
        isOldGold: json["is_old_gold"],
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
        "gst": gst,
        "created_at": createdAt?.toIso8601String(),
        "is_stone": isStone,
        "is_old_gold": isOldGold,
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
  dynamic hallmarkExtraCharge;
  Type? metalType;
  bool? sizeRequired;
  List<dynamic>? weightGroups;
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
            : List<dynamic>.from(json["weight_groups"]!.map((x) => x)),
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
            : List<dynamic>.from(weightGroups!.map((x) => x)),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x)),
      };
}

class Category {
  String? id;
  String? categoryName;
  bool? isWebstore;
  List<dynamic>? images;

  Category({
    this.id,
    this.categoryName,
    this.isWebstore,
    this.images,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        isWebstore: json["is_webstore"],
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "is_webstore": isWebstore,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}

class EmployeeDetails {
  String? id;
  String? code;
  String? organizationId;
  dynamic employeeId;
  String? shopId;
  String? firstName;
  String? lastName;
  dynamic email;
  dynamic phoneNumber;
  String? phoneCountryCode;

  EmployeeDetails({
    this.id,
    this.code,
    this.organizationId,
    this.employeeId,
    this.shopId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountryCode,
  });

  factory EmployeeDetails.fromRawJson(String str) =>
      EmployeeDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeDetails.fromJson(Map<String, dynamic> json) =>
      EmployeeDetails(
        id: json["id"],
        code: json["code"],
        organizationId: json["organization_id"],
        employeeId: json["employee_id"],
        shopId: json["shop_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "organization_id": organizationId,
        "employee_id": employeeId,
        "shop_id": shopId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
      };
}

class Image {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  Image({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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

class GetTaggingLineItemLineStone {
  String? id;
  String? organizationId;
  dynamic referenceStoneId;
  String? taggingLineItemId;
  String? name;
  int? pieces;
  String? carat;
  dynamic weight;
  String? rate;
  String? total;

  GetTaggingLineItemLineStone({
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

  factory GetTaggingLineItemLineStone.fromRawJson(String str) =>
      GetTaggingLineItemLineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingLineItemLineStone.fromJson(Map<String, dynamic> json) =>
      GetTaggingLineItemLineStone(
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

class VendorDetails {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? panNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  List<dynamic>? bankDetails;
  List<dynamic>? vendorTypes;
  List<dynamic>? ledgerItems;
  dynamic ledger;
  List<Address>? address;

  VendorDetails({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.panNumber,
    this.gstNumber,
    this.deductionType,
    this.deductionPercent,
    this.bankDetails,
    this.vendorTypes,
    this.ledgerItems,
    this.ledger,
    this.address,
  });

  factory VendorDetails.fromRawJson(String str) =>
      VendorDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VendorDetails.fromJson(Map<String, dynamic> json) => VendorDetails(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        panNumber: json["pan_number"],
        gstNumber: json["gst_number"],
        deductionType: json["deduction_type"],
        deductionPercent: json["deduction_percent"],
        bankDetails: json["bank_details"] == null
            ? []
            : List<dynamic>.from(json["bank_details"]!.map((x) => x)),
        vendorTypes: json["vendor_types"] == null
            ? []
            : List<dynamic>.from(json["vendor_types"]!.map((x) => x)),
        ledgerItems: json["ledger_items"] == null
            ? []
            : List<dynamic>.from(json["ledger_items"]!.map((x) => x)),
        ledger: json["ledger"],
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "organization_id": organizationId,
        "pan_number": panNumber,
        "gst_number": gstNumber,
        "deduction_type": deductionType,
        "deduction_percent": deductionPercent,
        "bank_details": bankDetails == null
            ? []
            : List<dynamic>.from(bankDetails!.map((x) => x)),
        "vendor_types": vendorTypes == null
            ? []
            : List<dynamic>.from(vendorTypes!.map((x) => x)),
        "ledger_items": ledgerItems == null
            ? []
            : List<dynamic>.from(ledgerItems!.map((x) => x)),
        "ledger": ledger,
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
      };
}

class Address {
  String? id;
  String? organizationId;
  bool? isDefault;
  bool? isJlAddress;
  String? type;
  dynamic gstNumber;
  String? phoneNumber;
  dynamic phoneCountryCode;
  dynamic firstName;
  dynamic lastName;
  dynamic country;
  String? state;
  String? city;
  String? pincode;
  String? addressLine1;
  String? addressLine2;
  String? linkedEntityType;
  String? linkedEntityId;
  dynamic nickname;
  dynamic longitude;
  dynamic latitude;

  Address({
    this.id,
    this.organizationId,
    this.isDefault,
    this.isJlAddress,
    this.type,
    this.gstNumber,
    this.phoneNumber,
    this.phoneCountryCode,
    this.firstName,
    this.lastName,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.addressLine1,
    this.addressLine2,
    this.linkedEntityType,
    this.linkedEntityId,
    this.nickname,
    this.longitude,
    this.latitude,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        isJlAddress: json["is_jl_address"],
        type: json["type"],
        gstNumber: json["gst_number"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        pincode: json["pincode"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        linkedEntityType: json["linked_entity_type"],
        linkedEntityId: json["linked_entity_id"],
        nickname: json["nickname"],
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "is_default": isDefault,
        "is_jl_address": isJlAddress,
        "type": type,
        "gst_number": gstNumber,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
        "first_name": firstName,
        "last_name": lastName,
        "country": country,
        "state": state,
        "city": city,
        "pincode": pincode,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "linked_entity_type": linkedEntityType,
        "linked_entity_id": linkedEntityId,
        "nickname": nickname,
        "longitude": longitude,
        "latitude": latitude,
      };
}
