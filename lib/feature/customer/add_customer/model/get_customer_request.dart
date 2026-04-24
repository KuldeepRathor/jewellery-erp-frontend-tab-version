import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';

class GetCustomerRequestResponse {
  List<CustomerDetails>? values;
  Pagination? pagination;

  GetCustomerRequestResponse({this.values, this.pagination});

  factory GetCustomerRequestResponse.fromRawJson(String str) =>
      GetCustomerRequestResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCustomerRequestResponse.fromJson(Map<String, dynamic> json) =>
      GetCustomerRequestResponse(
        values:
            json["values"] == null
                ? []
                : List<CustomerDetails>.from(
                  json["values"]!.map((x) => CustomerDetails.fromJson(x)),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  String? next;

  Pagination({this.totalCount, this.pageCount, this.next});

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalCount: json["total_count"],
    pageCount: json["page_count"],
    next: json["next"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount,
    "page_count": pageCount,
    "next": next,
  };
}

class CustomerDetails {
  String? id;

  String? phoneCountryCode;
  dynamic externalId;
  String? readableId;
  String? phoneNumber;
  String? aadhaarNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  String? gstNumber;
  String? organizationId;
  String? addressUuid;
  String? gender;
  List<dynamic>? nominees;
  List<Address>? address;
  // New fields
  String? deductionPercent;
  String? deductionType;
  int? ledgerId;
  List<AadharPanImage>? panImages;
  List<AadharPanImage>? aadhaarImages;
  String? aadhaarVerificationId;
  String? panVerificationId;

  CustomerDetails({
    this.id,
    this.phoneCountryCode,
    this.externalId,
    this.readableId,
    this.phoneNumber,
    this.aadhaarNumber,
    this.name,
    this.dateOfBirth,
    this.panNumber,
    this.gstNumber,
    this.organizationId,
    this.addressUuid,
    this.gender,
    this.nominees,
    this.address,

    // New fields in constructor
    this.deductionPercent,
    this.deductionType,
    this.ledgerId,
    this.panImages,
    this.aadhaarImages,
    this.aadhaarVerificationId,
    this.panVerificationId,
  });

  factory CustomerDetails.fromRawJson(String str) =>
      CustomerDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json["id"],
      phoneCountryCode: json["phone_country_code"],
      externalId: json["external_id"],
      readableId: json["readable_id"],
      phoneNumber: json["phone_number"],
      aadhaarNumber: json["aadhaar_number"],
      name: json["name"],
      dateOfBirth:
          json["date_of_birth"] == null
              ? null
              : DateTime.parse(json["date_of_birth"]),
      panNumber: json["pan_number"],
      gstNumber: json["gst_number"],
      organizationId: json["organization_id"],
      addressUuid: json["address_uuid"],
      gender: json["gender"],
      nominees:
          json["nominees"] == null
              ? []
              : List<dynamic>.from(json["nominees"]!.map((x) => x)),
      address:
          json["address"] == null
              ? []
              : List<Address>.from(
                json["address"]!.map(
                  (x) => Address.fromJson(x as Map<String, dynamic>),
                ),
              ),
      // New fields in fromJson
      deductionPercent: json["deduction_percent"],
      deductionType: json["deduction_type"],
      ledgerId: json["ledger_id"],
      panImages:
          json["pan_images"] == null
              ? []
              : List<AadharPanImage>.from(
                json["pan_images"]!.map((x) => AadharPanImage.fromJson(x)),
              ),
      aadhaarImages:
          json["aadhaar_images"] == null
              ? []
              : List<AadharPanImage>.from(
                json["aadhaar_images"]!.map((x) => AadharPanImage.fromJson(x)),
              ),
      aadhaarVerificationId: json["aadhaar_verification_id"],
      panVerificationId: json["pan_verification_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone_country_code": phoneCountryCode,
    "phone_number": phoneNumber,
    "aadhaar_number": aadhaarNumber,
    "name": name,
    "date_of_birth":
        dateOfBirth != null
            ? "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}"
            : null,
    "pan_number": panNumber,
    "gst_number": gstNumber,
    "address_uuid": addressUuid,
    "gender": gender,
    "address":
        address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
    // New fields in toJson
    "deduction_percent": deductionPercent,
    "deduction_type": deductionType,
    "ledger_id": ledgerId,
    "pan_images":
        panImages == null
            ? []
            : List<dynamic>.from(panImages!.map((x) => x.toJson())),
    "aadhaar_images":
        aadhaarImages == null
            ? []
            : List<dynamic>.from(aadhaarImages!.map((x) => x.toJson())),
    "aadhaar_verification_id": aadhaarVerificationId,
    "pan_verification_id": panVerificationId,
  };
}

class AadharPanImage {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  AadharPanImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory AadharPanImage.fromRawJson(String str) =>
      AadharPanImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AadharPanImage.fromJson(Map<String, dynamic> json) => AadharPanImage(
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
