import 'dart:convert';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/payment_method_detail_model.dart';

class PaymentDetail {
  String? id;
  String? organizationId;
  String? purchaseInvoiceId;
  String? subTotal;
  String? nett;
  String? cgst;
  String? sgst;
  String? igst;
  String? nettBeforeTaxDeduction;
  String? total;
  String? tcs;
  String? tds;
  String? paidAmount;
  String? balanceAmount;
  String? roundOff;
  List<PaymentMethodDetail>? paymentMethodDetails;
  String? hallmark;
  PaymentDetail({
    this.id,
    this.organizationId,
    this.purchaseInvoiceId,
    this.subTotal,
    this.nett,
    this.cgst,
    this.sgst,
    this.igst,
    this.nettBeforeTaxDeduction,
    this.total,
    this.tcs,
    this.tds,
    this.paidAmount,
    this.balanceAmount,
    this.paymentMethodDetails,
    this.roundOff,
    this.hallmark,
  });

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    id: json["id"],
    organizationId: json["organization_id"],
    purchaseInvoiceId: json["purchase_invoice_id"],
    subTotal: json["sub_total"],
    nett: json["nett"],
    cgst: json["cgst"],
    sgst: json["sgst"],
    igst: json["igst"],
    nettBeforeTaxDeduction: json["nett_before_tax_deduction"],
    total: json["total"],
    tcs: json["tcs"],
    tds: json["tds"],
    paidAmount: json["paid_amount"],
    balanceAmount: json["balance_amount"],
    roundOff: json["round_off"],
    paymentMethodDetails:
        json["payment_method_details"] == null
            ? []
            : List<PaymentMethodDetail>.from(
              json["payment_method_details"]!.map(
                (x) => PaymentMethodDetail.fromJson(x),
              ),
            ),
    hallmark: json["hallmark"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "purchase_invoice_id": purchaseInvoiceId,
    "sub_total": subTotal,
    "nett": nett,
    "cgst": cgst,
    "sgst": sgst,
    "igst": igst,
    "nett_before_tax_deduction": nettBeforeTaxDeduction,
    "total": total,
    "tcs": tcs,
    "tds": tds,
    "paid_amount": paidAmount,
    "balance_amount": balanceAmount,
    "round_off": roundOff,
    "payment_method_details":
        paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
    "hallmark": hallmark,
  };
  Map<String, dynamic> toRequestJson() => {
    // "id": id,
    // "organization_id": organizationId,
    // "purchase_invoice_id": purchaseInvoiceId,
    "sub_total": subTotal,
    "nett": nett,
    "cgst": cgst,
    "sgst": sgst,
    "igst": igst,
    "total": total,
    "tcs": tcs,
    "tds": tds,
    "paid_amount": paidAmount,
    "balance_amount": balanceAmount,
    "payment_method_details":
        paymentMethodDetails == null
            ? []
            : List<dynamic>.from(
              paymentMethodDetails!.map((x) => x.toRequestJson()),
            ),
  };
}
