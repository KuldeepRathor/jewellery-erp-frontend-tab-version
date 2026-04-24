import 'dart:convert';

class PurchasePresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<PurchasePresignedUrlImage>? images;

  PurchasePresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory PurchasePresignedUrlRequest.fromRawJson(String str) =>
      PurchasePresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchasePresignedUrlRequest.fromJson(Map<String, dynamic> json) =>
      PurchasePresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<PurchasePresignedUrlImage>.from(json["images"]!
                .map((x) => PurchasePresignedUrlImage.fromJson(x))),
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

class PurchasePresignedUrlImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  PurchasePresignedUrlImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory PurchasePresignedUrlImage.fromRawJson(String str) =>
      PurchasePresignedUrlImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchasePresignedUrlImage.fromJson(Map<String, dynamic> json) =>
      PurchasePresignedUrlImage(
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
