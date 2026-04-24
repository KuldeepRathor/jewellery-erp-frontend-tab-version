import 'dart:convert';

class ImageRequestModel {
  String? id;
  String? fileName;
  String? fileType;
  String? s3_key;

  ImageRequestModel({
    this.id,
    this.fileName,
    this.fileType,
    this.s3_key,
  });

  factory ImageRequestModel.fromRawJson(String str) =>
      ImageRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageRequestModel.fromJson(Map<String, dynamic> json) =>
      ImageRequestModel(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3_key: json["presigned_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3_key,
      };
}
