import 'dart:convert';

class CounterTransferListingAggregateResponse {
  List<CounterTransferListingAggregateValue>? values;
  Pagination? pagination;

  CounterTransferListingAggregateResponse({
    this.values,
    this.pagination,
  });

  factory CounterTransferListingAggregateResponse.fromRawJson(String str) =>
      CounterTransferListingAggregateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterTransferListingAggregateResponse.fromJson(
          Map<String, dynamic> json) =>
      CounterTransferListingAggregateResponse(
        values: json["values"] == null
            ? []
            : List<CounterTransferListingAggregateValue>.from(json["values"]!
                .map((x) => CounterTransferListingAggregateValue.fromJson(x))),
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

class CounterTransferListingAggregateValue {
  String? counterToId;
  String? counterToName;
  String? counterFrom;
  String? counterFromName;
  String? stockHeadId;
  String? employeeId;
  String? employeeName;
  DateTime? date;
  int? count;

  CounterTransferListingAggregateValue({
    this.counterToId,
    this.counterToName,
    this.counterFrom,
    this.counterFromName,
    this.stockHeadId,
    this.employeeId,
    this.employeeName,
    this.date,
    this.count,
  });

  factory CounterTransferListingAggregateValue.fromRawJson(String str) =>
      CounterTransferListingAggregateValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CounterTransferListingAggregateValue.fromJson(
          Map<String, dynamic> json) =>
      CounterTransferListingAggregateValue(
        counterToId: json["counter_to_id"],
        counterToName: json["counter_to_name"],
        counterFrom: json["counter_from"],
        counterFromName: json["counter_from_name"],
        stockHeadId: json["stock_head_id"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "counter_to_id": counterToId,
        "counter_to_name": counterToName,
        "counter_from": counterFrom,
        "counter_from_name": counterFromName,
        "stock_head_id": stockHeadId,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "count": count,
      };
}
