import 'dart:convert';

class RepairImagesPresignedUrlRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<RepairPresignedImage>? images;

  RepairImagesPresignedUrlRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory RepairImagesPresignedUrlRequest.fromRawJson(String str) =>
      RepairImagesPresignedUrlRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RepairImagesPresignedUrlRequest.fromJson(Map<String, dynamic> json) =>
      RepairImagesPresignedUrlRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<RepairPresignedImage>.from(
                json["images"]!.map((x) => RepairPresignedImage.fromJson(x))),
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

class RepairPresignedImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  RepairPresignedImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory RepairPresignedImage.fromRawJson(String str) =>
      RepairPresignedImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RepairPresignedImage.fromJson(Map<String, dynamic> json) =>
      RepairPresignedImage(
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
