import 'dart:convert';

class CalculateAmountResponse {
  double? weight;
  double? rate;
  double? subTotal;
  double? vaAmount;
  double? cgstAmount;
  double? igstAmount;
  double? sgstAmount;
  double? totalAmount;
  double? roundOff;

  CalculateAmountResponse({
    this.weight,
    this.rate,
    this.subTotal,
    this.vaAmount,
    this.cgstAmount,
    this.igstAmount,
    this.sgstAmount,
    this.totalAmount,
    this.roundOff,
  });

  factory CalculateAmountResponse.fromRawJson(String str) =>
      CalculateAmountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalculateAmountResponse.fromJson(Map<String, dynamic> json) =>
      CalculateAmountResponse(
        weight: json["weight"]?.toDouble(),
        rate: json["rate"]?.toDouble(),
        subTotal: json["sub_total"]?.toDouble(),
        vaAmount: json["va_amount"]?.toDouble(),
        cgstAmount: json["cgst_amount"]?.toDouble(),
        igstAmount: json["igst_amount"]?.toDouble(),
        sgstAmount: json["sgst_amount"]?.toDouble(),
        totalAmount: json["total_amount"]?.toDouble(),
        roundOff: json["round_off"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "weight": weight,
        "rate": rate,
        "sub_total": subTotal,
        "va_amount": vaAmount,
        "cgst_amount": cgstAmount,
        "igst_amount": igstAmount,
        "sgst_amount": sgstAmount,
        "total_amount": totalAmount,
        "round_off": roundOff,
      };
}
