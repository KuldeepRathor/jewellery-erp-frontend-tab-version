import 'dart:convert';

class PaymentMethodDetail {
  String? id;
  String? organizationId;
  String? purchaseInvoicePaymentDetailsId;
  String? amount;
  String? method;
  DateTime? date;
  String? pos;
  String? paymentCode;

  PaymentMethodDetail({
    this.id,
    this.organizationId,
    this.purchaseInvoicePaymentDetailsId,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
  });

  factory PaymentMethodDetail.fromRawJson(String str) =>
      PaymentMethodDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodDetail.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetail(
        id: json["id"],
        organizationId: json["organization_id"],
        purchaseInvoicePaymentDetailsId:
            json["purchase_invoice_payment_details_id"],
        amount: json["amount"],
        method: json["method"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        pos: json["pos"],
        paymentCode: json["payment_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "purchase_invoice_payment_details_id": purchaseInvoicePaymentDetailsId,
        "amount": amount,
        "method": method,
        "date": date,
        "pos": pos,
        "payment_code": paymentCode,
      };
  Map<String, dynamic> toRequestJson() => {
        // "id": id,
        // "organization_id": organizationId,
        // "purchase_invoice_payment_details_id": purchaseInvoicePaymentDetailsId,
        "amount": amount,
        "method": method,
        "date": date,
        "pos": pos,
        "payment_code": paymentCode,
      };
}
