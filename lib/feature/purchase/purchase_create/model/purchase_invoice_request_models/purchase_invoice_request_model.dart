import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_item_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_detail_request_model.dart';

class PurchaseInvoiceRequestModel {
  DateTime? invoiceCreateDate;
  String? invoiceNumber;
  DateTime? invoiceReceiveDate;
  List<LineItemRequestModel>? lineItems;
  String? organizationId;
  String? partyAddress;
  String? partyCode;
  String? partyGst;
  String? partyId;
  String? partyInvoiceNumber;
  String? partyName;
  String? partyType;
  List<PaymentDetailRequestModel>? paymentDetails;
  String? remark;
  bool? isService;

  PurchaseInvoiceRequestModel({
    this.invoiceCreateDate,
    this.invoiceNumber,
    this.invoiceReceiveDate,
    this.lineItems,
    this.organizationId,
    this.partyAddress,
    this.partyCode,
    this.partyGst,
    this.partyId,
    this.partyInvoiceNumber,
    this.partyName,
    this.partyType,
    this.paymentDetails,
    this.remark,
    this.isService,
  });

  factory PurchaseInvoiceRequestModel.fromRawJson(String str) =>
      PurchaseInvoiceRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseInvoiceRequestModel.fromJson(Map<String, dynamic> json) =>
      PurchaseInvoiceRequestModel(
        invoiceCreateDate:
            json["invoice_create_date"] == null
                ? null
                : DateTime.parse(json["invoice_create_date"]),
        invoiceNumber: json["invoice_number"],
        invoiceReceiveDate:
            json["invoice_receive_date"] == null
                ? null
                : DateTime.parse(json["invoice_receive_date"]),
        lineItems:
            json["line_items"] == null
                ? []
                : List<LineItemRequestModel>.from(
                  json["line_items"]!.map(
                    (x) => LineItemRequestModel.fromJson(x),
                  ),
                ),
        organizationId: json["organization_id"],
        partyAddress: json["party_address"],
        partyCode: json["party_code"],
        partyGst: json["party_gst"],
        partyId: json["party_id"],
        partyInvoiceNumber: json["party_invoice_number"],
        partyName: json["party_name"],
        partyType: json["party_type"],
        paymentDetails:
            json["payment_details"] == null
                ? []
                : List<PaymentDetailRequestModel>.from(
                  json["payment_details"]!.map(
                    (x) => PaymentDetailRequestModel.fromJson(x),
                  ),
                ),
        remark: json["remark"],
        isService: json["is_service"],
      );

  Map<String, dynamic> toJson() => {
    "invoice_create_date": invoiceCreateDate?.toIso8601String(),
    "invoice_number": invoiceNumber,
    "invoice_receive_date": invoiceReceiveDate?.toIso8601String(),
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
    "organization_id": organizationId,
    "party_address": partyAddress,
    "party_code": partyCode,
    "party_gst": partyGst,
    "party_id": partyId,
    "party_invoice_number": partyInvoiceNumber,
    "party_name": partyName,
    "party_type": partyType,
    "payment_details":
        paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
    "remark": remark,
    "is_service": isService,
  };
}
