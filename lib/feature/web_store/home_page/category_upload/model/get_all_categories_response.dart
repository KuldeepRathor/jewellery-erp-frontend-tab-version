import 'dart:convert';

class GetAllCategoriesResponse {
  List<GetAllCategoriesValue>? values;

  GetAllCategoriesResponse({
    this.values,
  });

  factory GetAllCategoriesResponse.fromRawJson(String str) =>
      GetAllCategoriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      GetAllCategoriesResponse(
        values: json["values"] == null
            ? []
            : List<GetAllCategoriesValue>.from(
                json["values"]!.map((x) => GetAllCategoriesValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllCategoriesValue {
  String? id;
  String? categoryName;
  bool? isWebstore;
  List<GetAllCategoriesImage>? images;

  GetAllCategoriesValue({
    this.id,
    this.categoryName,
    this.isWebstore,
    this.images,
  });

  factory GetAllCategoriesValue.fromRawJson(String str) =>
      GetAllCategoriesValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCategoriesValue.fromJson(Map<String, dynamic> json) =>
      GetAllCategoriesValue(
        id: json["id"],
        categoryName: json["category_name"],
        isWebstore: json["is_webstore"],
        images: json["images"] == null
            ? []
            : List<GetAllCategoriesImage>.from(
                json["images"]!.map((x) => GetAllCategoriesImage.fromJson(x))),
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

class GetAllCategoriesImage {
  dynamic id;
  String? fileName;
  String? fileType;
  String? s3Key;
  dynamic presignedUrl;
  bool? isWebstore;

  GetAllCategoriesImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory GetAllCategoriesImage.fromRawJson(String str) =>
      GetAllCategoriesImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCategoriesImage.fromJson(Map<String, dynamic> json) =>
      GetAllCategoriesImage(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3Key,
        "presigned_url": presignedUrl,
        "is_webstore": isWebstore,
      };
}
