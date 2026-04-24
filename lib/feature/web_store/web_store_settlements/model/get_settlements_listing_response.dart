import 'dart:convert';

class GetSettlementsListingResponse {
  List<GetSettlementsListingValue>? values;
  Pagination? pagination;

  GetSettlementsListingResponse({
    this.values,
    this.pagination,
  });

  factory GetSettlementsListingResponse.fromRawJson(String str) =>
      GetSettlementsListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSettlementsListingResponse.fromJson(Map<String, dynamic> json) =>
      GetSettlementsListingResponse(
        values: json["values"] == null
            ? []
            : List<GetSettlementsListingValue>.from(json["values"]!
                .map((x) => GetSettlementsListingValue.fromJson(x))),
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

class GetSettlementsListingValue {
  String? id;
  DateTime? recordCreatedAt;
  int? count;
  int? paymentsCount;
  String? totalOnlineAmount;
  String? txnCharges;
  String? txnChargesGst;
  String? settlementAmount;
  String? settlementId;
  DateTime? settlementTime;

  GetSettlementsListingValue({
    this.id,
    this.recordCreatedAt,
    this.count,
    this.paymentsCount,
    this.totalOnlineAmount,
    this.txnCharges,
    this.txnChargesGst,
    this.settlementAmount,
    this.settlementId,
    this.settlementTime,
  });

  factory GetSettlementsListingValue.fromRawJson(String str) =>
      GetSettlementsListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSettlementsListingValue.fromJson(Map<String, dynamic> json) =>
      GetSettlementsListingValue(
        id: json["id"],
        recordCreatedAt: json["record_created_at"] == null
            ? null
            : DateTime.parse(json["record_created_at"]),
        count: json["count"],
        paymentsCount: json["payments_count"],
        totalOnlineAmount: json["total_online_amount"],
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
        "record_created_at": recordCreatedAt?.toIso8601String(),
        "count": count,
        "payments_count": paymentsCount,
        "total_online_amount": totalOnlineAmount,
        "txn_charges": txnCharges,
        "txn_charges_gst": txnChargesGst,
        "settlement_amount": settlementAmount,
        "settlement_id": settlementId,
        "settlement_time": settlementTime?.toIso8601String(),
      };
}
