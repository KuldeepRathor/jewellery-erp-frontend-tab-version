import 'dart:convert';

class PostEstimateResponse {
  String? id;
  String? customerId;
  String? estimateNumber;
  String? remarks;
  List<PostEstimateResponseLineItem>? lineItems;
  List<PostEstimateResponseAdvanceBookingDetail>? advanceBookingDetails;
  List<PostEstimateResponseJewelleryPlan>? jewelleryPlans;
  List<PostEstimateResponseOldGold>? oldGolds;
  PostEstimateResponseBillingSummary? billingSummary;

  PostEstimateResponse({
    this.id,
    this.customerId,
    this.estimateNumber,
    this.remarks,
    this.lineItems,
    this.advanceBookingDetails,
    this.jewelleryPlans,
    this.oldGolds,
    this.billingSummary,
  });

  factory PostEstimateResponse.fromRawJson(String str) =>
      PostEstimateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostEstimateResponse.fromJson(Map<String, dynamic> json) =>
      PostEstimateResponse(
        id: json["id"],
        customerId: json["customer_id"],
        estimateNumber: json["estimate_number"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<PostEstimateResponseLineItem>.from(json["line_items"]!
                .map((x) => PostEstimateResponseLineItem.fromJson(x))),
        advanceBookingDetails: json["advance_booking_details"] == null
            ? []
            : List<PostEstimateResponseAdvanceBookingDetail>.from(
                json["advance_booking_details"]!.map((x) =>
                    PostEstimateResponseAdvanceBookingDetail.fromJson(x))),
        jewelleryPlans: json["jewellery_plans"] == null
            ? []
            : List<PostEstimateResponseJewelleryPlan>.from(
                json["jewellery_plans"]!
                    .map((x) => PostEstimateResponseJewelleryPlan.fromJson(x))),
        oldGolds: json["old_golds"] == null
            ? []
            : List<PostEstimateResponseOldGold>.from(json["old_golds"]!
                .map((x) => PostEstimateResponseOldGold.fromJson(x))),
        billingSummary: json["billing_summary"] == null
            ? null
            : PostEstimateResponseBillingSummary.fromJson(
                json["billing_summary"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "estimate_number": estimateNumber,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "advance_booking_details": advanceBookingDetails == null
            ? []
            : List<dynamic>.from(advanceBookingDetails!.map((x) => x.toJson())),
        "jewellery_plans": jewelleryPlans == null
            ? []
            : List<dynamic>.from(jewelleryPlans!.map((x) => x.toJson())),
        "old_golds": oldGolds == null
            ? []
            : List<dynamic>.from(oldGolds!.map((x) => x.toJson())),
        "billing_summary": billingSummary?.toJson(),
      };
}

class PostEstimateResponseAdvanceBookingDetail {
  String? advancePaid;
  String? bookingId;
  String? id;
  String? rate;
  String? status;
  String? weight;

  PostEstimateResponseAdvanceBookingDetail({
    this.advancePaid,
    this.bookingId,
    this.id,
    this.rate,
    this.status,
    this.weight,
  });

  factory PostEstimateResponseAdvanceBookingDetail.fromRawJson(String str) =>
      PostEstimateResponseAdvanceBookingDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostEstimateResponseAdvanceBookingDetail.fromJson(
          Map<String, dynamic> json) =>
      PostEstimateResponseAdvanceBookingDetail(
        advancePaid: json["advance_paid"],
        bookingId: json["booking_id"],
        id: json["id"],
        rate: json["rate"],
        status: json["status"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "advance_paid": advancePaid,
        "booking_id": bookingId,
        "id": id,
        "rate": rate,
        "status": status,
        "weight": weight,
      };
}

class PostEstimateResponseBillingSummary {
  String? subTotal;
  String? gst;
  String? oldGoldAmount;
  String? advanceBookingAmount;
  String? digitalGoldAmount;
  String? jewelleryPlanAmount;
  String? total;

  PostEstimateResponseBillingSummary({
    this.subTotal,
    this.gst,
    this.oldGoldAmount,
    this.advanceBookingAmount,
    this.digitalGoldAmount,
    this.jewelleryPlanAmount,
    this.total,
  });

  factory PostEstimateResponseBillingSummary.fromRawJson(String str) =>
      PostEstimateResponseBillingSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostEstimateResponseBillingSummary.fromJson(
          Map<String, dynamic> json) =>
      PostEstimateResponseBillingSummary(
        subTotal: json["sub_total"]?.toString(), // 2.24E+5 fix
        gst: json["gst"]?.toString(),
        oldGoldAmount: json["old_gold_amount"]?.toString(),
        advanceBookingAmount: json["advance_booking_amount"]?.toString(),
        digitalGoldAmount: json["digital_gold_amount"]?.toString(),
        jewelleryPlanAmount: json["jewellery_plan_amount"]?.toString(),
        total: json["total"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "sub_total": subTotal,
        "gst": gst,
        "old_gold_amount": oldGoldAmount,
        "advance_booking_amount": advanceBookingAmount,
        "digital_gold_amount": digitalGoldAmount,
        "jewellery_plan_amount": jewelleryPlanAmount,
        "total": total,
      };
}

class PostEstimateResponseJewelleryPlan {
  int? duration;
  String? estimationRecordId;
  String? id;
  String? installments;
  String? planId;
  String? redeemableAmount;
  DateTime? startDate;
  String? subscriptionId;
  String? totalWeight;
  String? type;

  PostEstimateResponseJewelleryPlan({
    this.duration,
    this.estimationRecordId,
    this.id,
    this.installments,
    this.planId,
    this.redeemableAmount,
    this.startDate,
    this.subscriptionId,
    this.totalWeight,
    this.type,
  });

  factory PostEstimateResponseJewelleryPlan.fromRawJson(String str) =>
      PostEstimateResponseJewelleryPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostEstimateResponseJewelleryPlan.fromJson(
          Map<String, dynamic> json) =>
      PostEstimateResponseJewelleryPlan(
        duration: json["duration"],
        estimationRecordId: json["estimation_record_id"],
        id: json["id"],
        installments: json["installments"],
        planId: json["plan_id"],
        redeemableAmount: json["redeemable_amount"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        subscriptionId: json["subscription_id"],
        totalWeight: json["total_weight"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "estimation_record_id": estimationRecordId,
        "id": id,
        "installments": installments,
        "plan_id": planId,
        "redeemable_amount": redeemableAmount,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "subscription_id": subscriptionId,
        "total_weight": totalWeight,
        "type": type,
      };
}

class PostEstimateResponseLineItem {
  String? id;
  String? estimationRecordId;
  String? code;
  String? taggingId;
  String? tag;
  String? rate;
  String? description;
  String? salesPersonId;
  int? taggingPieces;
  String? taggingGrossWeight;
  String? taggingNetWeight;
  int? finalPieces;
  String? finalGrossWeight;
  String? finalNetWeight;
  String? taggingVa;
  String? finalVa;
  String? taggingMc;
  String? finalMc;
  String? stoneCost;
  String? hallMark;
  String? discount;
  String? salesAmount;
  String? totalAmount;
  String? costDiscount;

  PostEstimateResponseLineItem({
    this.id,
    this.estimationRecordId,
    this.code,
    this.taggingId,
    this.tag,
    this.rate,
    this.description,
    this.salesPersonId,
    this.taggingPieces,
    this.taggingGrossWeight,
    this.taggingNetWeight,
    this.finalPieces,
    this.finalGrossWeight,
    this.finalNetWeight,
    this.taggingVa,
    this.finalVa,
    this.taggingMc,
    this.finalMc,
    this.stoneCost,
    this.hallMark,
    this.discount,
    this.salesAmount,
    this.totalAmount,
    this.costDiscount,
  });

  factory PostEstimateResponseLineItem.fromRawJson(String str) =>
      PostEstimateResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory PostEstimateResponseLineItem.fromJson(Map<String, dynamic> json) =>
      PostEstimateResponseLineItem(
        id: json["id"],
        estimationRecordId: json["estimation_record_id"],
        code: json["code"],
        taggingId: json["tagging_id"],
        tag: json["tag"]?.toString(),
        rate: json["rate"]?.toString(),
        description: json["description"],
        salesPersonId: json["sales_person_id"],
        taggingPieces: json["tagging_pieces"],
        taggingGrossWeight: json["tagging_gross_weight"]?.toString(),
        taggingNetWeight: json["tagging_net_weight"]?.toString(),
        finalPieces: json["final_pieces"],
        finalGrossWeight: json["final_gross_weight"]?.toString(),
        finalNetWeight: json["final_net_weight"]?.toString(),
        taggingVa: json["tagging_va"]?.toString(),
        finalVa: json["final_va"]?.toString(),
        taggingMc: json["tagging_mc"]?.toString(),
        finalMc: json["final_mc"]?.toString(),
        stoneCost: json["stone_cost"]?.toString(),
        hallMark: json["hall_mark"]?.toString(),
        discount: json["discount"]?.toString(),
        salesAmount: json["sales_amount"]?.toString(),
        totalAmount: json["total_amount"]?.toString(),
        costDiscount: json["cost_discount"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estimation_record_id": estimationRecordId,
        "code": code,
        "tagging_id": taggingId,
        "tag": tag,
        "rate": rate,
        "description": description,
        "sales_person_id": salesPersonId,
        "tagging_pieces": taggingPieces,
        "tagging_gross_weight": taggingGrossWeight,
        "tagging_net_weight": taggingNetWeight,
        "final_pieces": finalPieces,
        "final_gross_weight": finalGrossWeight,
        "final_net_weight": finalNetWeight,
        "tagging_va": taggingVa,
        "final_va": finalVa,
        "tagging_mc": taggingMc,
        "final_mc": finalMc,
        "stone_cost": stoneCost,
        "hall_mark": hallMark,
        "discount": discount,
        "sales_amount": salesAmount,
        "total_amount": totalAmount,
        "cost_discount": costDiscount,
      };
}

class PostEstimateResponseOldGold {
  String? id;
  String? oldGoldEstimateNumber;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;

  PostEstimateResponseOldGold({
    this.id,
    this.oldGoldEstimateNumber,
    this.organizationId,
    this.shopId,
    this.code,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.less,
    this.purityType,
    this.ornamentId,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
  });

  factory PostEstimateResponseOldGold.fromRawJson(String str) =>
      PostEstimateResponseOldGold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory PostEstimateResponseOldGold.fromJson(Map<String, dynamic> json) =>
      PostEstimateResponseOldGold(
        id: json["id"],
        oldGoldEstimateNumber: json["old_gold_estimate_number"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight:
            json["gross_weight"]?.toString(), // was: json["gross_weight"]
        netWeight: json["net_weight"]?.toString(), // was: json["net_weight"]
        less: json["less"]?.toString(), // was: json["less"]
        purityType: json["purity_type"],
        ornamentId: json["ornament_id"],
        rate: json["rate"]?.toString(), // was: json["rate"]
        amount: json["amount"]?.toString(), // was: json["amount"]
        roundOff: json["round_off"]?.toString(), // was: json["round_off"]
        total: json["total"]?.toString(), // was: json["total"]
        isReceived: json["is_received"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "old_gold_estimate_number": oldGoldEstimateNumber,
        "organization_id": organizationId,
        "shop_id": shopId,
        "code": code,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "less": less,
        "purity_type": purityType,
        "ornament_id": ornamentId,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
      };
}
