import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';

import 'post_sales_request_model.dart';

class GetSaleByEstimateResponse {
  String? id;
  String? customerId;
  String? estimateNumber;
  String? partyType; // Added field
  dynamic
  partyDetails; // Can be either CustomerSearchValue or VendorSearchValue

  String? remarks;
  List<GetSaleByEstimateResponseLineItem>? lineItems;
  List<AdvanceBookingDetail>? advanceBookingDetails;
  List<JewelleryPlan>? jewelleryPlans;
  List<OldGold>? oldGolds;
  BillingSummary? billingSummary;
  String? additionalLess;
  String? jewellerDiscount;
  List<PostSalePaymentDetailRequest>? paymentDetails;

  GetSaleByEstimateResponse({
    this.id,
    this.customerId,
    this.estimateNumber,
    this.partyType,
    this.partyDetails,
    this.remarks,
    this.lineItems,
    this.advanceBookingDetails,
    this.jewelleryPlans,
    this.oldGolds,
    this.billingSummary,
    this.additionalLess,
    this.jewellerDiscount,
    this.paymentDetails,
  });

  factory GetSaleByEstimateResponse.fromRawJson(String str) =>
      GetSaleByEstimateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSaleByEstimateResponse.fromJson(Map<String, dynamic> json) {
    dynamic parsedPartyDetails;
    if (json["party_type"] == "vendor") {
      parsedPartyDetails =
          json["party_details"] != null
              ? VendorSearchValue.fromJson(json["party_details"])
              : null;
    } else if (json["party_type"] == "customer") {
      parsedPartyDetails =
          json["party_details"] != null
              ? CustomerSearchValue.fromJson(json["party_details"])
              : null;
    }
    return GetSaleByEstimateResponse(
      id: json["id"],
      customerId: json["customer_id"],
      estimateNumber: json["estimate_number"],
      partyType: json["party_type"],
      partyDetails: parsedPartyDetails,
      remarks: json["remarks"],
      lineItems:
          json["line_items"] == null
              ? []
              : List<GetSaleByEstimateResponseLineItem>.from(
                json["line_items"]!.map(
                  (x) => GetSaleByEstimateResponseLineItem.fromJson(x),
                ),
              ),
      advanceBookingDetails:
          json["advance_booking_details"] == null
              ? []
              : List<AdvanceBookingDetail>.from(
                json["advance_booking_details"]!.map(
                  (x) => AdvanceBookingDetail.fromJson(x),
                ),
              ),
      jewelleryPlans:
          json["jewellery_plans"] == null
              ? []
              : List<JewelleryPlan>.from(
                json["jewellery_plans"]!.map((x) => JewelleryPlan.fromJson(x)),
              ),
      oldGolds:
          json["old_golds"] == null
              ? []
              : List<OldGold>.from(
                json["old_golds"]!.map((x) => OldGold.fromJson(x)),
              ),
      billingSummary:
          json["billing_summary"] == null
              ? null
              : BillingSummary.fromJson(json["billing_summary"]),
      additionalLess: json["additional_less"],
      jewellerDiscount: json["jeweller_discount"],
      paymentDetails:
          json["payment_details"] == null
              ? []
              : List<PostSalePaymentDetailRequest>.from(
                json["payment_details"]!.map(
                  (x) => PostSalePaymentDetailRequest.fromJson(x),
                ),
              ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? serializedPartyDetails;
    if (partyDetails != null) {
      if (partyType == "vendor" && partyDetails is VendorSearchValue) {
        serializedPartyDetails = (partyDetails as VendorSearchValue).toJson();
      } else if (partyType == "customer" &&
          partyDetails is CustomerSearchValue) {
        serializedPartyDetails = (partyDetails as CustomerSearchValue).toJson();
      }
    }
    return {
      "id": id,
      "customer_id": customerId,
      "estimate_number": estimateNumber,
      "party_type": partyType,
      "party_details": serializedPartyDetails,
      "remarks": remarks,
      "line_items":
          lineItems == null
              ? []
              : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      "advance_booking_details":
          advanceBookingDetails == null
              ? []
              : List<dynamic>.from(
                advanceBookingDetails!.map((x) => x.toJson()),
              ),
      "jewellery_plans":
          jewelleryPlans == null
              ? []
              : List<dynamic>.from(jewelleryPlans!.map((x) => x.toJson())),
      "old_golds":
          oldGolds == null
              ? []
              : List<dynamic>.from(oldGolds!.map((x) => x.toJson())),
      "billing_summary": billingSummary?.toJson(),
      "additional_less": additionalLess,
      "jeweller_discount": jewellerDiscount,
      "payment_details":
          paymentDetails == null
              ? []
              : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
    };
  }

  CustomerSearchValue? get customerDetails =>
      partyType == "customer" ? partyDetails as CustomerSearchValue? : null;

  VendorSearchValue? get vendorDetails =>
      partyType == "vendor" ? partyDetails as VendorSearchValue? : null;
}

class AdvanceBookingDetail {
  String? advancePaid;
  String? bookingId;
  String? id;
  String? rate;
  String? status;
  String? weight;

  AdvanceBookingDetail({
    this.advancePaid,
    this.bookingId,
    this.id,
    this.rate,
    this.status,
    this.weight,
  });

  factory AdvanceBookingDetail.fromRawJson(String str) =>
      AdvanceBookingDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdvanceBookingDetail.fromJson(Map<String, dynamic> json) =>
      AdvanceBookingDetail(
        advancePaid: json["advance_paid"],
        bookingId: json["booking_id"],
        id: json["id"],
        rate: json["rate"],
        status: json["status"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
    "advance_paid": advancePaid,
    "booking_id": bookingId,
    "id": id,
    "rate": rate,
    "status": status,
    "weight": weight,
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

class JewelleryPlan {
  String? id;
  String? planId;
  String? subscriptionId;
  String? type;
  DateTime? startDate;
  int? duration;
  String? installments;
  String? totalWeight;
  String? redeemableAmount;
  String? estimationRecordId;

  JewelleryPlan({
    this.id,
    this.planId,
    this.subscriptionId,
    this.type,
    this.startDate,
    this.duration,
    this.installments,
    this.totalWeight,
    this.redeemableAmount,
    this.estimationRecordId,
  });

  factory JewelleryPlan.fromRawJson(String str) =>
      JewelleryPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JewelleryPlan.fromJson(Map<String, dynamic> json) => JewelleryPlan(
    id: json["id"],
    planId: json["plan_id"],
    subscriptionId: json["subscription_id"],
    type: json["type"],
    startDate:
        json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    duration: json["duration"],
    installments: json["installments"],
    totalWeight: json["total_weight"],
    redeemableAmount: json["redeemable_amount"],
    estimationRecordId: json["estimation_record_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_id": planId,
    "subscription_id": subscriptionId,
    "type": type,
    "start_date":
        "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "duration": duration,
    "installments": installments,
    "total_weight": totalWeight,
    "redeemable_amount": redeemableAmount,
    "estimation_record_id": estimationRecordId,
  };
}

class GetSaleByEstimateResponseLineItem {
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
  GetSaleByEstimateResponseLineItemTaggingDetails? taggingDetails;
  GetEmployeesValue? salesPerson;

  GetSaleByEstimateResponseLineItem({
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
    this.taggingDetails,
    this.salesPerson,
  });

  factory GetSaleByEstimateResponseLineItem.fromRawJson(String str) =>
      GetSaleByEstimateResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSaleByEstimateResponseLineItem.fromJson(
    Map<String, dynamic> json,
  ) => GetSaleByEstimateResponseLineItem(
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
    taggingDetails:
        json["tagging_details"] == null
            ? null
            : GetSaleByEstimateResponseLineItemTaggingDetails.fromJson(
              json["tagging_details"],
            ),
    salesPerson:
        json["sales_person"] == null
            ? null
            : GetEmployeesValue.fromJson(json["sales_person"]),
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
    "tagging_details": taggingDetails?.toJson(),
    "sales_person": salesPerson?.toJson(),
  };
}

class GetSaleByEstimateResponseLineItemTaggingDetails {
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
  String? designWastageType; // Added
  String? designMakingChargesType; // Added
  String? designMinVa; // Added
  String? designMinMc; // Added
  String? rate;
  String? huid;
  String? purity;
  Design? design;
  SizeGroup? sizeGroup;
  Counter? counter;
  List<Image>? images;
  List<LineStone>? lineStones;
  DesignLineItem? designLineItem;

  GetSaleByEstimateResponseLineItemTaggingDetails({
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
    this.designWastageType, // Added
    this.designMakingChargesType, // Added
    this.designMinVa, // Added
    this.designMinMc, // Added
    this.huid,
    this.purity,
    this.design,
    this.sizeGroup,
    this.counter,
    this.images,
    this.lineStones,
    this.designLineItem,
  });

  factory GetSaleByEstimateResponseLineItemTaggingDetails.fromRawJson(
    String str,
  ) => GetSaleByEstimateResponseLineItemTaggingDetails.fromJson(
    json.decode(str),
  );

  String toRawJson() => json.encode(toJson());

  factory GetSaleByEstimateResponseLineItemTaggingDetails.fromJson(
    Map<String, dynamic> json,
  ) => GetSaleByEstimateResponseLineItemTaggingDetails(
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
    designWastageType: json["design_wastage_type"], // Added
    designMakingChargesType: json["design_making_charges_type"], // Added
    designMinVa: json["design_min_va"], // Added
    designMinMc: json["design_min_mc"],
    rate: json["rate"],
    huid: json["huid"],
    purity: json["purity"],
    design: json["design"] == null ? null : Design.fromJson(json["design"]),
    sizeGroup:
        json["size_group"] == null
            ? null
            : SizeGroup.fromJson(json["size_group"]),
    counter: json["counter"] == null ? null : Counter.fromJson(json["counter"]),
    images:
        json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    lineStones:
        json["line_stones"] == null
            ? []
            : List<LineStone>.from(
              json["line_stones"]!.map((x) => LineStone.fromJson(x)),
            ),
    designLineItem:
        json["design_line_item"] == null
            ? null
            : DesignLineItem.fromJson(json["design_line_item"]),
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
    "mc": mc, "design_wastage_type": designWastageType, // Added
    "design_making_charges_type": designMakingChargesType, // Added
    "design_min_va": designMinVa, // Added
    "design_min_mc": designMinMc, // Added
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
    "design_line_item": designLineItem?.toJson(),
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

class Image {
  dynamic id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  Image({this.id, this.fileName, this.fileType, this.s3Key, this.presignedUrl});

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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

class DesignType {
  String? id;
  String? typeName;

  DesignType({this.id, this.typeName});

  factory DesignType.fromRawJson(String str) =>
      DesignType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DesignType.fromJson(Map<String, dynamic> json) =>
      DesignType(id: json["id"], typeName: json["type_name"]);

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
  DateTime? createdAt;

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
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
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
  bool? isNetWeight;
  String? hallmarkExtraCharge;
  DesignType? metalType;
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
    category:
        json["category"] == null ? null : Category.fromJson(json["category"]),
    isNetWeight: json["is_net_weight"],
    hallmarkExtraCharge: json["hallmark_extra_charge"],
    metalType:
        json["metal_type"] == null
            ? null
            : DesignType.fromJson(json["metal_type"]),
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
    "is_net_weight": isNetWeight,
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
  String? minWeight;
  String? maxWeight;

  WeightGroup({this.id, this.name, this.code, this.minWeight, this.maxWeight});

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

class LineStone {
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

  factory LineStone.fromRawJson(String str) =>
      LineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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

class OldGold {
  String? id;
  String? oldGoldEstimateNumber;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purity;
  MetalType? metalType;
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
    this.purity,
    this.metalType,
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
    grossWeight: json["gross_weight"],
    netWeight: json["net_weight"],
    less: json["less"],
    purityType: json["purity_type"],
    purity: json["purity"],
    metalType:
        json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
    ornamentId: json["ornament_id"],
    ornamentName: json["ornament_name"],
    rate: json["rate"],
    amount: json["amount"],
    roundOff: json["round_off"],
    total: json["total"],
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
    "purity": purity,
    "metal_type": metalType?.toJson(),
    "ornament_id": ornamentId,
    "ornament_name": ornamentName,
    "rate": rate,
    "amount": amount,
    "round_off": roundOff,
    "total": total,
    "is_received": isReceived,
  };
}
