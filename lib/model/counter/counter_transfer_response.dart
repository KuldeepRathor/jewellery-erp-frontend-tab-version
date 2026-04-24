import 'dart:convert';

class CounterTransferListingResponse {
  List<CounterTransferValue>? values;
  Pagination? pagination;

  CounterTransferListingResponse({
    this.values,
    this.pagination,
  });

  factory CounterTransferListingResponse.fromRawJson(String str) =>
      CounterTransferListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterTransferListingResponse.fromJson(Map<String, dynamic> json) =>
      CounterTransferListingResponse(
        values: json["values"] == null
            ? []
            : List<CounterTransferValue>.from(
                json["values"]!.map((x) => CounterTransferValue.fromJson(x))),
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

class CounterTransferValue {
  String? counterToId;
  String? counterFrom;
  String? stockHeadId;
  String? employeeId;
  DateTime? date;
  int? count;

  CounterTransferValue({
    this.counterToId,
    this.counterFrom,
    this.stockHeadId,
    this.employeeId,
    this.date,
    this.count,
  });

  factory CounterTransferValue.fromRawJson(String str) =>
      CounterTransferValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterTransferValue.fromJson(Map<String, dynamic> json) =>
      CounterTransferValue(
        counterToId: json["counter_to_id"],
        counterFrom: json["counter_from"],
        stockHeadId: json["stock_head_id"],
        employeeId: json["employee_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "counter_to_id": counterToId,
        "counter_from": counterFrom,
        "stock_head_id": stockHeadId,
        "employee_id": employeeId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "count": count,
      };
}
