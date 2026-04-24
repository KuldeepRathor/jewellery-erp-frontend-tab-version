import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/model/get_lot_entries_response.dart';

class GetLotEntriesByIdResponse {
  String? id;
  DateTime? createdAt;
  String? lotEntryNumber;
  String? vendorId;
  String? vendorName;
  int? pieces;
  String? netWeight;
  String? grossWeight;
  String? transactionType;
  String? invoiceNumber;
  List<LotPurity>? lotPurity;
  dynamic status;
  dynamic recordNumber;
  dynamic taggingValues;
  dynamic differenceValues;

  GetLotEntriesByIdResponse({
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
  });

  factory GetLotEntriesByIdResponse.fromRawJson(String str) =>
      GetLotEntriesByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLotEntriesByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetLotEntriesByIdResponse(
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
        recordNumber: json["record_number"],
        taggingValues: json["tagging_values"],
        differenceValues: json["difference_values"],
        vendorName: json["vendor_name"],
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
    "record_number": recordNumber,
    "tagging_values": taggingValues,
    "difference_values": differenceValues,
    "vendor_name": vendorName,
  };
}
