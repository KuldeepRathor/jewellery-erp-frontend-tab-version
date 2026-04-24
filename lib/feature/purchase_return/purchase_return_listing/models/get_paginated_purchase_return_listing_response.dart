import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_resturn_response_model.dart';

class PaginatedGetPurchaseReturnListingResponse {
  List<PurchaseReturnResponseModel>? values;
  Pagination? pagination;

  PaginatedGetPurchaseReturnListingResponse({this.values, this.pagination});

  factory PaginatedGetPurchaseReturnListingResponse.fromRawJson(String str) =>
      PaginatedGetPurchaseReturnListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedGetPurchaseReturnListingResponse.fromJson(
    Map<String, dynamic> json,
  ) => PaginatedGetPurchaseReturnListingResponse(
    values:
        json["values"] == null
            ? []
            : List<PurchaseReturnResponseModel>.from(
              json["values"]!.map(
                (x) => PurchaseReturnResponseModel.fromJson(x),
              ),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}
