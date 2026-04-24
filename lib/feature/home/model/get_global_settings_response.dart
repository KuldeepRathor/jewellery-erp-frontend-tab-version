import 'dart:convert';

class GetGlobalSettingsResponse {
  List<SalePrintTemplate>? salePrintTemplates;
  EstimatePrintTemplate? estimatePrintTemplate;
  TagPrintTemplate? tagPrintTemplate;
  OrganizationSettings? organizationSettings;
  List<dynamic>? accountSettings;
  dynamic settlementAccount;
  TagPreference? tagPreference;
  SalePreference? salePreference;
  EstimatePreference? estimatePreference;

  GetGlobalSettingsResponse({
    this.salePrintTemplates,
    this.estimatePrintTemplate,
    this.tagPrintTemplate,
    this.organizationSettings,
    this.accountSettings,
    this.settlementAccount,
    this.tagPreference,
    this.salePreference,
    this.estimatePreference,
  });

  factory GetGlobalSettingsResponse.fromRawJson(String str) =>
      GetGlobalSettingsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetGlobalSettingsResponse.fromJson(Map<String, dynamic> json) =>
      GetGlobalSettingsResponse(
        salePrintTemplates: json["sale_print_templates"] == null
            ? []
            : List<SalePrintTemplate>.from(json["sale_print_templates"]!
                .map((x) => SalePrintTemplate.fromJson(x))),
        estimatePrintTemplate: json["estimate_print_template"] == null
            ? null
            : EstimatePrintTemplate.fromJson(json["estimate_print_template"]),
        tagPrintTemplate: json["tag_print_template"] == null
            ? null
            : TagPrintTemplate.fromJson(json["tag_print_template"]),
        organizationSettings: json["organization_settings"] == null
            ? null
            : OrganizationSettings.fromJson(json["organization_settings"]),
        accountSettings: json["account_settings"] == null
            ? []
            : List<dynamic>.from(json["account_settings"]!.map((x) => x)),
        settlementAccount: json["settlement_account"],
        tagPreference: json["tag_preference"] == null
            ? null
            : TagPreference.fromJson(json["tag_preference"]),
        salePreference: json["sale_preference"] == null
            ? null
            : SalePreference.fromJson(json["sale_preference"]),
        estimatePreference: json["estimate_preference"] == null
            ? null
            : EstimatePreference.fromJson(json["estimate_preference"]),
      );

  Map<String, dynamic> toJson() => {
        "sale_print_templates": salePrintTemplates == null
            ? []
            : List<dynamic>.from(salePrintTemplates!.map((x) => x.toJson())),
        "estimate_print_template": estimatePrintTemplate?.toJson(),
        "tag_print_template": tagPrintTemplate?.toJson(),
        "organization_settings": organizationSettings?.toJson(),
        "account_settings": accountSettings == null
            ? []
            : List<dynamic>.from(accountSettings!.map((x) => x)),
        "settlement_account": settlementAccount,
        "tag_preference": tagPreference?.toJson(),
        "sale_preference": salePreference?.toJson(),
        "estimate_preference": estimatePreference?.toJson(),
      };
}

class EstimatePreference {
  dynamic organizationId;
  bool? askSalesPersonDetails;
  bool? reduceInVaFirst;

  EstimatePreference({
    this.organizationId,
    this.askSalesPersonDetails,
    this.reduceInVaFirst,
  });

  factory EstimatePreference.fromRawJson(String str) =>
      EstimatePreference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EstimatePreference.fromJson(Map<String, dynamic> json) =>
      EstimatePreference(
        organizationId: json["organization_id"],
        askSalesPersonDetails: json["ask_sales_person_details"],
        reduceInVaFirst: json["reduce_in_va_first"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "ask_sales_person_details": askSalesPersonDetails,
        "reduce_in_va_first": reduceInVaFirst,
      };
}

class EstimatePrintTemplate {
  String? organizationId;
  String? percentVa;
  String? gramsVa;
  bool? mcTotal;
  bool? vendorCode;
  bool? empCode;
  bool? stockAge;
  bool? rateValideTill;
  bool? showAdditionalMessage;
  String? additionalMessage;

  EstimatePrintTemplate({
    this.organizationId,
    this.percentVa,
    this.gramsVa,
    this.mcTotal,
    this.vendorCode,
    this.empCode,
    this.stockAge,
    this.rateValideTill,
    this.showAdditionalMessage,
    this.additionalMessage,
  });

  factory EstimatePrintTemplate.fromRawJson(String str) =>
      EstimatePrintTemplate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EstimatePrintTemplate.fromJson(Map<String, dynamic> json) =>
      EstimatePrintTemplate(
        organizationId: json["organization_id"],
        percentVa: json["percent_va"],
        gramsVa: json["grams_va"],
        mcTotal: json["mc_total"],
        vendorCode: json["vendor_code"],
        empCode: json["emp_code"],
        stockAge: json["stock_age"],
        rateValideTill: json["rate_valide_till"],
        showAdditionalMessage: json["show_additional_message"],
        additionalMessage: json["additional_message"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "percent_va": percentVa,
        "grams_va": gramsVa,
        "mc_total": mcTotal,
        "vendor_code": vendorCode,
        "emp_code": empCode,
        "stock_age": stockAge,
        "rate_valide_till": rateValideTill,
        "show_additional_message": showAdditionalMessage,
        "additional_message": additionalMessage,
      };
}

class OrganizationSettings {
  String? id;
  String? organizationId;
  String? webstoreBaseUrl;
  bool? isShippingChargeFromCustomer;
  String? shippingCharges;
  bool? isPgChargeFromCustomer;
  String? paymentGatewayCharges;
  String? advanceBookingPercentage;
  dynamic additionalWebstoreVa;
  dynamic additionalWebstoreMc;
  dynamic termsOfUse;
  dynamic privacyPolicy;
  dynamic returnPolicy;
  dynamic shippingPolicy;
  bool? isPayoutEnabled;
  String? razorpayAccountId;
  String? settlementDeduction;
  dynamic organizationState;

  OrganizationSettings({
    this.id,
    this.organizationId,
    this.webstoreBaseUrl,
    this.isShippingChargeFromCustomer,
    this.shippingCharges,
    this.isPgChargeFromCustomer,
    this.paymentGatewayCharges,
    this.advanceBookingPercentage,
    this.additionalWebstoreVa,
    this.additionalWebstoreMc,
    this.termsOfUse,
    this.privacyPolicy,
    this.returnPolicy,
    this.shippingPolicy,
    this.isPayoutEnabled,
    this.razorpayAccountId,
    this.settlementDeduction,
    this.organizationState,
  });

  factory OrganizationSettings.fromRawJson(String str) =>
      OrganizationSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrganizationSettings.fromJson(Map<String, dynamic> json) =>
      OrganizationSettings(
        id: json["id"],
        organizationId: json["organization_id"],
        webstoreBaseUrl: json["webstore_base_url"],
        isShippingChargeFromCustomer: json["is_shipping_charge_from_customer"],
        shippingCharges: json["shipping_charges"],
        isPgChargeFromCustomer: json["is_pg_charge_from_customer"],
        paymentGatewayCharges: json["payment_gateway_charges"],
        advanceBookingPercentage: json["advance_booking_percentage"],
        additionalWebstoreVa: json["additional_webstore_va"],
        additionalWebstoreMc: json["additional_webstore_mc"],
        termsOfUse: json["terms_of_use"],
        privacyPolicy: json["privacy_policy"],
        returnPolicy: json["return_policy"],
        shippingPolicy: json["shipping_policy"],
        isPayoutEnabled: json["is_payout_enabled"],
        razorpayAccountId: json["razorpay_account_id"],
        settlementDeduction: json["settlement_deduction"],
        organizationState: json["organization_state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "webstore_base_url": webstoreBaseUrl,
        "is_shipping_charge_from_customer": isShippingChargeFromCustomer,
        "shipping_charges": shippingCharges,
        "is_pg_charge_from_customer": isPgChargeFromCustomer,
        "payment_gateway_charges": paymentGatewayCharges,
        "advance_booking_percentage": advanceBookingPercentage,
        "additional_webstore_va": additionalWebstoreVa,
        "additional_webstore_mc": additionalWebstoreMc,
        "terms_of_use": termsOfUse,
        "privacy_policy": privacyPolicy,
        "return_policy": returnPolicy,
        "shipping_policy": shippingPolicy,
        "is_payout_enabled": isPayoutEnabled,
        "razorpay_account_id": razorpayAccountId,
        "settlement_deduction": settlementDeduction,
        "organization_state": organizationState,
      };
}

class SalePreference {
  dynamic organizationId;
  bool? askCustomerAbove10K;
  bool? askPanAbove2L;

  SalePreference({
    this.organizationId,
    this.askCustomerAbove10K,
    this.askPanAbove2L,
  });

  factory SalePreference.fromRawJson(String str) =>
      SalePreference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalePreference.fromJson(Map<String, dynamic> json) => SalePreference(
        organizationId: json["organization_id"],
        askCustomerAbove10K: json["ask_customer_above_10k"],
        askPanAbove2L: json["ask_pan_above_2L"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "ask_customer_above_10k": askCustomerAbove10K,
        "ask_pan_above_2L": askPanAbove2L,
      };
}

class SalePrintTemplate {
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

  SalePrintTemplate({
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

  factory SalePrintTemplate.fromRawJson(String str) =>
      SalePrintTemplate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalePrintTemplate.fromJson(Map<String, dynamic> json) =>
      SalePrintTemplate(
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

class TagPreference {
  dynamic organizationId;
  bool? lotBasedTaggingOnly;
  bool? autoCreateLotPurchase;
  bool? autoCreateLotMaterialIn;
  bool? autoCreateLotSalesReturn;
  bool? autoCreateLotStockDifference;

  TagPreference({
    this.organizationId,
    this.lotBasedTaggingOnly,
    this.autoCreateLotPurchase,
    this.autoCreateLotMaterialIn,
    this.autoCreateLotSalesReturn,
    this.autoCreateLotStockDifference,
  });

  factory TagPreference.fromRawJson(String str) =>
      TagPreference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TagPreference.fromJson(Map<String, dynamic> json) => TagPreference(
        organizationId: json["organization_id"],
        lotBasedTaggingOnly: json["lot_based_tagging_only"],
        autoCreateLotPurchase: json["auto_create_lot_purchase"],
        autoCreateLotMaterialIn: json["auto_create_lot_material_in"],
        autoCreateLotSalesReturn: json["auto_create_lot_sales_return"],
        autoCreateLotStockDifference: json["auto_create_lot_stock_difference"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "lot_based_tagging_only": lotBasedTaggingOnly,
        "auto_create_lot_purchase": autoCreateLotPurchase,
        "auto_create_lot_material_in": autoCreateLotMaterialIn,
        "auto_create_lot_sales_return": autoCreateLotSalesReturn,
        "auto_create_lot_stock_difference": autoCreateLotStockDifference,
      };
}

class TagPrintTemplate {
  dynamic organizationId;
  bool? leftDesignName;
  bool? leftVendor;
  bool? leftTagNumber;
  bool? leftStoneWeight;
  bool? leftGrossWeight;
  bool? leftNetWeight;
  bool? leftPurity;
  bool? leftVaTypeGms;
  bool? leftSize;
  bool? leftHuid;
  bool? leftBarcodeNumber;
  bool? rightDesignName;
  bool? rightVendor;
  bool? rightTagNumber;
  bool? rightStoneWeight;
  bool? rightGrossWeight;
  bool? rightNetWeight;
  bool? rightPurity;
  bool? rightVaTypeGms;
  bool? rightSize;
  bool? rightHuid;
  bool? rightBarcodeNumber;

  TagPrintTemplate({
    this.organizationId,
    this.leftDesignName,
    this.leftVendor,
    this.leftTagNumber,
    this.leftStoneWeight,
    this.leftGrossWeight,
    this.leftNetWeight,
    this.leftPurity,
    this.leftVaTypeGms,
    this.leftSize,
    this.leftHuid,
    this.leftBarcodeNumber,
    this.rightDesignName,
    this.rightVendor,
    this.rightTagNumber,
    this.rightStoneWeight,
    this.rightGrossWeight,
    this.rightNetWeight,
    this.rightPurity,
    this.rightVaTypeGms,
    this.rightSize,
    this.rightHuid,
    this.rightBarcodeNumber,
  });

  factory TagPrintTemplate.fromRawJson(String str) =>
      TagPrintTemplate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TagPrintTemplate.fromJson(Map<String, dynamic> json) =>
      TagPrintTemplate(
        organizationId: json["organization_id"],
        leftDesignName: json["left_design_name"],
        leftVendor: json["left_vendor"],
        leftTagNumber: json["left_tag_number"],
        leftStoneWeight: json["left_stone_weight"],
        leftGrossWeight: json["left_gross_weight"],
        leftNetWeight: json["left_net_weight"],
        leftPurity: json["left_purity"],
        leftVaTypeGms: json["left_va_type_gms"],
        leftSize: json["left_size"],
        leftHuid: json["left_huid"],
        leftBarcodeNumber: json["left_barcode_number"],
        rightDesignName: json["right_design_name"],
        rightVendor: json["right_vendor"],
        rightTagNumber: json["right_tag_number"],
        rightStoneWeight: json["right_stone_weight"],
        rightGrossWeight: json["right_gross_weight"],
        rightNetWeight: json["right_net_weight"],
        rightPurity: json["right_purity"],
        rightVaTypeGms: json["right_va_type_gms"],
        rightSize: json["right_size"],
        rightHuid: json["right_huid"],
        rightBarcodeNumber: json["right_barcode_number"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "left_design_name": leftDesignName,
        "left_vendor": leftVendor,
        "left_tag_number": leftTagNumber,
        "left_stone_weight": leftStoneWeight,
        "left_gross_weight": leftGrossWeight,
        "left_net_weight": leftNetWeight,
        "left_purity": leftPurity,
        "left_va_type_gms": leftVaTypeGms,
        "left_size": leftSize,
        "left_huid": leftHuid,
        "left_barcode_number": leftBarcodeNumber,
        "right_design_name": rightDesignName,
        "right_vendor": rightVendor,
        "right_tag_number": rightTagNumber,
        "right_stone_weight": rightStoneWeight,
        "right_gross_weight": rightGrossWeight,
        "right_net_weight": rightNetWeight,
        "right_purity": rightPurity,
        "right_va_type_gms": rightVaTypeGms,
        "right_size": rightSize,
        "right_huid": rightHuid,
        "right_barcode_number": rightBarcodeNumber,
      };
}
