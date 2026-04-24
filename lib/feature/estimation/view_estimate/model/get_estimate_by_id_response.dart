import 'dart:convert';

class GetEstimateByIdResponse {
  String? id;
  String? customerId;
  String? partyType;
  PartyDetails? partyDetails;
  String? estimateNumber;
  String? remarks;
  List<GetEstimateByIdResponseLineItem>? lineItems;
  List<dynamic>? advanceBookingDetails;
  List<dynamic>? jewelleryPlans;
  List<OldGold>? oldGolds;
  List<PaymentDetail>? paymentDetails;
  BillingSummary? billingSummary;
  dynamic jewellerDiscount;
  dynamic digitalCoinCommodity;
  dynamic digitalCoinWeight;
  dynamic digitalCoinPhoneNumber;
  dynamic digitalCoinAmount;
  String? additionalLess;

  GetEstimateByIdResponse({
    this.id,
    this.customerId,
    this.partyType,
    this.partyDetails,
    this.estimateNumber,
    this.remarks,
    this.lineItems,
    this.advanceBookingDetails,
    this.jewelleryPlans,
    this.oldGolds,
    this.paymentDetails,
    this.billingSummary,
    this.jewellerDiscount,
    this.digitalCoinCommodity,
    this.digitalCoinWeight,
    this.digitalCoinPhoneNumber,
    this.digitalCoinAmount,
    this.additionalLess,
  });

  factory GetEstimateByIdResponse.fromRawJson(String str) =>
      GetEstimateByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEstimateByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetEstimateByIdResponse(
        id: json["id"],
        customerId: json["customer_id"],
        partyType: json["party_type"],
        partyDetails: json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
        estimateNumber: json["estimate_number"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<GetEstimateByIdResponseLineItem>.from(json["line_items"]!
                .map((x) => GetEstimateByIdResponseLineItem.fromJson(x))),
        advanceBookingDetails: json["advance_booking_details"] == null
            ? []
            : List<dynamic>.from(
                json["advance_booking_details"]!.map((x) => x)),
        jewelleryPlans: json["jewellery_plans"] == null
            ? []
            : List<dynamic>.from(json["jewellery_plans"]!.map((x) => x)),
        oldGolds: json["old_golds"] == null
            ? []
            : List<OldGold>.from(
                json["old_golds"]!.map((x) => OldGold.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
        billingSummary: json["billing_summary"] == null
            ? null
            : BillingSummary.fromJson(json["billing_summary"]),
        jewellerDiscount: json["jeweller_discount"],
        digitalCoinCommodity: json["digital_coin_commodity"],
        digitalCoinWeight: json["digital_coin_weight"],
        digitalCoinPhoneNumber: json["digital_coin_phone_number"],
        digitalCoinAmount: json["digital_coin_amount"],
        additionalLess: json["additional_less"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "party_type": partyType,
        "party_details": partyDetails?.toJson(),
        "estimate_number": estimateNumber,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "advance_booking_details": advanceBookingDetails == null
            ? []
            : List<dynamic>.from(advanceBookingDetails!.map((x) => x)),
        "jewellery_plans": jewelleryPlans == null
            ? []
            : List<dynamic>.from(jewelleryPlans!.map((x) => x)),
        "old_golds": oldGolds == null
            ? []
            : List<dynamic>.from(oldGolds!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "billing_summary": billingSummary?.toJson(),
        "jeweller_discount": jewellerDiscount,
        "digital_coin_commodity": digitalCoinCommodity,
        "digital_coin_weight": digitalCoinWeight,
        "digital_coin_phone_number": digitalCoinPhoneNumber,
        "digital_coin_amount": digitalCoinAmount,
        "additional_less": additionalLess,
      };
}

class BillingSummary {
  String? subTotal;
  String? gst;
  String? oldGoldAmount;
  String? advanceBookingAmount;
  String? digitalGoldAmount;
  String? jewelleryPlanAmount;
  String? total;

  BillingSummary({
    this.subTotal,
    this.gst,
    this.oldGoldAmount,
    this.advanceBookingAmount,
    this.digitalGoldAmount,
    this.jewelleryPlanAmount,
    this.total,
  });

  factory BillingSummary.fromRawJson(String str) =>
      BillingSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BillingSummary.fromJson(Map<String, dynamic> json) => BillingSummary(
        subTotal: json["sub_total"],
        gst: json["gst"],
        oldGoldAmount: json["old_gold_amount"],
        advanceBookingAmount: json["advance_booking_amount"],
        digitalGoldAmount: json["digital_gold_amount"],
        jewelleryPlanAmount: json["jewellery_plan_amount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "gst": gst,
        "old_gold_amount": oldGoldAmount,
        "advance_booking_amount": advanceBookingAmount,
        "digital_gold_amount": digitalGoldAmount,
        "jewellery_plan_amount": jewelleryPlanAmount,
        "total": total,
      };
}

class GetEstimateByIdResponseLineItem {
  String? id;
  String? estimationRecordId;
  String? code;
  String? taggingId;
  String? tag;
  String? description;
  String? rate;
  String? salesPersonId;
  int? taggingPieces;
  String? taggingGrossWeight;
  String? taggingNetWeight;
  int? finalPieces;
  String? finalGrossWeight;
  String? finalNetWeight;
  String? taggingVa;
  String? finalVa;
  String? taggingMc;
  String? finalMc;
  String? stoneCost;
  String? hallMark;
  String? discount;
  String? salesAmount;
  String? totalAmount;
  String? makingChargesAmount;
  TaggingDetails? taggingDetails;
  SalesPerson? salesPerson;

  GetEstimateByIdResponseLineItem({
    this.id,
    this.estimationRecordId,
    this.code,
    this.taggingId,
    this.tag,
    this.description,
    this.rate,
    this.salesPersonId,
    this.taggingPieces,
    this.taggingGrossWeight,
    this.taggingNetWeight,
    this.finalPieces,
    this.finalGrossWeight,
    this.finalNetWeight,
    this.taggingVa,
    this.finalVa,
    this.taggingMc,
    this.finalMc,
    this.stoneCost,
    this.hallMark,
    this.discount,
    this.salesAmount,
    this.totalAmount,
    this.makingChargesAmount,
    this.taggingDetails,
    this.salesPerson,
  });

  factory GetEstimateByIdResponseLineItem.fromRawJson(String str) =>
      GetEstimateByIdResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEstimateByIdResponseLineItem.fromJson(Map<String, dynamic> json) =>
      GetEstimateByIdResponseLineItem(
        id: json["id"],
        estimationRecordId: json["estimation_record_id"],
        code: json["code"],
        taggingId: json["tagging_id"],
        tag: json["tag"],
        description: json["description"],
        rate: json["rate"],
        salesPersonId: json["sales_person_id"],
        taggingPieces: json["tagging_pieces"],
        taggingGrossWeight: json["tagging_gross_weight"],
        taggingNetWeight: json["tagging_net_weight"],
        finalPieces: json["final_pieces"],
        finalGrossWeight: json["final_gross_weight"],
        finalNetWeight: json["final_net_weight"],
        taggingVa: json["tagging_va"],
        finalVa: json["final_va"],
        taggingMc: json["tagging_mc"],
        finalMc: json["final_mc"],
        stoneCost: json["stone_cost"],
        hallMark: json["hall_mark"],
        discount: json["discount"],
        salesAmount: json["sales_amount"],
        totalAmount: json["total_amount"],
        makingChargesAmount: json["making_charges_amount"],
        taggingDetails: json["tagging_details"] == null
            ? null
            : TaggingDetails.fromJson(json["tagging_details"]),
        salesPerson: json["sales_person"] == null
            ? null
            : SalesPerson.fromJson(json["sales_person"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estimation_record_id": estimationRecordId,
        "code": code,
        "tagging_id": taggingId,
        "tag": tag,
        "description": description,
        "rate": rate,
        "sales_person_id": salesPersonId,
        "tagging_pieces": taggingPieces,
        "tagging_gross_weight": taggingGrossWeight,
        "tagging_net_weight": taggingNetWeight,
        "final_pieces": finalPieces,
        "final_gross_weight": finalGrossWeight,
        "final_net_weight": finalNetWeight,
        "tagging_va": taggingVa,
        "final_va": finalVa,
        "tagging_mc": taggingMc,
        "final_mc": finalMc,
        "stone_cost": stoneCost,
        "hall_mark": hallMark,
        "discount": discount,
        "sales_amount": salesAmount,
        "total_amount": totalAmount,
        "making_charges_amount": makingChargesAmount,
        "tagging_details": taggingDetails?.toJson(),
        "sales_person": salesPerson?.toJson(),
      };
}

class SalesPerson {
  String? id;
  String? firstName;
  String? lastName;
  dynamic employeeId;
  String? email;
  String? phoneNumber;
  String? code;
  String? phoneCountryCode;

  SalesPerson({
    this.id,
    this.firstName,
    this.lastName,
    this.employeeId,
    this.email,
    this.phoneNumber,
    this.code,
    this.phoneCountryCode,
  });

  factory SalesPerson.fromRawJson(String str) =>
      SalesPerson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesPerson.fromJson(Map<String, dynamic> json) => SalesPerson(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        employeeId: json["employee_id"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        code: json["code"],
        phoneCountryCode: json["phone_country_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "employee_id": employeeId,
        "email": email,
        "phone_number": phoneNumber,
        "code": code,
        "phone_country_code": phoneCountryCode,
      };
}

class TaggingDetails {
  String? id;
  String? organizationId;
  String? shopId;
  String? startShopId;
  String? status;
  dynamic vendorId;
  dynamic vendorCode;
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
  String? rate;
  String? huid;
  String? purity;
  Design? design;
  DesignLineItemElement? designLineItem;
  SizeGroup? sizeGroup;
  Counter? counter;
  Counter? startCounter;
  List<dynamic>? images;
  DateTime? createdAt;
  String? taggedById;
  dynamic employeeDetails;
  List<dynamic>? lineStones;
  dynamic lastScannedAt;

  TaggingDetails({
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
  });

  factory TaggingDetails.fromRawJson(String str) =>
      TaggingDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggingDetails.fromJson(Map<String, dynamic> json) => TaggingDetails(
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
        rate: json["rate"],
        huid: json["huid"],
        purity: json["purity"],
        design: json["design"] == null ? null : Design.fromJson(json["design"]),
        designLineItem: json["design_line_item"] == null
            ? null
            : DesignLineItemElement.fromJson(json["design_line_item"]),
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
            : List<dynamic>.from(json["images"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        taggedById: json["tagged_by_id"],
        employeeDetails: json["employee_details"],
        lineStones: json["line_stones"] == null
            ? []
            : List<dynamic>.from(json["line_stones"]!.map((x) => x)),
        lastScannedAt: json["last_scanned_at"],
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
        "rate": rate,
        "huid": huid,
        "purity": purity,
        "design": design?.toJson(),
        "design_line_item": designLineItem?.toJson(),
        "size_group": sizeGroup?.toJson(),
        "counter": counter?.toJson(),
        "start_counter": startCounter?.toJson(),
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "tagged_by_id": taggedById,
        "employee_details": employeeDetails,
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x)),
        "last_scanned_at": lastScannedAt,
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
  List<Image>? images;
  String? remarks;
  List<DesignLineItemElement>? lineItems;

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
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<DesignLineItemElement>.from(json["line_items"]!
                .map((x) => DesignLineItemElement.fromJson(x))),
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
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
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

class DesignLineItemElement {
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

  DesignLineItemElement({
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

  factory DesignLineItemElement.fromRawJson(String str) =>
      DesignLineItemElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DesignLineItemElement.fromJson(Map<String, dynamic> json) =>
      DesignLineItemElement(
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
  List<WeightGroup>? weightGroups;
  List<SizeGroup>? sizeGroups;

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
            : List<SizeGroup>.from(
                json["size_groups"]!.map((x) => SizeGroup.fromJson(x))),
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

class Category {
  String? id;
  String? categoryName;
  bool? isWebstore;
  List<Image>? images;

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
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "is_webstore": isWebstore,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
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

class PartyDetails {
  String? id;
  String? syncId;
  String? readableId;
  String? phoneNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  dynamic aadhaarNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  Ledger? ledger;
  List<dynamic>? nominees;
  List<Address>? address;
  dynamic signUpSource;
  dynamic email;

  PartyDetails({
    this.id,
    this.syncId,
    this.readableId,
    this.phoneNumber,
    this.name,
    this.dateOfBirth,
    this.panNumber,
    this.aadhaarNumber,
    this.gstNumber,
    this.deductionType,
    this.deductionPercent,
    this.organizationId,
    this.addressUuid,
    this.gender,
    this.ledger,
    this.nominees,
    this.address,
    this.signUpSource,
    this.email,
  });

  factory PartyDetails.fromRawJson(String str) =>
      PartyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PartyDetails.fromJson(Map<String, dynamic> json) => PartyDetails(
        id: json["id"],
        syncId: json["sync_id"],
        readableId: json["readable_id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        panNumber: json["pan_number"],
        aadhaarNumber: json["aadhaar_number"],
        gstNumber: json["gst_number"],
        deductionType: json["deduction_type"],
        deductionPercent: json["deduction_percent"],
        organizationId: json["organization_id"],
        addressUuid: json["address_uuid"],
        gender: json["gender"],
        ledger: json["ledger"] == null ? null : Ledger.fromJson(json["ledger"]),
        nominees: json["nominees"] == null
            ? []
            : List<dynamic>.from(json["nominees"]!.map((x) => x)),
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
        signUpSource: json["sign_up_source"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sync_id": syncId,
        "readable_id": readableId,
        "phone_number": phoneNumber,
        "name": name,
        "date_of_birth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "pan_number": panNumber,
        "aadhaar_number": aadhaarNumber,
        "gst_number": gstNumber,
        "deduction_type": deductionType,
        "deduction_percent": deductionPercent,
        "organization_id": organizationId,
        "address_uuid": addressUuid,
        "gender": gender,
        "ledger": ledger?.toJson(),
        "nominees":
            nominees == null ? [] : List<dynamic>.from(nominees!.map((x) => x)),
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "sign_up_source": signUpSource,
        "email": email,
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
  String? phoneCountryCode;
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

class Ledger {
  int? id;
  String? groupName;
  bool? isMandatory;
  String? groupType;
  Ledger? parentGroup;

  Ledger({
    this.id,
    this.groupName,
    this.isMandatory,
    this.groupType,
    this.parentGroup,
  });

  factory Ledger.fromRawJson(String str) => Ledger.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ledger.fromJson(Map<String, dynamic> json) => Ledger(
        id: json["id"],
        groupName: json["group_name"],
        isMandatory: json["is_mandatory"],
        groupType: json["group_type"],
        parentGroup: json["parent_group"] == null
            ? null
            : Ledger.fromJson(json["parent_group"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "is_mandatory": isMandatory,
        "group_type": groupType,
        "parent_group": parentGroup?.toJson(),
      };
}

class PaymentDetail {
  String? id;
  String? organizationId;
  String? subTotal;
  String? schemeDiscount;
  String? rateDiscount;
  String? salesAmount;
  String? amount;
  String? cgst;
  String? sgst;
  String? igst;
  String? nettGst;
  dynamic tcs;
  dynamic tds;
  String? nettTdsTcs;
  String? purchaseOldGold;
  String? advance;
  String? roundOff;
  String? bankCharges;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? estimationRecordId;
  List<dynamic>? paymentMethodDetails;
  dynamic advanceBookingAmount;
  dynamic jewelleryPlanBaseAmount;

  PaymentDetail({
    this.id,
    this.organizationId,
    this.subTotal,
    this.schemeDiscount,
    this.rateDiscount,
    this.salesAmount,
    this.amount,
    this.cgst,
    this.sgst,
    this.igst,
    this.nettGst,
    this.tcs,
    this.tds,
    this.nettTdsTcs,
    this.purchaseOldGold,
    this.advance,
    this.roundOff,
    this.bankCharges,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.estimationRecordId,
    this.paymentMethodDetails,
    this.advanceBookingAmount,
    this.jewelleryPlanBaseAmount,
  });

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json["id"],
        organizationId: json["organization_id"],
        subTotal: json["sub_total"],
        schemeDiscount: json["scheme_discount"],
        rateDiscount: json["rate_discount"],
        salesAmount: json["sales_amount"],
        amount: json["amount"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        nettGst: json["nett_gst"],
        tcs: json["tcs"],
        tds: json["tds"],
        nettTdsTcs: json["nett_tds_tcs"],
        purchaseOldGold: json["purchase_old_gold"],
        advance: json["advance"],
        roundOff: json["round_off"],
        bankCharges: json["bank_charges"],
        receivedAmount: json["received_amount"],
        balanceAmount: json["balance_amount"],
        finalAmount: json["final_amount"],
        estimationRecordId: json["estimation_record_id"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<dynamic>.from(json["payment_method_details"]!.map((x) => x)),
        advanceBookingAmount: json["advance_booking_amount"],
        jewelleryPlanBaseAmount: json["jewellery_plan_base_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "sub_total": subTotal,
        "scheme_discount": schemeDiscount,
        "rate_discount": rateDiscount,
        "sales_amount": salesAmount,
        "amount": amount,
        "cgst": cgst,
        "sgst": sgst,
        "igst": igst,
        "nett_gst": nettGst,
        "tcs": tcs,
        "tds": tds,
        "nett_tds_tcs": nettTdsTcs,
        "purchase_old_gold": purchaseOldGold,
        "advance": advance,
        "round_off": roundOff,
        "bank_charges": bankCharges,
        "received_amount": receivedAmount,
        "balance_amount": balanceAmount,
        "final_amount": finalAmount,
        "estimation_record_id": estimationRecordId,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x)),
        "advance_booking_amount": advanceBookingAmount,
        "jewellery_plan_base_amount": jewelleryPlanBaseAmount,
      };
}

class OldGold {
  String? id;
  dynamic oldGoldEstimateNumber;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? ornamentId;
  String? ornamentName;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;

  OldGold({
    this.id,
    this.oldGoldEstimateNumber,
    this.organizationId,
    this.shopId,
    this.code,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.less,
    this.purityType,
    this.ornamentId,
    this.ornamentName,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
  });

  factory OldGold.fromRawJson(String str) => OldGold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory OldGold.fromJson(Map<String, dynamic> json) => OldGold(
        id: json["id"],
        oldGoldEstimateNumber: json["old_gold_estimate_number"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"]?.toString(), // 10.0 → "10.0"
        netWeight: json["net_weight"]?.toString(), // 10.0 → "10.0"
        less: json["less"]?.toString(), // 0.0  → "0.0"
        purityType: json["purity_type"],
        ornamentId: json["ornament_id"],
        ornamentName: json["ornament_name"],
        rate: json["rate"]?.toString(), // 16000.0 → "16000.0"
        amount: json["amount"]?.toString(), // 160000.0 → "160000.0"
        roundOff: json["round_off"]?.toString(), // 0.0 → "0.0"
        total: json["total"]?.toString(), // 160000.0 → "160000.0"
        isReceived: json["is_received"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "old_gold_estimate_number": oldGoldEstimateNumber,
        "organization_id": organizationId,
        "shop_id": shopId,
        "code": code,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "less": less,
        "purity_type": purityType,
        "ornament_id": ornamentId,
        "ornament_name": ornamentName,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
      };
}
