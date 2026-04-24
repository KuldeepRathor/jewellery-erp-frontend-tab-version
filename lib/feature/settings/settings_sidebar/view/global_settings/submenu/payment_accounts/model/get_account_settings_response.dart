import 'dart:convert';

class GetAccountSettingsResponse {
  String? id;
  String? paymentCode;
  String? accountName;
  String? accountNumber;
  String? ifsc;
  String? branch;
  String? accountType;
  bool? isActive;

  GetAccountSettingsResponse({
    this.id,
    this.paymentCode,
    this.accountName,
    this.accountNumber,
    this.ifsc,
    this.branch,
    this.accountType,
    this.isActive,
  });

  factory GetAccountSettingsResponse.fromRawJson(String str) =>
      GetAccountSettingsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAccountSettingsResponse.fromJson(Map<String, dynamic> json) =>
      GetAccountSettingsResponse(
        id: json["id"],
        paymentCode: json["payment_code"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        ifsc: json["ifsc"],
        branch: json["branch"],
        accountType: json["account_type"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_code": paymentCode,
        "account_name": accountName,
        "account_number": accountNumber,
        "ifsc": ifsc,
        "branch": branch,
        "account_type": accountType,
        "is_active": isActive,
      };
}
