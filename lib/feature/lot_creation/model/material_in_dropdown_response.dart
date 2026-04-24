import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';

class InvoiceNumberResponse {
  List<InvoiceNumberResponseValue>? values;
  NewPagination? pagination;

  InvoiceNumberResponse({this.values, this.pagination});

  factory InvoiceNumberResponse.fromRawJson(String str) =>
      InvoiceNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceNumberResponse.fromJson(Map<String, dynamic> json) =>
      InvoiceNumberResponse(
        values:
            json["values"] == null
                ? []
                : List<InvoiceNumberResponseValue>.from(
                  json["values"]!.map(
                    (x) => InvoiceNumberResponseValue.fromJson(x),
                  ),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : NewPagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class InvoiceNumberResponseValue {
  String? id;
  String? invoiceNumber;

  InvoiceNumberResponseValue({this.id, this.invoiceNumber});

  factory InvoiceNumberResponseValue.fromRawJson(String str) =>
      InvoiceNumberResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceNumberResponseValue.fromJson(Map<String, dynamic> json) =>
      InvoiceNumberResponseValue(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
      );

  Map<String, dynamic> toJson() => {"id": id, "invoice_number": invoiceNumber};
}
