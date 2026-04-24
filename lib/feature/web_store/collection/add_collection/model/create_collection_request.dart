import 'dart:convert';

class CreateCollectionRequest {
  String? collectionName;
  String? organizationId;
  String? shopId;
  bool? isWebstore;
  List<String>? category;
  List<String>? design;
  List<String>? taggingItems;
  List<String>? webstoreItems;
  List<String>? catalog;

  CreateCollectionRequest({
    this.collectionName,
    this.organizationId,
    this.shopId,
    this.isWebstore,
    this.category,
    this.design,
    this.taggingItems,
    this.webstoreItems,
    this.catalog,
  });

  factory CreateCollectionRequest.fromRawJson(String str) =>
      CreateCollectionRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCollectionRequest.fromJson(Map<String, dynamic> json) =>
      CreateCollectionRequest(
        collectionName: json["collection_name"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        isWebstore: json["is_webstore"],
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
        design: json["design"] == null
            ? []
            : List<String>.from(json["design"]!.map((x) => x)),
        taggingItems: json["tagging_items"] == null
            ? []
            : List<String>.from(json["tagging_items"]!.map((x) => x)),
        webstoreItems: json["webstore_items"] == null
            ? []
            : List<String>.from(json["webstore_items"]!.map((x) => x)),
        catalog: json["catalog"] == null
            ? []
            : List<String>.from(json["catalog"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "collection_name": collectionName,
        "organization_id": organizationId,
        "shop_id": shopId,
        "is_webstore": isWebstore,
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "design":
            design == null ? [] : List<dynamic>.from(design!.map((x) => x)),
        "tagging_items": taggingItems == null
            ? []
            : List<dynamic>.from(taggingItems!.map((x) => x)),
        "webstore_items": webstoreItems == null
            ? []
            : List<dynamic>.from(webstoreItems!.map((x) => x)),
        "catalog":
            catalog == null ? [] : List<dynamic>.from(catalog!.map((x) => x)),
      };
}
