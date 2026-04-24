import 'dart:convert';

class CustomerPanPresignedUrlSave {
  dynamic service;
  dynamic group;
  String? groupId;
  List<CustomerPanPresignedUrlSaveImage>? images;

  CustomerPanPresignedUrlSave({
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory CustomerPanPresignedUrlSave.fromRawJson(String str) =>
      CustomerPanPresignedUrlSave.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerPanPresignedUrlSave.fromJson(Map<String, dynamic> json) =>
      CustomerPanPresignedUrlSave(
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<CustomerPanPresignedUrlSaveImage>.from(json["images"]!
                .map((x) => CustomerPanPresignedUrlSaveImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "group": group,
        "group_id": groupId,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class CustomerPanPresignedUrlSaveImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CustomerPanPresignedUrlSaveImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CustomerPanPresignedUrlSaveImage.fromRawJson(String str) =>
      CustomerPanPresignedUrlSaveImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerPanPresignedUrlSaveImage.fromJson(
          Map<String, dynamic> json) =>
      CustomerPanPresignedUrlSaveImage(
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
