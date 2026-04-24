import 'dart:convert';

class CreateCatalogueRequest {
  String? designName;
  String? design;
  double? minWeight;
  double? maxWeight;
  double? rate;
  List<MetalColour>? metalColour;
  List<Purity>? purity;
  double? stoneWeight;
  String? stoneRateType;
  bool? isWebstore;
  List<Gemstone>? gemstones;
  List<CreateCatalogueImage>? images;
  List<Collection>? collections;

  CreateCatalogueRequest({
    this.designName,
    this.design,
    this.minWeight,
    this.maxWeight,
    this.rate,
    this.metalColour,
    this.purity,
    this.stoneWeight,
    this.stoneRateType,
    this.isWebstore,
    this.gemstones,
    this.images,
    this.collections,
  });

  factory CreateCatalogueRequest.fromRawJson(String str) =>
      CreateCatalogueRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCatalogueRequest.fromJson(Map<String, dynamic> json) =>
      CreateCatalogueRequest(
        designName: json["design_name"],
        design: json["design"],
        minWeight: json["min_weight"]?.toDouble(),
        maxWeight: json["max_weight"]?.toDouble(),
        rate: json["rate"]?.toDouble(),
        metalColour: json["metal_colour"] == null
            ? []
            : List<MetalColour>.from(
                json["metal_colour"]!.map((x) => MetalColour.fromJson(x))),
        purity: json["purity"] == null
            ? []
            : List<Purity>.from(json["purity"]!.map((x) => Purity.fromJson(x))),
        stoneWeight: json["stone_weight"]?.toDouble(),
        stoneRateType: json["stone_rate_type"],
        isWebstore: json["is_webstore"],
        gemstones: json["gemstones"] == null
            ? []
            : List<Gemstone>.from(
                json["gemstones"]!.map((x) => Gemstone.fromJson(x))),
        images: json["images"] == null
            ? []
            : List<CreateCatalogueImage>.from(
                json["images"]!.map((x) => CreateCatalogueImage.fromJson(x))),
        collections: json["collections"] == null
            ? []
            : List<Collection>.from(
                json["collections"]!.map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "design_name": designName,
        "design": design,
        "min_weight": minWeight,
        "max_weight": maxWeight,
        "rate": rate,
        "metal_colour": metalColour == null
            ? []
            : List<dynamic>.from(metalColour!.map((x) => x.toJson())),
        "purity": purity == null
            ? []
            : List<dynamic>.from(purity!.map((x) => x.toJson())),
        "stone_weight": stoneWeight,
        "stone_rate_type": stoneRateType,
        "is_webstore": isWebstore,
        "gemstones": gemstones == null
            ? []
            : List<dynamic>.from(gemstones!.map((x) => x.toJson())),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "collections": collections == null
            ? []
            : List<dynamic>.from(collections!.map((x) => x.toJson())),
      };
}

class Collection {
  String? collectionId;

  Collection({
    this.collectionId,
  });

  factory Collection.fromRawJson(String str) =>
      Collection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        collectionId: json["collection_id"],
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
      };
}

class Gemstone {
  String? gemstoneId;

  Gemstone({
    this.gemstoneId,
  });

  factory Gemstone.fromRawJson(String str) =>
      Gemstone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gemstone.fromJson(Map<String, dynamic> json) => Gemstone(
        gemstoneId: json["gemstone_id"],
      );

  Map<String, dynamic> toJson() => {
        "gemstone_id": gemstoneId,
      };
}

class CreateCatalogueImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CreateCatalogueImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CreateCatalogueImage.fromRawJson(String str) =>
      CreateCatalogueImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCatalogueImage.fromJson(Map<String, dynamic> json) =>
      CreateCatalogueImage(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3Key,
        "presigned_url": presignedUrl,
      };
}

class MetalColour {
  String? colourId;

  MetalColour({
    this.colourId,
  });

  factory MetalColour.fromRawJson(String str) =>
      MetalColour.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetalColour.fromJson(Map<String, dynamic> json) => MetalColour(
        colourId: json["colour_id"],
      );

  Map<String, dynamic> toJson() => {
        "colour_id": colourId,
      };
}

class Purity {
  String? purityType;

  Purity({
    this.purityType,
  });

  factory Purity.fromRawJson(String str) => Purity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Purity.fromJson(Map<String, dynamic> json) => Purity(
        purityType: json["purity_type"],
      );

  Map<String, dynamic> toJson() => {
        "purity_type": purityType,
      };
}
