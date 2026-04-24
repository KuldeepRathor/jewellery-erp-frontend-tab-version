import 'dart:convert';

class GetReceiptsPaginated {
  List<GetReceiptsPaginatedValue>? values;
  Pagination? pagination;

  GetReceiptsPaginated({
    this.values,
    this.pagination,
  });

  factory GetReceiptsPaginated.fromRawJson(String str) =>
      GetReceiptsPaginated.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReceiptsPaginated.fromJson(Map<String, dynamic> json) =>
      GetReceiptsPaginated(
        values: json["values"] == null
            ? []
            : List<GetReceiptsPaginatedValue>.from(json["values"]!
                .map((x) => GetReceiptsPaginatedValue.fromJson(x))),
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
  dynamic next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

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

class GetReceiptsPaginatedValue {
  String? id;
  String? paymentNumber;
  DateTime? date;
  String? partyId;
  String? partyType;
  String? partyName;
  String? phoneNumber;
  String? total;
  String? remarks;
  String? paymentReceiptId;
  String? cash;
  String? card;
  dynamic neftRtgs;
  dynamic upiImps;
  dynamic cheque;
  bool? isCancelled;
  String? againstInvoice;

  GetReceiptsPaginatedValue({
    this.id,
    this.paymentNumber,
    this.date,
    this.partyId,
    this.partyType,
    this.partyName,
    this.phoneNumber,
    this.total,
    this.remarks,
    this.paymentReceiptId,
    this.cash,
    this.card,
    this.neftRtgs,
    this.upiImps,
    this.cheque,
    this.isCancelled,
    this.againstInvoice,
  });

  factory GetReceiptsPaginatedValue.fromRawJson(String str) =>
      GetReceiptsPaginatedValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReceiptsPaginatedValue.fromJson(Map<String, dynamic> json) =>
      GetReceiptsPaginatedValue(
        id: json["id"],
        paymentNumber: json["payment_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        phoneNumber: json["phone_number"],
        total: json["total"],
        remarks: json["remarks"],
        paymentReceiptId: json["payment_receipt_id"],
        cash: json["cash"],
        card: json["card"],
        neftRtgs: json["neft_rtgs"],
        upiImps: json["upi_imps"],
        cheque: json["cheque"],
        isCancelled: json["is_cancelled"],
        againstInvoice: json["against_invoice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_number": paymentNumber,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "party_id": partyId,
        "party_type": partyType,
        "party_name": partyName,
        "phone_number": phoneNumber,
        "total": total,
        "remarks": remarks,
        "payment_receipt_id": paymentReceiptId,
        "cash": cash,
        "card": card,
        "neft_rtgs": neftRtgs,
        "upi_imps": upiImps,
        "cheque": cheque,
        "is_cancelled": isCancelled,
        "against_invoice": againstInvoice,
      };
}
