import 'dart:convert';

class GetAllBannersOneXOneResponse {
  List<GetAllBannersOneXOneValue>? values;

  GetAllBannersOneXOneResponse({
    this.values,
  });

  factory GetAllBannersOneXOneResponse.fromRawJson(String str) =>
      GetAllBannersOneXOneResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersOneXOneResponse.fromJson(Map<String, dynamic> json) =>
      GetAllBannersOneXOneResponse(
        values: json["values"] == null
            ? []
            : List<GetAllBannersOneXOneValue>.from(json["values"]!
                .map((x) => GetAllBannersOneXOneValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllBannersOneXOneValue {
  String? id;
  String? slidePosition;
  String? type;
  bool? isWebstore;
  String? typeId;
  String? typeLink;
  List<GetAllBannersOneXOneValueImage>? images;

  GetAllBannersOneXOneValue({
    this.id,
    this.slidePosition,
    this.type,
    this.isWebstore,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory GetAllBannersOneXOneValue.fromRawJson(String str) =>
      GetAllBannersOneXOneValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersOneXOneValue.fromJson(Map<String, dynamic> json) =>
      GetAllBannersOneXOneValue(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        isWebstore: json["is_webstore"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<GetAllBannersOneXOneValueImage>.from(json["images"]!
                .map((x) => GetAllBannersOneXOneValueImage.fromJson(x))),
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

class GetAllBannersOneXOneValueImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  GetAllBannersOneXOneValueImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory GetAllBannersOneXOneValueImage.fromRawJson(String str) =>
      GetAllBannersOneXOneValueImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersOneXOneValueImage.fromJson(Map<String, dynamic> json) =>
      GetAllBannersOneXOneValueImage(
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
