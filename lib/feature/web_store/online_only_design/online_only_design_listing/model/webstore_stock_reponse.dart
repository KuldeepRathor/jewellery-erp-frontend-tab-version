import 'dart:convert';

class WebstoreStockResponse {
  List<WebstoreStockValue>? values;
  Pagination? pagination;

  WebstoreStockResponse({
    this.values,
    this.pagination,
  });

  factory WebstoreStockResponse.fromRawJson(String str) =>
      WebstoreStockResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebstoreStockResponse.fromJson(Map<String, dynamic> json) =>
      WebstoreStockResponse(
        values: json["values"] == null
            ? []
            : List<WebstoreStockValue>.from(
                json["values"]!.map((x) => WebstoreStockValue.fromJson(x))),
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
  dynamic nextPage;
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

class WebstoreStockValue {
  String? id;
  String? title;
  String? description;
  StockHead? stockHead;
  Ornament? ornament;
  List<Image>? images;
  List<LineItem>? lineItems;

  WebstoreStockValue({
    this.id,
    this.title,
    this.description,
    this.stockHead,
    this.ornament,
    this.images,
    this.lineItems,
  });

  factory WebstoreStockValue.fromRawJson(String str) =>
      WebstoreStockValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebstoreStockValue.fromJson(Map<String, dynamic> json) =>
      WebstoreStockValue(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        stockHead: json["stock_head"] == null
            ? null
            : StockHead.fromJson(json["stock_head"]),
        ornament: json["ornament"] == null
            ? null
            : Ornament.fromJson(json["ornament"]),
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "stock_head": stockHead?.toJson(),
        "ornament": ornament?.toJson(),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? id;
  String? webstoreOnlyStockId;
  String? purity;
  String? weight;
  String? size;
  String? amount;
  int? totalPieces;
  int? soldPieces;
  int? currentPieces;
  dynamic editHistory;

  LineItem({
    this.id,
    this.webstoreOnlyStockId,
    this.purity,
    this.weight,
    this.size,
    this.amount,
    this.totalPieces,
    this.soldPieces,
    this.currentPieces,
    this.editHistory,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        webstoreOnlyStockId: json["webstore_only_stock_id"],
        purity: json["purity"],
        weight: json["weight"],
        size: json["size"],
        amount: json["amount"],
        totalPieces: json["total_pieces"],
        soldPieces: json["sold_pieces"],
        currentPieces: json["current_pieces"],
        editHistory: json["edit_history"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "webstore_only_stock_id": webstoreOnlyStockId,
        "purity": purity,
        "weight": weight,
        "size": size,
        "amount": amount,
        "total_pieces": totalPieces,
        "sold_pieces": soldPieces,
        "current_pieces": currentPieces,
        "edit_history": editHistory,
      };
}

class Ornament {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  String? hsnSac;
  OrnamentMetalType? metalType;
  String? openingWeight;
  String? openingAmount;
  int? openingQuantity;
  String? gst;
  DateTime? createdAt;
  bool? isStone;
  bool? isOldGold;
  bool? isService;
  String? purity;

  Ornament({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.hsnSac,
    this.metalType,
    this.openingWeight,
    this.openingAmount,
    this.openingQuantity,
    this.gst,
    this.createdAt,
    this.isStone,
    this.isOldGold,
    this.isService,
    this.purity,
  });

  factory Ornament.fromRawJson(String str) =>
      Ornament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ornament.fromJson(Map<String, dynamic> json) => Ornament(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        hsnSac: json["hsn_sac"],
        metalType: json["metal_type"] == null
            ? null
            : OrnamentMetalType.fromJson(json["metal_type"]),
        openingWeight: json["opening_weight"],
        openingAmount: json["opening_amount"],
        openingQuantity: json["opening_quantity"],
        gst: json["gst"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isStone: json["is_stone"],
        isOldGold: json["is_old_gold"],
        isService: json["is_service"],
        purity: json["purity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "organization_id": organizationId,
        "hsn_sac": hsnSac,
        "metal_type": metalType?.toJson(),
        "opening_weight": openingWeight,
        "opening_amount": openingAmount,
        "opening_quantity": openingQuantity,
        "gst": gst,
        "created_at": createdAt?.toIso8601String(),
        "is_stone": isStone,
        "is_old_gold": isOldGold,
        "is_service": isService,
        "purity": purity,
      };
}

class OrnamentMetalType {
  String? id;
  String? typeName;
  String? codeType;

  OrnamentMetalType({
    this.id,
    this.typeName,
    this.codeType,
  });

  factory OrnamentMetalType.fromRawJson(String str) =>
      OrnamentMetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrnamentMetalType.fromJson(Map<String, dynamic> json) =>
      OrnamentMetalType(
        id: json["id"],
        typeName: json["type_name"],
        codeType: json["code_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
        "code_type": codeType,
      };
}

class StockHead {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  Category? category;
  bool? isNetWeight;
  dynamic hallmarkExtraCharge;
  StockHeadMetalType? metalType;
  bool? sizeRequired;
  List<dynamic>? weightGroups;
  List<dynamic>? sizeGroups;

  StockHead({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.category,
    this.isNetWeight,
    this.hallmarkExtraCharge,
    this.metalType,
    this.sizeRequired,
    this.weightGroups,
    this.sizeGroups,
  });

  factory StockHead.fromRawJson(String str) =>
      StockHead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHead.fromJson(Map<String, dynamic> json) => StockHead(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        organizationId: json["organization_id"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        isNetWeight: json["is_net_weight"],
        hallmarkExtraCharge: json["hallmark_extra_charge"],
        metalType: json["metal_type"] == null
            ? null
            : StockHeadMetalType.fromJson(json["metal_type"]),
        sizeRequired: json["size_required"],
        weightGroups: json["weight_groups"] == null
            ? []
            : List<dynamic>.from(json["weight_groups"]!.map((x) => x)),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<dynamic>.from(json["size_groups"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "organization_id": organizationId,
        "category": category?.toJson(),
        "is_net_weight": isNetWeight,
        "hallmark_extra_charge": hallmarkExtraCharge,
        "metal_type": metalType?.toJson(),
        "size_required": sizeRequired,
        "weight_groups": weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x)),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x)),
      };
}

class Category {
  String? id;
  String? categoryName;
  bool? isWebstore;
  dynamic isHomePage;
  List<Image>? images;

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
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "is_webstore": isWebstore,
        "is_home_page": isHomePage,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Image {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  Image({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3Key,
        "presigned_url": presignedUrl,
        "is_webstore": isWebstore,
      };
}

class StockHeadMetalType {
  String? id;
  String? typeName;

  StockHeadMetalType({
    this.id,
    this.typeName,
  });

  factory StockHeadMetalType.fromRawJson(String str) =>
      StockHeadMetalType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHeadMetalType.fromJson(Map<String, dynamic> json) =>
      StockHeadMetalType(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
      };
}
