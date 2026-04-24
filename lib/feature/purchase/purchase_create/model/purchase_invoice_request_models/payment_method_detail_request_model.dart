import 'dart:convert';

class PaymentMethodDetailRequestModel {
  String? amount;
  DateTime? date;
  String? method;
  String? paymentCode;
  String? posAccountId;
  String? purchaseReturnId;

  PaymentMethodDetailRequestModel({
    this.amount,
    this.date,
    this.method,
    this.paymentCode,
    this.purchaseReturnId,
    this.posAccountId,
  });

  factory PaymentMethodDetailRequestModel.fromRawJson(String str) =>
      PaymentMethodDetailRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodDetailRequestModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetailRequestModel(
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        method: json["method"],
        paymentCode: json["payment_code"],
        purchaseReturnId: json["purchase_return_id"],
        posAccountId: json["pos_account_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date?.toIso8601String(),
        "method": method,
        "payment_code": paymentCode,
        "purchase_return_id": purchaseReturnId,
        "pos_account_id": posAccountId,
      };
}
