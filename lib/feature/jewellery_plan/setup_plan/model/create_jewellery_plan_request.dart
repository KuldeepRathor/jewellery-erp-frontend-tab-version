import 'dart:convert';

class CreateJewelleryPlanRequest {
  bool? collectGst;
  List<String>? designIds;
  int? gracePeriod;
  int? installmentBonus;
  int? jlId;
  String? maxSipAmount;
  String? mcBenefit;
  String? mcBenefitUpto;
  String? minSipAmount;
  String? organizationId;
  bool? paymentGatewayCharges;
  List<String>? planBenifit;
  int? planDuration;
  String? planName;
  String? planType;
  String? prefixedAmount;
  String? shopId;
  String? stockHeadId;
  String? stockHeadMetalType;
  String? stoneBenefitUpto;
  String? stoneType;
  String? tcTemplateId;
  String? termsAndCondition;
  String? vaBenefit;
  String? vaBenefitUpto;

  CreateJewelleryPlanRequest({
    this.collectGst,
    this.designIds,
    this.gracePeriod,
    this.installmentBonus,
    this.jlId,
    this.maxSipAmount,
    this.mcBenefit,
    this.mcBenefitUpto,
    this.minSipAmount,
    this.organizationId,
    this.paymentGatewayCharges,
    this.planBenifit,
    this.planDuration,
    this.planName,
    this.planType,
    this.prefixedAmount,
    this.shopId,
    this.stockHeadId,
    this.stockHeadMetalType,
    this.stoneBenefitUpto,
    this.stoneType,
    this.tcTemplateId,
    this.termsAndCondition,
    this.vaBenefit,
    this.vaBenefitUpto,
  });

  factory CreateJewelleryPlanRequest.fromRawJson(String str) =>
      CreateJewelleryPlanRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateJewelleryPlanRequest.fromJson(Map<String, dynamic> json) =>
      CreateJewelleryPlanRequest(
        collectGst: json["collect_gst"],
        designIds: json["design_ids"] == null
            ? []
            : List<String>.from(json["design_ids"]!.map((x) => x)),
        gracePeriod: json["grace_period"],
        installmentBonus: json["installment_bonus"],
        jlId: json["jl_id"],
        maxSipAmount: json["max_sip_amount"],
        mcBenefit: json["mc_benefit"],
        mcBenefitUpto: json["mc_benefit_upto"],
        minSipAmount: json["min_sip_amount"],
        organizationId: json["organization_id"],
        paymentGatewayCharges: json["payment_gateway_charges"],
        planBenifit: json["plan_benifit"] == null
            ? []
            : List<String>.from(json["plan_benifit"]!.map((x) => x)),
        planDuration: json["plan_duration"],
        planName: json["plan_name"],
        planType: json["plan_type"],
        prefixedAmount: json["prefixed_amount"],
        shopId: json["shop_id"],
        stockHeadId: json["stock_head_id"],
        stockHeadMetalType: json["stock_head_metal_type"],
        stoneBenefitUpto: json["stone_benefit_upto"],
        stoneType: json["stone_type"],
        tcTemplateId: json["tc_template_id"],
        termsAndCondition: json["terms_and_condition"],
        vaBenefit: json["va_benefit"],
        vaBenefitUpto: json["va_benefit_upto"],
      );

  Map<String, dynamic> toJson() => {
        "collect_gst": collectGst,
        "design_ids": designIds == null
            ? []
            : List<dynamic>.from(designIds!.map((x) => x)),
        "grace_period": gracePeriod,
        "installment_bonus": installmentBonus,
        "jl_id": jlId,
        "max_sip_amount": maxSipAmount,
        "mc_benefit": mcBenefit,
        "mc_benefit_upto": mcBenefitUpto,
        "min_sip_amount": minSipAmount,
        "organization_id": organizationId,
        "payment_gateway_charges": paymentGatewayCharges,
        "plan_benifit": planBenifit == null
            ? []
            : List<dynamic>.from(planBenifit!.map((x) => x)),
        "plan_duration": planDuration,
        "plan_name": planName,
        "plan_type": planType,
        "prefixed_amount": prefixedAmount,
        "shop_id": shopId,
        "stock_head_id": stockHeadId,
        "stock_head_metal_type": stockHeadMetalType,
        "stone_benefit_upto": stoneBenefitUpto,
        "stone_type": stoneType,
        "tc_template_id": tcTemplateId,
        "terms_and_condition": termsAndCondition,
        "va_benefit": vaBenefit,
        "va_benefit_upto": vaBenefitUpto,
      };
}
