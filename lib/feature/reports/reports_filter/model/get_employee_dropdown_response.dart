import 'dart:convert';

class GetEmployeeDropdownResponse {
  List<GetEmployeeDropdownValue>? values;
  Pagination? pagination;

  GetEmployeeDropdownResponse({
    this.values,
    this.pagination,
  });

  factory GetEmployeeDropdownResponse.fromRawJson(String str) =>
      GetEmployeeDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEmployeeDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetEmployeeDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetEmployeeDropdownValue>.from(json["values"]!
                .map((x) => GetEmployeeDropdownValue.fromJson(x))),
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

class GetEmployeeDropdownValue {
  String? id;
  String? code;
  String? name;

  GetEmployeeDropdownValue({
    this.id,
    this.code,
    this.name,
  });

  factory GetEmployeeDropdownValue.fromRawJson(String str) =>
      GetEmployeeDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEmployeeDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetEmployeeDropdownValue(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
      };
}
