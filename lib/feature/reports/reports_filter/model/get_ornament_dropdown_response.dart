import 'dart:convert';

class GetOrnamentDropdownResponse {
  List<GetOrnamentDropdownValue>? values;
  Pagination? pagination;

  GetOrnamentDropdownResponse({
    this.values,
    this.pagination,
  });

  factory GetOrnamentDropdownResponse.fromRawJson(String str) =>
      GetOrnamentDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrnamentDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetOrnamentDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetOrnamentDropdownValue>.from(json["values"]!
                .map((x) => GetOrnamentDropdownValue.fromJson(x))),
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
  String? nextPage;
  String? previousPage;

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

class GetOrnamentDropdownValue {
  String? id;
  String? code;
  String? name;

  GetOrnamentDropdownValue({
    this.id,
    this.code,
    this.name,
  });

  factory GetOrnamentDropdownValue.fromRawJson(String str) =>
      GetOrnamentDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrnamentDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetOrnamentDropdownValue(
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
