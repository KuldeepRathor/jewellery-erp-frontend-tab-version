import 'dart:convert';

class GetApprovalReceiptListingResponse {
  List<GetApprovalReceiptListingValue>? values;
  Pagination? pagination;

  GetApprovalReceiptListingResponse({
    this.values,
    this.pagination,
  });

  factory GetApprovalReceiptListingResponse.fromRawJson(String str) =>
      GetApprovalReceiptListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalReceiptListingResponse.fromJson(
          Map<String, dynamic> json) =>
      GetApprovalReceiptListingResponse(
        values: json["values"] == null
            ? []
            : List<GetApprovalReceiptListingValue>.from(json["values"]!
                .map((x) => GetApprovalReceiptListingValue.fromJson(x))),
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
  int? nextPage;
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

class GetApprovalReceiptListingValue {
  String? id;
  DateTime? createdAt;
  String? invoiceNumber;
  String? partyId;
  String? partyType;
  String? customerName;
  String? customerPhoneNumber;
  String? code;
  String? tag;
  String? taggingId;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? stoneCost;
  dynamic totalAmount;
  String? approvalReceiptId;

  GetApprovalReceiptListingValue({
    this.id,
    this.createdAt,
    this.invoiceNumber,
    this.partyId,
    this.partyType,
    this.customerName,
    this.customerPhoneNumber,
    this.code,
    this.tag,
    this.taggingId,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.stoneCost,
    this.totalAmount,
    this.approvalReceiptId,
  });

  factory GetApprovalReceiptListingValue.fromRawJson(String str) =>
      GetApprovalReceiptListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalReceiptListingValue.fromJson(Map<String, dynamic> json) =>
      GetApprovalReceiptListingValue(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        invoiceNumber: json["invoice_number"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        customerName: json["customer_name"],
        customerPhoneNumber: json["customer_phone_number"],
        code: json["code"],
        tag: json["tag"],
        taggingId: json["tagging_id"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneCost: json["stone_cost"],
        totalAmount: json["total_amount"],
        approvalReceiptId: json["approval_receipt_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "invoice_number": invoiceNumber,
        "party_id": partyId,
        "party_type": partyType,
        "customer_name": customerName,
        "customer_phone_number": customerPhoneNumber,
        "code": code,
        "tag": tag,
        "tagging_id": taggingId,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stone_cost": stoneCost,
        "total_amount": totalAmount,
        "approval_receipt_id": approvalReceiptId,
      };
}
