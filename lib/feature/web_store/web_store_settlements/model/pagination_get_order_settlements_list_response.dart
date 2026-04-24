// import 'dart:convert';

// import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';

// import 'get_order_item_model.dart';

// class PaginatedGetOrderSettlementListingResponse {
//   List<SettlementItem>? values;
//   Pagination? pagination;

//   PaginatedGetOrderSettlementListingResponse({
//     this.values,
//     this.pagination,
//   });

//   factory PaginatedGetOrderSettlementListingResponse.fromRawJson(String str) =>
//       PaginatedGetOrderSettlementListingResponse.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaginatedGetOrderSettlementListingResponse.fromJson(
//           Map<String, dynamic> json) =>
//       PaginatedGetOrderSettlementListingResponse(
//         values: json["items"] == null
//             ? []
//             : List<SettlementItem>.from(
//                 json["items"]!.map((x) => SettlementItem.fromMap(x))),
//         pagination: json["pagination"] == null
//             ? null
//             : Pagination.fromJson(json["pagination"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "items": values == null
//             ? []
//             : List<dynamic>.from(values!.map((x) => x.toMap())),
//         "pagination": pagination?.toJson(),
//       };
// }
