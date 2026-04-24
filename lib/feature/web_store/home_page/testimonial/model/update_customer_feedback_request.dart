import 'dart:convert';

class UpdateCustomerFeedbackRequest {
  String? id;
  String? customerName;
  String? emailId;
  String? comment;
  List<UpdateCustomerFeedbackImage>? images;
  bool? isWebstore;

  UpdateCustomerFeedbackRequest({
    this.id,
    this.customerName,
    this.emailId,
    this.comment,
    this.images,
    this.isWebstore,
  });

  factory UpdateCustomerFeedbackRequest.fromRawJson(String str) =>
      UpdateCustomerFeedbackRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCustomerFeedbackRequest.fromJson(Map<String, dynamic> json) =>
      UpdateCustomerFeedbackRequest(
        id: json["id"],
        customerName: json["customer_name"],
        emailId: json["email_id"],
        comment: json["comment"],
        images: json["images"] == null
            ? []
            : List<UpdateCustomerFeedbackImage>.from(json["images"]!
                .map((x) => UpdateCustomerFeedbackImage.fromJson(x))),
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_name": customerName,
        "email_id": emailId,
        "comment": comment,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "is_webstore": isWebstore,
      };
}

class UpdateCustomerFeedbackImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  UpdateCustomerFeedbackImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory UpdateCustomerFeedbackImage.fromRawJson(String str) =>
      UpdateCustomerFeedbackImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCustomerFeedbackImage.fromJson(Map<String, dynamic> json) =>
      UpdateCustomerFeedbackImage(
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
