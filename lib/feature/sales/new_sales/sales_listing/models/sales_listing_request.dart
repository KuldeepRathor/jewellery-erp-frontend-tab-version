import 'dart:convert';

class SalesListingRequest {
  SalesFilters? filters;

  SalesListingRequest({
    this.filters,
  });

  factory SalesListingRequest.fromRawJson(String str) =>
      SalesListingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesListingRequest.fromJson(Map<String, dynamic> json) =>
      SalesListingRequest(
        filters: json["filters"] == null
            ? null
            : SalesFilters.fromJson(json["filters"]),
      );

  Map<String, dynamic> toJson() => {
        "filters": filters?.toJson(),
      };
}

class SalesFilters {
  List<String>? metalType;
  DateTime? dateFrom;
  DateTime? dateTo;
  String? paymentStatus;
  String? itemStatus;
  List<String>? stockHead;
  List<String>? design;
  String? invoiceStatus;
  List<String>? branch;
  List<String>? partyId;

  SalesFilters({
    this.metalType,
    this.dateFrom,
    this.dateTo,
    this.paymentStatus,
    this.itemStatus,
    this.stockHead,
    this.design,
    this.invoiceStatus,
    this.branch,
    this.partyId,
  });

  factory SalesFilters.fromRawJson(String str) =>
      SalesFilters.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesFilters.fromJson(Map<String, dynamic> json) => SalesFilters(
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
        dateFrom: json["date_from"] == null
            ? null
            : DateTime.parse(json["date_from"]),
        dateTo:
            json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
        paymentStatus: json["payment_status"],
        itemStatus: json["item_status"],
        stockHead: json["stock_head"] == null
            ? []
            : List<String>.from(json["stock_head"]!.map((x) => x)),
        design: json["design"] == null
            ? []
            : List<String>.from(json["design"]!.map((x) => x)),
        invoiceStatus: json["invoice_status"],
        branch: json["branch"] == null
            ? []
            : List<String>.from(json["branch"]!.map((x) => x)),
        partyId: json["party_id"] == null
            ? []
            : List<String>.from(json["party_id"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
        "date_from": dateFrom?.toIso8601String(),
        "date_to": dateTo?.toIso8601String(),
        "payment_status": paymentStatus,
        "item_status": itemStatus,
        "stock_head": stockHead == null
            ? []
            : List<dynamic>.from(stockHead!.map((x) => x)),
        "design":
            design == null ? [] : List<dynamic>.from(design!.map((x) => x)),
        "invoice_status": invoiceStatus,
        "branch":
            branch == null ? [] : List<dynamic>.from(branch!.map((x) => x)),
        "party_id":
            partyId == null ? [] : List<dynamic>.from(partyId!.map((x) => x)),
      };
}
