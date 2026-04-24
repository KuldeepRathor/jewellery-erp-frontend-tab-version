// import 'dart:convert';

// class Pagination {
//   int? totalCount;
//   int? pageCount;
//   dynamic next;

//   Pagination({
//     this.totalCount,
//     this.pageCount,
//     this.next,
//   });

//   factory Pagination.fromRawJson(String str) =>
//       Pagination.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//         totalCount: json["total_count"],
//         pageCount: json["page_count"],
//         next: json["next"],
//       );

//   Map<String, dynamic> toJson() => {
//         "total_count": totalCount,
//         "page_count": pageCount,
//         "next": next,
//       };
// }
