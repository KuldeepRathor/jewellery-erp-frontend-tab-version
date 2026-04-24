import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';

class GetSalesBySaleNumberResponse {
  bool? isCancelled;
  bool? inStoreSale;
  String? stateName;
  String? stateCode;
  bool? completeHandover;
  DateTime? createdAt;
  String? id;
  String? partyId;
  String? partyType;
  PartyDetails? partyDetails;
  bool? itemHandover;
  String? refernceInvoiceNumber;
  String? saleNumber;
  String? remarks;
  String? paymentStatus;
  dynamic jewellerDiscount;
  List<GetSalesBySaleNumberResponseLineItem>? lineItems;
  List<GetSalesBySaleNumberResponseAdvanceBookingDetail>? advanceBookingDetails;
  List<GetSalesBySaleNumberResponseJewelleryPlan>? jewelleryPlans;
  List<GetSalesBySaleNumberResponseOldGold>? oldGolds;
  List<GetSalesBySaleNumberResponsePaymentDetail>? paymentDetails;
  List<dynamic>? customerHoldings;
  dynamic orderId;
  dynamic digitalCoinCommodity;
  dynamic digitalCoinWeight;
  dynamic digitalCoinPhoneNumber;
  dynamic digitalCoinAmount;
  dynamic additionalLess;
  String? purchaseInvoiceNumber;
  String? metalType;

  GetSalesBySaleNumberResponse({
    this.isCancelled,
    this.inStoreSale,
    this.stateName,
    this.stateCode,
    this.completeHandover,
    this.createdAt,
    this.id,
    this.partyId,
    this.partyType,
    this.partyDetails,
    this.refernceInvoiceNumber,
    this.saleNumber,
    this.remarks,
    this.paymentStatus,
    this.jewellerDiscount,
    this.itemHandover,
    this.lineItems,
    this.advanceBookingDetails,
    this.jewelleryPlans,
    this.oldGolds,
    this.paymentDetails,
    this.customerHoldings,
    this.orderId,
    this.digitalCoinCommodity,
    this.digitalCoinWeight,
    this.digitalCoinPhoneNumber,
    this.digitalCoinAmount,
    this.additionalLess,
    this.purchaseInvoiceNumber,
    this.metalType,
  });

  factory GetSalesBySaleNumberResponse.fromRawJson(String str) =>
      GetSalesBySaleNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponse.fromJson(Map<String, dynamic> json) {
    return GetSalesBySaleNumberResponse(
      isCancelled: json["is_cancelled"],
      inStoreSale: json["in_store_sale"],
      stateName: json["state_name"],
      stateCode: json["state_code"],
      completeHandover: json["complete_handover"],
      createdAt:
          json["created_at"] == null
              ? null
              : DateTime.parse(json["created_at"]),
      id: json["id"],
      partyId: json["party_id"],
      partyType: json["party_type"],
      partyDetails:
          json["party_details"] == null
              ? null
              : PartyDetails.fromJson(json["party_details"]),
      refernceInvoiceNumber: json["refernce_invoice_number"],
      saleNumber: json["sale_number"],
      remarks: json["remarks"],
      paymentStatus: json["payment_status"],
      jewellerDiscount: json["jeweller_discount"],
      itemHandover: json["item_handover"],
      lineItems:
          json["line_items"] == null
              ? []
              : List<GetSalesBySaleNumberResponseLineItem>.from(
                json["line_items"]!.map(
                  (x) => GetSalesBySaleNumberResponseLineItem.fromJson(x),
                ),
              ),
      advanceBookingDetails:
          json["advance_booking_details"] == null
              ? []
              : List<GetSalesBySaleNumberResponseAdvanceBookingDetail>.from(
                json["advance_booking_details"]!.map(
                  (x) =>
                      GetSalesBySaleNumberResponseAdvanceBookingDetail.fromJson(
                        x,
                      ),
                ),
              ),
      jewelleryPlans:
          json["jewellery_plans"] == null
              ? []
              : List<GetSalesBySaleNumberResponseJewelleryPlan>.from(
                json["jewellery_plans"]!.map(
                  (x) => GetSalesBySaleNumberResponseJewelleryPlan.fromJson(x),
                ),
              ),
      oldGolds:
          json["old_golds"] == null
              ? []
              : List<GetSalesBySaleNumberResponseOldGold>.from(
                json["old_golds"]!.map(
                  (x) => GetSalesBySaleNumberResponseOldGold.fromJson(x),
                ),
              ),
      paymentDetails:
          json["payment_details"] == null
              ? []
              : List<GetSalesBySaleNumberResponsePaymentDetail>.from(
                json["payment_details"]!.map(
                  (x) => GetSalesBySaleNumberResponsePaymentDetail.fromJson(x),
                ),
              ),
      customerHoldings:
          json["customer_holdings"] == null
              ? []
              : List<dynamic>.from(json["customer_holdings"]!.map((x) => x)),
      orderId: json["order_id"],
      digitalCoinCommodity: json["digital_coin_commodity"],
      digitalCoinWeight: json["digital_coin_weight"],
      digitalCoinPhoneNumber: json["digital_coin_phone_number"],
      digitalCoinAmount: json["digital_coin_amount"],
      additionalLess: json["additional_less"],
      purchaseInvoiceNumber: json["purchase_invoice_number"],
      metalType: json["metal_type"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "is_cancelled": isCancelled,
      "in_store_sale": inStoreSale,
      "state_name": stateName,
      "state_code": stateCode,
      "complete_handover": completeHandover,
      "created_at": createdAt?.toIso8601String(),
      "id": id,
      "party_id": partyId,
      "party_type": partyType,
      "party_details": partyDetails?.toJson(),
      "refernce_invoice_number": refernceInvoiceNumber,
      "sale_number": saleNumber,
      "remarks": remarks,
      "payment_status": paymentStatus,
      "jeweller_discount": jewellerDiscount,
      "item_handover": itemHandover,
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
      "payment_details":
          paymentDetails == null
              ? []
              : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      "customer_holdings":
          customerHoldings == null
              ? []
              : List<dynamic>.from(customerHoldings!.map((x) => x)),
      "order_id": orderId,
      "digital_coin_commodity": digitalCoinCommodity,
      "digital_coin_weight": digitalCoinWeight,
      "digital_coin_phone_number": digitalCoinPhoneNumber,
      "digital_coin_amount": digitalCoinAmount,
      "additional_less": additionalLess,
      "purchase_invoice_number": purchaseInvoiceNumber,
      "metal_type": metalType,
    };
  }

  CustomerSearchValue? get customerDetails =>
      partyType == "customer" ? partyDetails as CustomerSearchValue? : null;

  VendorSearchValue? get vendorDetails =>
      partyType == "vendor" ? partyDetails as VendorSearchValue? : null;
}

class GetSalesBySaleNumberResponseAdvanceBookingDetail {
  String? advancePaid;
  String? bookingId;
  String? id;
  String? rate;
  String? salesRecordId;
  String? status;
  String? weight;

  GetSalesBySaleNumberResponseAdvanceBookingDetail({
    this.advancePaid,
    this.bookingId,
    this.id,
    this.rate,
    this.salesRecordId,
    this.status,
    this.weight,
  });

  factory GetSalesBySaleNumberResponseAdvanceBookingDetail.fromRawJson(
    String str,
  ) => GetSalesBySaleNumberResponseAdvanceBookingDetail.fromJson(
    json.decode(str),
  );

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseAdvanceBookingDetail.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseAdvanceBookingDetail(
    advancePaid: json["advance_paid"],
    bookingId: json["booking_id"],
    id: json["id"],
    rate: json["rate"],
    salesRecordId: json["sales_record_id"],
    status: json["status"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "advance_paid": advancePaid,
    "booking_id": bookingId,
    "id": id,
    "rate": rate,
    "sales_record_id": salesRecordId,
    "status": status,
    "weight": weight,
  };
}

class GetSalesBySaleNumberResponseJewelleryPlan {
  String? amount;
  int? currentInstallment;
  int? duration;
  String? id;
  String? planId;
  String? redeemableAmount;
  String? salesRecordId;
  DateTime? startDate;
  int? totalInstallments;
  String? totalWeight;
  String? type;

  GetSalesBySaleNumberResponseJewelleryPlan({
    this.amount,
    this.currentInstallment,
    this.duration,
    this.id,
    this.planId,
    this.redeemableAmount,
    this.salesRecordId,
    this.startDate,
    this.totalInstallments,
    this.totalWeight,
    this.type,
  });

  factory GetSalesBySaleNumberResponseJewelleryPlan.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseJewelleryPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseJewelleryPlan.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseJewelleryPlan(
    amount: json["amount"],
    currentInstallment: json["current_installment"],
    duration: json["duration"],
    id: json["id"],
    planId: json["plan_id"],
    redeemableAmount: json["redeemable_amount"],
    salesRecordId: json["sales_record_id"],
    startDate:
        json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    totalInstallments: json["total_installments"],
    totalWeight: json["total_weight"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "current_installment": currentInstallment,
    "duration": duration,
    "id": id,
    "plan_id": planId,
    "redeemable_amount": redeemableAmount,
    "sales_record_id": salesRecordId,
    "start_date":
        "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "total_installments": totalInstallments,
    "total_weight": totalWeight,
    "type": type,
  };
}

class GetSalesBySaleNumberResponseLineItem {
  String? id;
  String? ornamentId;
  String? saleRecordId;
  String? code;
  String? taggingId;
  String? tag;
  String? description;
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
  String? makingChargesType;
  String? minVa;
  String? minMc;
  String? wastageType;
  String? costDiscount;
  GetSalesBySaleNumberResponseTaggingDetails? taggingDetails;
  GetEmployeesValue? salesPerson;
  String? rate;

  GetSalesBySaleNumberResponseLineItem({
    this.id,
    this.ornamentId,
    this.saleRecordId,
    this.code,
    this.taggingId,
    this.tag,
    this.description,
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
    this.makingChargesType,
    this.minVa,
    this.minMc,
    this.wastageType,
    this.costDiscount,
    this.taggingDetails,
    this.rate,
  });

  factory GetSalesBySaleNumberResponseLineItem.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseLineItem.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseLineItem(
    id: json["id"],
    ornamentId: json["ornament_id"],
    saleRecordId: json["sale_record_id"],
    code: json["code"],
    taggingId: json["tagging_id"],
    tag: json["tag"],
    description: json["description"],
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
    makingChargesType: json["making_charges_type"],
    minVa: json["min_va"],
    minMc: json["min_mc"],
    wastageType: json["wastage_type"],
    costDiscount: json["cost_discount"],
    taggingDetails:
        json["tagging_details"] == null
            ? null
            : GetSalesBySaleNumberResponseTaggingDetails.fromJson(
              json["tagging_details"],
            ),
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ornament_id": ornamentId,
    "sale_record_id": saleRecordId,
    "code": code,
    "tagging_id": taggingId,
    "tag": tag,
    "description": description,
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
    "making_charges_type": makingChargesType,
    "min_va": minVa,
    "min_mc": minMc,
    "wastage_type": wastageType,
    "cost_discount": costDiscount,
    "tagging_details": taggingDetails?.toJson(),
    "rate": rate,
  };
}

class GetSalesBySaleNumberResponseTaggingDetails {
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
  GetSalesBySaleNumberResponseDesign? design;
  GetSalesBySaleNumberResponseSizeGroup? sizeGroup;
  GetSalesBySaleNumberResponseCounter? counter;
  List<GetSalesBySaleNumberResponseImage>? images;
  List<GetSalesBySaleNumberResponseLineStone>? lineStones;

  GetSalesBySaleNumberResponseTaggingDetails({
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

  factory GetSalesBySaleNumberResponseTaggingDetails.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseTaggingDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseTaggingDetails.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseTaggingDetails(
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
    design:
        json["design"] == null
            ? null
            : GetSalesBySaleNumberResponseDesign.fromJson(json["design"]),
    sizeGroup:
        json["size_group"] == null
            ? null
            : GetSalesBySaleNumberResponseSizeGroup.fromJson(
              json["size_group"],
            ),
    counter:
        json["counter"] == null
            ? null
            : GetSalesBySaleNumberResponseCounter.fromJson(json["counter"]),
    images:
        json["images"] == null
            ? []
            : List<GetSalesBySaleNumberResponseImage>.from(
              json["images"]!.map(
                (x) => GetSalesBySaleNumberResponseImage.fromJson(x),
              ),
            ),
    lineStones:
        json["line_stones"] == null
            ? []
            : List<GetSalesBySaleNumberResponseLineStone>.from(
              json["line_stones"]!.map(
                (x) => GetSalesBySaleNumberResponseLineStone.fromJson(x),
              ),
            ),
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
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "line_stones":
        lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
  };
}

class GetSalesBySaleNumberResponseCounter {
  String? id;
  String? code;
  String? counterName;
  String? organizationId;
  bool? isDefault;
  int? totalItems;
  String? totalWeight;

  GetSalesBySaleNumberResponseCounter({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  factory GetSalesBySaleNumberResponseCounter.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseCounter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseCounter.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseCounter(
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

class GetSalesBySaleNumberResponseDesign {
  String? id;
  String? code;
  String? name;
  String? organizationId;
  GetSalesBySaleNumberResponseStockHead? stockHead;
  GetSalesBySaleNumberResponseOrnament? ornament;
  bool? tagRequired;
  bool? stoneRequired;
  bool? hasSameImage;
  Type? makingChargeType;
  List<GetSalesBySaleNumberResponseImage>? images;
  String? remarks;
  List<DesignLineItem>? lineItems;

  GetSalesBySaleNumberResponseDesign({
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

  factory GetSalesBySaleNumberResponseDesign.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseDesign.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseDesign.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseDesign(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    organizationId: json["organization_id"],
    stockHead:
        json["stock_head"] == null
            ? null
            : GetSalesBySaleNumberResponseStockHead.fromJson(
              json["stock_head"],
            ),
    ornament:
        json["ornament"] == null
            ? null
            : GetSalesBySaleNumberResponseOrnament.fromJson(json["ornament"]),
    tagRequired: json["tag_required"],
    stoneRequired: json["stone_required"],
    hasSameImage: json["has_same_image"],
    makingChargeType:
        json["making_charge_type"] == null
            ? null
            : Type.fromJson(json["making_charge_type"]),
    images:
        json["images"] == null
            ? []
            : List<GetSalesBySaleNumberResponseImage>.from(
              json["images"]!.map(
                (x) => GetSalesBySaleNumberResponseImage.fromJson(x),
              ),
            ),
    remarks: json["remarks"],
    lineItems:
        json["line_items"] == null
            ? []
            : List<DesignLineItem>.from(
              json["line_items"]!.map((x) => DesignLineItem.fromJson(x)),
            ),
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
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "remarks": remarks,
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
  };
}

class GetSalesBySaleNumberResponseImage {
  dynamic id;
  String? fileName;
  String? fileType;
  String? s3Key;
  dynamic presignedUrl;

  GetSalesBySaleNumberResponseImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory GetSalesBySaleNumberResponseImage.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseImage.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseImage(
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
  });

  factory DesignLineItem.fromRawJson(String str) =>
      DesignLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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

class Type {
  String? id;
  String? typeName;

  Type({this.id, this.typeName});

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) =>
      Type(id: json["id"], typeName: json["type_name"]);

  Map<String, dynamic> toJson() => {"id": id, "type_name": typeName};
}

class GetSalesBySaleNumberResponseOrnament {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  GetSalesBySaleNumberResponseMetalType? metalType;
  String? openingWeight;
  String? openingAmount;
  String? gst;
  DateTime? createdAt;

  GetSalesBySaleNumberResponseOrnament({
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

  factory GetSalesBySaleNumberResponseOrnament.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseOrnament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseOrnament.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseOrnament(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    organizationId: json["organization_id"],
    hsnSac: json["hsn_sac"],
    metalType:
        json["metal_type"] == null
            ? null
            : GetSalesBySaleNumberResponseMetalType.fromJson(
              json["metal_type"],
            ),
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

class GetSalesBySaleNumberResponseMetalType {
  String? id;
  String? typeName;
  String? codeType;

  GetSalesBySaleNumberResponseMetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory GetSalesBySaleNumberResponseMetalType.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseMetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseMetalType.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseMetalType(
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

class GetSalesBySaleNumberResponseStockHead {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  GetSalesBySaleNumberResponseCategory? category;
  bool? isNetWeight;
  String? hallmarkExtraCharge;
  Type? metalType;
  bool? sizeRequired;
  List<GetSalesBySaleNumberResponseWeightGroup>? weightGroups;
  List<GetSalesBySaleNumberResponseSizeGroup>? sizeGroups;

  GetSalesBySaleNumberResponseStockHead({
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

  factory GetSalesBySaleNumberResponseStockHead.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseStockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseStockHead.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseStockHead(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    organizationId: json["organization_id"],
    category:
        json["category"] == null
            ? null
            : GetSalesBySaleNumberResponseCategory.fromJson(json["category"]),
    isNetWeight: json["is_net_weight"],
    hallmarkExtraCharge: json["hallmark_extra_charge"],
    metalType:
        json["metal_type"] == null ? null : Type.fromJson(json["metal_type"]),
    sizeRequired: json["size_required"],
    weightGroups:
        json["weight_groups"] == null
            ? []
            : List<GetSalesBySaleNumberResponseWeightGroup>.from(
              json["weight_groups"]!.map(
                (x) => GetSalesBySaleNumberResponseWeightGroup.fromJson(x),
              ),
            ),
    sizeGroups:
        json["size_groups"] == null
            ? []
            : List<GetSalesBySaleNumberResponseSizeGroup>.from(
              json["size_groups"]!.map(
                (x) => GetSalesBySaleNumberResponseSizeGroup.fromJson(x),
              ),
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

class GetSalesBySaleNumberResponseCategory {
  String? id;
  String? categoryName;

  GetSalesBySaleNumberResponseCategory({this.id, this.categoryName});

  factory GetSalesBySaleNumberResponseCategory.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseCategory.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseCategory(
    id: json["id"],
    categoryName: json["category_name"],
  );

  Map<String, dynamic> toJson() => {"id": id, "category_name": categoryName};
}

class GetSalesBySaleNumberResponseSizeGroup {
  String? id;
  String? code;
  String? size;

  GetSalesBySaleNumberResponseSizeGroup({this.id, this.code, this.size});

  factory GetSalesBySaleNumberResponseSizeGroup.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseSizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseSizeGroup.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseSizeGroup(
    id: json["id"],
    code: json["code"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {"id": id, "code": code, "size": size};
}

class GetSalesBySaleNumberResponseWeightGroup {
  String? id;
  String? name;
  String? code;
  String? minWeight;
  String? maxWeight;

  GetSalesBySaleNumberResponseWeightGroup({
    this.id,
    this.name,
    this.code,
    this.minWeight,
    this.maxWeight,
  });

  factory GetSalesBySaleNumberResponseWeightGroup.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseWeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseWeightGroup.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseWeightGroup(
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

class GetSalesBySaleNumberResponseLineStone {
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

  GetSalesBySaleNumberResponseLineStone({
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

  factory GetSalesBySaleNumberResponseLineStone.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseLineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseLineStone.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseLineStone(
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

class GetSalesBySaleNumberResponseOldGold {
  String? id;
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
  String? rate;
  String? amount;
  String? roundOff;
  String? total;

  GetSalesBySaleNumberResponseOldGold({
    this.id,
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
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
  });

  factory GetSalesBySaleNumberResponseOldGold.fromRawJson(String str) =>
      GetSalesBySaleNumberResponseOldGold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponseOldGold.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponseOldGold(
    id: json["id"],
    organizationId: json["organization_id"],
    shopId: json["shop_id"],
    code: json["code"],
    description: json["description"],
    pieces: json["pieces"],
    grossWeight: json["gross_weight"],
    netWeight: json["net_weight"],
    less: json["less"],
    purityType: json["purity_type"],
    ornamentId: json["ornament_id"],
    rate: json["rate"],
    amount: json["amount"],
    roundOff: json["round_off"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
    "rate": rate,
    "amount": amount,
    "round_off": roundOff,
    "total": total,
  };
}

class GetSalesBySaleNumberResponsePaymentDetail {
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
  String? tcs;
  String? tds;
  String? nettTdsTcs;
  String? purchaseOldGold;
  String? advance;
  String? roundOff;
  String? bankCharges;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? salesRecordId;
  List<GetSalesBySaleNumberResponsePaymentMethodDetail>? paymentMethodDetails;

  GetSalesBySaleNumberResponsePaymentDetail({
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
    this.salesRecordId,
    this.paymentMethodDetails,
  });

  factory GetSalesBySaleNumberResponsePaymentDetail.fromRawJson(String str) =>
      GetSalesBySaleNumberResponsePaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponsePaymentDetail.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponsePaymentDetail(
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
    salesRecordId: json["sales_record_id"],
    paymentMethodDetails:
        json["payment_method_details"] == null
            ? []
            : List<GetSalesBySaleNumberResponsePaymentMethodDetail>.from(
              json["payment_method_details"]!.map(
                (x) =>
                    GetSalesBySaleNumberResponsePaymentMethodDetail.fromJson(x),
              ),
            ),
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
    "sales_record_id": salesRecordId,
    "payment_method_details":
        paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
  };
}

class GetSalesBySaleNumberResponsePaymentMethodDetail {
  String? id;
  String? amount;
  String? method;
  String? date;
  String? pos;
  String? paymentCode;
  String? salesPaymentDetailsId;

  GetSalesBySaleNumberResponsePaymentMethodDetail({
    this.id,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.salesPaymentDetailsId,
  });

  factory GetSalesBySaleNumberResponsePaymentMethodDetail.fromRawJson(
    String str,
  ) => GetSalesBySaleNumberResponsePaymentMethodDetail.fromJson(
    json.decode(str),
  );

  String toRawJson() => json.encode(toJson());

  factory GetSalesBySaleNumberResponsePaymentMethodDetail.fromJson(
    Map<String, dynamic> json,
  ) => GetSalesBySaleNumberResponsePaymentMethodDetail(
    id: json["id"],
    amount: json["amount"],
    method: json["method"],
    date: json["date"],
    pos: json["pos"],
    paymentCode: json["payment_code"],
    salesPaymentDetailsId: json["sales_payment_details_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "method": method,
    "date": date,
    "pos": pos,
    "payment_code": paymentCode,
    "sales_payment_details_id": salesPaymentDetailsId,
  };
}

class PartyDetails {
  String? id;
  String? syncId;
  String? readableId;
  String? phoneNumber;
  String? phoneCountryCode;
  String? name;
  DateTime? dateOfBirth;
  dynamic panNumber;
  dynamic aadhaarNumber;
  dynamic gstNumber;
  dynamic deductionType;
  dynamic deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  dynamic ledger;
  List<dynamic>? nominees;
  List<Address>? address;
  String? signUpSource;
  String? email;
  bool? isAadhaarVerified;
  bool? isPanVerified;
  bool? isAadhaarOnlineVerified;
  bool? isPanOnlineVerified;
  bool? isForcedKycAadhaar;
  bool? isForcedKycPan;
  dynamic panImages;
  dynamic aadhaarImages;

  PartyDetails({
    this.id,
    this.syncId,
    this.readableId,
    this.phoneNumber,
    this.phoneCountryCode,
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
    this.isAadhaarVerified,
    this.isPanVerified,
    this.isAadhaarOnlineVerified,
    this.isPanOnlineVerified,
    this.isForcedKycAadhaar,
    this.isForcedKycPan,
    this.panImages,
    this.aadhaarImages,
  });

  factory PartyDetails.fromRawJson(String str) =>
      PartyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PartyDetails.fromJson(Map<String, dynamic> json) => PartyDetails(
    id: json["id"],
    syncId: json["sync_id"],
    readableId: json["readable_id"],
    phoneNumber: json["phone_number"],
    phoneCountryCode: json["phone_country_code"],
    name: json["name"],
    dateOfBirth:
        json["date_of_birth"] == null
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
    ledger: json["ledger"],
    nominees:
        json["nominees"] == null
            ? []
            : List<dynamic>.from(json["nominees"]!.map((x) => x)),
    address:
        json["address"] == null
            ? []
            : List<Address>.from(
              json["address"]!.map((x) => Address.fromJson(x)),
            ),
    signUpSource: json["sign_up_source"],
    email: json["email"],
    isAadhaarVerified: json["is_aadhaar_verified"],
    isPanVerified: json["is_pan_verified"],
    isAadhaarOnlineVerified: json["is_aadhaar_online_verified"],
    isPanOnlineVerified: json["is_pan_online_verified"],
    isForcedKycAadhaar: json["is_forced_kyc_aadhaar"],
    isForcedKycPan: json["is_forced_kyc_pan"],
    panImages: json["pan_images"],
    aadhaarImages: json["aadhaar_images"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sync_id": syncId,
    "readable_id": readableId,
    "phone_number": phoneNumber,
    "phone_country_code": phoneCountryCode,
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
    "ledger": ledger,
    "nominees":
        nominees == null ? [] : List<dynamic>.from(nominees!.map((x) => x)),
    "address":
        address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
    "sign_up_source": signUpSource,
    "email": email,
    "is_aadhaar_verified": isAadhaarVerified,
    "is_pan_verified": isPanVerified,
    "is_aadhaar_online_verified": isAadhaarOnlineVerified,
    "is_pan_online_verified": isPanOnlineVerified,
    "is_forced_kyc_aadhaar": isForcedKycAadhaar,
    "is_forced_kyc_pan": isForcedKycPan,
    "pan_images": panImages,
    "aadhaar_images": aadhaarImages,
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
  dynamic state;
  String? city;
  String? pincode;
  String? addressLine1;
  dynamic addressLine2;
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
