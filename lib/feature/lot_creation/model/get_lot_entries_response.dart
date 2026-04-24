import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';

class GetLotEntriesResponse {
  List<GetLotEntriesValue>? values;
  NewPagination? pagination;

  GetLotEntriesResponse({this.values, this.pagination});

  factory GetLotEntriesResponse.fromRawJson(String str) =>
      GetLotEntriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLotEntriesResponse.fromJson(Map<String, dynamic> json) =>
      GetLotEntriesResponse(
        values:
            json["values"] == null
                ? []
                : List<GetLotEntriesValue>.from(
                  json["values"]!.map((x) => GetLotEntriesValue.fromJson(x)),
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

class GetLotEntriesValue {
  String? id;
  DateTime? createdAt;
  String? lotEntryNumber;
  String? vendorId;
  int? pieces;
  String? netWeight;
  String? grossWeight;
  String? transactionType;
  String? invoiceNumber;
  List<LotPurity>? lotPurity;
  String? status;
  List<String>? recordNumber;
  Values? taggingValues;
  Values? differenceValues;
  String? vendorName;
  String? vendor_code;

  GetLotEntriesValue({
    this.id,
    this.createdAt,
    this.lotEntryNumber,
    this.vendorId,
    this.pieces,
    this.netWeight,
    this.grossWeight,
    this.transactionType,
    this.invoiceNumber,
    this.lotPurity,
    this.status,
    this.recordNumber,
    this.taggingValues,
    this.differenceValues,
    this.vendorName,
    this.vendor_code,
  });

  factory GetLotEntriesValue.fromRawJson(String str) =>
      GetLotEntriesValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLotEntriesValue.fromJson(Map<String, dynamic> json) =>
      GetLotEntriesValue(
        id: json["id"],
        createdAt:
            json["created_at"] == null
                ? null
                : DateTime.parse(json["created_at"]),
        lotEntryNumber: json["lot_entry_number"],
        vendorId: json["vendor_id"],
        pieces: json["pieces"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        transactionType: json["transaction_type"],
        invoiceNumber: json["invoice_number"],
        lotPurity:
            json["lot_purity"] == null
                ? []
                : List<LotPurity>.from(
                  json["lot_purity"]!.map((x) => LotPurity.fromJson(x)),
                ),
        status: json["status"],
        recordNumber:
            json["record_number"] == null
                ? []
                : List<String>.from(json["record_number"].map((x) => x)),
        taggingValues:
            json["tagging_values"] == null
                ? null
                : Values.fromJson(json["tagging_values"]),
        differenceValues:
            json["difference_values"] == null
                ? null
                : Values.fromJson(json["difference_values"]),
        vendorName: json["vendor_name"],
        vendor_code: json["vendor_code"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "lot_entry_number": lotEntryNumber,
    "vendor_id": vendorId,
    "pieces": pieces,
    "net_weight": netWeight,
    "gross_weight": grossWeight,
    "transaction_type": transactionType,
    "invoice_number": invoiceNumber,
    "lot_purity":
        lotPurity == null
            ? []
            : List<dynamic>.from(lotPurity!.map((x) => x.toJson())),
    "status": status,
    "record_number":
        recordNumber == null
            ? []
            : List<dynamic>.from(recordNumber!.map((x) => x)),
    "tagging_values": taggingValues?.toJson(),
    "difference_values": differenceValues?.toJson(),
    "vendor_name": vendorName,
    "vendor_code": vendor_code,
  };
}

class Values {
  int? pieces;
  String? netWeight;
  String? grossWeight;

  Values({this.pieces, this.netWeight, this.grossWeight});

  factory Values.fromRawJson(String str) => Values.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Values.fromJson(Map<String, dynamic> json) => Values(
    pieces: json["pieces"],
    netWeight: json["net_weight"],
    grossWeight: json["gross_weight"],
  );

  Map<String, dynamic> toJson() => {
    "pieces": pieces,
    "net_weight": netWeight,
    "gross_weight": grossWeight,
  };
}

class LotPurity {
  String? id;
  String? purityType;

  LotPurity({this.id, this.purityType});

  factory LotPurity.fromRawJson(String str) =>
      LotPurity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LotPurity.fromJson(Map<String, dynamic> json) =>
      LotPurity(id: json["id"], purityType: json["purity_type"]);

  Map<String, dynamic> toJson() => {"id": id, "purity_type": purityType};
}
