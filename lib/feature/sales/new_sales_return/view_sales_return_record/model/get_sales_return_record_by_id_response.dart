import 'dart:convert';

class GetSalesReturnRecordByIdResponse {
  DateTime? createdAt;
  String? id;
  String? partyId;
  String? partyType;
  String? saleReturnNumber;
  SaleRecord? saleRecord;
  String? remarks;
  dynamic additionalLess;
  PartyDetails? partyDetails;
  List<GetSalesReturnRecordByIdResponseLineItem>? lineItems;
  List<GetSalesReturnRecordByIdResponsePaymentDetail>? paymentDetails;

  GetSalesReturnRecordByIdResponse({
    this.createdAt,
    this.id,
    this.partyId,
    this.partyType,
    this.saleReturnNumber,
    this.saleRecord,
    this.remarks,
    this.additionalLess,
    this.partyDetails,
    this.lineItems,
    this.paymentDetails,
  });

  factory GetSalesReturnRecordByIdResponse.fromRawJson(String str) =>
      GetSalesReturnRecordByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnRecordByIdResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReturnRecordByIdResponse(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        saleReturnNumber: json["sale_return_number"],
        saleRecord: json["sale_record"] == null
            ? null
            : SaleRecord.fromJson(json["sale_record"]),
        remarks: json["remarks"],
        additionalLess: json["additional_less"],
        partyDetails: json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
        lineItems: json["line_items"] == null
            ? []
            : List<GetSalesReturnRecordByIdResponseLineItem>.from(
                json["line_items"]!.map((x) =>
                    GetSalesReturnRecordByIdResponseLineItem.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<GetSalesReturnRecordByIdResponsePaymentDetail>.from(
                json["payment_details"]!.map((x) =>
                    GetSalesReturnRecordByIdResponsePaymentDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "party_id": partyId,
        "party_type": partyType,
        "sale_return_number": saleReturnNumber,
        "sale_record": saleRecord?.toJson(),
        "remarks": remarks,
        "additional_less": additionalLess,
        "party_details": partyDetails?.toJson(),
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      };
}

class GetSalesReturnRecordByIdResponseLineItem {
  String? id;
  String? ornamentId;
  String? saleReturnRecordId;
  String? saleLineItemId;
  String? code;
  String? taggingId;
  String? tag;
  String? description;
  String? salesPersonId;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? taggingVa;
  String? finalVa;
  String? taggingMc;
  String? finalMc;
  String? stoneCost;
  String? hallMark;
  String? discount;
  String? salesAmount;
  String? totalAmount;

  GetSalesReturnRecordByIdResponseLineItem({
    this.id,
    this.ornamentId,
    this.saleReturnRecordId,
    this.saleLineItemId,
    this.code,
    this.taggingId,
    this.tag,
    this.description,
    this.salesPersonId,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.taggingVa,
    this.finalVa,
    this.taggingMc,
    this.finalMc,
    this.stoneCost,
    this.hallMark,
    this.discount,
    this.salesAmount,
    this.totalAmount,
  });

  factory GetSalesReturnRecordByIdResponseLineItem.fromRawJson(String str) =>
      GetSalesReturnRecordByIdResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnRecordByIdResponseLineItem.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReturnRecordByIdResponseLineItem(
        id: json["id"],
        ornamentId: json["ornament_id"],
        saleReturnRecordId: json["sale_return_record_id"],
        saleLineItemId: json["sale_line_item_id"],
        code: json["code"],
        taggingId: json["tagging_id"],
        tag: json["tag"],
        description: json["description"],
        salesPersonId: json["sales_person_id"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        taggingVa: json["tagging_va"],
        finalVa: json["final_va"],
        taggingMc: json["tagging_mc"],
        finalMc: json["final_mc"],
        stoneCost: json["stone_cost"],
        hallMark: json["hall_mark"],
        discount: json["discount"],
        salesAmount: json["sales_amount"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ornament_id": ornamentId,
        "sale_return_record_id": saleReturnRecordId,
        "sale_line_item_id": saleLineItemId,
        "code": code,
        "tagging_id": taggingId,
        "tag": tag,
        "description": description,
        "sales_person_id": salesPersonId,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "tagging_va": taggingVa,
        "final_va": finalVa,
        "tagging_mc": taggingMc,
        "final_mc": finalMc,
        "stone_cost": stoneCost,
        "hall_mark": hallMark,
        "discount": discount,
        "sales_amount": salesAmount,
        "total_amount": totalAmount,
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
  String? email;

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
  String? firstName;
  String? lastName;
  String? country;
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
  dynamic parentGroup;

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
        parentGroup: json["parent_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "is_mandatory": isMandatory,
        "group_type": groupType,
        "parent_group": parentGroup,
      };
}

class GetSalesReturnRecordByIdResponsePaymentDetail {
  String? id;
  bool? isConsumed;
  String? balance;
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
  String? tds;
  String? nettTdsTcs;
  String? purchaseOldGold;
  String? advance;
  String? roundOff;
  String? bankCharges;
  String? finalAmount;
  String? saleReturnRecordId;
  List<PurplePaymentMethodDetail>? paymentMethodDetails;

  GetSalesReturnRecordByIdResponsePaymentDetail({
    this.id,
    this.isConsumed,
    this.balance,
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
    this.finalAmount,
    this.saleReturnRecordId,
    this.paymentMethodDetails,
  });

  factory GetSalesReturnRecordByIdResponsePaymentDetail.fromRawJson(
          String str) =>
      GetSalesReturnRecordByIdResponsePaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnRecordByIdResponsePaymentDetail.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReturnRecordByIdResponsePaymentDetail(
        id: json["id"],
        isConsumed: json["is_consumed"],
        balance: json["balance"],
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
        finalAmount: json["final_amount"],
        saleReturnRecordId: json["sale_return_record_id"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<PurplePaymentMethodDetail>.from(
                json["payment_method_details"]!
                    .map((x) => PurplePaymentMethodDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_consumed": isConsumed,
        "balance": balance,
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
        "final_amount": finalAmount,
        "sale_return_record_id": saleReturnRecordId,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
      };
}

class PurplePaymentMethodDetail {
  String? id;
  String? amount;
  String? method;
  DateTime? date;
  dynamic pos;
  String? paymentCode;
  String? universalPaymentCode;
  dynamic salesPaymentDetailsId;
  String? adjustInvoiceType;
  String? adjustInvoiceId;
  String? adjustInvoiceNumber;

  PurplePaymentMethodDetail({
    this.id,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.universalPaymentCode,
    this.salesPaymentDetailsId,
    this.adjustInvoiceType,
    this.adjustInvoiceId,
    this.adjustInvoiceNumber,
  });

  factory PurplePaymentMethodDetail.fromRawJson(String str) =>
      PurplePaymentMethodDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurplePaymentMethodDetail.fromJson(Map<String, dynamic> json) =>
      PurplePaymentMethodDetail(
        id: json["id"],
        amount: json["amount"],
        method: json["method"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        pos: json["pos"],
        paymentCode: json["payment_code"],
        universalPaymentCode: json["universal_payment_code"],
        salesPaymentDetailsId: json["sales_payment_details_id"],
        adjustInvoiceType: json["adjust_invoice_type"],
        adjustInvoiceId: json["adjust_invoice_id"],
        adjustInvoiceNumber: json["adjust_invoice_number"],
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
        "adjust_invoice_type": adjustInvoiceType,
        "adjust_invoice_id": adjustInvoiceId,
        "adjust_invoice_number": adjustInvoiceNumber,
      };
}

class SaleRecord {
  bool? isCancelled;
  bool? inStoreSale;
  String? stateName;
  String? stateCode;
  bool? completeHandover;
  DateTime? createdAt;
  String? id;
  String? partyId;
  String? partyType;
  dynamic partyDetails;
  String? refernceInvoiceNumber;
  String? saleNumber;
  String? remarks;
  String? paymentStatus;
  dynamic jewellerDiscount;
  List<SaleRecordLineItem>? lineItems;
  List<dynamic>? advanceBookingDetails;
  List<dynamic>? jewelleryPlans;
  List<dynamic>? oldGolds;
  List<SaleRecordPaymentDetail>? paymentDetails;
  List<dynamic>? customerHoldings;
  dynamic orderId;
  dynamic digitalCoinCommodity;
  dynamic digitalCoinWeight;
  dynamic digitalCoinPhoneNumber;
  dynamic digitalCoinAmount;
  dynamic additionalLess;
  dynamic purchaseInvoiceNumber;

  SaleRecord({
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

  factory SaleRecord.fromRawJson(String str) =>
      SaleRecord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleRecord.fromJson(Map<String, dynamic> json) => SaleRecord(
        isCancelled: json["is_cancelled"],
        inStoreSale: json["in_store_sale"],
        stateName: json["state_name"],
        stateCode: json["state_code"],
        completeHandover: json["complete_handover"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyDetails: json["party_details"],
        refernceInvoiceNumber: json["refernce_invoice_number"],
        saleNumber: json["sale_number"],
        remarks: json["remarks"],
        paymentStatus: json["payment_status"],
        jewellerDiscount: json["jeweller_discount"],
        lineItems: json["line_items"] == null
            ? []
            : List<SaleRecordLineItem>.from(
                json["line_items"]!.map((x) => SaleRecordLineItem.fromJson(x))),
        advanceBookingDetails: json["advance_booking_details"] == null
            ? []
            : List<dynamic>.from(
                json["advance_booking_details"]!.map((x) => x)),
        jewelleryPlans: json["jewellery_plans"] == null
            ? []
            : List<dynamic>.from(json["jewellery_plans"]!.map((x) => x)),
        oldGolds: json["old_golds"] == null
            ? []
            : List<dynamic>.from(json["old_golds"]!.map((x) => x)),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<SaleRecordPaymentDetail>.from(json["payment_details"]!
                .map((x) => SaleRecordPaymentDetail.fromJson(x))),
        customerHoldings: json["customer_holdings"] == null
            ? []
            : List<dynamic>.from(json["customer_holdings"]!.map((x) => x)),
        orderId: json["order_id"],
        digitalCoinCommodity: json["digital_coin_commodity"],
        digitalCoinWeight: json["digital_coin_weight"],
        digitalCoinPhoneNumber: json["digital_coin_phone_number"],
        digitalCoinAmount: json["digital_coin_amount"],
        additionalLess: json["additional_less"],
        purchaseInvoiceNumber: json["purchase_invoice_number"],
      );

  Map<String, dynamic> toJson() => {
        "is_cancelled": isCancelled,
        "in_store_sale": inStoreSale,
        "state_name": stateName,
        "state_code": stateCode,
        "complete_handover": completeHandover,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "party_id": partyId,
        "party_type": partyType,
        "party_details": partyDetails,
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
        "old_golds":
            oldGolds == null ? [] : List<dynamic>.from(oldGolds!.map((x) => x)),
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

class SaleRecordLineItem {
  String? id;
  String? ornamentId;
  String? saleRecordId;
  dynamic taggingRecord;
  String? code;
  String? taggingId;
  String? rate;
  String? tag;
  String? description;
  String? salesPersonId;
  dynamic salesPerson;
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
  dynamic makingChargeAmount;
  dynamic minVa;
  dynamic minMc;
  String? wastageType;
  dynamic costDiscount;

  SaleRecordLineItem({
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

  factory SaleRecordLineItem.fromRawJson(String str) =>
      SaleRecordLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleRecordLineItem.fromJson(Map<String, dynamic> json) =>
      SaleRecordLineItem(
        id: json["id"],
        ornamentId: json["ornament_id"],
        saleRecordId: json["sale_record_id"],
        taggingRecord: json["tagging_record"],
        code: json["code"],
        taggingId: json["tagging_id"],
        rate: json["rate"],
        tag: json["tag"],
        description: json["description"],
        salesPersonId: json["sales_person_id"],
        salesPerson: json["sales_person"],
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
        makingChargeAmount: json["making_charge_amount"],
        minVa: json["min_va"],
        minMc: json["min_mc"],
        wastageType: json["wastage_type"],
        costDiscount: json["cost_discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ornament_id": ornamentId,
        "sale_record_id": saleRecordId,
        "tagging_record": taggingRecord,
        "code": code,
        "tagging_id": taggingId,
        "rate": rate,
        "tag": tag,
        "description": description,
        "sales_person_id": salesPersonId,
        "sales_person": salesPerson,
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

class SaleRecordPaymentDetail {
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
  List<FluffyPaymentMethodDetail>? paymentMethodDetails;
  dynamic advanceBookingAmount;
  dynamic jewelleryPlanBaseAmount;

  SaleRecordPaymentDetail({
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

  factory SaleRecordPaymentDetail.fromRawJson(String str) =>
      SaleRecordPaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleRecordPaymentDetail.fromJson(Map<String, dynamic> json) =>
      SaleRecordPaymentDetail(
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
            : List<FluffyPaymentMethodDetail>.from(
                json["payment_method_details"]!
                    .map((x) => FluffyPaymentMethodDetail.fromJson(x))),
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
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
        "advance_booking_amount": advanceBookingAmount,
        "jewellery_plan_base_amount": jewelleryPlanBaseAmount,
      };
}

class FluffyPaymentMethodDetail {
  String? id;
  String? amount;
  String? method;
  DateTime? date;
  dynamic pos;
  String? paymentCode;
  String? universalPaymentCode;
  String? salesPaymentDetailsId;

  FluffyPaymentMethodDetail({
    this.id,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.universalPaymentCode,
    this.salesPaymentDetailsId,
  });

  factory FluffyPaymentMethodDetail.fromRawJson(String str) =>
      FluffyPaymentMethodDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyPaymentMethodDetail.fromJson(Map<String, dynamic> json) =>
      FluffyPaymentMethodDetail(
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
