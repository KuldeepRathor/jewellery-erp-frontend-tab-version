import 'dart:convert';

class CollectionImagesPresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<CollectionImagesPresignedUrlImage>? images;

  CollectionImagesPresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory CollectionImagesPresignedUrlRequest.fromRawJson(String str) =>
      CollectionImagesPresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CollectionImagesPresignedUrlRequest.fromJson(
          Map<String, dynamic> json) =>
      CollectionImagesPresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<CollectionImagesPresignedUrlImage>.from(json["images"]!
                .map((x) => CollectionImagesPresignedUrlImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "service": service,
        "group": group,
        "group_id": groupId,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class CollectionImagesPresignedUrlImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CollectionImagesPresignedUrlImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CollectionImagesPresignedUrlImage.fromRawJson(String str) =>
      CollectionImagesPresignedUrlImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CollectionImagesPresignedUrlImage.fromJson(
          Map<String, dynamic> json) =>
      CollectionImagesPresignedUrlImage(
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
