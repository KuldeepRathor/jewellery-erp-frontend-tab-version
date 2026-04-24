import 'dart:convert';

class JewelleryPlanResponse {
  String? id;
  String? organizationId;
  String? shopId;
  String? planName;
  int? planDuration;
  String? minSipAmount;
  String? maxSipAmount;
  String? prefixedAmount;
  bool? paymentGatewayCharges;
  String? vaBenefit;
  String? vaBenefitUpto;
  String? mcBenefit;
  String? mcBenefitUpto;
  String? stoneType;
  String? stoneBenefitUpto;
  int? installmentBonus;
  bool? collectGst;
  String? stockHeadId;
  String? stockHeadMetalType;
  int? gracePeriod;
  String? tcTemplateId;
  String? termsAndCondition;
  List<String>? planBenifit;
  int? jlId;
  String? subscriptionCode;
  int? dueInstallments;
  String? type;
  String? code;
  String? amount;
  int? duration;
  String? startDate;
  String? installments;
  String? totalWeight;
  String? status;
  int? setupId;
// Note redeemable amount will be used only for frontend purpose
  double? redeemableAmount;
  String? otp;
  JewelleryPlanResponse({
    this.id,
    this.organizationId,
    this.shopId,
    this.planName,
    this.planDuration,
    this.minSipAmount,
    this.maxSipAmount,
    this.prefixedAmount,
    this.paymentGatewayCharges,
    this.vaBenefit,
    this.vaBenefitUpto,
    this.mcBenefit,
    this.mcBenefitUpto,
    this.stoneType,
    this.stoneBenefitUpto,
    this.installmentBonus,
    this.collectGst,
    this.stockHeadId,
    this.stockHeadMetalType,
    this.gracePeriod,
    this.tcTemplateId,
    this.termsAndCondition,
    this.planBenifit,
    this.jlId,
    this.subscriptionCode,
    this.dueInstallments,
    this.type,
    this.code,
    this.amount,
    this.duration,
    this.startDate,
    this.installments,
    this.totalWeight,
    this.status,
    this.setupId,
    // Note redeemable amount will be used only for frontend purpose
    this.redeemableAmount,
    this.otp,
  });

  factory JewelleryPlanResponse.fromRawJson(String str) =>
      JewelleryPlanResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JewelleryPlanResponse.fromJson(Map<String, dynamic> json) =>
      JewelleryPlanResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        planName: json["plan_name"],
        planDuration: json["plan_duration"],
        minSipAmount: json["min_sip_amount"],
        maxSipAmount: json["max_sip_amount"],
        prefixedAmount: json["prefixed_amount"],
        paymentGatewayCharges: json["payment_gateway_charges"],
        vaBenefit: json["va_benefit"],
        vaBenefitUpto: json["va_benefit_upto"],
        mcBenefit: json["mc_benefit"],
        mcBenefitUpto: json["mc_benefit_upto"],
        stoneType: json["stone_type"],
        stoneBenefitUpto: json["stone_benefit_upto"],
        installmentBonus: json["installment_bonus"],
        collectGst: json["collect_gst"],
        stockHeadId: json["stock_head_id"],
        stockHeadMetalType: json["stock_head_metal_type"],
        gracePeriod: json["grace_period"],
        tcTemplateId: json["tc_template_id"],
        termsAndCondition: json["terms_and_condition"],
        planBenifit: json["plan_benifit"] == null
            ? []
            : List<String>.from(json["plan_benifit"]!.map((x) => x)),
        jlId: json["jl_id"],
        subscriptionCode: json["subscription_code"],
        dueInstallments: json["due_installments"],
        type: json["type"],
        code: json["code"],
        amount: json["amount"],
        duration: json["duration"],
        startDate: json["start_date"],
        installments: json["installments"],
        totalWeight: json["total_weight"],
        status: json["status"],
        setupId: json["setup_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "plan_name": planName,
        "plan_duration": planDuration,
        "min_sip_amount": minSipAmount,
        "max_sip_amount": maxSipAmount,
        "prefixed_amount": prefixedAmount,
        "payment_gateway_charges": paymentGatewayCharges,
        "va_benefit": vaBenefit,
        "va_benefit_upto": vaBenefitUpto,
        "mc_benefit": mcBenefit,
        "mc_benefit_upto": mcBenefitUpto,
        "stone_type": stoneType,
        "stone_benefit_upto": stoneBenefitUpto,
        "installment_bonus": installmentBonus,
        "collect_gst": collectGst,
        "stock_head_id": stockHeadId,
        "stock_head_metal_type": stockHeadMetalType,
        "grace_period": gracePeriod,
        "tc_template_id": tcTemplateId,
        "terms_and_condition": termsAndCondition,
        "plan_benifit": planBenifit == null
            ? []
            : List<dynamic>.from(planBenifit!.map((x) => x)),
        "jl_id": jlId,
        "subscription_code": subscriptionCode,
        "due_installments": dueInstallments,
        "type": type,
        "code": code,
        "amount": amount,
        "duration": duration,
        "start_date": startDate,
        "installments": installments,
        "total_weight": totalWeight,
        "status": status,
        "setup_id": setupId,
      };
}
