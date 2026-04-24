import 'dart:convert';

class GetAllCustomerFeedbackResponse {
  List<GetAllCustomerFeedbackValue>? values;

  GetAllCustomerFeedbackResponse({
    this.values,
  });

  factory GetAllCustomerFeedbackResponse.fromRawJson(String str) =>
      GetAllCustomerFeedbackResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCustomerFeedbackResponse.fromJson(Map<String, dynamic> json) =>
      GetAllCustomerFeedbackResponse(
        values: json["values"] == null
            ? []
            : List<GetAllCustomerFeedbackValue>.from(json["values"]!
                .map((x) => GetAllCustomerFeedbackValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetAllCustomerFeedbackValue {
  String? id;
  String? customerName;
  String? emailId;
  String? comment;
  List<GetAllCustomerFeedbackImage>? images;
  bool? isWebstore;

  GetAllCustomerFeedbackValue({
    this.id,
    this.customerName,
    this.emailId,
    this.comment,
    this.images,
    this.isWebstore,
  });

  factory GetAllCustomerFeedbackValue.fromRawJson(String str) =>
      GetAllCustomerFeedbackValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCustomerFeedbackValue.fromJson(Map<String, dynamic> json) =>
      GetAllCustomerFeedbackValue(
        id: json["id"],
        customerName: json["customer_name"],
        emailId: json["email_id"],
        comment: json["comment"],
        images: json["images"] == null
            ? []
            : List<GetAllCustomerFeedbackImage>.from(json["images"]!
                .map((x) => GetAllCustomerFeedbackImage.fromJson(x))),
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

class GetAllCustomerFeedbackImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  bool? isWebstore;

  GetAllCustomerFeedbackImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory GetAllCustomerFeedbackImage.fromRawJson(String str) =>
      GetAllCustomerFeedbackImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllCustomerFeedbackImage.fromJson(Map<String, dynamic> json) =>
      GetAllCustomerFeedbackImage(
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
