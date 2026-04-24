import 'dart:convert';

class GetPaymentsPaginated {
  List<GetPaymentsPaginatedValue>? values;
  Pagination? pagination;

  GetPaymentsPaginated({
    this.values,
    this.pagination,
  });

  factory GetPaymentsPaginated.fromRawJson(String str) =>
      GetPaymentsPaginated.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaymentsPaginated.fromJson(Map<String, dynamic> json) =>
      GetPaymentsPaginated(
        values: json["values"] == null
            ? []
            : List<GetPaymentsPaginatedValue>.from(json["values"]!
                .map((x) => GetPaymentsPaginatedValue.fromJson(x))),
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

class GetPaymentsPaginatedValue {
  String? id;
  String? paymentNumber;
  DateTime? date;
  String? partyId;
  String? partyType;
  String? partyName;
  String? phoneNumber;
  String? total;
  String? remarks;
  String? paymentId;
  String? cash;
  dynamic card;
  dynamic neftRtgs;
  dynamic upiImps;
  dynamic cheque;

  GetPaymentsPaginatedValue({
    this.id,
    this.paymentNumber,
    this.date,
    this.partyId,
    this.partyType,
    this.partyName,
    this.phoneNumber,
    this.total,
    this.remarks,
    this.paymentId,
    this.cash,
    this.card,
    this.neftRtgs,
    this.upiImps,
    this.cheque,
  });

  factory GetPaymentsPaginatedValue.fromRawJson(String str) =>
      GetPaymentsPaginatedValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaymentsPaginatedValue.fromJson(Map<String, dynamic> json) =>
      GetPaymentsPaginatedValue(
        id: json["id"],
        paymentNumber: json["payment_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        phoneNumber: json["phone_number"],
        total: json["total"],
        remarks: json["remarks"],
        paymentId: json["payment_id"],
        cash: json["cash"],
        card: json["card"],
        neftRtgs: json["neft_rtgs"],
        upiImps: json["upi_imps"],
        cheque: json["cheque"],
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
        "payment_id": paymentId,
        "cash": cash,
        "card": card,
        "neft_rtgs": neftRtgs,
        "upi_imps": upiImps,
        "cheque": cheque,
      };
}
