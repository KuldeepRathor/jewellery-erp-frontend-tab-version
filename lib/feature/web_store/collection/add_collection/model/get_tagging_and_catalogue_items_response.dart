import 'dart:convert';

class GetTaggingAndCatalogItemsReponse {
  List<GetTaggingAndCatalogItem>? items;

  GetTaggingAndCatalogItemsReponse({
    this.items,
  });

  factory GetTaggingAndCatalogItemsReponse.fromRawJson(String str) =>
      GetTaggingAndCatalogItemsReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingAndCatalogItemsReponse.fromJson(
          Map<String, dynamic> json) =>
      GetTaggingAndCatalogItemsReponse(
        items: json["items"] == null
            ? []
            : List<GetTaggingAndCatalogItem>.from(json["items"]!
                .map((x) => GetTaggingAndCatalogItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class GetTaggingAndCatalogItem {
  String? id;
  String? name;
  String? barcode;
  List<GetTaggingAndCatalogItemsImage>? images;
  String? weightRange;
  String? grossWeight;
  String? netWeight;
  bool? stoneAvailable;
  List<String>? purity;
  List<String>? gemstones;
  List<String>? metalColours;
  bool? isSelected;
  String? type;

  GetTaggingAndCatalogItem({
    this.id,
    this.name,
    this.barcode,
    this.images,
    this.weightRange,
    this.grossWeight,
    this.netWeight,
    this.stoneAvailable,
    this.purity,
    this.gemstones,
    this.metalColours,
    this.isSelected,
    this.type,
  });

  factory GetTaggingAndCatalogItem.fromRawJson(String str) =>
      GetTaggingAndCatalogItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingAndCatalogItem.fromJson(Map<String, dynamic> json) =>
      GetTaggingAndCatalogItem(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
        images: json["images"] == null
            ? []
            : List<GetTaggingAndCatalogItemsImage>.from(json["images"]!
                .map((x) => GetTaggingAndCatalogItemsImage.fromJson(x))),
        weightRange: json["weight_range"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneAvailable: json["stone_available"],
        purity: json["purity"] == null
            ? []
            : List<String>.from(json["purity"]!.map((x) => x)),
        gemstones: json["gemstones"] == null
            ? []
            : List<String>.from(json["gemstones"]!.map((x) => x)),
        metalColours: json["metal_colours"] == null
            ? []
            : List<String>.from(json["metal_colours"]!.map((x) => x)),
        isSelected: json["is_selected"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "weight_range": weightRange,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stone_available": stoneAvailable,
        "purity":
            purity == null ? [] : List<dynamic>.from(purity!.map((x) => x)),
        "gemstones": gemstones == null
            ? []
            : List<dynamic>.from(gemstones!.map((x) => x)),
        "metal_colours": metalColours == null
            ? []
            : List<dynamic>.from(metalColours!.map((x) => x)),
        "is_selected": isSelected,
        "type": type,
      };
}

class GetTaggingAndCatalogItemsImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  GetTaggingAndCatalogItemsImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory GetTaggingAndCatalogItemsImage.fromRawJson(String str) =>
      GetTaggingAndCatalogItemsImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingAndCatalogItemsImage.fromJson(Map<String, dynamic> json) =>
      GetTaggingAndCatalogItemsImage(
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
