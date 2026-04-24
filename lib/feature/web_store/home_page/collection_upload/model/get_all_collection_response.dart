import 'dart:convert';

class GetAllCollectionResponse {
  List<GetAllCollectionValue>? values;

  GetAllCollectionResponse({
    this.values,
  });

  factory GetAllCollectionResponse.fromRawJson(String str) =>
      GetAllCollectionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCollectionResponse.fromJson(Map<String, dynamic> json) =>
      GetAllCollectionResponse(
        values: json["values"] == null
            ? []
            : List<GetAllCollectionValue>.from(
                json["values"]!.map((x) => GetAllCollectionValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllCollectionValue {
  String? id;
  String? collectionName;
  List<GetAllCollectionImage>? images;
  bool? isWebstore;

  GetAllCollectionValue({
    this.id,
    this.collectionName,
    this.images,
    this.isWebstore,
  });

  factory GetAllCollectionValue.fromRawJson(String str) =>
      GetAllCollectionValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCollectionValue.fromJson(Map<String, dynamic> json) =>
      GetAllCollectionValue(
        id: json["id"],
        collectionName: json["collection_name"],
        images: json["images"] == null
            ? []
            : List<GetAllCollectionImage>.from(json["images"]!.map((x) =>
                GetAllCollectionImage.fromJson(
                    x is Map<String, dynamic> ? x : {}))),
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collection_name": collectionName,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "is_webstore": isWebstore,
      };
}

class GetAllCollectionImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  GetAllCollectionImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory GetAllCollectionImage.fromJson(Map<String, dynamic> json) =>
      GetAllCollectionImage(
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
