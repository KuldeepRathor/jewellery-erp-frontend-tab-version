import 'dart:convert';

class TaggedItemImageUploadRequest {
  String? taggingLineItemId;
  List<Image>? images;

  TaggedItemImageUploadRequest({
    this.taggingLineItemId,
    this.images,
  });

  factory TaggedItemImageUploadRequest.fromRawJson(String str) =>
      TaggedItemImageUploadRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggedItemImageUploadRequest.fromJson(Map<String, dynamic> json) =>
      TaggedItemImageUploadRequest(
        taggingLineItemId: json["tagging_line_item_id"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item_id": taggingLineItemId,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Image {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  Image({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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
