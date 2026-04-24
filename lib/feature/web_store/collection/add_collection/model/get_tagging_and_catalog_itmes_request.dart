import 'dart:convert';

class GetTaggingAndCatalogItemsRequest {
  List<String>? designIds;
  List<String>? categoryIds;
  List<String>? webOnlyStockIds;

  GetTaggingAndCatalogItemsRequest({
    this.designIds,
    this.categoryIds,
    this.webOnlyStockIds,
  });

  factory GetTaggingAndCatalogItemsRequest.fromRawJson(String str) =>
      GetTaggingAndCatalogItemsRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingAndCatalogItemsRequest.fromJson(
          Map<String, dynamic> json) =>
      GetTaggingAndCatalogItemsRequest(
        designIds: json["design_ids"] == null
            ? []
            : List<String>.from(json["design_ids"]!.map((x) => x)),
        categoryIds: json["category_ids"] == null
            ? []
            : List<String>.from(json["category_ids"]!.map((x) => x)),
        webOnlyStockIds: json["web_only_stock_ids"] == null
            ? []
            : List<String>.from(json["web_only_stock_ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "design_ids": designIds == null
            ? []
            : List<dynamic>.from(designIds!.map((x) => x)),
        "category_ids": categoryIds == null
            ? []
            : List<dynamic>.from(categoryIds!.map((x) => x)),
        "web_only_stock_ids": webOnlyStockIds == null
            ? []
            : List<dynamic>.from(webOnlyStockIds!.map((x) => x)),
      };
}
