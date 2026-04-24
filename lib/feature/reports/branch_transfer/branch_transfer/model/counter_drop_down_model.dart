import 'dart:convert';

class CounterDropDownModel {
  List<Value>? values;
  Pagination? pagination;

  CounterDropDownModel({
    this.values,
    this.pagination,
  });

  CounterDropDownModel copyWith({
    List<Value>? values,
    Pagination? pagination,
  }) =>
      CounterDropDownModel(
        values: values ?? this.values,
        pagination: pagination ?? this.pagination,
      );

  factory CounterDropDownModel.fromRawJson(String str) =>
      CounterDropDownModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterDropDownModel.fromJson(Map<String, dynamic> json) =>
      CounterDropDownModel(
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
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

  Pagination copyWith({
    int? totalCount,
    int? pageCount,
    dynamic next,
  }) =>
      Pagination(
        totalCount: totalCount ?? this.totalCount,
        pageCount: pageCount ?? this.pageCount,
        next: next ?? this.next,
      );

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

class Value {
  String? id;
  String? code;
  String? counterName;
  String? organizationId;
  bool? isDefault;
  int? totalItems;
  String? totalWeight;

  Value({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
  });

  Value copyWith({
    String? id,
    String? code,
    String? counterName,
    String? organizationId,
    bool? isDefault,
    int? totalItems,
    String? totalWeight,
  }) =>
      Value(
        id: id ?? this.id,
        code: code ?? this.code,
        counterName: counterName ?? this.counterName,
        organizationId: organizationId ?? this.organizationId,
        isDefault: isDefault ?? this.isDefault,
        totalItems: totalItems ?? this.totalItems,
        totalWeight: totalWeight ?? this.totalWeight,
      );

  factory Value.fromRawJson(String str) => Value.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"],
        code: json["code"],
        counterName: json["counter_name"],
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        totalItems: json["total_items"],
        totalWeight: json["total_weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "counter_name": counterName,
        "organization_id": organizationId,
        "is_default": isDefault,
        "total_items": totalItems,
        "total_weight": totalWeight,
      };
}
