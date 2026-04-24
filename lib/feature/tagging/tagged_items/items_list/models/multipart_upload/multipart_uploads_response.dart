import 'dart:convert';

class MultipartUploadsResponse {
  String? uploadId;
  String? s3Key;
  int? totalParts;
  int? partSize;
  String? status;

  MultipartUploadsResponse({
    this.uploadId,
    this.s3Key,
    this.totalParts,
    this.partSize,
    this.status,
  });

  factory MultipartUploadsResponse.fromRawJson(String str) =>
      MultipartUploadsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MultipartUploadsResponse.fromJson(Map<String, dynamic> json) =>
      MultipartUploadsResponse(
        uploadId: json["upload_id"],
        s3Key: json["s3_key"],
        totalParts: json["total_parts"],
        partSize: json["part_size"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "upload_id": uploadId,
        "s3_key": s3Key,
        "total_parts": totalParts,
        "part_size": partSize,
        "status": status,
      };
}
