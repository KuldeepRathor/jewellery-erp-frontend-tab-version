import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';

class GetPartyDetailsByLedgerResponse {
  GetVendorByIdResponse? vendor;
  List<GetPartyDetailsByLedgerResponseDetail>? purchaseDetails;
  List<GetPartyDetailsByLedgerResponseDetail>? purchaseReturnDetails;
  List<GetPartyDetailsByLedgerResponseDetail>? salesDetails;
  List<GetPartyDetailsByLedgerResponseDetail>? salesReturnDetails;

  GetPartyDetailsByLedgerResponse({
    this.vendor,
    this.purchaseDetails,
    this.purchaseReturnDetails,
    this.salesDetails,
    this.salesReturnDetails,
  });

  factory GetPartyDetailsByLedgerResponse.fromRawJson(String str) =>
      GetPartyDetailsByLedgerResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPartyDetailsByLedgerResponse.fromJson(Map<String, dynamic> json) =>
      GetPartyDetailsByLedgerResponse(
        vendor:
            json["vendor"] == null
                ? null
                : GetVendorByIdResponse.fromJson(json["vendor"]),
        purchaseDetails:
            json["purchase_details"] == null
                ? []
                : List<GetPartyDetailsByLedgerResponseDetail>.from(
                  json["purchase_details"]!.map(
                    (x) => GetPartyDetailsByLedgerResponseDetail.fromJson(x),
                  ),
                ),
        purchaseReturnDetails:
            json["purchase_return_details"] == null
                ? []
                : List<GetPartyDetailsByLedgerResponseDetail>.from(
                  json["purchase_return_details"]!.map(
                    (x) => GetPartyDetailsByLedgerResponseDetail.fromJson(x),
                  ),
                ),
        salesDetails:
            json["sales_details"] == null
                ? []
                : List<GetPartyDetailsByLedgerResponseDetail>.from(
                  json["sales_details"]!.map(
                    (x) => GetPartyDetailsByLedgerResponseDetail.fromJson(x),
                  ),
                ),
        salesReturnDetails:
            json["sales_return_details"] == null
                ? []
                : List<GetPartyDetailsByLedgerResponseDetail>.from(
                  json["sales_return_details"]!.map(
                    (x) => GetPartyDetailsByLedgerResponseDetail.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "vendor": vendor?.toJson(),
    "purchase_details":
        purchaseDetails == null
            ? []
            : List<dynamic>.from(purchaseDetails!.map((x) => x.toJson())),
    "purchase_return_details":
        purchaseReturnDetails == null
            ? []
            : List<dynamic>.from(purchaseReturnDetails!.map((x) => x.toJson())),
    "sales_details":
        salesDetails == null
            ? []
            : List<dynamic>.from(salesDetails!.map((x) => x.toJson())),
    "sales_return_details":
        salesReturnDetails == null
            ? []
            : List<dynamic>.from(salesReturnDetails!.map((x) => x.toJson())),
  };
}

class GetPartyDetailsByLedgerResponseDetail {
  String? invoiceId;
  DateTime? invoiceDate;
  String? invoiceAmount;
  String? invoiceNumber;
  String? balanceAmount;
  String? remarks;
  String? invoiceType;

  GetPartyDetailsByLedgerResponseDetail({
    this.invoiceId,
    this.invoiceDate,
    this.invoiceAmount,
    this.invoiceNumber,
    this.balanceAmount,
    this.remarks,
    this.invoiceType,
  });

  factory GetPartyDetailsByLedgerResponseDetail.fromRawJson(String str) =>
      GetPartyDetailsByLedgerResponseDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPartyDetailsByLedgerResponseDetail.fromJson(
    Map<String, dynamic> json,
  ) => GetPartyDetailsByLedgerResponseDetail(
    invoiceId: json["invoice_id"],
    invoiceDate:
        json["invoice_date"] == null
            ? null
            : DateTime.parse(json["invoice_date"]),
    invoiceAmount: json["invoice_amount"],
    invoiceNumber: json["invoice_number"],
    balanceAmount: json["balance_amount"],
    remarks: json["remarks"],
    invoiceType: json["invoice_type"],
  );

  Map<String, dynamic> toJson() => {
    "invoice_id": invoiceId,
    "invoice_date": invoiceDate?.toIso8601String(),
    "invoice_amount": invoiceAmount,
    "invoice_number": invoiceNumber,
    "balance_amount": balanceAmount,
    "remarks": remarks,
    "invoice_type": invoiceType,
  };
}
