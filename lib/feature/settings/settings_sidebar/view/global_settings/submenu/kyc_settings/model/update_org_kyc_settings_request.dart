import 'dart:convert';

class UpdateOrgKycSettingsRequest {
  double? transactionLimit;
  double? dailyLimit;
  double? monthlyLimit;
  double? yearlyLimit;

  UpdateOrgKycSettingsRequest({
    this.transactionLimit,
    this.dailyLimit,
    this.monthlyLimit,
    this.yearlyLimit,
  });

  factory UpdateOrgKycSettingsRequest.fromRawJson(String str) =>
      UpdateOrgKycSettingsRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateOrgKycSettingsRequest.fromJson(Map<String, dynamic> json) =>
      UpdateOrgKycSettingsRequest(
        transactionLimit: json["transaction_limit"],
        dailyLimit: json["daily_limit"],
        monthlyLimit: json["monthly_limit"],
        yearlyLimit: json["yearly_limit"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_limit": transactionLimit,
        "daily_limit": dailyLimit,
        "monthly_limit": monthlyLimit,
        "yearly_limit": yearlyLimit,
      };
}
