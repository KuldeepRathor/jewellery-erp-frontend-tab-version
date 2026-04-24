import 'dart:convert';

class BannersFourXFourImagePresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<BannersFourXFourImagePresignedUrlImage>? images;

  BannersFourXFourImagePresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory BannersFourXFourImagePresignedUrlRequest.fromRawJson(String str) =>
      BannersFourXFourImagePresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannersFourXFourImagePresignedUrlRequest.fromJson(
          Map<String, dynamic> json) =>
      BannersFourXFourImagePresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<BannersFourXFourImagePresignedUrlImage>.from(json["images"]!
                .map(
                    (x) => BannersFourXFourImagePresignedUrlImage.fromJson(x))),
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

class BannersFourXFourImagePresignedUrlImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  BannersFourXFourImagePresignedUrlImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory BannersFourXFourImagePresignedUrlImage.fromRawJson(String str) =>
      BannersFourXFourImagePresignedUrlImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannersFourXFourImagePresignedUrlImage.fromJson(
          Map<String, dynamic> json) =>
      BannersFourXFourImagePresignedUrlImage(
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
