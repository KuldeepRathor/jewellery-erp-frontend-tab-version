import 'dart:convert';

class GetAccountsResponse {
  List<BankAccount>? bankAccounts;
  List<PosAccount>? posAccounts;

  GetAccountsResponse({
    this.bankAccounts,
    this.posAccounts,
  });

  factory GetAccountsResponse.fromRawJson(String str) =>
      GetAccountsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAccountsResponse.fromJson(Map<String, dynamic> json) =>
      GetAccountsResponse(
        bankAccounts: json["bank_accounts"] == null
            ? []
            : List<BankAccount>.from(
                json["bank_accounts"]!.map((x) => BankAccount.fromJson(x))),
        posAccounts: json["pos_accounts"] == null
            ? []
            : List<PosAccount>.from(
                json["pos_accounts"]!.map((x) => PosAccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bank_accounts": bankAccounts == null
            ? []
            : List<dynamic>.from(bankAccounts!.map((x) => x.toJson())),
        "pos_accounts": posAccounts == null
            ? []
            : List<dynamic>.from(posAccounts!.map((x) => x.toJson())),
      };
}

class BankAccount {
  int? id;
  String? number;
  int? type;

  BankAccount({
    this.id,
    this.number,
    this.type,
  });

  factory BankAccount.fromRawJson(String str) =>
      BankAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        number: json["number"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "type": type,
      };
}

class PosAccount {
  int? id;
  String? number;
  int? type;

  PosAccount({
    this.id,
    this.number,
    this.type,
  });

  factory PosAccount.fromRawJson(String str) =>
      PosAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosAccount.fromJson(Map<String, dynamic> json) => PosAccount(
        id: json["id"],
        number: json["number"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "type": type,
      };
}
