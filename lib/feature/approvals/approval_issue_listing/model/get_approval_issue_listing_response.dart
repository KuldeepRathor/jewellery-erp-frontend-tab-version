import 'dart:convert';

class GetApprovalIssueListingResponse {
  List<GetApprovalIssueListingValue>? values;
  Pagination? pagination;

  GetApprovalIssueListingResponse({
    this.values,
    this.pagination,
  });

  factory GetApprovalIssueListingResponse.fromRawJson(String str) =>
      GetApprovalIssueListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalIssueListingResponse.fromJson(Map<String, dynamic> json) =>
      GetApprovalIssueListingResponse(
        values: json["values"] == null
            ? []
            : List<GetApprovalIssueListingValue>.from(json["values"]!
                .map((x) => GetApprovalIssueListingValue.fromJson(x))),
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

class GetApprovalIssueListingValue {
  String? id;
  DateTime? createdAt;
  String? invoiceNumber;
  String? approvalRecordId;
  String? approverId;
  String? approverName;
  String? partyType;
  String? partyId;
  String? customerName;
  String? customerPhoneNumber;
  String? taggingId;
  String? code;
  String? tag;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? stoneCost;
  String? totalAmount;

  GetApprovalIssueListingValue({
    this.id,
    this.createdAt,
    this.invoiceNumber,
    this.approvalRecordId,
    this.approverId,
    this.approverName,
    this.partyType,
    this.partyId,
    this.customerName,
    this.customerPhoneNumber,
    this.taggingId,
    this.code,
    this.tag,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.stoneCost,
    this.totalAmount,
  });

  factory GetApprovalIssueListingValue.fromRawJson(String str) =>
      GetApprovalIssueListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalIssueListingValue.fromJson(Map<String, dynamic> json) =>
      GetApprovalIssueListingValue(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        invoiceNumber: json["invoice_number"],
        approvalRecordId: json["approval_record_id"],
        approverId: json["approver_id"],
        approverName: json["approver_name"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        customerName: json["customer_name"],
        customerPhoneNumber: json["customer_phone_number"],
        taggingId: json["tagging_id"],
        code: json["code"],
        tag: json["tag"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneCost: json["stone_cost"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
        "invoice_number": invoiceNumber,
        "approval_record_id": approvalRecordId,
        "approver_id": approverId,
        "approver_name": approverName,
        "party_type": partyType,
        "party_id": partyId,
        "customer_name": customerName,
        "customer_phone_number": customerPhoneNumber,
        "tagging_id": taggingId,
        "code": code,
        "tag": tag,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stone_cost": stoneCost,
        "total_amount": totalAmount,
      };
}
