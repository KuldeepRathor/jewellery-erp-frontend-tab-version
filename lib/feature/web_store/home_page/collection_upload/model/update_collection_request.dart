import 'dart:convert';

class UpdateCollectionRequest {
  String? id;
  String? collectionName;
  bool? isWebstore;
  List<UpdateCollectionImage>? images;

  UpdateCollectionRequest({
    this.id,
    this.collectionName,
    this.isWebstore,
    this.images,
  });

  factory UpdateCollectionRequest.fromRawJson(String str) =>
      UpdateCollectionRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCollectionRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCollectionRequest(
        id: json["id"],
        collectionName: json["collection_name"],
        isWebstore: json["is_webstore"],
        images: json["images"] == null
            ? []
            : List<UpdateCollectionImage>.from(
                json["images"]!.map((x) => UpdateCollectionImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collection_name": collectionName,
        "is_webstore": isWebstore,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class UpdateCollectionImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateCollectionImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateCollectionImage.fromRawJson(String str) =>
      UpdateCollectionImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCollectionImage.fromJson(Map<String, dynamic> json) =>
      UpdateCollectionImage(
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
