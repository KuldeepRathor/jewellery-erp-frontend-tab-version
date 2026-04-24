import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/bank_account_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_ledger_list_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_types_response.dart';

class AddVendorRequestResponse {
  String? name;
  String? code;
  String? organization_id;
  String? panNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  List<BankAccount>? bankDetails;
  List<VendorType>? vendorTypes;
  List<LedgerItem>? ledgerItems;
  List<Address>? address;
  int? ledgerId;

  AddVendorRequestResponse({
    this.name,
    this.code,
    this.organization_id,
    this.panNumber,
    this.gstNumber,
    this.deductionType,
    this.deductionPercent,
    this.bankDetails,
    this.vendorTypes,
    this.ledgerItems,
    this.address,
    this.ledgerId,
  });

  factory AddVendorRequestResponse.fromRawJson(String str) =>
      AddVendorRequestResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddVendorRequestResponse.fromJson(Map<String, dynamic> json) =>
      AddVendorRequestResponse(
        name: json["name"],
        code: json["code"],
        organization_id: json["organization_id"],
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
        ledgerId: json["ledger_id"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "organization_id": organization_id,
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
    "ledger_id": ledgerId,
  };
}
