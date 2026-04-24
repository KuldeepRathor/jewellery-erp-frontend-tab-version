import 'dart:convert';

class FeedbackPresignedUrlSaveRequest {
  dynamic organizationId;
  dynamic shopId;
  dynamic service;
  dynamic group;
  String? groupId;
  List<FeedbackPresignedUrlSaveImage>? images;

  FeedbackPresignedUrlSaveRequest({
    this.organizationId,
    this.shopId,
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory FeedbackPresignedUrlSaveRequest.fromRawJson(String str) =>
      FeedbackPresignedUrlSaveRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackPresignedUrlSaveRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackPresignedUrlSaveRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<FeedbackPresignedUrlSaveImage>.from(json["images"]!
                .map((x) => FeedbackPresignedUrlSaveImage.fromJson(x))),
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

class FeedbackPresignedUrlSaveImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  FeedbackPresignedUrlSaveImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory FeedbackPresignedUrlSaveImage.fromRawJson(String str) =>
      FeedbackPresignedUrlSaveImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackPresignedUrlSaveImage.fromJson(Map<String, dynamic> json) =>
      FeedbackPresignedUrlSaveImage(
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
