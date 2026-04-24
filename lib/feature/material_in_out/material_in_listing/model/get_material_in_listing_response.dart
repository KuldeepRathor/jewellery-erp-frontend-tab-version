import 'dart:convert';

class GetMaterialInListingResponse {
  List<GetMaterialInListingValue>? values;
  Pagination? pagination;

  GetMaterialInListingResponse({
    this.values,
    this.pagination,
  });

  factory GetMaterialInListingResponse.fromRawJson(String str) =>
      GetMaterialInListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMaterialInListingResponse.fromJson(Map<String, dynamic> json) =>
      GetMaterialInListingResponse(
        values: json["values"] == null
            ? []
            : List<GetMaterialInListingValue>.from(json["values"]!
                .map((x) => GetMaterialInListingValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  dynamic next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class GetMaterialInListingValue {
  String? id;
  String? organizationId;
  String? partyType;
  String? partyId;
  String? partyName;
  String? partyCode;
  String? partyAddress;
  String? partyGst;
  String? invoiceNumber;
  String? partyInvoiceNumber;
  String? remark;
  List<LineItem>? lineItems;

  GetMaterialInListingValue({
    this.id,
    this.organizationId,
    this.partyType,
    this.partyId,
    this.partyName,
    this.partyCode,
    this.partyAddress,
    this.partyGst,
    this.invoiceNumber,
    this.partyInvoiceNumber,
    this.remark,
    this.lineItems,
  });

  factory GetMaterialInListingValue.fromRawJson(String str) =>
      GetMaterialInListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMaterialInListingValue.fromJson(Map<String, dynamic> json) =>
      GetMaterialInListingValue(
        id: json["id"],
        organizationId: json["organization_id"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyCode: json["party_code"],
        partyAddress: json["party_address"],
        partyGst: json["party_gst"],
        invoiceNumber: json["invoice_number"],
        partyInvoiceNumber: json["party_invoice_number"],
        remark: json["remark"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "party_type": partyType,
        "party_id": partyId,
        "party_name": partyName,
        "party_code": partyCode,
        "party_address": partyAddress,
        "party_gst": partyGst,
        "invoice_number": invoiceNumber,
        "party_invoice_number": partyInvoiceNumber,
        "remark": remark,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? id;
  String? organizationId;
  String? code;
  String? itemDescription;
  int? pieces;
  String? grossWeight;
  String? less;
  String? netWeight;
  String? va;
  dynamic tch;
  String? mc;
  String? stone;
  String? rate;
  String? amount;

  LineItem({
    this.id,
    this.organizationId,
    this.code,
    this.itemDescription,
    this.pieces,
    this.grossWeight,
    this.less,
    this.netWeight,
    this.va,
    this.tch,
    this.mc,
    this.stone,
    this.rate,
    this.amount,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        code: json["code"],
        itemDescription: json["item_description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        less: json["less"],
        netWeight: json["net_weight"],
        va: json["va"],
        tch: json["tch"],
        mc: json["mc"],
        stone: json["stone"],
        rate: json["rate"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "code": code,
        "item_description": itemDescription,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "less": less,
        "net_weight": netWeight,
        "va": va,
        "tch": tch,
        "mc": mc,
        "stone": stone,
        "rate": rate,
        "amount": amount,
      };
}
