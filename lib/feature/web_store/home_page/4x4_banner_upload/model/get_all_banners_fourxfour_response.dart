import 'dart:convert';

class GetAllBannersFourXFourResponse {
  List<GetAllBannersFourXFourValue>? values;

  GetAllBannersFourXFourResponse({
    this.values,
  });

  factory GetAllBannersFourXFourResponse.fromRawJson(String str) =>
      GetAllBannersFourXFourResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersFourXFourResponse.fromJson(Map<String, dynamic> json) =>
      GetAllBannersFourXFourResponse(
        values: json["values"] == null
            ? []
            : List<GetAllBannersFourXFourValue>.from(json["values"]!
                .map((x) => GetAllBannersFourXFourValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllBannersFourXFourValue {
  String? id;
  String? slidePosition;
  String? type;
  bool? isWebstore;
  String? typeId;
  String? typeLink;
  List<GetAllBannersFourXFourImage>? images;

  GetAllBannersFourXFourValue({
    this.id,
    this.slidePosition,
    this.type,
    this.isWebstore,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory GetAllBannersFourXFourValue.fromRawJson(String str) =>
      GetAllBannersFourXFourValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersFourXFourValue.fromJson(Map<String, dynamic> json) =>
      GetAllBannersFourXFourValue(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        isWebstore: json["is_webstore"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<GetAllBannersFourXFourImage>.from(json["images"]!
                .map((x) => GetAllBannersFourXFourImage.fromJson(x))),
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

class GetAllBannersFourXFourImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  GetAllBannersFourXFourImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory GetAllBannersFourXFourImage.fromRawJson(String str) =>
      GetAllBannersFourXFourImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersFourXFourImage.fromJson(Map<String, dynamic> json) =>
      GetAllBannersFourXFourImage(
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
