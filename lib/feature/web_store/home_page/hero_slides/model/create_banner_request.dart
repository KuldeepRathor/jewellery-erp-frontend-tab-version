import 'dart:convert';

class CreateBannerRequest {
  int? slidePosition;
  String? type;
  String? typeId;
  String? typeLink;
  List<CreateBannerImage>? images;

  CreateBannerRequest({
    this.slidePosition,
    this.type,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory CreateBannerRequest.fromRawJson(String str) =>
      CreateBannerRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateBannerRequest.fromJson(Map<String, dynamic> json) =>
      CreateBannerRequest(
        slidePosition: json["slide_position"],
        type: json["type"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<CreateBannerImage>.from(
                json["images"]!.map((x) => CreateBannerImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "slide_position": slidePosition,
        "type": type,
        "type_id": typeId,
        "type_link": typeLink,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class CreateBannerImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  CreateBannerImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory CreateBannerImage.fromRawJson(String str) =>
      CreateBannerImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateBannerImage.fromJson(Map<String, dynamic> json) =>
      CreateBannerImage(
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
