import 'dart:convert';

class PurchaseInvoiceListingRequest {
  List<String>? metalType;
  DateTime? dateFrom;
  DateTime? dateTo;
  String? transactionType;
  String? paymentStatus;
  List<String>? ornamentType;
  String? invoiceStatus;

  PurchaseInvoiceListingRequest({
    this.metalType,
    this.dateFrom,
    this.dateTo,
    this.transactionType,
    this.paymentStatus,
    this.ornamentType,
    this.invoiceStatus,
  });

  factory PurchaseInvoiceListingRequest.fromRawJson(String str) =>
      PurchaseInvoiceListingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseInvoiceListingRequest.fromJson(Map<String, dynamic> json) =>
      PurchaseInvoiceListingRequest(
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        transactionType: json["transaction_type"],
        paymentStatus: json["payment_status"],
        ornamentType: json["ornament_type"] == null
            ? []
            : List<String>.from(json["ornament_type"]!.map((x) => x)),
        invoiceStatus: json["invoice_status"],
      );

  Map<String, dynamic> toJson() => {
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "transaction_type": transactionType,
        "payment_status": paymentStatus,
        "ornament_type": ornamentType == null
            ? []
            : List<dynamic>.from(ornamentType!.map((x) => x)),
        "invoice_status": invoiceStatus,
      };
}
