import 'dart:convert';

class PostSalesRequestModel {
  String? voucherType;
  String? voucherSeriesId;
  bool is_held;
  bool? in_store_sale;
  String? organizationId;
  String? shopId;
  String? partyId;
  String? partyType;
  String? partyName;
  String? designCode;
  String? ornamentName;
  String? ornamentCode;
  String? saleNumber;
  String? remarks;
  bool? paymentStatus;
  double? jewellerDiscount;
  List<PostSaleLineItemRequest>? lineItems;
  List<PostSaleAdvanceBookingDetailRequest>? advanceBookingDetails;
  List<PostSaleJewelleryPlanRequest>? jewelleryPlans;
  List<PostSaleOldGoldRequest>? oldGolds;
  List<PostSalePaymentDetailRequest>? paymentDetails;
  List<PostSaleCustomerHoldingRequest>? customerHoldings;
  String? partyCode;
  String? partyAddress;
  String? partyGst;
  String? partyInvoiceNumber;
  String? purchaseInvoiceNumber;
  String? purchaseId;
  String? refernceInvoiceNumber;
  String? orderId;
  // Jewellery Plan
  String? jewelleryPlanOtp;
  String? jewelleryPlanPhoneNumber;
  // Digital coin
  String? digitalCoinCommodity;
  double? digitalCoinWeight;
  String? digitalCoinPhoneNumber;
  double? digitalCoinAmount;
  String? digitalCoinOtp;

  String? metalType;

  PostSalesRequestModel({
    this.voucherType,
    this.voucherSeriesId,
    required this.is_held,
    this.in_store_sale,
    this.organizationId,
    this.shopId,
    this.partyId,
    this.partyType,
    this.partyName,
    this.designCode,
    this.ornamentName,
    this.ornamentCode,
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
    this.partyCode,
    this.partyAddress,
    this.partyGst,
    this.partyInvoiceNumber,
    this.purchaseInvoiceNumber,
    this.purchaseId,
    this.refernceInvoiceNumber,
    this.orderId,
    // Jewellery plan
    this.jewelleryPlanOtp,
    this.jewelleryPlanPhoneNumber,
    // Digital Coin
    this.digitalCoinCommodity,
    this.digitalCoinWeight,
    this.digitalCoinPhoneNumber,
    this.digitalCoinAmount,
    this.digitalCoinOtp,
    this.metalType,
  });

  factory PostSalesRequestModel.fromRawJson(String str) =>
      PostSalesRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSalesRequestModel.fromJson(Map<String, dynamic> json) =>
      PostSalesRequestModel(
        voucherType: json["voucher_type"],
        voucherSeriesId: json["voucher_series_id"],

        is_held: json["is_held"],
        in_store_sale: json["in_store_sale"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        designCode: json["design_code"],
        ornamentName: json["ornament_name"],
        ornamentCode: json["ornament_code"],
        saleNumber: json["sale_number"],
        remarks: json["remarks"],
        paymentStatus: json["payment_status"],
        jewellerDiscount: json["jeweller_discount"],
        lineItems: json["line_items"] == null
            ? []
            : List<PostSaleLineItemRequest>.from(json["line_items"]!
                .map((x) => PostSaleLineItemRequest.fromJson(x))),
        advanceBookingDetails: json["advance_booking_details"] == null
            ? []
            : List<PostSaleAdvanceBookingDetailRequest>.from(
                json["advance_booking_details"]!.map(
                    (x) => PostSaleAdvanceBookingDetailRequest.fromJson(x))),
        jewelleryPlans: json["jewellery_plans"] == null
            ? []
            : List<PostSaleJewelleryPlanRequest>.from(json["jewellery_plans"]!
                .map((x) => PostSaleJewelleryPlanRequest.fromJson(x))),
        oldGolds: json["old_golds"] == null
            ? []
            : List<PostSaleOldGoldRequest>.from(json["old_golds"]!
                .map((x) => PostSaleOldGoldRequest.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PostSalePaymentDetailRequest>.from(json["payment_details"]!
                .map((x) => PostSalePaymentDetailRequest.fromJson(x))),
        customerHoldings: json["customer_holdings"] == null
            ? []
            : List<PostSaleCustomerHoldingRequest>.from(
                json["customer_holdings"]!
                    .map((x) => PostSaleCustomerHoldingRequest.fromJson(x))),
        partyCode: json["party_code"],
        partyAddress: json["party_address"],
        partyGst: json["party_gst"],
        partyInvoiceNumber: json["party_invoice_number"],
        purchaseInvoiceNumber: json["purchase_invoice_number"],
        purchaseId: json["purchase_id"],
        refernceInvoiceNumber: json["refernce_invoice_number"],
        orderId: json["order_id"],
        // Jewellery plan
        jewelleryPlanOtp: json["jewellery_plan_otp"],
        jewelleryPlanPhoneNumber: json["jewellery_plan_phone_number"],
        // Digital coin
        digitalCoinCommodity: json["digital_coin_commodity"],
        digitalCoinWeight: json["digital_coin_weight"],
        digitalCoinPhoneNumber: json["digital_coin_phone_number"],
        digitalCoinAmount: json["digital_coin_amount"],
        digitalCoinOtp: json["digital_coin_otp"],
        metalType: json["metal_type"],
      );

  Map<String, dynamic> toJson() => {
        "voucher_type": voucherType,
        "voucher_series_id": voucherSeriesId,
        "is_held": is_held,
        "in_store_sale": in_store_sale,
        "organization_id": organizationId,
        "shop_id": shopId,
        "party_id": partyId,
        "party_type": partyType,
        "party_name": partyName,
        "design_code": designCode,
        "ornament_name": ornamentName,
        "ornament_code": ornamentCode,
        "sale_number": saleNumber,
        "remarks": remarks,
        "payment_status": paymentStatus,
        "jeweller_discount": jewellerDiscount,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "advance_booking_details": advanceBookingDetails == null
            ? []
            : List<dynamic>.from(advanceBookingDetails!.map((x) => x.toJson())),
        "jewellery_plans": jewelleryPlans == null
            ? []
            : List<dynamic>.from(jewelleryPlans!.map((x) => x.toJson())),
        "old_golds": oldGolds == null
            ? []
            : List<dynamic>.from(oldGolds!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "customer_holdings": customerHoldings == null
            ? []
            : List<dynamic>.from(customerHoldings!.map((x) => x.toJson())),
        "party_code": partyCode,
        "party_address": partyAddress,
        "party_gst": partyGst,
        "party_invoice_number": partyInvoiceNumber,
        "purchase_invoice_number": purchaseInvoiceNumber,
        "purchase_id": purchaseId,
        "refernce_invoice_number": refernceInvoiceNumber,
        "order_id": orderId,
        // Jewellery plan
        "jewellery_plan_otp": jewelleryPlanOtp,
        "jewellery_plan_phone_number": jewelleryPlanPhoneNumber,
        // Digital Coin
        "digital_coin_commodity": digitalCoinCommodity,
        "digital_coin_weight": digitalCoinWeight,
        "digital_coin_phone_number": digitalCoinPhoneNumber,
        "digital_coin_amount": digitalCoinAmount,
        "digital_coin_otp": digitalCoinOtp,
        "metal_type": metalType,
      };
}

class PostSaleAdvanceBookingDetailRequest {
  String? advancePaid;
  String? bookingId;
  String? rate;
  String? status;
  String? weight;

  PostSaleAdvanceBookingDetailRequest({
    this.advancePaid,
    this.bookingId,
    this.rate,
    this.status,
    this.weight,
  });

  factory PostSaleAdvanceBookingDetailRequest.fromRawJson(String str) =>
      PostSaleAdvanceBookingDetailRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSaleAdvanceBookingDetailRequest.fromJson(
          Map<String, dynamic> json) =>
      PostSaleAdvanceBookingDetailRequest(
        advancePaid: json["advance_paid"],
        bookingId: json["booking_id"],
        rate: json["rate"],
        status: json["status"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "advance_paid": advancePaid,
        "booking_id": bookingId,
        "rate": rate,
        "status": status,
        "weight": weight,
      };
}

class PostSaleCustomerHoldingRequest {
  String? organizationId;
  String? shopId;
  String? itemDescription;
  double? netWeight;
  String? customerId;
  String? salesRecordId;
  bool? isReturned;

  PostSaleCustomerHoldingRequest({
    this.organizationId,
    this.shopId,
    this.itemDescription,
    this.netWeight,
    this.customerId,
    this.salesRecordId,
    this.isReturned,
  });

  factory PostSaleCustomerHoldingRequest.fromRawJson(String str) =>
      PostSaleCustomerHoldingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSaleCustomerHoldingRequest.fromJson(Map<String, dynamic> json) =>
      PostSaleCustomerHoldingRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        itemDescription: json["item_description"],
        netWeight: json["net_weight"],
        customerId: json["customer_id"],
        salesRecordId: json["sales_record_id"],
        isReturned: json["is_returned"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "item_description": itemDescription,
        "net_weight": netWeight,
        "customer_id": customerId,
        "sales_record_id": salesRecordId,
        "is_returned": isReturned,
      };
}

class PostSaleJewelleryPlanRequest {
  int? duration;
  String? installments;
  String? planId;
  String? redeemableAmount;
  String? salesRecordId;
  DateTime? startDate;
  String? subscriptionId;
  String? totalWeight;
  String? type;

  PostSaleJewelleryPlanRequest({
    this.duration,
    this.installments,
    this.planId,
    this.redeemableAmount,
    this.salesRecordId,
    this.startDate,
    this.subscriptionId,
    this.totalWeight,
    this.type,
  });

  factory PostSaleJewelleryPlanRequest.fromRawJson(String str) =>
      PostSaleJewelleryPlanRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSaleJewelleryPlanRequest.fromJson(Map<String, dynamic> json) =>
      PostSaleJewelleryPlanRequest(
        duration: json["duration"],
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

class PostSaleLineItemRequest {
  String? organizationId;
  String? ornamentId;
  String? shopId;
  String? saleRecordId;
  bool? itemHandover;
  String? code;
  String? taggingId;
  String? tag;
  String? rate;
  String? description;
  String? salesPersonId;
  double? taggingPieces;
  String? taggingGrossWeight;
  String? taggingNetWeight;
  double? finalPieces;
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
  String? salesAmountWithoutRoundoff;
  String? salesAmountRoundoffDiff;
  String? totalAmount;
  String? totalAmountWithoutRoundoff;
  String? totalAmountRoundoffDiff;
  String? makingChargesType;
  double? minVa;
  double? minMc;
  String? wastageType;
  double? costDiscount;
  String? ornamentCode;
  String? ornamentName;
  String? designCode;

  PostSaleLineItemRequest({
    this.organizationId,
    this.ornamentId,
    this.shopId,
    this.saleRecordId,
    this.itemHandover,
    this.code,
    this.taggingId,
    this.tag,
    this.rate,
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
    this.salesAmountWithoutRoundoff,
    this.salesAmountRoundoffDiff,
    this.totalAmount,
    this.totalAmountWithoutRoundoff,
    this.totalAmountRoundoffDiff,
    this.makingChargesType,
    this.minVa,
    this.minMc,
    this.wastageType,
    this.costDiscount,
    this.ornamentCode,
    this.ornamentName,
    this.designCode,
  });

  factory PostSaleLineItemRequest.fromRawJson(String str) =>
      PostSaleLineItemRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSaleLineItemRequest.fromJson(Map<String, dynamic> json) =>
      PostSaleLineItemRequest(
        organizationId: json["organization_id"],
        ornamentId: json["ornament_id"],
        shopId: json["shop_id"],
        saleRecordId: json["sale_record_id"],
        itemHandover: json["item_handover"],
        code: json["code"],
        taggingId: json["tagging_id"],
        tag: json["tag"],
        rate: json["rate"],
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
        salesAmountWithoutRoundoff: json["sales_amount_without_roundoff"],
        salesAmountRoundoffDiff: json["sales_amount_roundoff_diff"],
        totalAmount: json["total_amount"],
        totalAmountWithoutRoundoff: json["total_amount_without_roundoff"],
        totalAmountRoundoffDiff: json["total_amount_roundoff_diff"],
        makingChargesType: json["making_charges_type"],
        minVa: json["min_va"],
        minMc: json["min_mc"],
        wastageType: json["wastage_type"],
        costDiscount: json["cost_discount"],
        ornamentCode: json["ornament_code"],
        ornamentName: json["ornament_name"],
        designCode: json["design_code"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "ornament_id": ornamentId,
        "shop_id": shopId,
        "sale_record_id": saleRecordId,
        "item_handover": itemHandover,
        "code": code,
        "tagging_id": taggingId,
        "tag": tag,
        "rate": rate,
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
        "sales_amount_without_roundoff": salesAmountWithoutRoundoff,
        "sales_amount_roundoff_diff": salesAmountRoundoffDiff,
        "total_amount": totalAmount,
        "total_amount_without_roundoff": totalAmountWithoutRoundoff,
        "total_amount_roundoff_diff": totalAmountRoundoffDiff,
        "making_charges_type": makingChargesType,
        "min_va": minVa,
        "min_mc": minMc,
        "wastage_type": wastageType,
        "cost_discount": costDiscount,
        "ornament_code": ornamentCode,
        "ornament_name": ornamentName,
        "design_code": designCode,
      };
}

class PostSaleOldGoldRequest {
  String? id;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  String? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? purity;
  String? metalType;
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;
  String? ornamentCode;
  String? ornamentName;
  String? va;
  String? tch;
  String? mc;
  String? stone;

  PostSaleOldGoldRequest({
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
    this.purity,
    this.metalType,
    this.ornamentId,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
    this.ornamentCode,
    this.ornamentName,
    this.va,
    this.tch,
    this.mc,
    this.stone,
  });

  factory PostSaleOldGoldRequest.fromRawJson(String str) =>
      PostSaleOldGoldRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSaleOldGoldRequest.fromJson(Map<String, dynamic> json) =>
      PostSaleOldGoldRequest(
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
        purity: json["purity"],
        metalType: json["metal_type"],
        ornamentId: json["ornament_id"],
        rate: json["rate"],
        amount: json["amount"],
        roundOff: json["round_off"],
        total: json["total"],
        isReceived: json["is_received"],
        ornamentCode: json["ornament_code"],
        ornamentName: json["ornament_name"],
        va: json["va"],
        tch: json["tch"],
        mc: json["mc"],
        stone: json["stone"],
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
        "purity": purity,
        "metal_type": metalType,
        "ornament_id": ornamentId,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
        "ornament_code": ornamentCode,
        "ornament_name": ornamentName,
        "va": va,
        "tch": tch,
        "mc": mc,
        "stone": stone,
      };
}

class PostSalePaymentDetailRequest {
  String? organizationId;
  String? subTotal;
  String? schemeDiscount;
  String? rateDiscount;
  String? salesAmount;
  String? salesAmountWithoutRoundoff;
  String? salesAmountRoundoffDiff;
  String? amount;
  String? cgst;
  String? cgstWithoutRoundoff;
  String? cgstRoundoffDiff;
  String? sgst;
  String? sgstWithoutRoundoff;
  String? sgstRoundoffDiff;
  String? igst;
  String? igstWithoutRoundoff;
  String? igstRoundoffDiff;
  String? nettGst;
  String? nettGstWithoutRoundoff;
  String? nettGstRoundoffDiff;
  String? tcs;
  String? tcsWithoutRoundoff;
  String? tcsRoundoffDiff;
  String? tds;
  String? tdsWithoutRoundoff;
  String? tdsRoundoffDiff;
  String? nettTdsTcs;
  String? nettTdsTcsWithoutRoundoff;
  String? nettTdsTcsRoundoffDiff;
  String? purchaseOldGold;
  String? advance;
  String? roundOff;
  String? bankCharges;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? finalAmountWithoutRoundoff;
  String? finalAmountRoundoffDiff;
  String? salesRecordId;
  List<PostSalePaymentMethodDetailRequest>? paymentMethodDetails;
  double? advance_booking_amount;
  double? jewellery_plan_base_amount;
  double? order_amount_used;

  PostSalePaymentDetailRequest({
    this.organizationId,
    this.subTotal,
    this.schemeDiscount,
    this.rateDiscount,
    this.salesAmount,
    this.salesAmountWithoutRoundoff,
    this.salesAmountRoundoffDiff,
    this.amount,
    this.cgst,
    this.cgstWithoutRoundoff,
    this.cgstRoundoffDiff,
    this.sgst,
    this.sgstWithoutRoundoff,
    this.sgstRoundoffDiff,
    this.igst,
    this.igstWithoutRoundoff,
    this.igstRoundoffDiff,
    this.nettGst,
    this.nettGstWithoutRoundoff,
    this.nettGstRoundoffDiff,
    this.tcs,
    this.tcsWithoutRoundoff,
    this.tcsRoundoffDiff,
    this.tds,
    this.tdsWithoutRoundoff,
    this.tdsRoundoffDiff,
    this.nettTdsTcs,
    this.nettTdsTcsWithoutRoundoff,
    this.nettTdsTcsRoundoffDiff,
    this.purchaseOldGold,
    this.advance,
    this.roundOff,
    this.bankCharges,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.finalAmountWithoutRoundoff,
    this.finalAmountRoundoffDiff,
    this.salesRecordId,
    this.paymentMethodDetails,
    this.advance_booking_amount,
    this.jewellery_plan_base_amount,
    this.order_amount_used,
  });

  factory PostSalePaymentDetailRequest.fromRawJson(String str) =>
      PostSalePaymentDetailRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSalePaymentDetailRequest.fromJson(Map<String, dynamic> json) =>
      PostSalePaymentDetailRequest(
        organizationId: json["organization_id"],
        subTotal: json["sub_total"],
        schemeDiscount: json["scheme_discount"],
        rateDiscount: json["rate_discount"],
        salesAmount: json["sales_amount"],
        salesAmountWithoutRoundoff: json["sales_amount_without_roundoff"],
        salesAmountRoundoffDiff: json["sales_amount_roundoff_diff"],
        amount: json["amount"],
        cgst: json["cgst"],
        cgstWithoutRoundoff: json["cgst_without_roundoff"],
        cgstRoundoffDiff: json["cgst_roundoff_diff"],
        sgst: json["sgst"],
        sgstWithoutRoundoff: json["sgst_without_roundoff"],
        sgstRoundoffDiff: json["sgst_roundoff_diff"],
        igst: json["igst"],
        igstWithoutRoundoff: json["igst_without_roundoff"],
        igstRoundoffDiff: json["igst_roundoff_diff"],
        nettGst: json["nett_gst"],
        nettGstWithoutRoundoff: json["nett_gst_without_roundoff"],
        nettGstRoundoffDiff: json["nett_gst_roundoff_diff"],
        tcs: json["tcs"],
        tcsWithoutRoundoff: json["tcs_without_roundoff"],
        tcsRoundoffDiff: json["tcs_roundoff_diff"],
        tds: json["tds"],
        tdsWithoutRoundoff: json["tds_without_roundoff"],
        tdsRoundoffDiff: json["tds_roundoff_diff"],
        nettTdsTcs: json["nett_tds_tcs"],
        nettTdsTcsWithoutRoundoff: json["nett_tds_tcs_without_roundoff"],
        nettTdsTcsRoundoffDiff: json["nett_tds_tcs_roundoff_diff"],
        purchaseOldGold: json["purchase_old_gold"],
        advance: json["advance"],
        roundOff: json["round_off"],
        bankCharges: json["bank_charges"],
        receivedAmount: json["received_amount"],
        balanceAmount: json["balance_amount"],
        finalAmount: json["final_amount"],
        finalAmountWithoutRoundoff: json["final_amount_without_roundoff"],
        finalAmountRoundoffDiff: json["final_amount_roundoff_diff"],
        salesRecordId: json["sales_record_id"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<PostSalePaymentMethodDetailRequest>.from(
                json["payment_method_details"]!.map(
                    (x) => PostSalePaymentMethodDetailRequest.fromJson(x))),
        advance_booking_amount: json["advance_booking_amount"],
        jewellery_plan_base_amount: json["jewellery_plan_base_amount"],
        order_amount_used: json["order_amount_used"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "sub_total": subTotal,
        "scheme_discount": schemeDiscount,
        "rate_discount": rateDiscount,
        "sales_amount": salesAmount,
        "sales_amount_without_roundoff": salesAmountWithoutRoundoff,
        "sales_amount_roundoff_diff": salesAmountRoundoffDiff,
        "amount": amount,
        "cgst": cgst,
        "cgst_without_roundoff": cgstWithoutRoundoff,
        "cgst_roundoff_diff": cgstRoundoffDiff,
        "sgst": sgst,
        "sgst_without_roundoff": sgstWithoutRoundoff,
        "sgst_roundoff_diff": sgstRoundoffDiff,
        "igst": igst,
        "igst_without_roundoff": igstWithoutRoundoff,
        "igst_roundoff_diff": igstRoundoffDiff,
        "nett_gst": nettGst,
        "nett_gst_without_roundoff": nettGstWithoutRoundoff,
        "nett_gst_roundoff_diff": nettGstRoundoffDiff,
        "tcs": tcs,
        "tcs_without_roundoff": tcsWithoutRoundoff,
        "tcs_roundoff_diff": tcsRoundoffDiff,
        "tds": tds,
        "tds_without_roundoff": tdsWithoutRoundoff,
        "tds_roundoff_diff": tdsRoundoffDiff,
        "nett_tds_tcs": nettTdsTcs,
        "nett_tds_tcs_without_roundoff": nettTdsTcsWithoutRoundoff,
        "nett_tds_tcs_roundoff_diff": nettTdsTcsRoundoffDiff,
        "purchase_old_gold": purchaseOldGold,
        "advance": advance,
        "round_off": roundOff,
        "bank_charges": bankCharges,
        "received_amount": receivedAmount,
        "balance_amount": balanceAmount,
        "final_amount": finalAmount,
        "final_amount_without_roundoff": finalAmountWithoutRoundoff,
        "final_amount_roundoff_diff": finalAmountRoundoffDiff,
        "sales_record_id": salesRecordId,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
        "advance_booking_amount": advance_booking_amount,
        "jewellery_plan_base_amount": jewellery_plan_base_amount,
        "order_amount_used": order_amount_used,
      };
}

class PostSalePaymentMethodDetailRequest {
  String? organizationId;
  String? amount;
  String? method;
  DateTime? date;
  String? pos;
  String? paymentCode;
  String? salesPaymentDetailsId;
  String? posAccountId;
  String? salesReturnId;
  bool? isCompleted;

  PostSalePaymentMethodDetailRequest({
    this.organizationId,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.salesPaymentDetailsId,
    this.posAccountId,
    this.salesReturnId,
    this.isCompleted,
  });

  factory PostSalePaymentMethodDetailRequest.fromRawJson(String str) =>
      PostSalePaymentMethodDetailRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSalePaymentMethodDetailRequest.fromJson(
          Map<String, dynamic> json) =>
      PostSalePaymentMethodDetailRequest(
        organizationId: json["organization_id"],
        amount: json["amount"],
        method: json["method"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        pos: json["pos"],
        paymentCode: json["payment_code"],
        salesPaymentDetailsId: json["sales_payment_details_id"],
        posAccountId: json["pos_account_id"],
        salesReturnId: json["sales_return_id"],
        isCompleted: json["is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "amount": amount,
        "method": method,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "pos": pos,
        "payment_code": paymentCode,
        "sales_payment_details_id": salesPaymentDetailsId,
        "pos_account_id": posAccountId,
        "sales_return_id": salesReturnId,
        "is_completed": isCompleted,
      };
}
