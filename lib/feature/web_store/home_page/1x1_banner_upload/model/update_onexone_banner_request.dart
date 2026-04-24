import 'dart:convert';

class UpdateBannersOneXOneRequest {
  String? id;
  String? slidePosition;
  String? type;
  bool? isWebstore;
  String? typeId;
  String? typeLink;
  List<UpdateBannersOneXOneRequestImage>? images;

  UpdateBannersOneXOneRequest({
    this.id,
    this.slidePosition,
    this.type,
    this.isWebstore,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory UpdateBannersOneXOneRequest.fromRawJson(String str) =>
      UpdateBannersOneXOneRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannersOneXOneRequest.fromJson(Map<String, dynamic> json) =>
      UpdateBannersOneXOneRequest(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        isWebstore: json["is_webstore"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<UpdateBannersOneXOneRequestImage>.from(json["images"]!
                .map((x) => UpdateBannersOneXOneRequestImage.fromJson(x))),
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

class UpdateBannersOneXOneRequestImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateBannersOneXOneRequestImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateBannersOneXOneRequestImage.fromRawJson(String str) =>
      UpdateBannersOneXOneRequestImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateBannersOneXOneRequestImage.fromJson(
          Map<String, dynamic> json) =>
      UpdateBannersOneXOneRequestImage(
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
