import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';

class VendorSearchModel {
  List<VendorSearchValue>? values;
  Pagination? pagination;

  VendorSearchModel({this.values, this.pagination});

  factory VendorSearchModel.fromRawJson(String str) =>
      VendorSearchModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VendorSearchModel.fromJson(Map<String, dynamic> json) =>
      VendorSearchModel(
        values:
            json["values"] == null
                ? []
                : List<VendorSearchValue>.from(
                  json["values"]!.map((x) => VendorSearchValue.fromJson(x)),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  String? next;

  Pagination({this.totalCount, this.pageCount, this.next});

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalCount: json["total_count"],
    pageCount: json["page_count"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount,
    "page_count": pageCount,
    "next": next,
  };
}

class VendorSearchValue {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  List<Address>? address;
  String? panNumber;
  String? phoneNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  List<BankDetail>? bankDetails;
  List<dynamic>? vendorTypes;
  List<dynamic>? ledgerItems;

  VendorSearchValue({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.address,
    this.panNumber,
    this.gstNumber,
    this.deductionType,
    this.deductionPercent,
    this.bankDetails,
    this.vendorTypes,
    this.ledgerItems,
    this.phoneNumber,
  });

  factory VendorSearchValue.fromRawJson(String str) =>
      VendorSearchValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VendorSearchValue.fromJson(Map<String, dynamic> json) =>
      VendorSearchValue(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        address:
            json["address"] == null
                ? []
                : List<Address>.from(
                  json["address"]!.map((x) => Address.fromJson(x)),
                ),
        panNumber: json["pan_number"],
        gstNumber: json["gst_number"],
        deductionType: json["deduction_type"],
        deductionPercent: json["deduction_percent"],
        bankDetails:
            json["bank_details"] == null
                ? []
                : List<BankDetail>.from(
                  json["bank_details"]!.map((x) => BankDetail.fromJson(x)),
                ),
        vendorTypes:
            json["vendor_types"] == null
                ? []
                : List<dynamic>.from(json["vendor_types"]!.map((x) => x)),
        ledgerItems:
            json["ledger_items"] == null
                ? []
                : List<dynamic>.from(json["ledger_items"]!.map((x) => x)),
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "organization_id": organizationId,
    "address":
        address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
    "pan_number": panNumber,
    "gst_number": gstNumber,
    "deduction_type": deductionType,
    "deduction_percent": deductionPercent,
    "bank_details":
        bankDetails == null
            ? []
            : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
    "vendor_types":
        vendorTypes == null
            ? []
            : List<dynamic>.from(vendorTypes!.map((x) => x)),
    "ledger_items":
        ledgerItems == null
            ? []
            : List<dynamic>.from(ledgerItems!.map((x) => x)),
    "phone_number": phoneNumber,
  };
}

class BankDetail {
  String? id;
  String? holderName;
  dynamic nickname;
  String? accountNumber;
  String? ifscCode;

  BankDetail({
    this.id,
    this.holderName,
    this.nickname,
    this.accountNumber,
    this.ifscCode,
  });

  factory BankDetail.fromRawJson(String str) =>
      BankDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    id: json["id"],
    holderName: json["holder_name"],
    nickname: json["nickname"],
    accountNumber: json["account_number"],
    ifscCode: json["ifsc_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "holder_name": holderName,
    "nickname": nickname,
    "account_number": accountNumber,
    "ifsc_code": ifscCode,
  };
}
