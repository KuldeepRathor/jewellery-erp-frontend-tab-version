import 'dart:convert';

class GetTaggedItemsByIdResponse {
  String? id;
  String? organizationId;
  String? recordNumber;
  String? taggedById;
  EmployeeDetails? employeeDetails;
  VendorDetails? vendorDetails;
  String? totalMakingCharge;
  List<GetTaggedItemsByIdResponseLineItem>? lineItems;
  List<GetTaggedItemsByIdResponseStoneDataResponse>? stoneData;

  GetTaggedItemsByIdResponse({
    this.id,
    this.organizationId,
    this.recordNumber,
    this.taggedById,
    this.vendorDetails,
    this.totalMakingCharge,
    this.employeeDetails,
    this.lineItems,
    this.stoneData,
  });

  factory GetTaggedItemsByIdResponse.fromRawJson(String str) =>
      GetTaggedItemsByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        recordNumber: json["record_number"],
        taggedById: json["tagged_by_id"],
        employeeDetails: json["employee_details"] == null
            ? null
            : EmployeeDetails.fromJson(json["employee_details"]),
        vendorDetails: json["vendor_details"] == null
            ? null
            : VendorDetails.fromJson(json["vendor_details"]),
        totalMakingCharge: json["total_making_charge"],
        lineItems: json["line_items"] == null
            ? []
            : List<GetTaggedItemsByIdResponseLineItem>.from(json["line_items"]!
                .map((x) => GetTaggedItemsByIdResponseLineItem.fromJson(x))),
        stoneData: json["stone_data"] == null
            ? []
            : List<GetTaggedItemsByIdResponseStoneDataResponse>.from(
                json["stone_data"]!.map((x) =>
                    GetTaggedItemsByIdResponseStoneDataResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "record_number": recordNumber,
        "tagged_by_id": taggedById,
        "employee_details": employeeDetails?.toJson(),
        "vendor_details": vendorDetails?.toJson(),
        "total_making_charge": totalMakingCharge,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "stone_data": stoneData == null
            ? []
            : List<dynamic>.from(stoneData!.map((x) => x.toJson())),
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

class GetTaggedItemsByIdResponseStoneDataResponse {
  String? stoneId;
  String? stoneName;
  String? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  GetTaggedItemsByIdResponseStoneDataResponse({
    this.stoneId,
    this.stoneName,
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory GetTaggedItemsByIdResponseStoneDataResponse.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseStoneDataResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseStoneDataResponse.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseStoneDataResponse(
        stoneId: json["stone_id"],
        stoneName: json["stone_name"],
        pieces: json["pieces"],
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "stone_id": stoneId,
        "stone_name": stoneName,
        "pieces": pieces,
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
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
  String? email;
  String? phoneNumber;
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

class GetTaggedItemsByIdResponseLineItem {
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
  GetTaggedItemsByIdResponseDesign? design;
  GetTaggedItemsByIdResponseSizeGroup? sizeGroup;
  GetTaggedItemsByIdResponseCounter? counter;
  GetTaggedItemsByIdResponseCounter? startCounter;
  List<GetTaggedItemsByIdResponseImage>? images;
  List<GetTaggedItemsByIdResponseLineStone>? lineStones;

  GetTaggedItemsByIdResponseLineItem({
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
  });

  factory GetTaggedItemsByIdResponseLineItem.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseLineItem.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseLineItem(
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
            : GetTaggedItemsByIdResponseDesign.fromJson(json["design"]),
        sizeGroup: json["size_group"] == null
            ? null
            : GetTaggedItemsByIdResponseSizeGroup.fromJson(json["size_group"]),
        counter: json["counter"] == null
            ? null
            : GetTaggedItemsByIdResponseCounter.fromJson(json["counter"]),
        startCounter: json["start_counter"] == null
            ? null
            : GetTaggedItemsByIdResponseCounter.fromJson(json["start_counter"]),
        images: json["images"] == null
            ? []
            : List<GetTaggedItemsByIdResponseImage>.from(json["images"]!
                .map((x) => GetTaggedItemsByIdResponseImage.fromJson(x))),
        lineStones: json["line_stones"] == null
            ? []
            : List<GetTaggedItemsByIdResponseLineStone>.from(
                json["line_stones"]!.map(
                    (x) => GetTaggedItemsByIdResponseLineStone.fromJson(x))),
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
      };
}

class GetTaggedItemsByIdResponseCounter {
  String? id;
  String? code;
  String? counterName;
  String? organizationId;
  bool? isDefault;
  int? totalItems;
  String? totalWeight;

  GetTaggedItemsByIdResponseCounter({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  factory GetTaggedItemsByIdResponseCounter.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseCounter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseCounter.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseCounter(
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

class GetTaggedItemsByIdResponseDesign {
  String? id;
  String? code;
  String? name;
  String? organizationId;
  GetTaggedItemsByIdResponseStockHead? stockHead;
  GetTaggedItemsByIdResponseOrnament? ornament;
  bool? tagRequired;
  bool? stoneRequired;
  bool? hasSameImage;
  GetTaggedItemsByIdResponseType? makingChargeType;
  List<GetTaggedItemsByIdResponseImage>? images;
  String? remarks;
  List<GetTaggedItemsByIdResponseDesignLineItem>? lineItems;

  GetTaggedItemsByIdResponseDesign({
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

  factory GetTaggedItemsByIdResponseDesign.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseDesign.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseDesign.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseDesign(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        organizationId: json["organization_id"],
        stockHead: json["stock_head"] == null
            ? null
            : GetTaggedItemsByIdResponseStockHead.fromJson(json["stock_head"]),
        ornament: json["ornament"] == null
            ? null
            : GetTaggedItemsByIdResponseOrnament.fromJson(json["ornament"]),
        tagRequired: json["tag_required"],
        stoneRequired: json["stone_required"],
        hasSameImage: json["has_same_image"],
        makingChargeType: json["making_charge_type"] == null
            ? null
            : GetTaggedItemsByIdResponseType.fromJson(
                json["making_charge_type"]),
        images: json["images"] == null
            ? []
            : List<GetTaggedItemsByIdResponseImage>.from(json["images"]!
                .map((x) => GetTaggedItemsByIdResponseImage.fromJson(x))),
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<GetTaggedItemsByIdResponseDesignLineItem>.from(
                json["line_items"]!.map((x) =>
                    GetTaggedItemsByIdResponseDesignLineItem.fromJson(x))),
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

class GetTaggedItemsByIdResponseImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  GetTaggedItemsByIdResponseImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory GetTaggedItemsByIdResponseImage.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseImage.fromJson(Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseImage(
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

class GetTaggedItemsByIdResponseDesignLineItem {
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

  GetTaggedItemsByIdResponseDesignLineItem({
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

  factory GetTaggedItemsByIdResponseDesignLineItem.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseDesignLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseDesignLineItem.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseDesignLineItem(
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

class GetTaggedItemsByIdResponseType {
  String? id;
  String? typeName;
  String? codeType;

  GetTaggedItemsByIdResponseType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory GetTaggedItemsByIdResponseType.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseType.fromJson(Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseType(
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

class GetTaggedItemsByIdResponseOrnament {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  GetTaggedItemsByIdResponseMetalType? metalType;
  String? openingWeight;
  String? openingAmount;
  int? openingQuantity;
  String? gst;
  String? createdAt;

  GetTaggedItemsByIdResponseOrnament({
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

  factory GetTaggedItemsByIdResponseOrnament.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseOrnament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseOrnament.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseOrnament(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType: json["metal_type"] == null
            ? null
            : GetTaggedItemsByIdResponseMetalType.fromJson(json["metal_type"]),
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        openingQuantity: json["opening_quantity"],
        gst: json["gst"],
        createdAt: json["created_at"],
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
        "created_at": createdAt,
      };
}

class GetTaggedItemsByIdResponseMetalType {
  String? id;
  String? typeName;
  String? codeType;

  GetTaggedItemsByIdResponseMetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory GetTaggedItemsByIdResponseMetalType.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseMetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseMetalType.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseMetalType(
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

class GetTaggedItemsByIdResponseStockHead {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  GetTaggedItemsByIdResponseCategory? category;
  bool? isNetWeight;
  String? hallmarkExtraCharge;
  GetTaggedItemsByIdResponseType? metalType;
  bool? sizeRequired;
  List<GetTaggedItemsByIdResponseWeightGroup>? weightGroups;
  List<GetTaggedItemsByIdResponseSizeGroup>? sizeGroups;

  GetTaggedItemsByIdResponseStockHead({
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

  factory GetTaggedItemsByIdResponseStockHead.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseStockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseStockHead.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseStockHead(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        category: json["category"] == null
            ? null
            : GetTaggedItemsByIdResponseCategory.fromJson(json["category"]),
        isNetWeight: json["is_net_weight"],
        hallmarkExtraCharge: json["hallmark_extra_charge"],
        metalType: json["metal_type"] == null
            ? null
            : GetTaggedItemsByIdResponseType.fromJson(json["metal_type"]),
        sizeRequired: json["size_required"],
        weightGroups: json["weight_groups"] == null
            ? []
            : List<GetTaggedItemsByIdResponseWeightGroup>.from(
                json["weight_groups"]!.map(
                    (x) => GetTaggedItemsByIdResponseWeightGroup.fromJson(x))),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<GetTaggedItemsByIdResponseSizeGroup>.from(
                json["size_groups"]!.map(
                    (x) => GetTaggedItemsByIdResponseSizeGroup.fromJson(x))),
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

class GetTaggedItemsByIdResponseCategory {
  String? id;
  String? categoryName;

  GetTaggedItemsByIdResponseCategory({
    this.id,
    this.categoryName,
  });

  factory GetTaggedItemsByIdResponseCategory.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseCategory.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseCategory(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class GetTaggedItemsByIdResponseSizeGroup {
  String? id;
  String? code;
  String? size;

  GetTaggedItemsByIdResponseSizeGroup({
    this.id,
    this.code,
    this.size,
  });

  factory GetTaggedItemsByIdResponseSizeGroup.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseSizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseSizeGroup.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseSizeGroup(
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

class GetTaggedItemsByIdResponseWeightGroup {
  String? id;
  String? name;
  String? code;
  bool? isNetWeight;
  String? minWeight;
  String? maxWeight;

  GetTaggedItemsByIdResponseWeightGroup({
    this.id,
    this.name,
    this.code,
    this.isNetWeight,
    this.minWeight,
    this.maxWeight,
  });

  factory GetTaggedItemsByIdResponseWeightGroup.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseWeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseWeightGroup.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseWeightGroup(
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

class GetTaggedItemsByIdResponseLineStone {
  String? id;
  String? referenceStoneId;
  String? taggingLineItemId;
  String? name;
  int? pieces;
  String? carat;
  String? weight;
  String? rate;
  String? total;

  GetTaggedItemsByIdResponseLineStone({
    this.id,
    this.referenceStoneId,
    this.taggingLineItemId,
    this.name,
    this.pieces,
    this.carat,
    this.weight,
    this.rate,
    this.total,
  });

  factory GetTaggedItemsByIdResponseLineStone.fromRawJson(String str) =>
      GetTaggedItemsByIdResponseLineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsByIdResponseLineStone.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsByIdResponseLineStone(
        id: json["id"],
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
