import 'dart:convert';

class ImagesUploadResponse {
  dynamic designId;
  List<ImageResponseModel>? images;

  ImagesUploadResponse({
    this.designId,
    this.images,
  });

  factory ImagesUploadResponse.fromRawJson(String str) =>
      ImagesUploadResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImagesUploadResponse.fromJson(Map<String, dynamic> json) =>
      ImagesUploadResponse(
        designId: json["design_id"],
        images: json["images"] == null
            ? []
            : List<ImageResponseModel>.from(
                json["images"]!.map((x) => ImageResponseModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "design_id": designId,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class ImageResponseModel {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  ImageResponseModel({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory ImageResponseModel.fromRawJson(String str) =>
      ImageResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageResponseModel.fromJson(Map<String, dynamic> json) =>
      ImageResponseModel(
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
