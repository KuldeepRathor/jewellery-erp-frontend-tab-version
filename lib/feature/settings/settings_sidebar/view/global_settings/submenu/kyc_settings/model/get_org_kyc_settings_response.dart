import 'dart:convert';

class GetOrgKycSettingsResponse {
  String? id;
  String? organizationId;
  bool? isKycEnabled;
  String? aadhaarKycCharges;
  String? panKycCharges;
  String? creditsRemaining;
  String? creditsUsed;
  String? minimumCreditsRequired;
  int? panVerificationCount;
  int? aadhaarVerificationCount;
  bool? lowCreditsAlertSent;
  bool? isLowOnCredits;
  String? transactionLimit;
  String? dailyLimit;
  String? monthlyLimit;
  String? yearlyLimit;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetOrgKycSettingsResponse({
    this.id,
    this.organizationId,
    this.isKycEnabled,
    this.aadhaarKycCharges,
    this.panKycCharges,
    this.creditsRemaining,
    this.creditsUsed,
    this.minimumCreditsRequired,
    this.panVerificationCount,
    this.aadhaarVerificationCount,
    this.lowCreditsAlertSent,
    this.isLowOnCredits,
    this.transactionLimit,
    this.dailyLimit,
    this.monthlyLimit,
    this.yearlyLimit,
    this.createdAt,
    this.updatedAt,
  });

  factory GetOrgKycSettingsResponse.fromRawJson(String str) =>
      GetOrgKycSettingsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrgKycSettingsResponse.fromJson(Map<String, dynamic> json) =>
      GetOrgKycSettingsResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        isKycEnabled: json["is_kyc_enabled"],
        aadhaarKycCharges: json["aadhaar_kyc_charges"],
        panKycCharges: json["pan_kyc_charges"],
        creditsRemaining: json["credits_remaining"],
        creditsUsed: json["credits_used"],
        minimumCreditsRequired: json["minimum_credits_required"],
        panVerificationCount: json["pan_verification_count"],
        aadhaarVerificationCount: json["aadhaar_verification_count"],
        lowCreditsAlertSent: json["low_credits_alert_sent"],
        isLowOnCredits: json["is_low_on_credits"],
        transactionLimit: json["transaction_limit"],
        dailyLimit: json["daily_limit"],
        monthlyLimit: json["monthly_limit"],
        yearlyLimit: json["yearly_limit"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "is_kyc_enabled": isKycEnabled,
        "aadhaar_kyc_charges": aadhaarKycCharges,
        "pan_kyc_charges": panKycCharges,
        "credits_remaining": creditsRemaining,
        "credits_used": creditsUsed,
        "minimum_credits_required": minimumCreditsRequired,
        "pan_verification_count": panVerificationCount,
        "aadhaar_verification_count": aadhaarVerificationCount,
        "low_credits_alert_sent": lowCreditsAlertSent,
        "is_low_on_credits": isLowOnCredits,
        "transaction_limit": transactionLimit,
        "daily_limit": dailyLimit,
        "monthly_limit": monthlyLimit,
        "yearly_limit": yearlyLimit,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
