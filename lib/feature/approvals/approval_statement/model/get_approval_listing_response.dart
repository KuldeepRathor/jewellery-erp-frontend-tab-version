import 'dart:convert';

class GetApprovalListingResponse {
  List<GetApprovalListingValue>? values;
  Pagination? pagination;

  GetApprovalListingResponse({
    this.values,
    this.pagination,
  });

  factory GetApprovalListingResponse.fromRawJson(String str) =>
      GetApprovalListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalListingResponse.fromJson(Map<String, dynamic> json) =>
      GetApprovalListingResponse(
        values: json["values"] == null
            ? []
            : List<GetApprovalListingValue>.from(json["values"]!
                .map((x) => GetApprovalListingValue.fromJson(x))),
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

class GetApprovalListingValue {
  String? id;
  dynamic ornamentId;
  String? approvalIssueNumber;
  DateTime? approvalDate;
  String? partyId;
  String? partyType;
  String? partyName;
  String? partyNumber;
  String? tag;
  String? code;
  String? tagBarcode;
  String? taggingId;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  DateTime? receiptDate;
  String? receiptNumber;
  String? status;

  GetApprovalListingValue({
    this.id,
    this.ornamentId,
    this.approvalIssueNumber,
    this.approvalDate,
    this.partyId,
    this.partyType,
    this.partyName,
    this.partyNumber,
    this.tag,
    this.code,
    this.tagBarcode,
    this.taggingId,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.receiptDate,
    this.receiptNumber,
    this.status,
  });

  factory GetApprovalListingValue.fromRawJson(String str) =>
      GetApprovalListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalListingValue.fromJson(Map<String, dynamic> json) =>
      GetApprovalListingValue(
        id: json["id"],
        ornamentId: json["ornament_id"],
        approvalIssueNumber: json["approval_issue_number"],
        approvalDate: json["approval_date"] == null
            ? null
            : DateTime.parse(json["approval_date"]),
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        partyNumber: json["party_number"],
        tag: json["tag"],
        code: json["code"],
        tagBarcode: json["tag_barcode"],
        taggingId: json["tagging_id"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        receiptDate: json["receipt_date"] == null
            ? null
            : DateTime.parse(json["receipt_date"]),
        receiptNumber: json["receipt_number"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ornament_id": ornamentId,
        "approval_issue_number": approvalIssueNumber,
        "approval_date": approvalDate == null
            ? null
            : "${approvalDate!.year.toString().padLeft(4, '0')}-${approvalDate!.month.toString().padLeft(2, '0')}-${approvalDate!.day.toString().padLeft(2, '0')}",
        "party_id": partyId,
        "party_type": partyType,
        "party_name": partyName,
        "party_number": partyNumber,
        "tag": tag,
        "code": code,
        "tag_barcode": tagBarcode,
        "tagging_id": taggingId,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "receipt_date": receiptDate == null
            ? null
            : "${receiptDate!.year.toString().padLeft(4, '0')}-${receiptDate!.month.toString().padLeft(2, '0')}-${receiptDate!.day.toString().padLeft(2, '0')}",
        "receipt_number": receiptNumber,
        "status": status,
      };
}
