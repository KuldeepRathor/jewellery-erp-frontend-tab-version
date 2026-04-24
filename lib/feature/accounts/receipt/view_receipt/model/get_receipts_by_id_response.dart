import 'dart:convert';

class GetReceiptsByIdResponse {
  String? id;
  String? paymentReceiptNumber;
  String? partyId;
  String? partyType;
  String? partyName;
  PartyDetails? partyDetails;
  DateTime? date;
  String? amount;
  String? roundOff;
  String? bankCharges;
  String? total;
  String? tcs;
  String? tds;
  String? nett;
  List<LineItem>? lineItems;

  GetReceiptsByIdResponse({
    this.id,
    this.paymentReceiptNumber,
    this.partyId,
    this.partyType,
    this.partyName,
    this.partyDetails,
    this.date,
    this.amount,
    this.roundOff,
    this.bankCharges,
    this.total,
    this.tcs,
    this.tds,
    this.nett,
    this.lineItems,
  });

  factory GetReceiptsByIdResponse.fromRawJson(String str) =>
      GetReceiptsByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReceiptsByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetReceiptsByIdResponse(
        id: json["id"],
        paymentReceiptNumber: json["payment_receipt_number"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        partyDetails: json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        roundOff: json["round_off"],
        bankCharges: json["bank_charges"],
        total: json["total"],
        tcs: json["tcs"],
        tds: json["tds"],
        nett: json["nett"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_receipt_number": paymentReceiptNumber,
        "party_id": partyId,
        "party_type": partyType,
        "party_name": partyName,
        "party_details": partyDetails?.toJson(),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "round_off": roundOff,
        "bank_charges": bankCharges,
        "total": total,
        "tcs": tcs,
        "tds": tds,
        "nett": nett,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? id;
  dynamic partyName;
  String? paymentReceiptNumber;
  String? amount;
  String? method;
  String? transactionType;
  String? transactionCode;
  String? invoiceNumber;
  String? invoiceType;
  String? remarks;

  LineItem({
    this.id,
    this.partyName,
    this.paymentReceiptNumber,
    this.amount,
    this.method,
    this.transactionType,
    this.transactionCode,
    this.invoiceNumber,
    this.invoiceType,
    this.remarks,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        partyName: json["party_name"],
        paymentReceiptNumber: json["payment_receipt_number"],
        amount: json["amount"],
        method: json["method"],
        transactionType: json["transaction_type"],
        transactionCode: json["transaction_code"],
        invoiceNumber: json["invoice_number"],
        invoiceType: json["invoice_type"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "party_name": partyName,
        "payment_receipt_number": paymentReceiptNumber,
        "amount": amount,
        "method": method,
        "transaction_type": transactionType,
        "transaction_code": transactionCode,
        "invoice_number": invoiceNumber,
        "invoice_type": invoiceType,
        "remarks": remarks,
      };
}

class PartyDetails {
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

  PartyDetails({
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

  factory PartyDetails.fromRawJson(String str) =>
      PartyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PartyDetails.fromJson(Map<String, dynamic> json) => PartyDetails(
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
