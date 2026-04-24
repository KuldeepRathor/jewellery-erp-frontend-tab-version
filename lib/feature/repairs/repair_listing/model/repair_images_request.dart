import 'dart:convert';

class RepairImagesRequest {
  String? repairLineItemId;
  String? notes;
  List<RepairImage>? images;

  RepairImagesRequest({
    this.repairLineItemId,
    this.notes,
    this.images,
  });

  factory RepairImagesRequest.fromRawJson(String str) =>
      RepairImagesRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RepairImagesRequest.fromJson(Map<String, dynamic> json) =>
      RepairImagesRequest(
        repairLineItemId: json["repair_line_item_id"],
        notes: json["notes"],
        images: json["images"] == null
            ? []
            : List<RepairImage>.from(
                json["images"]!.map((x) => RepairImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "repair_line_item_id": repairLineItemId,
        "notes": notes,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class RepairImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  RepairImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory RepairImage.fromRawJson(String str) =>
      RepairImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RepairImage.fromJson(Map<String, dynamic> json) => RepairImage(
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
