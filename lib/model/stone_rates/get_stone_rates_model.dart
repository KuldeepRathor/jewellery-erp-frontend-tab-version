import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';

class GetStoneRatesResponse {
  List<GetStoneRatesValue>? values;
  NewPagination? pagination;

  GetStoneRatesResponse({this.values, this.pagination});

  factory GetStoneRatesResponse.fromRawJson(String str) =>
      GetStoneRatesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStoneRatesResponse.fromJson(Map<String, dynamic> json) =>
      GetStoneRatesResponse(
        values:
            json["values"] == null
                ? []
                : List<GetStoneRatesValue>.from(
                  json["values"]!.map((x) => GetStoneRatesValue.fromJson(x)),
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

class GetStoneRatesValue {
  String? id;
  String? code;
  String? name;
  String? rateType;
  String? rate;
  String? color;
  String? cut;
  String? clarity;
  String? buyBackPercentage;
  GetAllOrnamentsResponseValue? ornament;
  bool? isOther;
  GetStoneRatesValue({
    this.id,
    this.code,
    this.name,
    this.rateType,
    this.rate,
    this.color,
    this.cut,
    this.clarity,
    this.buyBackPercentage,
    this.ornament,
    this.isOther,
  });

  factory GetStoneRatesValue.fromRawJson(String str) =>
      GetStoneRatesValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStoneRatesValue.fromJson(Map<String, dynamic> json) =>
      GetStoneRatesValue(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        rateType: json["rate_type"],
        rate: json["rate"],
        color: json["color"],
        cut: json["cut"],
        clarity: json["clarity"],
        buyBackPercentage: json["buy_back_percentage"],
        ornament:
            json["ornament"] == null
                ? null
                : GetAllOrnamentsResponseValue.fromJson(json["ornament"]),
        isOther: json["is_other"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "rate_type": rateType,
    "rate": rate,
    "color": color,
    "cut": cut,
    "clarity": clarity,
    "buy_back_percentage": buyBackPercentage,
    "ornament": ornament?.toJson(),
    "is_other": isOther,
  };
}
