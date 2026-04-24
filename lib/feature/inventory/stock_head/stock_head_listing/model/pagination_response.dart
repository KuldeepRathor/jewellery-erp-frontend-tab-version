import 'dart:convert';

class StockHeadPagination {
  int? totalCount;
  int? pageCount;
  dynamic next;

  StockHeadPagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory StockHeadPagination.fromRawJson(String str) =>
      StockHeadPagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHeadPagination.fromJson(Map<String, dynamic> json) =>
      StockHeadPagination(
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
