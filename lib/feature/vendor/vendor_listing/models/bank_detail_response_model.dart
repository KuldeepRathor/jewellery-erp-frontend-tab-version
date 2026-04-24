import 'dart:convert';

class BankDetail {
  String? id;
  String? holderName;
  dynamic nickname;
  String? accountNumber;
  String? ifscCode;

  BankDetail({
    this.id,
    this.holderName,
    this.nickname,
    this.accountNumber,
    this.ifscCode,
  });

  factory BankDetail.fromRawJson(String str) =>
      BankDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        id: json["id"],
        holderName: json["holder_name"],
        nickname: json["nickname"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "holder_name": holderName,
        "nickname": nickname,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
      };
}
