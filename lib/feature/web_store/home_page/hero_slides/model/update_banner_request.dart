import 'dart:convert';

class UpdateBannerRequest {
  String? id;
  int? slidePosition;
  String? type;
  String? typeId;
  String? typeLink;
  List<UpdateBannerRequestImage>? images;

  UpdateBannerRequest({
    this.id,
    this.slidePosition,
    this.type,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory UpdateBannerRequest.fromRawJson(String str) =>
      UpdateBannerRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannerRequest.fromJson(Map<String, dynamic> json) =>
      UpdateBannerRequest(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<UpdateBannerRequestImage>.from(json["images"]!
                .map((x) => UpdateBannerRequestImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slide_position": slidePosition,
        "type": type,
        "type_id": typeId,
        "type_link": typeLink,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class UpdateBannerRequestImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateBannerRequestImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateBannerRequestImage.fromRawJson(String str) =>
      UpdateBannerRequestImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannerRequestImage.fromJson(Map<String, dynamic> json) =>
      UpdateBannerRequestImage(
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
