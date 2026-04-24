import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';

class PaginatedGetVendorListingDetailsResponse {
  List<GetVendorByIdResponse>? values;
  Pagination? pagination;

  PaginatedGetVendorListingDetailsResponse({this.values, this.pagination});

  factory PaginatedGetVendorListingDetailsResponse.fromRawJson(String str) =>
      PaginatedGetVendorListingDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedGetVendorListingDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) => PaginatedGetVendorListingDetailsResponse(
    values:
        json["values"] == null
            ? []
            : List<GetVendorByIdResponse>.from(
              json["values"]!.map((x) => GetVendorByIdResponse.fromJson(x)),
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
