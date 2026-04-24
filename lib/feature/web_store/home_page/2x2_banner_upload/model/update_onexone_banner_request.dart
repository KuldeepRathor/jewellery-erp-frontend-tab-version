import 'dart:convert';

class UpdateBannersTwoXTwoRequest {
  String? id;
  String? slidePosition;
  String? type;
  bool? isWebstore;
  String? typeId;
  String? typeLink;
  List<UpdateBannersTwoXTwoRequestImage>? images;

  UpdateBannersTwoXTwoRequest({
    this.id,
    this.slidePosition,
    this.type,
    this.isWebstore,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory UpdateBannersTwoXTwoRequest.fromRawJson(String str) =>
      UpdateBannersTwoXTwoRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannersTwoXTwoRequest.fromJson(Map<String, dynamic> json) =>
      UpdateBannersTwoXTwoRequest(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        isWebstore: json["is_webstore"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<UpdateBannersTwoXTwoRequestImage>.from(json["images"]!
                .map((x) => UpdateBannersTwoXTwoRequestImage.fromJson(x))),
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

class UpdateBannersTwoXTwoRequestImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateBannersTwoXTwoRequestImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateBannersTwoXTwoRequestImage.fromRawJson(String str) =>
      UpdateBannersTwoXTwoRequestImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannersTwoXTwoRequestImage.fromJson(
          Map<String, dynamic> json) =>
      UpdateBannersTwoXTwoRequestImage(
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
