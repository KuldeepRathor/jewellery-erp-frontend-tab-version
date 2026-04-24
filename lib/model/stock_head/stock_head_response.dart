import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';

import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_value.dart';

class StockHeadResponse {
  List<StockHeadValue>? values;
  NewPagination? pagination;

  StockHeadResponse({this.values, this.pagination});

  factory StockHeadResponse.fromRawJson(String str) =>
      StockHeadResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHeadResponse.fromJson(Map<String, dynamic> json) =>
      StockHeadResponse(
        values:
            json["values"] == null
                ? []
                : List<StockHeadValue>.from(
                  json["values"]!.map((x) => StockHeadValue.fromJson(x)),
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

class MetalType {
  String? id;
  String? typeName;

  MetalType({this.id, this.typeName});

  factory MetalType.fromRawJson(String str) =>
      MetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalType.fromJson(Map<String, dynamic> json) =>
      MetalType(id: json["id"], typeName: json["type_name"]);

  Map<String, dynamic> toJson() => {"id": id, "type_name": typeName};
}
