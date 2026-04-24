import 'dart:convert';

class GetSalesPrintTemplateResponse {
  dynamic organizationId;
  int? templateNumber;
  String? percentVa;
  String? gramsVa;
  bool? mcTotal;
  int? panInvoiceCopy;
  int? balanceInvoiceCopy;
  bool? oldDetailsSlip;
  bool? itemDifferenceSlip;
  bool? printEstimate;
  bool? showAdditionalMessage;
  String? additionalMessage;
  String? schemeDiscount;
  String? rateDiscount;
  String? discount;
  String? additionalLess;

  GetSalesPrintTemplateResponse({
    this.organizationId,
    this.templateNumber,
    this.percentVa,
    this.gramsVa,
    this.mcTotal,
    this.panInvoiceCopy,
    this.balanceInvoiceCopy,
    this.oldDetailsSlip,
    this.itemDifferenceSlip,
    this.printEstimate,
    this.showAdditionalMessage,
    this.additionalMessage,
    this.schemeDiscount,
    this.rateDiscount,
    this.discount,
    this.additionalLess,
  });

  factory GetSalesPrintTemplateResponse.fromRawJson(String str) =>
      GetSalesPrintTemplateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesPrintTemplateResponse.fromJson(Map<String, dynamic> json) =>
      GetSalesPrintTemplateResponse(
        organizationId: json["organization_id"],
        templateNumber: json["template_number"],
        percentVa: json["percent_va"],
        gramsVa: json["grams_va"],
        mcTotal: json["mc_total"],
        panInvoiceCopy: json["pan_invoice_copy"],
        balanceInvoiceCopy: json["balance_invoice_copy"],
        oldDetailsSlip: json["old_details_slip"],
        itemDifferenceSlip: json["item_difference_slip"],
        printEstimate: json["print_estimate"],
        showAdditionalMessage: json["show_additional_message"],
        additionalMessage: json["additional_message"],
        schemeDiscount: json["scheme_discount"],
        rateDiscount: json["rate_discount"],
        discount: json["discount"],
        additionalLess: json["additional_less"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "template_number": templateNumber,
        "percent_va": percentVa,
        "grams_va": gramsVa,
        "mc_total": mcTotal,
        "pan_invoice_copy": panInvoiceCopy,
        "balance_invoice_copy": balanceInvoiceCopy,
        "old_details_slip": oldDetailsSlip,
        "item_difference_slip": itemDifferenceSlip,
        "print_estimate": printEstimate,
        "show_additional_message": showAdditionalMessage,
        "additional_message": additionalMessage,
        "scheme_discount": schemeDiscount,
        "rate_discount": rateDiscount,
        "discount": discount,
        "additional_less": additionalLess,
      };
}
