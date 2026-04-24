import 'dart:convert';

class DailyStockResponseModel {
  final String? id;
  final String? code;
  final String? counterName;
  final String? organizationId;
  final bool? isDefault;
  final int? totalItems;
  final String? totalWeight;
  final List<DailyStockResponseModelStockHead>? stockHeads;

  DailyStockResponseModel({
    this.id,
    this.code,
    this.counterName,
    this.organizationId,
    this.isDefault,
    this.totalItems,
    this.totalWeight,
    this.stockHeads,
  });

  factory DailyStockResponseModel.fromRawJson(String str) =>
      DailyStockResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyStockResponseModel.fromJson(Map<String, dynamic> json) =>
      DailyStockResponseModel(
        id: json["id"],
        code: json["code"],
        counterName: json["counter_name"],
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        totalItems: json["total_items"],
        totalWeight: json["total_weight"],
        stockHeads: json["stock_heads"] == null
            ? []
            : List<DailyStockResponseModelStockHead>.from(json["stock_heads"]!
                .map((x) => DailyStockResponseModelStockHead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "counter_name": counterName,
        "organization_id": organizationId,
        "is_default": isDefault,
        "total_items": totalItems,
        "total_weight": totalWeight,
        "stock_heads": stockHeads == null
            ? []
            : List<dynamic>.from(stockHeads!.map((x) => x.toJson())),
      };
}

class DailyStockResponseModelStockHead {
  final String? id;
  final String? name;
  final String? code;
  final int? count;
  final int? manualCount;
  final Category? category;
  final MetalType? metalType;

  DailyStockResponseModelStockHead({
    this.id,
    this.name,
    this.code,
    this.count,
    this.manualCount,
    this.category,
    this.metalType,
  });

  factory DailyStockResponseModelStockHead.fromRawJson(String str) =>
      DailyStockResponseModelStockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyStockResponseModelStockHead.fromJson(
          Map<String, dynamic> json) =>
      DailyStockResponseModelStockHead(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        count: json["count"],
        manualCount: json["manual_count"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        metalType: json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "count": count,
        "manual_count": manualCount,
        "category": category?.toJson(),
        "metal_type": metalType?.toJson(),
      };
}

class Category {
  final String? id;
  final String? categoryName;

  Category({
    this.id,
    this.categoryName,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class MetalType {
  final String? id;
  final String? typeName;

  MetalType({
    this.id,
    this.typeName,
  });

  factory MetalType.fromRawJson(String str) =>
      MetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalType.fromJson(Map<String, dynamic> json) => MetalType(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}
