import 'dart:convert';

class BannerImagesPresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<BannerImagesPresignedUrlImage>? images;

  BannerImagesPresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory BannerImagesPresignedUrlRequest.fromRawJson(String str) =>
      BannerImagesPresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerImagesPresignedUrlRequest.fromJson(Map<String, dynamic> json) =>
      BannerImagesPresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<BannerImagesPresignedUrlImage>.from(json["images"]!
                .map((x) => BannerImagesPresignedUrlImage.fromJson(x))),
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

class BannerImagesPresignedUrlImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  BannerImagesPresignedUrlImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory BannerImagesPresignedUrlImage.fromRawJson(String str) =>
      BannerImagesPresignedUrlImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerImagesPresignedUrlImage.fromJson(Map<String, dynamic> json) =>
      BannerImagesPresignedUrlImage(
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
