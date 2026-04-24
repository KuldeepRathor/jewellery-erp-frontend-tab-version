import 'dart:convert';

class CreateSubscriptionRequest {
  String? phone;
  int? planid;
  int? amount;
  List<PaymentOption>? paymentOption;

  CreateSubscriptionRequest({
    this.phone,
    this.planid,
    this.amount,
    this.paymentOption,
  });

  factory CreateSubscriptionRequest.fromRawJson(String str) =>
      CreateSubscriptionRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      CreateSubscriptionRequest(
        phone: json["phone"],
        planid: json["planid"],
        amount: json["amount"],
        paymentOption: json["payment_option"] == null
            ? []
            : List<PaymentOption>.from(
                json["payment_option"]!.map((x) => PaymentOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "planid": planid,
        "amount": amount,
        "payment_option": paymentOption == null
            ? []
            : List<dynamic>.from(paymentOption!.map((x) => x.toJson())),
      };
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
  int? id;
  int? amount;
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

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        bank: json["bank"],
        paymentInfo: json["payment_info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "bank": bank,
        "payment_info": paymentInfo,
      };
}
