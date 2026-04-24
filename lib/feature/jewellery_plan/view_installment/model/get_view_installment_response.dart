import 'dart:convert';

class GetViewInstallmentResponse {
  List<Emi>? emi;
  Subscription? subscription;

  GetViewInstallmentResponse({
    this.emi,
    this.subscription,
  });

  factory GetViewInstallmentResponse.fromRawJson(String str) =>
      GetViewInstallmentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetViewInstallmentResponse.fromJson(Map<String, dynamic> json) =>
      GetViewInstallmentResponse(
        emi: json["emi"] == null
            ? []
            : List<Emi>.from(json["emi"]!.map((x) => Emi.fromJson(x))),
        subscription: json["subscription"] == null
            ? null
            : Subscription.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "emi":
            emi == null ? [] : List<dynamic>.from(emi!.map((x) => x.toJson())),
        "subscription": subscription?.toJson(),
      };
}

class Emi {
  int? id;
  String? planId;
  String? code;
  int? orderId;
  String? installments;
  String? planName;
  String? planDate;
  String? amount;
  double? rate; // Changed from int? to double?
  String? weight;
  String? paymentMode;
  bool? isOnline;
  String? accumulatedWeight;
  String? paymentId;
  String? settlementId;
  String? settlementDate;

  Emi({
    this.id,
    this.planId,
    this.code,
    this.orderId,
    this.installments,
    this.planName,
    this.planDate,
    this.amount,
    this.rate,
    this.weight,
    this.paymentMode,
    this.isOnline,
    this.accumulatedWeight,
    this.paymentId,
    this.settlementId,
    this.settlementDate,
  });

  factory Emi.fromRawJson(String str) => Emi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Emi.fromJson(Map<String, dynamic> json) => Emi(
        id: json["id"],
        planId: json["plan_id"],
        code: json["code"],
        orderId: json["order_id"],
        installments: json["installments"],
        planName: json["plan_name"],
        planDate: json["plan_date"],
        amount: json["amount"],
        rate: json["rate"] != null
            ? double.tryParse(json["rate"].toString()) ?? 0.0
            : null,
        weight: json["weight"]
            ?.toString(), // Convert to String since it's coming as "0.0000"
        paymentMode: json["payment_mode"],
        isOnline: json["is_online"],
        accumulatedWeight: json["accumulated_weight"],
        paymentId: json["payment_id"],
        settlementId: json["settlement_id"],
        settlementDate: json["settlement_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_id": planId,
        "code": code,
        "order_id": orderId,
        "installments": installments,
        "plan_name": planName,
        "plan_date": planDate,
        "amount": amount,
        "rate": rate,
        "weight": weight,
        "payment_mode": paymentMode,
        "is_online": isOnline,
        "accumulated_weight": accumulatedWeight,
        "payment_id": paymentId,
        "settlement_id": settlementId,
        "settlement_date": settlementDate,
      };
}

class Subscription {
  int? dueInstallments;
  String? type;
  String? code;
  String? amount;
  int? duration;
  String? startDate;
  String? installments;
  String? totalWeight;
  String? status;

  Subscription({
    this.dueInstallments,
    this.type,
    this.code,
    this.amount,
    this.duration,
    this.startDate,
    this.installments,
    this.totalWeight,
    this.status,
  });

  factory Subscription.fromRawJson(String str) =>
      Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        dueInstallments: json["due_installments"],
        type: json["type"],
        code: json["code"],
        amount: json["amount"],
        duration: json["duration"],
        startDate: json["start_date"],
        installments: json["installments"],
        totalWeight: json["total_weight"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "due_installments": dueInstallments,
        "type": type,
        "code": code,
        "amount": amount,
        "duration": duration,
        "start_date": startDate,
        "installments": installments,
        "total_weight": totalWeight,
        "status": status,
      };
}
