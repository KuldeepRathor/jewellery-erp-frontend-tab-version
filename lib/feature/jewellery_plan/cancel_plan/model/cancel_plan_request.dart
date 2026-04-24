import 'dart:convert';

class CancelPlanRequest {
  String? planId;
  int? deduction;
  int? amountPayable;
  DateTime? cancelDate;
  int? paymentMode;
  dynamic bank;
  DateTime? paymentDate;
  String? comments;

  CancelPlanRequest({
    this.planId,
    this.deduction,
    this.amountPayable,
    this.cancelDate,
    this.paymentMode,
    this.bank,
    this.paymentDate,
    this.comments,
  });

  factory CancelPlanRequest.fromRawJson(String str) =>
      CancelPlanRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelPlanRequest.fromJson(Map<String, dynamic> json) =>
      CancelPlanRequest(
        planId: json["plan_id"],
        deduction: json["deduction"],
        amountPayable: json["amount_payable"],
        cancelDate: json["cancel_date"] == null
            ? null
            : DateTime.parse(json["cancel_date"]),
        paymentMode: json["payment_mode"],
        bank: json["bank"],
        paymentDate: json["payment_date"] == null
            ? null
            : DateTime.parse(json["payment_date"]),
        comments: json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "deduction": deduction,
        "amount_payable": amountPayable,
        "cancel_date":
            "${cancelDate!.year.toString().padLeft(4, '0')}-${cancelDate!.month.toString().padLeft(2, '0')}-${cancelDate!.day.toString().padLeft(2, '0')}",
        "payment_mode": paymentMode,
        "bank": bank,
        "payment_date":
            "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
        "comments": comments,
      };
}
