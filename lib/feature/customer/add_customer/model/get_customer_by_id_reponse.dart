import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';

class GetCustomerByIdResponse {
  String? id;
  String? syncId;
  String? readableId;
  String? phoneNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  AccountMapping? ledger;
  List<Nominee>? nominees;
  List<Address>? address;

  String? phoneCountryCode;

  String? aadhaarNumber;

  String? signUpSource;
  String? email;
  bool? isAadhaarVerified;
  bool? isPanVerified;
  bool? isAadhaarOnlineVerified;
  bool? isPanOnlineVerified;
  bool? isForcedKycAadhaar;
  bool? isForcedKycPan;

  GetCustomerByIdResponse({
    this.id,
    this.syncId,
    this.readableId,
    this.phoneNumber,
    this.name,
    this.dateOfBirth,
    this.panNumber,
    this.gstNumber,
    this.deductionType,
    this.deductionPercent,
    this.organizationId,
    this.addressUuid,
    this.gender,
    this.ledger,
    this.nominees,
    this.address,
    this.phoneCountryCode,
    this.aadhaarNumber,
    this.signUpSource,
    this.email,
    this.isAadhaarVerified,
    this.isPanVerified,
    this.isAadhaarOnlineVerified,
    this.isPanOnlineVerified,
    this.isForcedKycAadhaar,
    this.isForcedKycPan,
  });

  factory GetCustomerByIdResponse.fromRawJson(String str) =>
      GetCustomerByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCustomerByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetCustomerByIdResponse(
        id: json["id"],
        syncId: json["sync_id"],
        readableId: json["readable_id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        dateOfBirth:
            json["date_of_birth"] == null
                ? null
                : DateTime.parse(json["date_of_birth"]),
        panNumber: json["pan_number"],
        gstNumber: json["gst_number"],
        deductionType: json["deduction_type"],
        deductionPercent: json["deduction_percent"],
        organizationId: json["organization_id"],
        addressUuid: json["address_uuid"],
        gender: json["gender"],
        ledger:
            json["ledger"] == null
                ? null
                : AccountMapping.fromJson(json["ledger"]),
        nominees:
            json["nominees"] == null
                ? []
                : List<Nominee>.from(
                  json["nominees"]!.map((x) => Nominee.fromJson(x)),
                ),
        address:
            json["address"] == null
                ? []
                : List<Address>.from(
                  json["address"]!.map((x) => Address.fromJson(x)),
                ),
        phoneCountryCode: json["phone_country_code"],
        aadhaarNumber: json["aadhaar_number"],
        signUpSource: json["sign_up_source"],
        email: json["email"],
        isAadhaarVerified: json["is_aadhaar_verified"],
        isPanVerified: json["is_pan_verified"],
        isAadhaarOnlineVerified: json["is_aadhaar_online_verified"],
        isPanOnlineVerified: json["is_pan_online_verified"],
        isForcedKycAadhaar: json["is_forced_kyc_aadhaar"],
        isForcedKycPan: json["is_forced_kyc_pan"],
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
    "gst_number": gstNumber,
    "deduction_type": deductionType,
    "deduction_percent": deductionPercent,
    "organization_id": organizationId,
    "address_uuid": addressUuid,
    "gender": gender,
    "ledger": ledger?.toJson(),
    "nominees":
        nominees == null
            ? []
            : List<dynamic>.from(nominees!.map((x) => x.toJson())),
    "address":
        address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
    "phone_country_code": phoneCountryCode,
    "aadhaar_number": aadhaarNumber,
    "sign_up_source": signUpSource,
    "email": email,
    "is_aadhaar_verified": isAadhaarVerified,
    "is_pan_verified": isPanVerified,
    "is_aadhaar_online_verified": isAadhaarOnlineVerified,
    "is_pan_online_verified": isPanOnlineVerified,
    "is_forced_kyc_aadhaar": isForcedKycAadhaar,
    "is_forced_kyc_pan": isForcedKycPan,
  };
}

class Nominee {
  String? id;
  dynamic organizationId;
  dynamic syncId;
  Customer? customer;
  String? name;
  String? countryCode;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? relation;

  Nominee({
    this.id,
    this.organizationId,
    this.syncId,
    this.customer,
    this.name,
    this.countryCode,
    this.phoneNumber,
    this.dateOfBirth,
    this.relation,
  });

  factory Nominee.fromRawJson(String str) => Nominee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Nominee.fromJson(Map<String, dynamic> json) => Nominee(
    id: json["id"],
    organizationId: json["organization_id"],
    syncId: json["sync_id"],
    customer:
        json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    name: json["name"],
    countryCode: json["country_code"],
    phoneNumber: json["phone_number"],
    dateOfBirth:
        json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
    relation: json["relation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "sync_id": syncId,
    "customer": customer?.toJson(),
    "name": name,
    "country_code": countryCode,
    "phone_number": phoneNumber,
    "date_of_birth":
        "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "relation": relation,
  };
}

class Customer {
  String? id;

  Customer({this.id});

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}
