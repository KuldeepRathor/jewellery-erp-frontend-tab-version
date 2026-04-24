import 'dart:convert';

class SalesReturnListingRequest {
  String? metalType;
  DateTime? dateFrom;
  DateTime? dateTo;
  String? pendingAmountFrom;
  String? pendingAmountTo;
  String? invoiceStatus;

  SalesReturnListingRequest({
    this.metalType,
    this.dateFrom,
    this.dateTo,
    this.pendingAmountFrom,
    this.pendingAmountTo,
    this.invoiceStatus,
  });

  factory SalesReturnListingRequest.fromRawJson(String str) =>
      SalesReturnListingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesReturnListingRequest.fromJson(Map<String, dynamic> json) =>
      SalesReturnListingRequest(
        metalType: json["metal_type"],
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        pendingAmountFrom: json["pending_amount_from"],
        pendingAmountTo: json["pending_amount_to"],
        invoiceStatus: json["invoice_status"],
      );

  Map<String, dynamic> toJson() => {
        "metal_type": metalType,
        "date_from": dateFrom == null
            ? null
            : "${dateFrom!.year.toString().padLeft(4, '0')}-${dateFrom!.month.toString().padLeft(2, '0')}-${dateFrom!.day.toString().padLeft(2, '0')}",
        "date_to": dateTo == null
            ? null
            : "${dateTo!.year.toString().padLeft(4, '0')}-${dateTo!.month.toString().padLeft(2, '0')}-${dateTo!.day.toString().padLeft(2, '0')}",
        "pending_amount_from": pendingAmountFrom,
        "pending_amount_to": pendingAmountTo,
        "invoice_status": invoiceStatus,
      };
}
