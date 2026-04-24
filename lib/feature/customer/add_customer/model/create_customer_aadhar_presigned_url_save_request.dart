import 'dart:convert';

class CustomerAadharPresignedUrlSave {
  dynamic service;
  dynamic group;
  String? groupId;
  List<CustomerAadharPresignedUrlSaveImage>? images;

  CustomerAadharPresignedUrlSave({
    this.service,
    this.group,
    this.groupId,
    this.images,
  });

  factory CustomerAadharPresignedUrlSave.fromRawJson(String str) =>
      CustomerAadharPresignedUrlSave.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerAadharPresignedUrlSave.fromJson(Map<String, dynamic> json) =>
      CustomerAadharPresignedUrlSave(
        service: json["service"],
        group: json["group"],
        groupId: json["group_id"],
        images: json["images"] == null
            ? []
            : List<CustomerAadharPresignedUrlSaveImage>.from(json["images"]!
                .map((x) => CustomerAadharPresignedUrlSaveImage.fromJson(x))),
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

class CustomerAadharPresignedUrlSaveImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CustomerAadharPresignedUrlSaveImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CustomerAadharPresignedUrlSaveImage.fromRawJson(String str) =>
      CustomerAadharPresignedUrlSaveImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerAadharPresignedUrlSaveImage.fromJson(
          Map<String, dynamic> json) =>
      CustomerAadharPresignedUrlSaveImage(
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
