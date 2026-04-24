import 'dart:convert';

class CreateCustomerRequest {
  String? phoneCountryCode;
  String? phoneNumber;
  String? name;
  String? syncId;
  String? dateOfBirth;
  int? deductionPercent;
  String? deductionType;
  String? panNumber;
  String? aadhaarNumber;
  String? gstNumber;
  String? addressUuid;
  String? gender;
  List<Nominee>? nominees;
  List<Address?>? address;
  List<Image>? panImages;
  List<Image>? aadhaarImages;
  String? aadhaarVerificationId;
  String? panVerificationId;

  CreateCustomerRequest({
    this.phoneCountryCode,
    this.phoneNumber,
    this.name,
    this.syncId,
    this.dateOfBirth,
    this.deductionPercent,
    this.deductionType,
    this.panNumber,
    this.aadhaarNumber,
    this.gstNumber,
    this.addressUuid,
    this.gender,
    this.nominees,
    this.address,
    this.panImages,
    this.aadhaarImages,
    this.aadhaarVerificationId,
    this.panVerificationId,
  });

  factory CreateCustomerRequest.fromRawJson(String str) =>
      CreateCustomerRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) =>
      CreateCustomerRequest(
        phoneCountryCode: json["phone_country_code"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        syncId: json["sync_id"],
        dateOfBirth: json["date_of_birth"],
        deductionPercent: json["deduction_percent"],
        deductionType: json["deduction_type"],
        panNumber: json["pan_number"],
        aadhaarNumber: json["aadhaar_number"],
        gstNumber: json["gst_number"],
        addressUuid: json["address_uuid"],
        gender: json["gender"],
        nominees: json["nominees"] == null
            ? []
            : List<Nominee>.from(
                json["nominees"]!.map((x) => Nominee.fromJson(x))),
        address: json["address"] == null
            ? []
            : List<Address?>.from(json["address"]!
                .map((x) => x == null ? null : Address.fromJson(x))),
        panImages: json["pan_images"] == null
            ? []
            : List<Image>.from(
                json["pan_images"]!.map((x) => Image.fromJson(x))),
        aadhaarImages: json["aadhaar_images"] == null
            ? []
            : List<Image>.from(
                json["aadhaar_images"]!.map((x) => Image.fromJson(x))),
        aadhaarVerificationId: json["aadhaar_verification_id"],
        panVerificationId: json["pan_verification_id"],
      );

  Map<String, dynamic> toJson() => {
        "phone_country_code": phoneCountryCode,
        "phone_number": phoneNumber,
        "name": name,
        "sync_id": syncId,
        "date_of_birth": dateOfBirth,
        "deduction_percent": deductionPercent,
        "deduction_type": deductionType,
        "pan_number": panNumber,
        "aadhaar_number": aadhaarNumber,
        "gst_number": gstNumber,
        "address_uuid": addressUuid,
        "gender": gender,
        "nominees": nominees == null
            ? []
            : List<dynamic>.from(nominees!.map((x) => x.toJson())),
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x?.toJson())),
        "pan_images": panImages == null
            ? []
            : List<dynamic>.from(panImages!.map((x) => x.toJson())),
        "aadhaar_images": aadhaarImages == null
            ? []
            : List<dynamic>.from(aadhaarImages!.map((x) => x.toJson())),
        "aadhaar_verification_id": aadhaarVerificationId,
        "pan_verification_id": panVerificationId,
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

class Address {
  String? organizationId;
  bool? isDefault;
  bool? isJlAddress;
  String? city;
  String? pincode;
  String? addressLine1;
  String? addressLine2;
  String? linkedEntityType;
  String? linkedEntityId;
  String? type;
  String? phoneNumber;
  String? phoneCountryCode;
  String? firstName;
  String? lastName;
  String? country;
  String? state;
  String? nickname;

  Address({
    this.organizationId,
    this.isDefault,
    this.isJlAddress,
    this.city,
    this.pincode,
    this.addressLine1,
    this.addressLine2,
    this.linkedEntityType,
    this.linkedEntityId,
    this.type,
    this.phoneNumber,
    this.phoneCountryCode,
    this.firstName,
    this.lastName,
    this.country,
    this.state,
    this.nickname,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        isJlAddress: json["is_jl_address"],
        city: json["city"],
        pincode: json["pincode"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        linkedEntityType: json["linked_entity_type"],
        linkedEntityId: json["linked_entity_id"],
        type: json["type"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        country: json["country"],
        state: json["state"],
        nickname: json["nickname"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "is_default": isDefault,
        "is_jl_address": isJlAddress,
        "city": city,
        "pincode": pincode,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "linked_entity_type": linkedEntityType,
        "linked_entity_id": linkedEntityId,
        "type": type,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
        "first_name": firstName,
        "last_name": lastName,
        "country": country,
        "state": state,
        "nickname": nickname,
      };
}

class Nominee {
  String? syncId;
  String? organizationId;
  Customer? customer;
  String? name;
  String? countryCode;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? relation;

  Nominee({
    this.syncId,
    this.organizationId,
    this.customer,
    this.name,
    this.countryCode,
    this.phoneNumber,
    this.dateOfBirth,
    this.relation,
  });

  factory Nominee.fromRawJson(String str) => Nominee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Nominee.fromJson(Map<String, dynamic> json) => Nominee(
        syncId: json["sync_id"],
        organizationId: json["organization_id"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        name: json["name"],
        countryCode: json["country_code"],
        phoneNumber: json["phone_number"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "sync_id": syncId,
        "organization_id": organizationId,
        "customer": customer?.toJson(),
        "name": name,
        "country_code": countryCode,
        "phone_number": phoneNumber,
        "date_of_birth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "relation": relation,
      };
}

class Customer {
  String? id;

  Customer({
    this.id,
  });

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
