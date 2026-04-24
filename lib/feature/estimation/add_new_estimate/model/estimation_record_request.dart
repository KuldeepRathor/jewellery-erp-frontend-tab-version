import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/post_sales_request_model.dart';

class PostEstimateRequestModel {
  String? organizationId;
  String? shopId;
  String? customerId;
  String? partyType;
  String? estimateNumber;
  String? remarks;
  List<PostLineItemRequestModel>? lineItems;
  List<PostAdvanceBookingRequestModel>? advanceBookingDetails;
  List<PostJewelleryPlanRequestModel>? jewelleryPlans;
  List<PostOldGoldRequestModel>? oldGolds;
  String? subTotal;
  String? gst;
  String? oldGoldAmount;
  String? advanceBookingAmount;
  String? digitalGoldAmount;
  String? jewelleryPlanAmount;
  String? total;
  String? additional_less;
  double? jewellerDiscount;
  String? metalType;

  List<PostSalePaymentDetailRequest>? paymentDetails;

  PostEstimateRequestModel({
    this.organizationId,
    this.shopId,
    this.customerId,
    this.partyType,
    this.estimateNumber,
    this.remarks,
    this.lineItems,
    this.advanceBookingDetails,
    this.jewelleryPlans,
    this.oldGolds,
    this.subTotal,
    this.gst,
    this.oldGoldAmount,
    this.advanceBookingAmount,
    this.digitalGoldAmount,
    this.jewelleryPlanAmount,
    this.total,
    this.additional_less,
    this.jewellerDiscount,
    this.paymentDetails,
    this.metalType,
  });

  factory PostEstimateRequestModel.fromRawJson(String str) =>
      PostEstimateRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostEstimateRequestModel.fromJson(Map<String, dynamic> json) =>
      PostEstimateRequestModel(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        customerId: json["customer_id"],
        partyType: json["party_type"],
        estimateNumber: json["estimate_number"],
        remarks: json["remarks"],
        lineItems:
            json["line_items"] == null
                ? []
                : List<PostLineItemRequestModel>.from(
                  json["line_items"]!.map(
                    (x) => PostLineItemRequestModel.fromJson(x),
                  ),
                ),
        advanceBookingDetails:
            json["advance_booking_details"] == null
                ? []
                : List<PostAdvanceBookingRequestModel>.from(
                  json["advance_booking_details"]!.map(
                    (x) => PostAdvanceBookingRequestModel.fromJson(x),
                  ),
                ),
        jewelleryPlans:
            json["jewellery_plans"] == null
                ? []
                : List<PostJewelleryPlanRequestModel>.from(
                  json["jewellery_plans"]!.map(
                    (x) => PostJewelleryPlanRequestModel.fromJson(x),
                  ),
                ),
        oldGolds:
            json["old_golds"] == null
                ? []
                : List<PostOldGoldRequestModel>.from(
                  json["old_golds"]!.map(
                    (x) => PostOldGoldRequestModel.fromJson(x),
                  ),
                ),
        subTotal: json["sub_total"],
        gst: json["gst"],
        oldGoldAmount: json["old_gold_amount"],
        advanceBookingAmount: json["advance_booking_amount"],
        digitalGoldAmount: json["digital_gold_amount"],
        jewelleryPlanAmount: json["jewellery_plan_amount"],
        total: json["total"],
        additional_less: json["additional_less"],
        jewellerDiscount: json["jeweller_discount"],
        metalType: json["metal_type"],
        paymentDetails:
            json["payment_details"] == null
                ? []
                : List<PostSalePaymentDetailRequest>.from(
                  json["payment_details"]!.map(
                    (x) => PostSalePaymentDetailRequest.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "organization_id": organizationId,
    "shop_id": shopId,
    "customer_id": customerId,
    "party_type": partyType,
    "estimate_number": estimateNumber,
    "remarks": remarks,
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
    "advance_booking_details":
        advanceBookingDetails == null
            ? []
            : List<dynamic>.from(advanceBookingDetails!.map((x) => x.toJson())),
    "jewellery_plans":
        jewelleryPlans == null
            ? []
            : List<dynamic>.from(jewelleryPlans!.map((x) => x.toJson())),
    "old_golds":
        oldGolds == null
            ? []
            : List<dynamic>.from(oldGolds!.map((x) => x.toJson())),
    "sub_total": subTotal,
    "gst": gst,
    "old_gold_amount": oldGoldAmount,
    "advance_booking_amount": advanceBookingAmount,
    "digital_gold_amount": digitalGoldAmount,
    "jewellery_plan_amount": jewelleryPlanAmount,
    "total": total,
    "additional_less": additional_less,
    "jeweller_discount": jewellerDiscount,
    "metal_type": metalType,
    "payment_details":
        paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
  };
}

class PostAdvanceBookingRequestModel {
  String? advancePaid;
  String? bookingId;
  String? organizationId;
  String? rate;
  String? shopId;
  String? status;
  String? weight;

  PostAdvanceBookingRequestModel({
    this.advancePaid,
    this.bookingId,
    this.organizationId,
    this.rate,
    this.shopId,
    this.status,
    this.weight,
  });

  factory PostAdvanceBookingRequestModel.fromRawJson(String str) =>
      PostAdvanceBookingRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostAdvanceBookingRequestModel.fromJson(Map<String, dynamic> json) =>
      PostAdvanceBookingRequestModel(
        advancePaid: json["advance_paid"],
        bookingId: json["booking_id"],
        organizationId: json["organization_id"],
        rate: json["rate"],
        shopId: json["shop_id"],
        status: json["status"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
    "advance_paid": advancePaid,
    "booking_id": bookingId,
    "organization_id": organizationId,
    "rate": rate,
    "shop_id": shopId,
    "status": status,
    "weight": weight,
  };
}

class PostJewelleryPlanRequestModel {
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

  PostJewelleryPlanRequestModel({
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

  factory PostJewelleryPlanRequestModel.fromRawJson(String str) =>
      PostJewelleryPlanRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostJewelleryPlanRequestModel.fromJson(Map<String, dynamic> json) =>
      PostJewelleryPlanRequestModel(
        duration: json["duration"],
        estimationRecordId: json["estimation_record_id"],
        id: json["id"],
        installments: json["installments"],
        planId: json["plan_id"],
        redeemableAmount: json["redeemable_amount"],
        startDate:
            json["start_date"] == null
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

class PostLineItemRequestModel {
  String? organizationId;
  String? shopId;
  String? estimationRecordId;
  String? code;
  String? taggingId;
  String? tag;
  String? description;
  String? rate;
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

  PostLineItemRequestModel({
    this.organizationId,
    this.shopId,
    this.estimationRecordId,
    this.code,
    this.taggingId,
    this.tag,
    this.description,
    this.rate,
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

  factory PostLineItemRequestModel.fromRawJson(String str) =>
      PostLineItemRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostLineItemRequestModel.fromJson(Map<String, dynamic> json) =>
      PostLineItemRequestModel(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        estimationRecordId: json["estimation_record_id"],
        code: json["code"],
        taggingId: json["tagging_id"],
        tag: json["tag"],
        description: json["description"],
        rate: json["rate"],
        salesPersonId: json["sales_person_id"],
        taggingPieces: json["tagging_pieces"],
        taggingGrossWeight: json["tagging_gross_weight"],
        taggingNetWeight: json["tagging_net_weight"],
        finalPieces: json["final_pieces"],
        finalGrossWeight: json["final_gross_weight"],
        finalNetWeight: json["final_net_weight"],
        taggingVa: json["tagging_va"],
        finalVa: json["final_va"],
        taggingMc: json["tagging_mc"],
        finalMc: json["final_mc"],
        stoneCost: json["stone_cost"],
        hallMark: json["hall_mark"],
        discount: json["discount"],
        salesAmount: json["sales_amount"],
        totalAmount: json["total_amount"],
        costDiscount: json["cost_discount"],
      );

  Map<String, dynamic> toJson() => {
    "organization_id": organizationId,
    "shop_id": shopId,
    "estimation_record_id": estimationRecordId,
    "code": code,
    "tagging_id": taggingId,
    "tag": tag,
    "description": description,
    "rate": rate,
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

class PostOldGoldRequestModel {
  bool? isCompleted;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  String? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? purity;
  String? metalType;
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;
  String? id;

  PostOldGoldRequestModel({
    this.isCompleted,
    this.organizationId,
    this.shopId,
    this.code,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.less,
    this.purityType,
    this.purity,
    this.metalType,
    this.ornamentId,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
    this.id,
  });

  factory PostOldGoldRequestModel.fromRawJson(String str) =>
      PostOldGoldRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostOldGoldRequestModel.fromJson(Map<String, dynamic> json) =>
      PostOldGoldRequestModel(
        isCompleted: json["is_completed"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        less: json["less"],
        purityType: json["purity_type"],
        purity: json["purity"],
        metalType: json["metal_type"],
        ornamentId: json["ornament_id"],
        rate: json["rate"],
        amount: json["amount"],
        roundOff: json["round_off"],
        total: json["total"],
        isReceived: json["is_received"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
    "is_completed": isCompleted,
    "organization_id": organizationId,
    "shop_id": shopId,
    "code": code,
    "description": description,
    "pieces": pieces,
    "gross_weight": grossWeight,
    "net_weight": netWeight,
    "less": less,
    "purity_type": purityType,
    "purity": purity,
    "metal_type": metalType,
    "ornament_id": ornamentId,
    "rate": rate,
    "amount": amount,
    "round_off": roundOff,
    "total": total,
    "is_received": isReceived,
    "id": id,
  };
}
