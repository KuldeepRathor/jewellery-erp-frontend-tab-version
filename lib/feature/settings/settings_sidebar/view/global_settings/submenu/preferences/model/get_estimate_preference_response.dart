import 'dart:convert';

class GetEstimatePreferenceResponse {
  bool? askSalesPersonDetails;
  bool? reduceInVaFirst;

  GetEstimatePreferenceResponse({
    this.askSalesPersonDetails,
    this.reduceInVaFirst,
  });

  factory GetEstimatePreferenceResponse.fromRawJson(String str) =>
      GetEstimatePreferenceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEstimatePreferenceResponse.fromJson(Map<String, dynamic> json) =>
      GetEstimatePreferenceResponse(
        askSalesPersonDetails: json["ask_sales_person_details"],
        reduceInVaFirst: json["reduce_in_va_first"],
      );

  Map<String, dynamic> toJson() => {
        "ask_sales_person_details": askSalesPersonDetails,
        "reduce_in_va_first": reduceInVaFirst,
      };
}
