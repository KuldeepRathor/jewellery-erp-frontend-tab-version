import 'dart:convert';

class GetSettlementsDetailsListingResponse {
  List<GetSettlementsDetailsListingValue>? values;
  Pagination? pagination;

  GetSettlementsDetailsListingResponse({
    this.values,
    this.pagination,
  });

  factory GetSettlementsDetailsListingResponse.fromRawJson(String str) =>
      GetSettlementsDetailsListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSettlementsDetailsListingResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSettlementsDetailsListingResponse(
        values: json["values"] == null
            ? []
            : List<GetSettlementsDetailsListingValue>.from(json["values"]!
                .map((x) => GetSettlementsDetailsListingValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  int? totalPages;
  int? currentPage;
  dynamic nextPage;
  dynamic previousPage;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        previousPage: json["previous_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "total_pages": totalPages,
        "current_page": currentPage,
        "next_page": nextPage,
        "previous_page": previousPage,
      };
}

class GetSettlementsDetailsListingValue {
  String? id;
  String? customerId;
  DateTime? transactionCreatedAt;
  String? phoneNumber;
  String? customerName;
  String? txnId;
  String? txnType;
  String? txnAmount;
  String? paymentMode;
  String? paymentId;
  String? txnCharges;
  String? txnChargesGst;
  String? settlementAmount;
  String? settlementId;
  DateTime? settlementTime;

  GetSettlementsDetailsListingValue({
    this.id,
    this.customerId,
    this.transactionCreatedAt,
    this.phoneNumber,
    this.customerName,
    this.txnId,
    this.txnType,
    this.txnAmount,
    this.paymentMode,
    this.paymentId,
    this.txnCharges,
    this.txnChargesGst,
    this.settlementAmount,
    this.settlementId,
    this.settlementTime,
  });

  factory GetSettlementsDetailsListingValue.fromRawJson(String str) =>
      GetSettlementsDetailsListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSettlementsDetailsListingValue.fromJson(
          Map<String, dynamic> json) =>
      GetSettlementsDetailsListingValue(
        id: json["id"],
        customerId: json["customer_id"],
        transactionCreatedAt: json["transaction_created_at"] == null
            ? null
            : DateTime.parse(json["transaction_created_at"]),
        phoneNumber: json["phone_number"],
        customerName: json["customer_name"],
        txnId: json["txn_id"],
        txnType: json["txn_type"],
        txnAmount: json["txn_amount"],
        paymentMode: json["payment_mode"],
        paymentId: json["payment_id"],
        txnCharges: json["txn_charges"],
        txnChargesGst: json["txn_charges_gst"],
        settlementAmount: json["settlement_amount"],
        settlementId: json["settlement_id"],
        settlementTime: json["settlement_time"] == null
            ? null
            : DateTime.parse(json["settlement_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "transaction_created_at": transactionCreatedAt?.toIso8601String(),
        "phone_number": phoneNumber,
        "customer_name": customerName,
        "txn_id": txnId,
        "txn_type": txnType,
        "txn_amount": txnAmount,
        "payment_mode": paymentMode,
        "payment_id": paymentId,
        "txn_charges": txnCharges,
        "txn_charges_gst": txnChargesGst,
        "settlement_amount": settlementAmount,
        "settlement_id": settlementId,
        "settlement_time": settlementTime?.toIso8601String(),
      };
}
