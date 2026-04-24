import 'dart:convert';

class GetStockHeadDropdownResponse {
  List<GetStockHeadDropdownValue>? values;
  Pagination? pagination;

  GetStockHeadDropdownResponse({
    this.values,
    this.pagination,
  });

  factory GetStockHeadDropdownResponse.fromRawJson(String str) =>
      GetStockHeadDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStockHeadDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetStockHeadDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetStockHeadDropdownValue>.from(json["values"]!
                .map((x) => GetStockHeadDropdownValue.fromJson(x))),
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
  int? totalPages;
  int? currentPage;
  int? nextPage;
  dynamic previousPage;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        previousPage: json["previous_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "total_pages": totalPages,
        "current_page": currentPage,
        "next_page": nextPage,
        "previous_page": previousPage,
      };
}

class GetStockHeadDropdownValue {
  String? id;
  String? name;
  String? code;
  Category? category;
  MetalType? metalType;

  GetStockHeadDropdownValue({
    this.id,
    this.name,
    this.code,
    this.category,
    this.metalType,
  });

  factory GetStockHeadDropdownValue.fromRawJson(String str) =>
      GetStockHeadDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStockHeadDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetStockHeadDropdownValue(
        id: json["id"],
        name: json["name"],
        code: json["code"],
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
        "category": category?.toJson(),
        "metal_type": metalType?.toJson(),
      };
}

class Category {
  String? id;
  String? categoryName;
  bool? isWebstore;
  dynamic isHomePage;
  List<dynamic>? images;

  Category({
    this.id,
    this.categoryName,
    this.isWebstore,
    this.isHomePage,
    this.images,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        isWebstore: json["is_webstore"],
        isHomePage: json["is_home_page"],
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "is_webstore": isWebstore,
        "is_home_page": isHomePage,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}

class MetalType {
  String? id;
  String? typeName;

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
