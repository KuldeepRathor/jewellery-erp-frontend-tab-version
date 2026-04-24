import 'dart:convert';

class GetAllCollectionsResponse {
  List<GetAllCollectionsValue>? values;

  GetAllCollectionsResponse({
    this.values,
  });

  factory GetAllCollectionsResponse.fromRawJson(String str) =>
      GetAllCollectionsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCollectionsResponse.fromJson(Map<String, dynamic> json) =>
      GetAllCollectionsResponse(
        values: json["values"] == null
            ? []
            : List<GetAllCollectionsValue>.from(
                json["values"]!.map((x) => GetAllCollectionsValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllCollectionsValue {
  String? id;
  String? collectionName;
  bool? isWebstore;
  String? categories;
  int? totalDesign;
  int? totalItem;

  GetAllCollectionsValue({
    this.id,
    this.collectionName,
    this.isWebstore,
    this.categories,
    this.totalDesign,
    this.totalItem,
  });

  factory GetAllCollectionsValue.fromRawJson(String str) =>
      GetAllCollectionsValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCollectionsValue.fromJson(Map<String, dynamic> json) =>
      GetAllCollectionsValue(
        id: json["id"],
        collectionName: json["collection_name"],
        isWebstore: json["is_webstore"],
        categories: json["categories"],
        totalDesign: json["total_design"],
        totalItem: json["total_item"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collection_name": collectionName,
        "is_webstore": isWebstore,
        "categories": categories,
        "total_design": totalDesign,
        "total_item": totalItem,
      };
}
