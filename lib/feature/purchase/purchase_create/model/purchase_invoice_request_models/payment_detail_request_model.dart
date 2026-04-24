import 'dart:convert';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/payment_method_detail_request_model.dart';

class PaymentDetailRequestModel {
  String? balanceAmount;
  String? nett;
  String? paidAmount;

  String? hallmark;
  List<PaymentMethodDetailRequestModel>? paymentMethodDetails;
  String? roundOff;
  String? cgst;
  String? sgst;
  String? igst;
  String? subTotal;
  String? tcs;
  String? tds;
  String? total;

  PaymentDetailRequestModel({
    this.balanceAmount,
    this.cgst,
    this.nett,
    this.paidAmount,
    this.hallmark,
    this.paymentMethodDetails,
    this.roundOff,
    this.sgst,
    this.subTotal,
    this.tcs,
    this.tds,
    this.total,
    this.igst,
  });

  factory PaymentDetailRequestModel.fromRawJson(String str) =>
      PaymentDetailRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetailRequestModel.fromJson(Map<String, dynamic> json) =>
      PaymentDetailRequestModel(
        balanceAmount: json["balance_amount"],
        cgst: json["cgst"],
        nett: json["nett"],
        paidAmount: json["paid_amount"],
        hallmark: json["hallmark"],
        paymentMethodDetails:
            json["payment_method_details"] == null
                ? []
                : List<PaymentMethodDetailRequestModel>.from(
                  json["payment_method_details"]!.map(
                    (x) => PaymentMethodDetailRequestModel.fromJson(x),
                  ),
                ),
        roundOff: json["round_off"],
        sgst: json["sgst"],
        subTotal: json["sub_total"],
        tcs: json["tcs"],
        tds: json["tds"],
        total: json["total"],
        igst: json["igst"],
      );

  Map<String, dynamic> toJson() => {
    "balance_amount": balanceAmount,
    "cgst": cgst,
    "nett": nett,
    "paid_amount": paidAmount,
    "hallmark": hallmark,
    "payment_method_details":
        paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
    "round_off": roundOff,
    "sgst": sgst,
    "sub_total": subTotal,
    "tcs": tcs,
    "tds": tds,
    "total": total,
    "igst": igst,
  };
}
