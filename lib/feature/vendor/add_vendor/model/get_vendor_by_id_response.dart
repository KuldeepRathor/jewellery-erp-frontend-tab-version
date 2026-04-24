import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/bank_account_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_ledger_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';

class GetVendorByIdResponse {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? panNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  List<BankAccount>? bankDetails;
  List<VendorType>? vendorTypes;
  List<LedgerItem>? ledgerItems;
  List<Address>? address;
  AccountMapping? ledger;
  GetVendorByIdResponse({
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
    this.ledger,
  });

  factory GetVendorByIdResponse.fromRawJson(String str) =>
      GetVendorByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetVendorByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetVendorByIdResponse(
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
                : List<BankAccount>.from(
                  json["bank_details"]!.map((x) => BankAccount.fromJson(x)),
                ),
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
        ledger:
            json["ledger"] == null
                ? null
                : AccountMapping.fromJson(json["ledger"]),
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
            : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
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
    "ledger": ledger?.toJson(),
  };
}
