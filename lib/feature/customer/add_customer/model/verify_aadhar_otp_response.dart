import 'dart:convert';

class VerifyAadharOtpResponse {
  String? id;
  String? aadhaarNumber;
  String? aadhaarStatus;
  bool? isAadhaarVerified;
  AadhaarData? aadhaarData;
  String? attemptId;
  String? attemptStatus;
  String? message;

  VerifyAadharOtpResponse({
    this.id,
    this.aadhaarNumber,
    this.aadhaarStatus,
    this.isAadhaarVerified,
    this.aadhaarData,
    this.attemptId,
    this.attemptStatus,
    this.message,
  });

  factory VerifyAadharOtpResponse.fromRawJson(String str) =>
      VerifyAadharOtpResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyAadharOtpResponse.fromJson(Map<String, dynamic> json) =>
      VerifyAadharOtpResponse(
        id: json["id"],
        aadhaarNumber: json["aadhaar_number"],
        aadhaarStatus: json["aadhaar_status"],
        isAadhaarVerified: json["is_aadhaar_verified"],
        aadhaarData: json["aadhaar_data"] == null
            ? null
            : AadhaarData.fromJson(json["aadhaar_data"]),
        attemptId: json["attempt_id"],
        attemptStatus: json["attempt_status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "aadhaar_number": aadhaarNumber,
        "aadhaar_status": aadhaarStatus,
        "is_aadhaar_verified": isAadhaarVerified,
        "aadhaar_data": aadhaarData?.toJson(),
        "attempt_id": attemptId,
        "attempt_status": attemptStatus,
        "message": message,
      };

  // Helper getters for backward compatibility
  String? get status => aadhaarData?.status;
  String? get name => aadhaarData?.name;
  String? get dob => aadhaarData?.dob;
  String? get gender => aadhaarData?.gender;
  String? get address => aadhaarData?.address;
  SplitAddress? get splitAddress => aadhaarData?.splitAddress;
}

class AadhaarData {
  String? aadhaarNumber;
  String? refId;
  String? status;
  String? name;
  String? dob;
  String? gender;
  String? email;
  String? address;
  SplitAddress? splitAddress;
  String? verifiedAt;

  AadhaarData({
    this.aadhaarNumber,
    this.refId,
    this.status,
    this.name,
    this.dob,
    this.gender,
    this.email,
    this.address,
    this.splitAddress,
    this.verifiedAt,
  });

  factory AadhaarData.fromRawJson(String str) =>
      AadhaarData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AadhaarData.fromJson(Map<String, dynamic> json) => AadhaarData(
        aadhaarNumber: json["aadhaar_number"],
        refId: json["ref_id"],
        status: json["status"],
        name: json["name"],
        dob: json["dob"],
        gender: json["gender"],
        email: json["email"],
        address: json["address"],
        splitAddress: json["split_address"] == null
            ? null
            : SplitAddress.fromJson(json["split_address"]),
        verifiedAt: json["verified_at"],
      );

  Map<String, dynamic> toJson() => {
        "aadhaar_number": aadhaarNumber,
        "ref_id": refId,
        "status": status,
        "name": name,
        "dob": dob,
        "gender": gender,
        "email": email,
        "address": address,
        "split_address": splitAddress?.toJson(),
        "verified_at": verifiedAt,
      };
}

class SplitAddress {
  String? country;
  String? dist;
  String? house;
  String? landmark;
  String? pincode;
  String? po;
  String? state;
  String? street;
  String? subdist;
  String? vtc;
  String? locality;

  SplitAddress({
    this.country,
    this.dist,
    this.house,
    this.landmark,
    this.pincode,
    this.po,
    this.state,
    this.street,
    this.subdist,
    this.vtc,
    this.locality,
  });

  factory SplitAddress.fromRawJson(String str) =>
      SplitAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SplitAddress.fromJson(Map<String, dynamic> json) => SplitAddress(
        country: json["country"],
        dist: json["dist"],
        house: json["house"],
        landmark: json["landmark"],
        pincode: json["pincode"],
        po: json["po"],
        state: json["state"],
        street: json["street"],
        subdist: json["subdist"],
        vtc: json["vtc"],
        locality: json["locality"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "dist": dist,
        "house": house,
        "landmark": landmark,
        "pincode": pincode,
        "po": po,
        "state": state,
        "street": street,
        "subdist": subdist,
        "vtc": vtc,
        "locality": locality,
      };
}
