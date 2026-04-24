import 'dart:convert';

class WebstoreStockRequest {
  String? organizationId;
  String? shopId;
  String? title;
  String? description;
  String? stockHeadId;
  String? ornamentId;
  List<WebstoreStockImage>? images;
  List<WebstoreStockLineItem>? lineItems;

  WebstoreStockRequest({
    this.organizationId,
    this.shopId,
    this.title,
    this.description,
    this.stockHeadId,
    this.ornamentId,
    this.images,
    this.lineItems,
  });

  factory WebstoreStockRequest.fromRawJson(String str) =>
      WebstoreStockRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebstoreStockRequest.fromJson(Map<String, dynamic> json) =>
      WebstoreStockRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        title: json["title"],
        description: json["description"],
        stockHeadId: json["stock_head_id"],
        ornamentId: json["ornament_id"],
        images: json["images"] == null
            ? []
            : List<WebstoreStockImage>.from(
                json["images"]!.map((x) => WebstoreStockImage.fromJson(x))),
        lineItems: json["line_items"] == null
            ? []
            : List<WebstoreStockLineItem>.from(json["line_items"]!
                .map((x) => WebstoreStockLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
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

class WebstoreStockImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  WebstoreStockImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory WebstoreStockImage.fromRawJson(String str) =>
      WebstoreStockImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebstoreStockImage.fromJson(Map<String, dynamic> json) =>
      WebstoreStockImage(
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

class WebstoreStockLineItem {
  String? purity;
  int? currentPieces;
  int? weight;
  String? size;
  int? amount;
  int? undiscountedAmount;

  WebstoreStockLineItem({
    this.purity,
    this.currentPieces,
    this.weight,
    this.size,
    this.amount,
    this.undiscountedAmount,
  });

  factory WebstoreStockLineItem.fromRawJson(String str) =>
      WebstoreStockLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebstoreStockLineItem.fromJson(Map<String, dynamic> json) =>
      WebstoreStockLineItem(
        purity: json["purity"],
        currentPieces: json["current_pieces"],
        weight: json["weight"],
        size: json["size"],
        amount: json["amount"],
        undiscountedAmount: json["undiscounted_amount"],
      );

  Map<String, dynamic> toJson() => {
        "purity": purity,
        "current_pieces": currentPieces,
        "weight": weight,
        "size": size,
        "amount": amount,
        "undiscounted_amount": undiscountedAmount,
      };
}
