import 'dart:convert';

class CounterResponse {
  List<CounterValue>? values;
  Pagination? pagination;

  CounterResponse({
    this.values,
    this.pagination,
  });

  factory CounterResponse.fromRawJson(String str) =>
      CounterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterResponse.fromJson(Map<String, dynamic> json) =>
      CounterResponse(
        values: json["values"] == null
            ? []
            : List<CounterValue>.from(
                json["values"]!.map(
                  (x) => CounterValue.fromJson(x),
                ),
              ),
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

class CounterValue {
  String? id;
  String? code;
  String? counterName;
  String? organizationId;
  bool? isDefault;
  int? totalItems;
  String? totalWeight;

  CounterValue({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  factory CounterValue.fromRawJson(String str) =>
      CounterValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterValue.fromJson(Map<String, dynamic> json) => CounterValue(
        id: json["id"],
        code: json["code"],
        counterName: json["counter_name"],
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        totalItems: json["total_items"],
        totalWeight: json["total_weight"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "code": code,
        "counter_name": counterName,
        // "organization_id": organizationId,
        "is_default": isDefault,
        // "total_items": totalItems,
        // "total_weight": totalWeight,
      };
}
