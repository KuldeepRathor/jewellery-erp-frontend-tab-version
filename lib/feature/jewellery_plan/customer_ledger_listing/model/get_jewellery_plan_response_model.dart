import 'dart:convert';

class GetJewelleryPlanResponseModel {
  int? count;
  String? next;
  String? previous;
  List<GetJewelleryPlanValue>? results;

  GetJewelleryPlanResponseModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory GetJewelleryPlanResponseModel.fromRawJson(String str) =>
      GetJewelleryPlanResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetJewelleryPlanResponseModel.fromJson(Map<String, dynamic> json) =>
      GetJewelleryPlanResponseModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<GetJewelleryPlanValue>.from(
                json["results"]!.map((x) => GetJewelleryPlanValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class GetJewelleryPlanValue {
  String? id;
  String? code;
  String? planId;
  String? customerName;
  String? planName;
  String? phone;
  String? planType;
  double? cost;
  int? duration;
  String? createdOn;
  String? weightOrAmount;
  String? status;
  String? installments;

  GetJewelleryPlanValue({
    this.id,
    this.code,
    this.planId,
    this.customerName,
    this.planName,
    this.phone,
    this.planType,
    this.cost,
    this.duration,
    this.createdOn,
    this.weightOrAmount,
    this.status,
    this.installments,
  });

  factory GetJewelleryPlanValue.fromRawJson(String str) =>
      GetJewelleryPlanValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetJewelleryPlanValue.fromJson(Map<String, dynamic> json) =>
      GetJewelleryPlanValue(
        id: json["id"],
        code: json["code"],
        planId: json["plan_id"],
        customerName: json["customer_name"],
        planName: json["plan_name"],
        phone: json["phone"],
        planType: json["plan_type"],
        cost: json["cost"],
        duration: json["duration"],
        createdOn: json["created_on"],
        weightOrAmount: json["weight_or_amount"],
        status: json["status"],
        installments: json["installments"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "plan_id": planId,
        "customer_name": customerName,
        "plan_name": planName,
        "phone": phone,
        "plan_type": planType,
        "cost": cost,
        "duration": duration,
        "created_on": createdOn,
        "weight_or_amount": weightOrAmount,
        "status": status,
        "installments": installments,
      };
}
