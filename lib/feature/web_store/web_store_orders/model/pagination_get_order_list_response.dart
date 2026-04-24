import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';

import 'get_order_item_model.dart';

class PaginatedGetOrderListingResponse {
  List<GetWebStoreOrdersListResponse>? values;
  Pagination? pagination;

  PaginatedGetOrderListingResponse({this.values, this.pagination});

  factory PaginatedGetOrderListingResponse.fromRawJson(String str) =>
      PaginatedGetOrderListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedGetOrderListingResponse.fromJson(
    Map<String, dynamic> json,
  ) => PaginatedGetOrderListingResponse(
    values:
        json["values"] == null
            ? []
            : List<GetWebStoreOrdersListResponse>.from(
              json["values"]!.map(
                (x) => GetWebStoreOrdersListResponse.fromMap(x),
              ),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "values":
        values == null ? [] : List<dynamic>.from(values!.map((x) => x.toMap())),
    "pagination": pagination?.toJson(),
  };
}
