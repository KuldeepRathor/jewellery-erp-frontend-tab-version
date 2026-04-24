import 'dart:convert';

class GetTaggedItemsReportLimitedResponse {
  List<GetTaggedItemsReportLimitedValue>? values;
  Pagination? pagination;

  GetTaggedItemsReportLimitedResponse({
    this.values,
    this.pagination,
  });

  factory GetTaggedItemsReportLimitedResponse.fromRawJson(String str) =>
      GetTaggedItemsReportLimitedResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsReportLimitedResponse.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsReportLimitedResponse(
        values: json["values"] == null
            ? []
            : List<GetTaggedItemsReportLimitedValue>.from(json["values"]!
                .map((x) => GetTaggedItemsReportLimitedValue.fromJson(x))),
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
  String? next;

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

class GetTaggedItemsReportLimitedValue {
  String? id;
  String? code;
  String? tagBarcode;
  int? tagNumber;
  String? purity;
  String? itemDescription;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  bool? isWebstore;
  String? status;
  String? counterName;
  String? totalLineStone;
  int? imagesCount;

  GetTaggedItemsReportLimitedValue({
    this.id,
    this.code,
    this.tagBarcode,
    this.tagNumber,
    this.purity,
    this.itemDescription,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.isWebstore,
    this.status,
    this.counterName,
    this.totalLineStone,
    this.imagesCount,
  });

  factory GetTaggedItemsReportLimitedValue.fromRawJson(String str) =>
      GetTaggedItemsReportLimitedValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsReportLimitedValue.fromJson(
          Map<String, dynamic> json) =>
      GetTaggedItemsReportLimitedValue(
        id: json["id"],
        code: json["code"],
        tagBarcode: json["tag_barcode"],
        tagNumber: json["tag_number"],
        purity: json["purity"],
        itemDescription: json["item_description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        isWebstore: json["is_webstore"],
        status: json["status"],
        counterName: json["counter_name"],
        totalLineStone: json["total_line_stone"],
        imagesCount: json["images_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "tag_barcode": tagBarcode,
        "tag_number": tagNumber,
        "purity": purity,
        "item_description": itemDescription,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "is_webstore": isWebstore,
        "status": status,
        "counter_name": counterName,
        "total_line_stone": totalLineStone,
        "images_count": imagesCount,
      };
}
