import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_model.dart';

class PaginatedGetPurchaseListingResponse {
  List<PurchaseInvoiceModel>? values;
  Pagination? pagination;

  PaginatedGetPurchaseListingResponse({this.values, this.pagination});

  factory PaginatedGetPurchaseListingResponse.fromRawJson(String str) =>
      PaginatedGetPurchaseListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedGetPurchaseListingResponse.fromJson(
    Map<String, dynamic> json,
  ) => PaginatedGetPurchaseListingResponse(
    values:
        json["values"] == null
            ? []
            : List<PurchaseInvoiceModel>.from(
              json["values"]!.map((x) => PurchaseInvoiceModel.fromJson(x)),
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
