import 'dart:convert';

class GetApprovalIssueNumberResponse {
  List<GetApprovalIssueNumberValue>? values;
  Pagination? pagination;

  GetApprovalIssueNumberResponse({
    this.values,
    this.pagination,
  });

  factory GetApprovalIssueNumberResponse.fromRawJson(String str) =>
      GetApprovalIssueNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalIssueNumberResponse.fromJson(Map<String, dynamic> json) =>
      GetApprovalIssueNumberResponse(
        values: json["values"] == null
            ? []
            : List<GetApprovalIssueNumberValue>.from(json["values"]!
                .map((x) => GetApprovalIssueNumberValue.fromJson(x))),
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

class GetApprovalIssueNumberValue {
  String? id;
  String? approvalIssueNumber;

  GetApprovalIssueNumberValue({
    this.id,
    this.approvalIssueNumber,
  });

  factory GetApprovalIssueNumberValue.fromRawJson(String str) =>
      GetApprovalIssueNumberValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalIssueNumberValue.fromJson(Map<String, dynamic> json) =>
      GetApprovalIssueNumberValue(
        id: json["id"],
        approvalIssueNumber: json["approval_issue_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "approval_issue_number": approvalIssueNumber,
      };
}
