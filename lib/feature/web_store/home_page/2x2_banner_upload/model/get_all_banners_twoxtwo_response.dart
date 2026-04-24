import 'dart:convert';

class GetAllBannersTwoXTwoResponse {
  List<GetAllBannersTwoXTwoValue>? values;

  GetAllBannersTwoXTwoResponse({
    this.values,
  });

  factory GetAllBannersTwoXTwoResponse.fromRawJson(String str) =>
      GetAllBannersTwoXTwoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersTwoXTwoResponse.fromJson(Map<String, dynamic> json) =>
      GetAllBannersTwoXTwoResponse(
        values: json["values"] == null
            ? []
            : List<GetAllBannersTwoXTwoValue>.from(json["values"]!
                .map((x) => GetAllBannersTwoXTwoValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllBannersTwoXTwoValue {
  String? id;
  String? slidePosition;
  String? type;
  bool? isWebstore;
  String? typeId;
  String? typeLink;
  List<GetAllBannersTwoXTwoImage>? images;

  GetAllBannersTwoXTwoValue({
    this.id,
    this.slidePosition,
    this.type,
    this.isWebstore,
    this.typeId,
    this.typeLink,
    this.images,
  });

  factory GetAllBannersTwoXTwoValue.fromRawJson(String str) =>
      GetAllBannersTwoXTwoValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersTwoXTwoValue.fromJson(Map<String, dynamic> json) =>
      GetAllBannersTwoXTwoValue(
        id: json["id"],
        slidePosition: json["slide_position"],
        type: json["type"],
        isWebstore: json["is_webstore"],
        typeId: json["type_id"],
        typeLink: json["type_link"],
        images: json["images"] == null
            ? []
            : List<GetAllBannersTwoXTwoImage>.from(json["images"]!
                .map((x) => GetAllBannersTwoXTwoImage.fromJson(x))),
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

class GetAllBannersTwoXTwoImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  GetAllBannersTwoXTwoImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory GetAllBannersTwoXTwoImage.fromRawJson(String str) =>
      GetAllBannersTwoXTwoImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllBannersTwoXTwoImage.fromJson(Map<String, dynamic> json) =>
      GetAllBannersTwoXTwoImage(
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
