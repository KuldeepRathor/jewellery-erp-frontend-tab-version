import 'dart:convert';

class BankAccount {
  String? id;
  String? holder_name;
  String? account_number;
  String? ifsc_code;

  BankAccount({
    this.id,
    this.holder_name,
    this.account_number,
    this.ifsc_code,
  });

  factory BankAccount.fromRawJson(String str) =>
      BankAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        holder_name: json["holder_name"],
        account_number: json["account_number"],
        ifsc_code: json["ifsc_code"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "holder_name": holder_name,
      "account_number": account_number,
      "ifsc_code": ifsc_code,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
