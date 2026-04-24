import 'dart:convert';

class UpdateCategoryRequest {
  String? id;
  String? categoryName;
  bool? isWebstore;
  List<UpdateCategoryImage>? images;

  UpdateCategoryRequest({
    this.id,
    this.categoryName,
    this.isWebstore,
    this.images,
  });

  factory UpdateCategoryRequest.fromRawJson(String str) =>
      UpdateCategoryRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCategoryRequest(
        id: json["id"],
        categoryName: json["category_name"],
        isWebstore: json["is_webstore"],
        images: json["images"] == null
            ? []
            : List<UpdateCategoryImage>.from(
                json["images"]!.map((x) => UpdateCategoryImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "is_webstore": isWebstore,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class UpdateCategoryImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateCategoryImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateCategoryImage.fromRawJson(String str) =>
      UpdateCategoryImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCategoryImage.fromJson(Map<String, dynamic> json) =>
      UpdateCategoryImage(
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
