import 'dart:convert';

class GetSetupPlanListingResponse {
  List<GetSetupPlanListingValue>? values;
  Pagination? pagination;

  GetSetupPlanListingResponse({
    this.values,
    this.pagination,
  });

  factory GetSetupPlanListingResponse.fromRawJson(String str) =>
      GetSetupPlanListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSetupPlanListingResponse.fromJson(Map<String, dynamic> json) =>
      GetSetupPlanListingResponse(
        values: json["values"] == null
            ? []
            : List<GetSetupPlanListingValue>.from(json["values"]!
                .map((x) => GetSetupPlanListingValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  dynamic next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class GetSetupPlanListingValue {
  String? id;
  String? organizationId;
  String? shopId;
  String? planName;
  int? planDuration;
  String? planType;
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
  dynamic gracePeriod;
  String? tcTemplateId;
  String? termsAndCondition;
  List<dynamic>? planBenifit;
  dynamic jlId;

  GetSetupPlanListingValue({
    this.id,
    this.organizationId,
    this.shopId,
    this.planName,
    this.planDuration,
    this.planType,
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
  });

  factory GetSetupPlanListingValue.fromRawJson(String str) =>
      GetSetupPlanListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSetupPlanListingValue.fromJson(Map<String, dynamic> json) =>
      GetSetupPlanListingValue(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        planName: json["plan_name"],
        planDuration: json["plan_duration"],
        planType: json["plan_type"],
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
            : List<dynamic>.from(json["plan_benifit"]!.map((x) => x)),
        jlId: json["jl_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "plan_name": planName,
        "plan_duration": planDuration,
        "plan_type": planType,
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
      };
}
