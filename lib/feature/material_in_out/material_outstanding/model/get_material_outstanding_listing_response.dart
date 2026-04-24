import 'dart:convert';

class GetMaterialOutstandingListingResponse {
  List<GetMaterialOutstandingListingValue>? values;

  GetMaterialOutstandingListingResponse({
    this.values,
  });

  factory GetMaterialOutstandingListingResponse.fromRawJson(String str) =>
      GetMaterialOutstandingListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMaterialOutstandingListingResponse.fromJson(
          Map<String, dynamic> json) =>
      GetMaterialOutstandingListingResponse(
        values: json["values"] == null
            ? []
            : List<GetMaterialOutstandingListingValue>.from(json["values"]!
                .map((x) => GetMaterialOutstandingListingValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetMaterialOutstandingListingValue {
  String? partyId;
  String? partyName;
  String? partyType;
  String? weightDebit;
  String? weightCredit;
  String? amountDebit;
  String? amountCredit;
  String? closingWeight;
  String? closingAmount;

  GetMaterialOutstandingListingValue({
    this.partyId,
    this.partyName,
    this.partyType,
    this.weightDebit,
    this.weightCredit,
    this.amountDebit,
    this.amountCredit,
    this.closingWeight,
    this.closingAmount,
  });

  factory GetMaterialOutstandingListingValue.fromRawJson(String str) =>
      GetMaterialOutstandingListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMaterialOutstandingListingValue.fromJson(
          Map<String, dynamic> json) =>
      GetMaterialOutstandingListingValue(
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyType: json["party_type"],
        weightDebit: json["weight_debit"],
        weightCredit: json["weight_credit"],
        amountDebit: json["amount_debit"],
        amountCredit: json["amount_credit"],
        closingWeight: json["closing_weight"],
        closingAmount: json["closing_amount"],
      );

  Map<String, dynamic> toJson() => {
        "party_id": partyId,
        "party_name": partyName,
        "party_type": partyType,
        "weight_debit": weightDebit,
        "weight_credit": weightCredit,
        "amount_debit": amountDebit,
        "amount_credit": amountCredit,
        "closing_weight": closingWeight,
        "closing_amount": closingAmount,
      };
}
