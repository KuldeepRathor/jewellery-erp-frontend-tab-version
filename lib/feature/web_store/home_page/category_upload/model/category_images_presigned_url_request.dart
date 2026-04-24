import 'dart:convert';

class CategoryImagesPresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<CategoryImagesPresignedUrlImage>? images;

  CategoryImagesPresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory CategoryImagesPresignedUrlRequest.fromRawJson(String str) =>
      CategoryImagesPresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryImagesPresignedUrlRequest.fromJson(
          Map<String, dynamic> json) =>
      CategoryImagesPresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<CategoryImagesPresignedUrlImage>.from(json["images"]!
                .map((x) => CategoryImagesPresignedUrlImage.fromJson(x))),
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

class CategoryImagesPresignedUrlImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CategoryImagesPresignedUrlImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CategoryImagesPresignedUrlImage.fromRawJson(String str) =>
      CategoryImagesPresignedUrlImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryImagesPresignedUrlImage.fromJson(Map<String, dynamic> json) =>
      CategoryImagesPresignedUrlImage(
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
