import 'dart:convert';

class NewBookingRequest {
  int? setupId;
  String? phone;
  List<PaymentOption>? paymentOptions;
  String? weight;
  int? rate;
  int? payable;

  NewBookingRequest({
    this.setupId,
    this.phone,
    this.paymentOptions,
    this.weight,
    this.rate,
    this.payable,
  });

  factory NewBookingRequest.fromRawJson(String str) =>
      NewBookingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewBookingRequest.fromJson(Map<String, dynamic> json) =>
      NewBookingRequest(
        setupId: json["setup_id"],
        phone: json["phone"],
        paymentOptions: json["payment_options"] == null
            ? []
            : List<PaymentOption>.from(
                json["payment_options"]!.map((x) => PaymentOption.fromJson(x))),
        weight: json["weight"],
        rate: json["rate"],
        payable: json["payable"],
      );

  Map<String, dynamic> toJson() => {
        "setup_id": setupId,
        "phone": phone,
        "payment_options": paymentOptions == null
            ? []
            : List<dynamic>.from(paymentOptions!.map((x) => x.toJson())),
        "weight": weight,
        "rate": rate,
        "payable": payable,
      };
}

class PaymentOption {
  String? type;
  List<Option>? options;
  String? mode;

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
