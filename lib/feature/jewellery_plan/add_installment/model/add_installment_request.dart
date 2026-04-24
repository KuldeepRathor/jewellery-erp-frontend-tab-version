import 'dart:convert';

class AddInstallmentRequest {
  InstallmentData? installmentData;
  List<PaymentOption>? paymentOption;
  String? subscriptionId;

  AddInstallmentRequest({
    this.installmentData,
    this.paymentOption,
    this.subscriptionId,
  });

  factory AddInstallmentRequest.fromRawJson(String str) =>
      AddInstallmentRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddInstallmentRequest.fromJson(Map<String, dynamic> json) =>
      AddInstallmentRequest(
        installmentData: json["installment_data"] == null
            ? null
            : InstallmentData.fromJson(json["installment_data"]),
        paymentOption: json["payment_option"] == null
            ? []
            : List<PaymentOption>.from(
                json["payment_option"]!.map((x) => PaymentOption.fromJson(x))),
        subscriptionId: json["subscription_id"],
      );

  Map<String, dynamic> toJson() => {
        "installment_data": installmentData?.toJson(),
        "payment_option": paymentOption == null
            ? []
            : List<dynamic>.from(paymentOption!.map((x) => x.toJson())),
        "subscription_id": subscriptionId,
      };
}

class InstallmentData {
  String? planId;
  DateTime? date;
  String? amount;
  String? installmentNumber;
  int? rate;
  String? customerName;
  String? phone;
  int? weight;
  DateTime? lastPaid;
  String? planType;

  InstallmentData({
    this.planId,
    this.date,
    this.amount,
    this.installmentNumber,
    this.rate,
    this.customerName,
    this.phone,
    this.weight,
    this.lastPaid,
    this.planType,
  });

  factory InstallmentData.fromJson(Map<String, dynamic> json) =>
      InstallmentData(
        planId: json["plan_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        installmentNumber: json["installment_number"],
        rate: json["rate"],
        customerName: json["customer_name"],
        phone: json["phone"],
        weight: json["weight"],
        lastPaid: json["last_paid"] == null
            ? null
            : DateTime.parse(json["last_paid"]),
        planType: json["plan_type"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "plan_id": planId,
      "amount": amount,
      "installment_number": installmentNumber,
      "rate": rate,
      "customer_name": customerName,
      "phone": phone,
      "weight": weight,
      "plan_type": planType,
    };

    if (date != null) {
      data["date"] =
          "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}";
    }

    if (lastPaid != null) {
      data["last_paid"] =
          "${lastPaid!.year.toString().padLeft(4, '0')}-${lastPaid!.month.toString().padLeft(2, '0')}-${lastPaid!.day.toString().padLeft(2, '0')}";
    }

    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class PaymentOption {
  String? type;
  List<Option>? options;
  int? mode;

  PaymentOption({
    this.type,
    this.options,
    this.mode,
  });

  factory PaymentOption.fromRawJson(String str) =>
      PaymentOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
        type: json["type"],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
        mode: json["mode"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "mode": mode,
      };
}

class Option {
  String? id;
  String? amount;
  DateTime? date;
  String? bank;
  String? paymentInfo;

  Option({
    this.id,
    this.amount,
    this.date,
    this.bank,
    this.paymentInfo,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        bank: json["bank"],
        paymentInfo: json["payment_info"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      "amount": amount,
      "bank": bank,
      "payment_info": paymentInfo,
    };

    if (date != null) {
      data["date"] =
          "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}";
    }

    data.removeWhere((key, value) => value == null);
    return data;
  }
}
