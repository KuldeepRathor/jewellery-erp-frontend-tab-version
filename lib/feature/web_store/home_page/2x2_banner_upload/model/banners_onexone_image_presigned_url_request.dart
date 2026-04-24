import 'dart:convert';

class BannersTwoXTwoImagePresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<BannersTwoXTwoImagePresignedUrlImage>? images;

  BannersTwoXTwoImagePresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory BannersTwoXTwoImagePresignedUrlRequest.fromRawJson(String str) =>
      BannersTwoXTwoImagePresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannersTwoXTwoImagePresignedUrlRequest.fromJson(
          Map<String, dynamic> json) =>
      BannersTwoXTwoImagePresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<BannersTwoXTwoImagePresignedUrlImage>.from(json["images"]!
                .map((x) => BannersTwoXTwoImagePresignedUrlImage.fromJson(x))),
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

class BannersTwoXTwoImagePresignedUrlImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  BannersTwoXTwoImagePresignedUrlImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory BannersTwoXTwoImagePresignedUrlImage.fromRawJson(String str) =>
      BannersTwoXTwoImagePresignedUrlImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannersTwoXTwoImagePresignedUrlImage.fromJson(
          Map<String, dynamic> json) =>
      BannersTwoXTwoImagePresignedUrlImage(
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
