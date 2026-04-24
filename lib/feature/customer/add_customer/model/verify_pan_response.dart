import 'dart:convert';

class VerifyPanResponse {
  String? id;
  String? panNumber;
  String? panStatus;
  bool? isPanVerified;
  PanData? panData;
  String? attemptId;
  String? attemptStatus;
  String? message;

  VerifyPanResponse({
    this.id,
    this.panNumber,
    this.panStatus,
    this.isPanVerified,
    this.panData,
    this.attemptId,
    this.attemptStatus,
    this.message,
  });

  factory VerifyPanResponse.fromRawJson(String str) =>
      VerifyPanResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyPanResponse.fromJson(Map<String, dynamic> json) =>
      VerifyPanResponse(
        id: json["id"],
        panNumber: json["pan_number"],
        panStatus: json["pan_status"],
        isPanVerified: json["is_pan_verified"],
        panData: json["pan_data"] == null
            ? null
            : PanData.fromJson(json["pan_data"]),
        attemptId: json["attempt_id"],
        attemptStatus: json["attempt_status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pan_number": panNumber,
        "pan_status": panStatus,
        "is_pan_verified": isPanVerified,
        "pan_data": panData?.toJson(),
        "attempt_id": attemptId,
        "attempt_status": attemptStatus,
        "message": message,
      };
}

class PanData {
  String? panNumber;
  String? panType;
  String? registeredName;
  String? nameOnCard;
  dynamic nameMatchScore;
  String? nameMatchResult;
  String? aadhaarSeedingStatus;
  DateTime? verifiedAt;

  PanData({
    this.panNumber,
    this.panType,
    this.registeredName,
    this.nameOnCard,
    this.nameMatchScore,
    this.nameMatchResult,
    this.aadhaarSeedingStatus,
    this.verifiedAt,
  });

  factory PanData.fromRawJson(String str) => PanData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PanData.fromJson(Map<String, dynamic> json) => PanData(
        panNumber: json["pan_number"],
        panType: json["pan_type"],
        registeredName: json["registered_name"],
        nameOnCard: json["name_on_card"],
        nameMatchScore: json["name_match_score"],
        nameMatchResult: json["name_match_result"],
        aadhaarSeedingStatus: json["aadhaar_seeding_status"],
        verifiedAt: json["verified_at"] == null
            ? null
            : DateTime.parse(json["verified_at"]),
      );

  Map<String, dynamic> toJson() => {
        "pan_number": panNumber,
        "pan_type": panType,
        "registered_name": registeredName,
        "name_on_card": nameOnCard,
        "name_match_score": nameMatchScore,
        "name_match_result": nameMatchResult,
        "aadhaar_seeding_status": aadhaarSeedingStatus,
        "verified_at": verifiedAt?.toIso8601String(),
      };
}
