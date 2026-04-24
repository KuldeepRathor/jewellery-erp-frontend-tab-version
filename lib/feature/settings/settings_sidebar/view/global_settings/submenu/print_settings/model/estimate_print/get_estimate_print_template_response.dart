import 'dart:convert';

class GetEstimatePrintTemplateResponse {
  String? percentVa;
  String? gramsVa;
  bool? mcTotal;
  bool? vendorCode;
  bool? stockAge;
  bool? empCode;
  bool? rateValideTill;
  bool? showAdditionalMessage;
  String? additionalMessage;

  GetEstimatePrintTemplateResponse({
    this.percentVa,
    this.gramsVa,
    this.mcTotal,
    this.vendorCode,
    this.stockAge,
    this.empCode,
    this.rateValideTill,
    this.showAdditionalMessage,
    this.additionalMessage,
  });

  factory GetEstimatePrintTemplateResponse.fromRawJson(String str) =>
      GetEstimatePrintTemplateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetEstimatePrintTemplateResponse.fromJson(
          Map<String, dynamic> json) =>
      GetEstimatePrintTemplateResponse(
        percentVa: json["percent_va"],
        gramsVa: json["grams_va"],
        mcTotal: json["mc_total"],
        vendorCode: json["vendor_code"],
        stockAge: json["stock_age"],
        empCode: json["emp_code"],
        rateValideTill: json["rate_valide_till"],
        showAdditionalMessage: json["show_additional_message"],
        additionalMessage: json["additional_message"],
      );

  Map<String, dynamic> toJson() => {
        "percent_va": percentVa,
        "grams_va": gramsVa,
        "mc_total": mcTotal,
        "vendor_code": vendorCode,
        "stock_age": stockAge,
        "emp_code": empCode,
        "rate_valide_till": rateValideTill,
        "show_additional_message": showAdditionalMessage,
        "additional_message": additionalMessage,
      };
}
