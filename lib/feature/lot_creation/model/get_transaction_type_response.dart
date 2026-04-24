import 'dart:convert';

class LotTransactionTypesResponse {
  String? id;
  String? transactionType;

  LotTransactionTypesResponse({
    this.id,
    this.transactionType,
  });

  factory LotTransactionTypesResponse.fromRawJson(String str) =>
      LotTransactionTypesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LotTransactionTypesResponse.fromJson(Map<String, dynamic> json) =>
      LotTransactionTypesResponse(
        id: json["id"],
        transactionType: json["transaction_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_type": transactionType,
      };
}
