import 'dart:convert';

class GetSettlementDetailsResponse {
  dynamic organizationId;
  String? accountName;
  String? accountNumber;
  String? ifsc;

  GetSettlementDetailsResponse({
    this.organizationId,
    this.accountName,
    this.accountNumber,
    this.ifsc,
  });

  factory GetSettlementDetailsResponse.fromRawJson(String str) =>
      GetSettlementDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSettlementDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetSettlementDetailsResponse(
        organizationId: json["organization_id"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        ifsc: json["ifsc"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "account_name": accountName,
        "account_number": accountNumber,
        "ifsc": ifsc,
      };
}
