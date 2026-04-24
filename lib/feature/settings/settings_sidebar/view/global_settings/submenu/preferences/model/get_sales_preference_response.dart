import 'dart:convert';

class GetSalesPreferenceResponse {
  bool? askCustomerAbove10K;
  bool? askPanAbove2L;

  GetSalesPreferenceResponse({
    this.askCustomerAbove10K,
    this.askPanAbove2L,
  });

  factory GetSalesPreferenceResponse.fromRawJson(String str) =>
      GetSalesPreferenceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      GetSalesPreferenceResponse(
        askCustomerAbove10K: json["ask_customer_above_10k"],
        askPanAbove2L: json["ask_pan_above_2L"],
      );

  Map<String, dynamic> toJson() => {
        "ask_customer_above_10k": askCustomerAbove10K,
        "ask_pan_above_2L": askPanAbove2L,
      };
}
