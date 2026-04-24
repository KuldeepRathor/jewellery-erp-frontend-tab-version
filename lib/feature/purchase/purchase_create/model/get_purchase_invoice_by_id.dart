import 'dart:convert';

class GetPurchaseInvoiceById {
  String? id;
  String? organizationId;
  String? shopId;
  String? partyType;
  String? partyId;
  String? partyName;
  String? partyCode;
  String? partyAddress;
  String? partyPhoneNumber;
  String? partyGst;
  PartyDetails? partyDetails;
  String? invoiceNumber;
  String? partyInvoiceNumber;
  DateTime? invoiceCreateDate;
  DateTime? invoiceReceiveDate;
  dynamic remark;
  List<GetPurchaseInvoiceByIdPaymentDetail>? paymentDetails;
  List<GetPurchaseInvoiceByIdLineItem>? lineItems;

  String? saleId;
  String? saleInvoiceNumber;

  GetPurchaseInvoiceById({
    this.id,
    this.organizationId,
    this.shopId,
    this.partyType,
    this.partyId,
    this.partyName,
    this.partyCode,
    this.partyAddress,
    this.partyPhoneNumber,
    this.partyGst,
    this.partyDetails,
    this.invoiceNumber,
    this.partyInvoiceNumber,
    this.invoiceCreateDate,
    this.invoiceReceiveDate,
    this.remark,
    this.paymentDetails,
    this.lineItems,
    this.saleId,
    this.saleInvoiceNumber,
  });

  factory GetPurchaseInvoiceById.fromRawJson(String str) =>
      GetPurchaseInvoiceById.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseInvoiceById.fromJson(Map<String, dynamic> json) =>
      GetPurchaseInvoiceById(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyCode: json["party_code"],
        partyAddress: json["party_address"],
        partyPhoneNumber: json["party_phone_number"],
        partyGst: json["party_gst"],
        partyDetails: json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
        invoiceNumber: json["invoice_number"],
        partyInvoiceNumber: json["party_invoice_number"],
        invoiceCreateDate: json["invoice_create_date"] == null
            ? null
            : DateTime.parse(json["invoice_create_date"]),
        invoiceReceiveDate: json["invoice_receive_date"] == null
            ? null
            : DateTime.parse(json["invoice_receive_date"]),
        remark: json["remark"],
        paymentDetails: json["payment_details"] == null
            ? []
            : List<GetPurchaseInvoiceByIdPaymentDetail>.from(
                json["payment_details"]!.map(
                    (x) => GetPurchaseInvoiceByIdPaymentDetail.fromJson(x))),
        lineItems: json["line_items"] == null
            ? []
            : List<GetPurchaseInvoiceByIdLineItem>.from(json["line_items"]!
                .map((x) => GetPurchaseInvoiceByIdLineItem.fromJson(x))),
        saleId: json["sale_id"],
        saleInvoiceNumber: json["sale_invoice_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "party_type": partyType,
        "party_id": partyId,
        "party_name": partyName,
        "party_code": partyCode,
        "party_address": partyAddress,
        "party_phone_number": partyPhoneNumber,
        "party_gst": partyGst,
        "party_details": partyDetails?.toJson(),
        "invoice_number": invoiceNumber,
        "party_invoice_number": partyInvoiceNumber,
        "invoice_create_date": invoiceCreateDate?.toIso8601String(),
        "invoice_receive_date": invoiceReceiveDate?.toIso8601String(),
        "remark": remark,
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "sale_id": saleId,
        "sale_invoice_number": saleInvoiceNumber,
      };
}

class GetPurchaseInvoiceByIdLineItem {
  String? id;
  String? organizationId;
  String? shopId;
  String? ornamentId;
  String? code;
  String? itemDescription;
  int? pieces;
  String? grossWeight;
  String? less;
  String? netWeight;
  String? va;
  dynamic tch;
  String? mc;
  String? stone;
  String? rate;
  String? amount;
  String? purchaseInvoiceId;
  List<dynamic>? lineStones;

  GetPurchaseInvoiceByIdLineItem({
    this.id,
    this.organizationId,
    this.shopId,
    this.ornamentId,
    this.code,
    this.itemDescription,
    this.pieces,
    this.grossWeight,
    this.less,
    this.netWeight,
    this.va,
    this.tch,
    this.mc,
    this.stone,
    this.rate,
    this.amount,
    this.purchaseInvoiceId,
    this.lineStones,
  });

  factory GetPurchaseInvoiceByIdLineItem.fromRawJson(String str) =>
      GetPurchaseInvoiceByIdLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseInvoiceByIdLineItem.fromJson(Map<String, dynamic> json) =>
      GetPurchaseInvoiceByIdLineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        ornamentId: json["ornament_id"],
        code: json["code"],
        itemDescription: json["item_description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        less: json["less"],
        netWeight: json["net_weight"],
        va: json["va"],
        tch: json["tch"],
        mc: json["mc"],
        stone: json["stone"],
        rate: json["rate"],
        amount: json["amount"],
        purchaseInvoiceId: json["purchase_invoice_id"],
        lineStones: json["line_stones"] == null
            ? []
            : List<dynamic>.from(json["line_stones"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "ornament_id": ornamentId,
        "code": code,
        "item_description": itemDescription,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "less": less,
        "net_weight": netWeight,
        "va": va,
        "tch": tch,
        "mc": mc,
        "stone": stone,
        "rate": rate,
        "amount": amount,
        "purchase_invoice_id": purchaseInvoiceId,
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x)),
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

class GetPurchaseInvoiceByIdPaymentDetail {
  String? id;
  String? organizationId;
  String? purchaseInvoiceId;
  String? subTotal;
  String? nett;
  dynamic cgst;
  dynamic sgst;
  dynamic igst;
  String? roundOff;
  String? total;
  dynamic tcs;
  String? tds;
  String? paidAmount;
  String? balanceAmount;
  List<dynamic>? paymentMethodDetails;

  GetPurchaseInvoiceByIdPaymentDetail({
    this.id,
    this.organizationId,
    this.purchaseInvoiceId,
    this.subTotal,
    this.nett,
    this.cgst,
    this.sgst,
    this.igst,
    this.roundOff,
    this.total,
    this.tcs,
    this.tds,
    this.paidAmount,
    this.balanceAmount,
    this.paymentMethodDetails,
  });

  factory GetPurchaseInvoiceByIdPaymentDetail.fromRawJson(String str) =>
      GetPurchaseInvoiceByIdPaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseInvoiceByIdPaymentDetail.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseInvoiceByIdPaymentDetail(
        id: json["id"],
        organizationId: json["organization_id"],
        purchaseInvoiceId: json["purchase_invoice_id"],
        subTotal: json["sub_total"],
        nett: json["nett"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        roundOff: json["round_off"],
        total: json["total"],
        tcs: json["tcs"],
        tds: json["tds"],
        paidAmount: json["paid_amount"],
        balanceAmount: json["balance_amount"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<dynamic>.from(json["payment_method_details"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "purchase_invoice_id": purchaseInvoiceId,
        "sub_total": subTotal,
        "nett": nett,
        "cgst": cgst,
        "sgst": sgst,
        "igst": igst,
        "round_off": roundOff,
        "total": total,
        "tcs": tcs,
        "tds": tds,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x)),
      };
}
