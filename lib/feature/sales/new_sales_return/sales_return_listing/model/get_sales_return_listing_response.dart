import 'dart:convert';

class GetSalesReturnPaginatedResponse {
  List<GetSalesReturnPaginatedResponseValue>? values;
  Pagination? pagination;

  GetSalesReturnPaginatedResponse({
    this.values,
    this.pagination,
  });

  factory GetSalesReturnPaginatedResponse.fromRawJson(String str) =>
      GetSalesReturnPaginatedResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      GetSalesReturnPaginatedResponse(
        values: json["values"] == null
            ? []
            : List<GetSalesReturnPaginatedResponseValue>.from(json["values"]!
                .map((x) => GetSalesReturnPaginatedResponseValue.fromJson(x))),
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
  String? next;

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

class GetSalesReturnPaginatedResponseValue {
  String? id;
  DateTime? createdAt;
  String? saleReturnNumber;
  String? saleNumber;
  String? name;
  String? partyType;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? invoiceAmount;
  List<AdjustInvoice>? adjustInvoices;
  String? balance;
  String? paymentStatus;
  String? remarks;

  GetSalesReturnPaginatedResponseValue({
    this.id,
    this.createdAt,
    this.saleReturnNumber,
    this.saleNumber,
    this.name,
    this.partyType,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.invoiceAmount,
    this.adjustInvoices,
    this.balance,
    this.paymentStatus,
    this.remarks,
  });

  factory GetSalesReturnPaginatedResponseValue.fromRawJson(String str) =>
      GetSalesReturnPaginatedResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnPaginatedResponseValue.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReturnPaginatedResponseValue(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        saleReturnNumber: json["sale_return_number"],
        saleNumber: json["sale_number"],
        name: json["name"],
        partyType: json["party_type"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        invoiceAmount: json["invoice_amount"],
        adjustInvoices: json["adjust_invoices"] == null
            ? []
            : List<AdjustInvoice>.from(
                json["adjust_invoices"]!.map((x) => AdjustInvoice.fromJson(x))),
        balance: json["balance"],
        paymentStatus: json["payment_status"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "sale_return_number": saleReturnNumber,
        "sale_number": saleNumber,
        "name": name,
        "party_type": partyType,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "invoice_amount": invoiceAmount,
        "adjust_invoices": adjustInvoices == null
            ? []
            : List<dynamic>.from(adjustInvoices!.map((x) => x.toJson())),
        "balance": balance,
        "payment_status": paymentStatus,
        "remarks": remarks,
      };
}

class AdjustInvoice {
  String? adjustInvoiceType;
  String? adjustInvoiceId;
  String? adjustInvoiceNumber;

  AdjustInvoice({
    this.adjustInvoiceType,
    this.adjustInvoiceId,
    this.adjustInvoiceNumber,
  });

  factory AdjustInvoice.fromRawJson(String str) =>
      AdjustInvoice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdjustInvoice.fromJson(Map<String, dynamic> json) => AdjustInvoice(
        adjustInvoiceType: json["adjust_invoice_type"],
        adjustInvoiceId: json["adjust_invoice_id"],
        adjustInvoiceNumber: json["adjust_invoice_number"],
      );

  Map<String, dynamic> toJson() => {
        "adjust_invoice_type": adjustInvoiceType,
        "adjust_invoice_id": adjustInvoiceId,
        "adjust_invoice_number": adjustInvoiceNumber,
      };
}
