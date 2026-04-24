import 'dart:convert';

class GetSalesRecordByIdAggregateResponse {
  bool? completeHandover;

  bool? isCancelled;
  bool? inStoreSale;
  String? stateName;
  String? stateCode;
  DateTime? createdAt;
  String? id;
  String? partyId;
  String? partyType;
  PartyDetails? partyDetails;
  String? refernceInvoiceNumber;
  String? saleNumber;
  String? remarks;
  String? paymentStatus;
  String? jewellerDiscount;
  List<GetSalesRecordByIdAggregateResponseLineItem>? lineItems;
  List<AdvanceBookingDetail>? advanceBookingDetails;
  List<JewelleryPlan>? jewelleryPlans;
  List<GetSalesRecordByIdAggregateOldGold>? oldGolds;
  List<PaymentDetail>? paymentDetails;
  List<CustomerHolding>? customerHoldings;
  String? orderId;
  String? digitalCoinCommodity;
  String? digitalCoinWeight;
  String? digitalCoinPhoneNumber;
  String? digitalCoinAmount;
  String? additionalLess;
  String? purchaseInvoiceNumber;

  GetSalesRecordByIdAggregateResponse({
    this.inStoreSale,
    this.isCancelled,
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
  });

  factory GetSalesRecordByIdAggregateResponse.fromRawJson(String str) =>
      GetSalesRecordByIdAggregateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesRecordByIdAggregateResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSalesRecordByIdAggregateResponse(
        inStoreSale: json["in_store_sale"],
        isCancelled: json["is_cancelled"],
        stateName: json["state_name"],
        stateCode: json["state_code"],
        completeHandover: json["complete_handover"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyDetails: json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
        refernceInvoiceNumber: json["refernce_invoice_number"],
        saleNumber: json["sale_number"],
        remarks: json["remarks"],
        paymentStatus: json["payment_status"],
        jewellerDiscount: json["jeweller_discount"],
        lineItems: json["line_items"] == null
            ? []
            : List<GetSalesRecordByIdAggregateResponseLineItem>.from(
                json["line_items"]!.map((x) =>
                    GetSalesRecordByIdAggregateResponseLineItem.fromJson(x))),
        advanceBookingDetails: json["advance_booking_details"] == null
            ? []
            : List<AdvanceBookingDetail>.from(json["advance_booking_details"]!
                .map((x) => AdvanceBookingDetail.fromJson(x))),
        jewelleryPlans: json["jewellery_plans"] == null
            ? []
            : List<JewelleryPlan>.from(
                json["jewellery_plans"]!.map((x) => JewelleryPlan.fromJson(x))),
        oldGolds: json["old_golds"] == null
            ? []
            : List<GetSalesRecordByIdAggregateOldGold>.from(json["old_golds"]!
                .map((x) => GetSalesRecordByIdAggregateOldGold.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
        customerHoldings: json["customer_holdings"] == null
            ? []
            : List<CustomerHolding>.from(json["customer_holdings"]!
                .map((x) => CustomerHolding.fromJson(x))),
        orderId: json["order_id"],
        digitalCoinCommodity: json["digital_coin_commodity"],
        digitalCoinWeight: json["digital_coin_weight"],
        digitalCoinPhoneNumber: json["digital_coin_phone_number"],
        digitalCoinAmount: json["digital_coin_amount"],
        additionalLess: json["additional_less"],
        purchaseInvoiceNumber: json["purchase_invoice_number"],
      );

  Map<String, dynamic> toJson() => {
        "in_store_sale": inStoreSale,
        "is_cancelled": isCancelled,
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
        "customer_holdings": customerHoldings == null
            ? []
            : List<dynamic>.from(customerHoldings!.map((x) => x)),
        "order_id": orderId,
        "digital_coin_commodity": digitalCoinCommodity,
        "digital_coin_weight": digitalCoinWeight,
        "digital_coin_phone_number": digitalCoinPhoneNumber,
        "digital_coin_amount": digitalCoinAmount,
        "additional_less": additionalLess,
        "purchase_invoice_number": purchaseInvoiceNumber,
      };
}

class AdvanceBookingDetail {
  String? advancePaid;
  String? bookingId;
  String? id;
  String? rate;
  String? salesRecordId;
  String? status;
  String? weight;

  AdvanceBookingDetail({
    this.advancePaid,
    this.bookingId,
    this.id,
    this.rate,
    this.salesRecordId,
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

class CustomerHolding {
  String? id;
  String? organizationId;
  String? shopId;
  String? itemDescription;
  String? netWeight;
  String? customerId;
  bool? isReturned;

  CustomerHolding({
    this.id,
    this.organizationId,
    this.shopId,
    this.itemDescription,
    this.netWeight,
    this.customerId,
    this.isReturned,
  });

  factory CustomerHolding.fromRawJson(String str) =>
      CustomerHolding.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerHolding.fromJson(Map<String, dynamic> json) =>
      CustomerHolding(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        itemDescription: json["item_description"],
        netWeight: json["net_weight"],
        customerId: json["customer_id"],
        isReturned: json["is_returned"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "item_description": itemDescription,
        "net_weight": netWeight,
        "customer_id": customerId,
        "is_returned": isReturned,
      };
}

class JewelleryPlan {
  int? duration;
  String? id;
  String? installments;
  String? planId;
  String? redeemableAmount;
  String? salesRecordId;
  DateTime? startDate;
  String? subscriptionId;
  String? totalWeight;
  String? type;

  JewelleryPlan({
    this.duration,
    this.id,
    this.installments,
    this.planId,
    this.redeemableAmount,
    this.salesRecordId,
    this.startDate,
    this.subscriptionId,
    this.totalWeight,
    this.type,
  });

  factory JewelleryPlan.fromRawJson(String str) =>
      JewelleryPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JewelleryPlan.fromJson(Map<String, dynamic> json) => JewelleryPlan(
        duration: json["duration"],
        id: json["id"],
        installments: json["installments"],
        planId: json["plan_id"],
        redeemableAmount: json["redeemable_amount"],
        salesRecordId: json["sales_record_id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        subscriptionId: json["subscription_id"],
        totalWeight: json["total_weight"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "id": id,
        "installments": installments,
        "plan_id": planId,
        "redeemable_amount": redeemableAmount,
        "sales_record_id": salesRecordId,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "subscription_id": subscriptionId,
        "total_weight": totalWeight,
        "type": type,
      };
}

class GetSalesRecordByIdAggregateResponseLineItem {
  String? id;
  String? ornamentId;
  String? saleRecordId;
  TaggingRecord? taggingRecord;
  String? code;
  String? taggingId;
  String? rate;
  String? tag;
  String? description;
  String? salesPersonId;
  SalesPerson? salesPerson;
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
  String? makingChargeAmount;
  String? minVa;
  String? minMc;
  String? wastageType;
  String? costDiscount;

  GetSalesRecordByIdAggregateResponseLineItem({
    this.id,
    this.ornamentId,
    this.saleRecordId,
    this.taggingRecord,
    this.code,
    this.taggingId,
    this.rate,
    this.tag,
    this.description,
    this.salesPersonId,
    this.salesPerson,
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
    this.makingChargeAmount,
    this.minVa,
    this.minMc,
    this.wastageType,
    this.costDiscount,
  });

  static String? _trimDecimal(String? value) {
    if (value == null) return null;
    return value.endsWith('.00') ? value.replaceAll('.00', '') : value;
  }

  factory GetSalesRecordByIdAggregateResponseLineItem.fromRawJson(String str) =>
      GetSalesRecordByIdAggregateResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesRecordByIdAggregateResponseLineItem.fromJson(
          Map<String, dynamic> json) =>
      GetSalesRecordByIdAggregateResponseLineItem(
        id: json["id"],
        ornamentId: json["ornament_id"],
        saleRecordId: json["sale_record_id"],
        taggingRecord: json["tagging_record"] == null
            ? null
            : TaggingRecord.fromJson(json["tagging_record"]),
        code: json["code"],
        taggingId: json["tagging_id"],
        rate: json["rate"],
        tag: json["tag"],
        description: json["description"],
        salesPersonId: json["sales_person_id"],
        salesPerson: json["sales_person"] == null
            ? null
            : SalesPerson.fromJson(json["sales_person"]),
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
        stoneCost: _trimDecimal(json["stone_cost"]),
        hallMark: _trimDecimal(json["hall_mark"]),
        discount: json["discount"],
        salesAmount: json["sales_amount"],
        totalAmount: json["total_amount"],
        makingChargesType: json["making_charges_type"],
        makingChargeAmount: _trimDecimal(json["making_charge_amount"]),
        minVa: json["min_va"],
        minMc: json["min_mc"],
        wastageType: json["wastage_type"],
        costDiscount: json["cost_discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ornament_id": ornamentId,
        "sale_record_id": saleRecordId,
        "tagging_record": taggingRecord?.toJson(),
        "code": code,
        "tagging_id": taggingId,
        "rate": rate,
        "tag": tag,
        "description": description,
        "sales_person_id": salesPersonId,
        "sales_person": salesPerson?.toJson(),
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
        "making_charge_amount": makingChargeAmount,
        "min_va": minVa,
        "min_mc": minMc,
        "wastage_type": wastageType,
        "cost_discount": costDiscount,
      };
}

class SalesPerson {
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

  SalesPerson({
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

  factory SalesPerson.fromRawJson(String str) =>
      SalesPerson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesPerson.fromJson(Map<String, dynamic> json) => SalesPerson(
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

class TaggingRecord {
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
  String? rate;
  String? huid;
  String? purity;
  bool? isWebstore;
  Design? design;
  DesignLineItemElement? designLineItem;
  SizeGroup? sizeGroup;
  Counter? counter;
  Counter? startCounter;
  List<Image>? images;
  String? employeeId;
  DateTime? createdAt;
  String? taggedById;
  List<LineStone>? lineStones;
  DateTime? lastScannedAt;
  dynamic orderLineItemId;
  dynamic repairLineItemId;

  TaggingRecord({
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
    this.isWebstore,
    this.design,
    this.designLineItem,
    this.sizeGroup,
    this.counter,
    this.startCounter,
    this.images,
    this.employeeId,
    this.createdAt,
    this.taggedById,
    this.lineStones,
    this.lastScannedAt,
    this.orderLineItemId,
    this.repairLineItemId,
  });

  factory TaggingRecord.fromRawJson(String str) =>
      TaggingRecord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggingRecord.fromJson(Map<String, dynamic> json) => TaggingRecord(
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
        isWebstore: json["is_webstore"],
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
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        employeeId: json["employee_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        taggedById: json["tagged_by_id"],
        lineStones: json["line_stones"] == null
            ? []
            : List<LineStone>.from(
                json["line_stones"]!.map((x) => LineStone.fromJson(x))),
        lastScannedAt: json["last_scanned_at"] == null
            ? null
            : DateTime.parse(json["last_scanned_at"]),
        orderLineItemId: json["order_line_item_id"],
        repairLineItemId: json["repair_line_item_id"],
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
        "is_webstore": isWebstore,
        "design": design?.toJson(),
        "design_line_item": designLineItem?.toJson(),
        "size_group": sizeGroup?.toJson(),
        "counter": counter?.toJson(),
        "start_counter": startCounter?.toJson(),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "employee_id": employeeId,
        "created_at": createdAt?.toIso8601String(),
        "tagged_by_id": taggedById,
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
        "last_scanned_at": lastScannedAt?.toIso8601String(),
        "order_line_item_id": orderLineItemId,
        "repair_line_item_id": repairLineItemId,
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
  dynamic tagCode;
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
        "tag_code": tagCode,
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
  List<dynamic>? valueCounts;

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
    this.valueCounts,
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

class LineStone {
  String? id;
  String? organizationId;
  ReferenceStone? referenceStone;
  String? taggingLineItemId;
  String? name;
  int? pieces;
  String? carat;
  dynamic weight;
  String? rate;
  String? total;

  LineStone({
    this.id,
    this.organizationId,
    this.referenceStone,
    this.taggingLineItemId,
    this.name,
    this.pieces,
    this.carat,
    this.weight,
    this.rate,
    this.total,
  });

  static String? _trimDecimal(String? value) {
    if (value == null) return null;
    return value.endsWith('.00') ? value.replaceAll('.00', '') : value;
  }

  factory LineStone.fromRawJson(String str) =>
      LineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineStone.fromJson(Map<String, dynamic> json) => LineStone(
        id: json["id"],
        organizationId: json["organization_id"],
        referenceStone: json["reference_stone"] == null
            ? null
            : ReferenceStone.fromJson(json["reference_stone"]),
        taggingLineItemId: json["tagging_line_item_id"],
        name: json["name"],
        pieces: json["pieces"],
        carat: json["carat"],
        weight: json["weight"],
        rate: json["rate"],
        total: _trimDecimal(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "reference_stone": referenceStone?.toJson(),
        "tagging_line_item_id": taggingLineItemId,
        "name": name,
        "pieces": pieces,
        "carat": carat,
        "weight": weight,
        "rate": rate,
        "total": total,
      };
}

class ReferenceStone {
  bool? isOther;
  String? id;
  String? code;
  String? name;
  String? rateType;
  String? rate;
  String? color;
  String? cut;
  String? clarity;
  String? buyBackPercentage;
  Ornament? ornament;

  ReferenceStone({
    this.isOther,
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

  factory ReferenceStone.fromRawJson(String str) =>
      ReferenceStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferenceStone.fromJson(Map<String, dynamic> json) => ReferenceStone(
        isOther: json["is_other"],
        id: json["id"],
        code: json["code"],
        name: json["name"],
        rateType: json["rate_type"],
        rate: json["rate"],
        color: json["color"],
        cut: json["cut"],
        clarity: json["clarity"],
        buyBackPercentage: json["buy_back_percentage"],
        ornament: json["ornament"] == null
            ? null
            : Ornament.fromJson(json["ornament"]),
      );

  Map<String, dynamic> toJson() => {
        "is_other": isOther,
        "id": id,
        "code": code,
        "name": name,
        "rate_type": rateType,
        "rate": rate,
        "color": color,
        "cut": cut,
        "clarity": clarity,
        "buy_back_percentage": buyBackPercentage,
        "ornament": ornament?.toJson(),
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

class GetSalesRecordByIdAggregateOldGold {
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
  String? purity;
  MetalType? metalType;
  String? ornamentId;
  String? ornamentName;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;

  GetSalesRecordByIdAggregateOldGold({
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

  factory GetSalesRecordByIdAggregateOldGold.fromRawJson(String str) =>
      GetSalesRecordByIdAggregateOldGold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory GetSalesRecordByIdAggregateOldGold.fromJson(
          Map<String, dynamic> json) =>
      GetSalesRecordByIdAggregateOldGold(
        id: json["id"],
        oldGoldEstimateNumber: json["old_gold_estimate_number"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"]?.toString(), // 20.213 → "20.213"
        netWeight: json["net_weight"]?.toString(), // 17.872 → "17.872"
        less: json["less"]?.toString(), // 2.341  → "2.341"
        purityType: json["purity_type"],
        purity: json["purity"]?.toString(), // 85.12  → "85.12"
        metalType: json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
        ornamentId: json["ornament_id"],
        ornamentName: json["ornament_name"],
        rate: json["rate"]?.toString(), // 16000.0 → "16000.0"
        amount: json["amount"]?.toString(), // 243402.34 → "243402.34"
        roundOff: json["round_off"]?.toString(), // 0.0 → "0.0"
        total: json["total"]?.toString(), // 243403.0 → "243403.0"
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

class PartyDetails {
  String? id;
  dynamic syncId;
  String? readableId;
  String? phoneNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  dynamic aadhaarNumber;
  String? gstNumber;
  dynamic deductionType;
  dynamic deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  dynamic ledger;
  List<dynamic>? nominees;
  List<Address>? address;

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
        ledger: json["ledger"],
        nominees: json["nominees"] == null
            ? []
            : List<dynamic>.from(json["nominees"]!.map((x) => x)),
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
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
        "ledger": ledger,
        "nominees":
            nominees == null ? [] : List<dynamic>.from(nominees!.map((x) => x)),
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
  String? salesRecordId;
  List<PaymentMethodDetail>? paymentMethodDetails;
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
    this.salesRecordId,
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
        salesRecordId: json["sales_record_id"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<PaymentMethodDetail>.from(json["payment_method_details"]!
                .map((x) => PaymentMethodDetail.fromJson(x))),
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
        "sales_record_id": salesRecordId,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x)),
        "advance_booking_amount": advanceBookingAmount,
        "jewellery_plan_base_amount": jewelleryPlanBaseAmount,
      };
}

class PaymentMethodDetail {
  String? id;
  String? amount;
  String? method;
  DateTime? date;
  dynamic pos;
  String? paymentCode;
  String? universalPaymentCode;
  String? salesPaymentDetailsId;

  PaymentMethodDetail({
    this.id,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.universalPaymentCode,
    this.salesPaymentDetailsId,
  });

  factory PaymentMethodDetail.fromRawJson(String str) =>
      PaymentMethodDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodDetail.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetail(
        id: json["id"],
        amount: json["amount"],
        method: json["method"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        pos: json["pos"],
        paymentCode: json["payment_code"],
        universalPaymentCode: json["universal_payment_code"],
        salesPaymentDetailsId: json["sales_payment_details_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "method": method,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "pos": pos,
        "payment_code": paymentCode,
        "universal_payment_code": universalPaymentCode,
        "sales_payment_details_id": salesPaymentDetailsId,
      };
}
