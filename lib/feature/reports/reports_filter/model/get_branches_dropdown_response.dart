import 'dart:convert';

class GetBranchesDropdownResponse {
  List<GetBranchesDropdownValue>? values;
  Pagination? pagination;

  GetBranchesDropdownResponse({
    this.values,
    this.pagination,
  });

  factory GetBranchesDropdownResponse.fromRawJson(String str) =>
      GetBranchesDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBranchesDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetBranchesDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetBranchesDropdownValue>.from(json["values"]!
                .map((x) => GetBranchesDropdownValue.fromJson(x))),
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

class GetBranchesDropdownValue {
  String? id;
  String? branchName;
  String? readableId;

  GetBranchesDropdownValue({
    this.id,
    this.branchName,
    this.readableId,
  });

  factory GetBranchesDropdownValue.fromRawJson(String str) =>
      GetBranchesDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBranchesDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetBranchesDropdownValue(
        id: json["id"],
        branchName: json["branch_name"],
        readableId: json["readable_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_name": branchName,
        "readable_id": readableId,
      };
}
