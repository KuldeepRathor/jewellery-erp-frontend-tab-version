import 'dart:convert';

class AddAdvanceBookingRequest {
  List<PaymentOption>? paymentOptions;
  int? bookingId;

  AddAdvanceBookingRequest({
    this.paymentOptions,
    this.bookingId,
  });

  factory AddAdvanceBookingRequest.fromRawJson(String str) =>
      AddAdvanceBookingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddAdvanceBookingRequest.fromJson(Map<String, dynamic> json) =>
      AddAdvanceBookingRequest(
        paymentOptions: json["payment_options"] == null
            ? []
            : List<PaymentOption>.from(
                json["payment_options"]!.map((x) => PaymentOption.fromJson(x))),
        bookingId: json["booking_id"],
      );

  Map<String, dynamic> toJson() => {
        "payment_options": paymentOptions == null
            ? []
            : List<dynamic>.from(paymentOptions!.map((x) => x.toJson())),
        "booking_id": bookingId,
      };
}

class PaymentOption {
  String? id;
  String? mode;
  String? amount;
  DateTime? date;
  int? bank;
  String? paymentInfo;

  PaymentOption({
    this.id,
    this.mode,
    this.amount,
    this.date,
    this.bank,
    this.paymentInfo,
  });

  factory PaymentOption.fromRawJson(String str) =>
      PaymentOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
        id: json["id"],
        mode: json["mode"],
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        bank: json["bank"],
        paymentInfo: json["payment_info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mode": mode,
        "amount": amount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "bank": bank,
        "payment_info": paymentInfo,
      };
}
