import 'dart:convert';

class UpdateBannersFourXFourRequest {
  String? id;
  String? slidePosition;
  String? type;
  bool? isWebstore;
  String? typeId;
  String? typeLink;
  List<UpdateBannersFourXFourRequestImage>? images;

  UpdateBannersFourXFourRequest({
    this.id,
    this.slidePosition,
    this.type,
    this.isWebstore,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory UpdateBannersFourXFourRequest.fromRawJson(String str) =>
      UpdateBannersFourXFourRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannersFourXFourRequest.fromJson(Map<String, dynamic> json) =>
      UpdateBannersFourXFourRequest(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        isWebstore: json["is_webstore"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<UpdateBannersFourXFourRequestImage>.from(json["images"]!
                .map((x) => UpdateBannersFourXFourRequestImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slide_position": slidePosition,
        "type": type,
        "is_webstore": isWebstore,
        "type_id": typeId,
        "type_link": typeLink,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class UpdateBannersFourXFourRequestImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateBannersFourXFourRequestImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateBannersFourXFourRequestImage.fromRawJson(String str) =>
      UpdateBannersFourXFourRequestImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannersFourXFourRequestImage.fromJson(
          Map<String, dynamic> json) =>
      UpdateBannersFourXFourRequestImage(
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
