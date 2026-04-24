import 'dart:convert';

class EditWebstoreStockByIdRequest {
  String? title;
  String? description;
  String? stockHeadId;
  String? ornamentId;
  List<EditWebstoreStockByIdImage>? images;
  List<EditWebstoreStockByIdLineItem>? lineItems;

  EditWebstoreStockByIdRequest({
    this.title,
    this.description,
    this.stockHeadId,
    this.ornamentId,
    this.images,
    this.lineItems,
  });

  factory EditWebstoreStockByIdRequest.fromRawJson(String str) =>
      EditWebstoreStockByIdRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditWebstoreStockByIdRequest.fromJson(Map<String, dynamic> json) =>
      EditWebstoreStockByIdRequest(
        title: json["title"],
        description: json["description"],
        stockHeadId: json["stock_head_id"],
        ornamentId: json["ornament_id"],
        images: json["images"] == null
            ? []
            : List<EditWebstoreStockByIdImage>.from(json["images"]!
                .map((x) => EditWebstoreStockByIdImage.fromJson(x))),
        lineItems: json["line_items"] == null
            ? []
            : List<EditWebstoreStockByIdLineItem>.from(json["line_items"]!
                .map((x) => EditWebstoreStockByIdLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "stock_head_id": stockHeadId,
        "ornament_id": ornamentId,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class EditWebstoreStockByIdImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  EditWebstoreStockByIdImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory EditWebstoreStockByIdImage.fromRawJson(String str) =>
      EditWebstoreStockByIdImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditWebstoreStockByIdImage.fromJson(Map<String, dynamic> json) =>
      EditWebstoreStockByIdImage(
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

class EditWebstoreStockByIdLineItem {
  String? key;
  String? purity;
  int? currentPieces;
  int? weight;
  String? size;
  int? amount;
  int? undiscountedAmount;

  EditWebstoreStockByIdLineItem({
    this.key,
    this.purity,
    this.currentPieces,
    this.weight,
    this.size,
    this.amount,
    this.undiscountedAmount,
  });

  factory EditWebstoreStockByIdLineItem.fromRawJson(String str) =>
      EditWebstoreStockByIdLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditWebstoreStockByIdLineItem.fromJson(Map<String, dynamic> json) =>
      EditWebstoreStockByIdLineItem(
        key: json["key"],
        purity: json["purity"],
        currentPieces: json["current_pieces"],
        weight: json["weight"],
        size: json["size"],
        amount: json["amount"],
        undiscountedAmount: json["undiscounted_amount"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "purity": purity,
        "current_pieces": currentPieces,
        "weight": weight,
        "size": size,
        "amount": amount,
        "undiscounted_amount": undiscountedAmount,
      };
}
