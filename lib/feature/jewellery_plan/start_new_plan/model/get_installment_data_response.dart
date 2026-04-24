class GetInstallmentDataResponse {
  String? amount;
  String? installment;
  String? name;
  String? phone;
  double? rate; // Changed from int? to double?
  double? weight; // Changed from int? to double?
  int? paymentId;
  bool? admin;
  DateTime? date;
  DateTime? sDate;
  DateTime? lastPaid;
  String? planType;
  int? pendingInstallment;

  GetInstallmentDataResponse({
    this.amount,
    this.installment,
    this.name,
    this.phone,
    this.rate,
    this.weight,
    this.paymentId,
    this.admin,
    this.date,
    this.sDate,
    this.lastPaid,
    this.planType,
    this.pendingInstallment,
  });

  factory GetInstallmentDataResponse.fromJson(Map<String, dynamic> json) =>
      GetInstallmentDataResponse(
        amount: json["amount"],
        installment: json["installment"],
        name: json["name"],
        phone: json["phone"],
        rate: json["rate"]?.toDouble(), // Convert to double
        weight: json["weight"]?.toDouble(), // Convert to double
        paymentId: json["payment_id"],
        admin: json["admin"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        sDate: json["s_date"] == null ? null : DateTime.parse(json["s_date"]),
        lastPaid: json["last_paid"] == null
            ? null
            : DateTime.parse(json["last_paid"]),
        planType: json["plan_type"],
        pendingInstallment: json["pending_installment"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "installment": installment,
        "name": name,
        "phone": phone,
        "rate": rate,
        "weight": weight,
        "payment_id": paymentId,
        "admin": admin,
        "date": date?.toIso8601String(),
        "s_date": sDate?.toIso8601String(),
        "last_paid": lastPaid?.toIso8601String(),
        "plan_type": planType,
        "pending_installment": pendingInstallment,
      };
}
