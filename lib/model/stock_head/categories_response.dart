import 'dart:convert';

class CategoriesResponse {
  String? id;
  String? categoryName;

  CategoriesResponse({
    this.id,
    this.categoryName,
  });

  factory CategoriesResponse.fromRawJson(String str) =>
      CategoriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}
