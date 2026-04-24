import 'dart:convert';

class PartyBalanceResponse {
  List<PartyBalanceResponseValue>? values;

  PartyBalanceResponse({
    this.values,
  });

  factory PartyBalanceResponse.fromRawJson(String str) =>
      PartyBalanceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PartyBalanceResponse.fromJson(Map<String, dynamic> json) =>
      PartyBalanceResponse(
        values: json["values"] == null
            ? []
            : List<PartyBalanceResponseValue>.from(json["values"]!
                .map((x) => PartyBalanceResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class PartyBalanceResponseValue {
  String? partyId;
  String? partyName;
  String? partyType;
  String? balanceCredit;
  String? balanceDebit;
  String? balanceDifference;

  PartyBalanceResponseValue({
    this.partyId,
    this.partyName,
    this.partyType,
    this.balanceCredit,
    this.balanceDebit,
    this.balanceDifference,
  });

  factory PartyBalanceResponseValue.fromRawJson(String str) =>
      PartyBalanceResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PartyBalanceResponseValue.fromJson(Map<String, dynamic> json) =>
      PartyBalanceResponseValue(
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyType: json["party_type"],
        balanceCredit: json["balance_credit"],
        balanceDebit: json["balance_debit"],
        balanceDifference: json["balance_difference"],
      );

  Map<String, dynamic> toJson() => {
        "party_id": partyId,
        "party_name": partyName,
        "party_type": partyType,
        "balance_credit": balanceCredit,
        "balance_debit": balanceDebit,
        "balance_difference": balanceDifference,
      };
}
