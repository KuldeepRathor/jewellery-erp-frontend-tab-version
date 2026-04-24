import 'dart:convert';

class StockHeadCategory {
  String? id;
  String? categoryName;

  StockHeadCategory({
    this.id,
    this.categoryName,
  });

  factory StockHeadCategory.fromRawJson(String str) =>
      StockHeadCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHeadCategory.fromJson(Map<String, dynamic> json) =>
      StockHeadCategory(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}
