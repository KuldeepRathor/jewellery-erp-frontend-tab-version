import 'dart:convert';

class GetWeightGroupDropdownResponse {
  List<GetWeightGroupDropdownValue>? values;
  Pagination? pagination;

  GetWeightGroupDropdownResponse({
    this.values,
    this.pagination,
  });

  factory GetWeightGroupDropdownResponse.fromRawJson(String str) =>
      GetWeightGroupDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWeightGroupDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetWeightGroupDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetWeightGroupDropdownValue>.from(json["values"]!
                .map((x) => GetWeightGroupDropdownValue.fromJson(x))),
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

class GetWeightGroupDropdownValue {
  String? id;
  String? code;
  String? name;

  GetWeightGroupDropdownValue({
    this.id,
    this.code,
    this.name,
  });

  factory GetWeightGroupDropdownValue.fromRawJson(String str) =>
      GetWeightGroupDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWeightGroupDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetWeightGroupDropdownValue(
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
