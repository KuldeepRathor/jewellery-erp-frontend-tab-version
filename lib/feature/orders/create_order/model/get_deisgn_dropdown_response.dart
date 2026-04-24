import 'dart:convert';

class GetDesignDropdownResponse {
  List<GetDesignDropdownValue>? values;
  Pagination? pagination;

  GetDesignDropdownResponse({
    this.values,
    this.pagination,
  });

  factory GetDesignDropdownResponse.fromRawJson(String str) =>
      GetDesignDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetDesignDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetDesignDropdownValue>.from(
                json["values"]!.map((x) => GetDesignDropdownValue.fromJson(x))),
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

class GetDesignDropdownValue {
  String? id;
  String? code;
  String? name;

  GetDesignDropdownValue({
    this.id,
    this.code,
    this.name,
  });

  factory GetDesignDropdownValue.fromRawJson(String str) =>
      GetDesignDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetDesignDropdownValue(
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
