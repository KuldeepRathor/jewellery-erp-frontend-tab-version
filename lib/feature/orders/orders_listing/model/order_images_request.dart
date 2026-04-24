import 'dart:convert';

class OrderImagesRequest {
  String? orderLineItemId;
  String? notes;
  List<Image>? images;

  OrderImagesRequest({
    this.orderLineItemId,
    this.notes,
    this.images,
  });

  factory OrderImagesRequest.fromRawJson(String str) =>
      OrderImagesRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderImagesRequest.fromJson(Map<String, dynamic> json) =>
      OrderImagesRequest(
        orderLineItemId: json["order_line_item_id"],
        notes: json["notes"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_line_item_id": orderLineItemId,
        "notes": notes,
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
