import 'dart:convert';

class MultipartUploadsRequest {
  String? filename;
  int? fileSize;
  String? contentType;
  int? partSize;

  MultipartUploadsRequest({
    this.filename,
    this.fileSize,
    this.contentType,
    this.partSize,
  });

  factory MultipartUploadsRequest.fromRawJson(String str) =>
      MultipartUploadsRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MultipartUploadsRequest.fromJson(Map<String, dynamic> json) =>
      MultipartUploadsRequest(
        filename: json["filename"],
        fileSize: json["file_size"],
        contentType: json["content_type"],
        partSize: json["part_size"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "file_size": fileSize,
        "content_type": contentType,
        "part_size": partSize,
      };
}
