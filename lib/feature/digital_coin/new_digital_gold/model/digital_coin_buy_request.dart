import 'dart:convert';

class DigitalCoinBuyRequest {
  String? phone;
  List<PaymentOption>? paymentOptions;
  double? weight;
  String? commodity;

  DigitalCoinBuyRequest({
    this.phone,
    this.paymentOptions,
    this.weight,
    this.commodity,
  });

  factory DigitalCoinBuyRequest.fromRawJson(String str) =>
      DigitalCoinBuyRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DigitalCoinBuyRequest.fromJson(Map<String, dynamic> json) =>
      DigitalCoinBuyRequest(
        phone: json["phone"],
        paymentOptions: json["payment_options"] == null
            ? []
            : List<PaymentOption>.from(
                json["payment_options"]!.map((x) => PaymentOption.fromJson(x))),
        weight: json["weight"],
        commodity: json["commodity"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "payment_options": paymentOptions == null
            ? []
            : List<dynamic>.from(paymentOptions!.map((x) => x.toJson())),
        "weight": weight,
        "commodity": commodity,
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
  String? id;
  int? amount;
  DateTime? date;
  int? bank;
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
