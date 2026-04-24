import 'dart:convert';

class GetAllBannersResponse {
  List<GetAllBannersValue>? values;

  GetAllBannersResponse({
    this.values,
  });

  factory GetAllBannersResponse.fromRawJson(String str) =>
      GetAllBannersResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersResponse.fromJson(Map<String, dynamic> json) =>
      GetAllBannersResponse(
        values: json["values"] == null
            ? []
            : List<GetAllBannersValue>.from(
                json["values"]!.map((x) => GetAllBannersValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllBannersValue {
  String? id;
  int? slidePosition;
  String? type;
  String? typeId;
  String? typeLink;
  List<Image>? images;

  GetAllBannersValue({
    this.id,
    this.slidePosition,
    this.type,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory GetAllBannersValue.fromRawJson(String str) =>
      GetAllBannersValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersValue.fromJson(Map<String, dynamic> json) =>
      GetAllBannersValue(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slide_position": slidePosition,
        "type": type,
        "type_id": typeId,
        "type_link": typeLink,
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
  bool? isWebstore;

  Image({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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
