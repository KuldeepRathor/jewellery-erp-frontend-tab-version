import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/line_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/payment_detail_model.dart';

class PurchaseInvoiceModel {
  String? id;
  String? organizationId;
  String? partyType;
  String? partyId;
  String? partyName;
  String? partyCode;
  String? partyAddress;
  String? partyGst;
  String? invoiceNumber;
  String? partyInvoiceNumber;
  DateTime? invoiceCreateDate;
  DateTime? invoiceReceiveDate;
  List<PaymentDetail>? paymentDetails;
  List<LineItem>? lineItems;
  DateTime? cancelledAt;
  bool? isCancelled;
  String? status;
  List<PurchaseAttachment>? purchaseAttachments;

  PurchaseInvoiceModel({
    this.id,
    this.organizationId,
    this.partyType,
    this.partyId,
    this.partyName,
    this.partyCode,
    this.partyAddress,
    this.partyGst,
    this.invoiceNumber,
    this.partyInvoiceNumber,
    this.invoiceCreateDate,
    this.invoiceReceiveDate,
    this.paymentDetails,
    this.lineItems,
    this.cancelledAt,
    this.isCancelled,
    this.status,
    this.purchaseAttachments,
  });

  factory PurchaseInvoiceModel.fromRawJson(String str) =>
      PurchaseInvoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseInvoiceModel.fromJson(Map<String, dynamic> json) =>
      PurchaseInvoiceModel(
        id: json["id"],
        organizationId: json["organization_id"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyCode: json["party_code"],
        partyAddress: json["party_address"],
        partyGst: json["party_gst"],
        invoiceNumber: json["invoice_number"],
        partyInvoiceNumber: json["party_invoice_number"],
        invoiceCreateDate:
            json["invoice_create_date"] == null
                ? null
                : DateTime.parse(json["invoice_create_date"]),
        invoiceReceiveDate:
            json["invoice_receive_date"] == null
                ? null
                : DateTime.parse(json["invoice_receive_date"]),
        paymentDetails:
            json["payment_details"] == null
                ? []
                : List<PaymentDetail>.from(
                  json["payment_details"]!.map(
                    (x) => PaymentDetail.fromJson(x),
                  ),
                ),
        lineItems:
            json["line_items"] == null
                ? []
                : List<LineItem>.from(
                  json["line_items"]!.map((x) => LineItem.fromJson(x)),
                ),
        cancelledAt:
            json["cancelled_at"] == null
                ? null
                : DateTime.parse(json["cancelled_at"]),
        isCancelled: json["is_cancelled"],
        status: json["status"],
        purchaseAttachments:
            json["purchase_attachments"] == null
                ? []
                : List<PurchaseAttachment>.from(
                  json["purchase_attachments"]!.map(
                    (x) => PurchaseAttachment.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "party_type": partyType,
    "party_id": partyId,
    "party_name": partyName,
    "party_code": partyCode,
    "party_address": partyAddress,
    "party_gst": partyGst,
    "invoice_number": invoiceNumber,
    "party_invoice_number": partyInvoiceNumber,
    "invoice_create_date": invoiceCreateDate,
    "invoice_receive_date": invoiceReceiveDate,
    "payment_details":
        paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
    "cancelled_at": cancelledAt?.toIso8601String(),
    "is_cancelled": isCancelled,
    "status": status,
    "purchase_attachments":
        purchaseAttachments == null
            ? []
            : List<dynamic>.from(purchaseAttachments!.map((x) => x.toJson())),
  };

  Map<String, dynamic> toRequestJson() => {
    // "id": id,
    "organization_id": organizationId,
    "party_type": partyType,
    "party_id": partyId,
    "party_name": partyName,
    "party_code": partyCode,
    "party_address": partyAddress,
    "party_gst": partyGst,
    "invoice_number": invoiceNumber,
    "party_invoice_number": partyInvoiceNumber,
    "invoice_create_date": invoiceCreateDate,
    "invoice_receive_date": invoiceReceiveDate,
    "payment_details":
        paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toRequestJson())),
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toRequestJson())),
    "cancelled_at": cancelledAt?.toIso8601String(),
    "is_cancelled": isCancelled,
    "status": status,
  };
}

class PurchaseAttachment {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  PurchaseAttachment({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory PurchaseAttachment.fromRawJson(String str) =>
      PurchaseAttachment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseAttachment.fromJson(Map<String, dynamic> json) =>
      PurchaseAttachment(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_name": fileName,
    "file_type": fileType,
    "s3_key": s3Key,
    "presigned_url": presignedUrl,
    "is_webstore": isWebstore,
  };
}
