import 'dart:convert';

class CatalogImagesPresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<CatalogImagePresigned>? images;

  CatalogImagesPresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory CatalogImagesPresignedUrlRequest.fromRawJson(String str) =>
      CatalogImagesPresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CatalogImagesPresignedUrlRequest.fromJson(
          Map<String, dynamic> json) =>
      CatalogImagesPresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<CatalogImagePresigned>.from(
                json["images"]!.map((x) => CatalogImagePresigned.fromJson(x))),
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

class CatalogImagePresigned {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CatalogImagePresigned({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CatalogImagePresigned.fromRawJson(String str) =>
      CatalogImagePresigned.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CatalogImagePresigned.fromJson(Map<String, dynamic> json) =>
      CatalogImagePresigned(
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
