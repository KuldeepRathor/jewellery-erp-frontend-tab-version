import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';

class GetLotEntriesDropdownResponse {
  List<GetLotEntriesDropdownValue>? values;
  NewPagination? pagination;

  GetLotEntriesDropdownResponse({this.values, this.pagination});

  factory GetLotEntriesDropdownResponse.fromRawJson(String str) =>
      GetLotEntriesDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLotEntriesDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetLotEntriesDropdownResponse(
        values:
            json["values"] == null
                ? []
                : List<GetLotEntriesDropdownValue>.from(
                  json["values"]!.map(
                    (x) => GetLotEntriesDropdownValue.fromJson(x),
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

class GetLotEntriesDropdownValue {
  String? id;
  DateTime? createdAt;
  String? lotEntryNumber;
  String? netWeight;
  String? grossWeight;
  List<String>? purityTypes;
  String? vendorId;
  String? vendorCode;

  GetLotEntriesDropdownValue({
    this.id,
    this.createdAt,
    this.lotEntryNumber,
    this.netWeight,
    this.grossWeight,
    this.purityTypes,
    this.vendorId,
    this.vendorCode,
  });

  factory GetLotEntriesDropdownValue.fromRawJson(String str) =>
      GetLotEntriesDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLotEntriesDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetLotEntriesDropdownValue(
        id: json["id"],
        createdAt:
            json["created_at"] == null
                ? null
                : DateTime.parse(json["created_at"]),
        lotEntryNumber: json["lot_entry_number"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        purityTypes:
            json["purity_types"] == null
                ? []
                : List<String>.from(json["purity_types"]!.map((x) => x)),
        vendorId: json["vendor_id"],
        vendorCode: json["vendor_code"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "lot_entry_number": lotEntryNumber,
    "net_weight": netWeight,
    "gross_weight": grossWeight,
    "purity_types":
        purityTypes == null
            ? []
            : List<dynamic>.from(purityTypes!.map((x) => x)),
    "vendor_id": vendorId,
    "vendor_name": vendorCode,
  };
}
