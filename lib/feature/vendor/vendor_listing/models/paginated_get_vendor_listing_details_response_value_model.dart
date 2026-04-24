import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_ledger_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';

class PaginatedGetVendorListingDetailsResponseValue {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? panNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  List<dynamic>? bankDetails;
  List<VendorType>? vendorTypes;
  List<LedgerItem>? ledgerItems;
  List<Address>? address;

  PaginatedGetVendorListingDetailsResponseValue({
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
    this.address,
  });

  factory PaginatedGetVendorListingDetailsResponseValue.fromRawJson(
    String str,
  ) => PaginatedGetVendorListingDetailsResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedGetVendorListingDetailsResponseValue.fromJson(
    Map<String, dynamic> json,
  ) => PaginatedGetVendorListingDetailsResponseValue(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    organizationId: json["organization_id"],
    panNumber: json["pan_number"],
    gstNumber: json["gst_number"],
    deductionType: json["deduction_type"],
    deductionPercent: json["deduction_percent"],
    bankDetails:
        json["bank_details"] == null
            ? []
            : List<dynamic>.from(json["bank_details"]!.map((x) => x)),
    vendorTypes:
        json["vendor_types"] == null
            ? []
            : List<VendorType>.from(
              json["vendor_types"]!.map((x) => VendorType.fromJson(x)),
            ),
    ledgerItems:
        json["ledger_items"] == null
            ? []
            : List<LedgerItem>.from(
              json["ledger_items"]!.map((x) => LedgerItem.fromJson(x)),
            ),
    address:
        json["address"] == null
            ? []
            : List<Address>.from(
              json["address"]!.map((x) => Address.fromJson(x)),
            ),
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
    "bank_details":
        bankDetails == null
            ? []
            : List<dynamic>.from(bankDetails!.map((x) => x)),
    "vendor_types":
        vendorTypes == null
            ? []
            : List<dynamic>.from(vendorTypes!.map((x) => x.toJson())),
    "ledger_items":
        ledgerItems == null
            ? []
            : List<dynamic>.from(ledgerItems!.map((x) => x.toJson())),
    "address":
        address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
  };
}

class Address {
  String? id;
  String? organizationId;
  String? type;
  dynamic gstNumber;
  dynamic phoneNumber;
  dynamic phoneCountryCode;
  dynamic firstName;
  dynamic lastName;
  dynamic country;
  dynamic state;
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
