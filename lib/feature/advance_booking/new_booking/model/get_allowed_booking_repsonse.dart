import 'dart:convert';

// Model for single booking rule
class BookingRule {
  int? id;
  String? weightFrom;
  String? weightTo;
  int? advancePercentage;
  int? redeemDuration;
  bool? status;
  int? shopId;

  BookingRule({
    this.id,
    this.weightFrom,
    this.weightTo,
    this.advancePercentage,
    this.redeemDuration,
    this.status,
    this.shopId,
  });

  factory BookingRule.fromJson(Map<String, dynamic> json) => BookingRule(
        id: json["id"],
        weightFrom: json["weight_from"],
        weightTo: json["weight_to"],
        advancePercentage: json["advance_percentage"],
        redeemDuration: json["redeem_duration"],
        status: json["status"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weight_from": weightFrom,
        "weight_to": weightTo,
        "advance_percentage": advancePercentage,
        "redeem_duration": redeemDuration,
        "status": status,
        "shop_id": shopId,
      };
}

// Response model that contains list of booking rules
class GetAllowedBookingResponse {
  final List<BookingRule> bookingRules;

  GetAllowedBookingResponse({
    required this.bookingRules,
  });

  factory GetAllowedBookingResponse.fromRawJson(String str) =>
      GetAllowedBookingResponse.fromJson(json.decode(str));

  factory GetAllowedBookingResponse.fromJson(List<dynamic> json) =>
      GetAllowedBookingResponse(
        bookingRules: json.map((x) => BookingRule.fromJson(x)).toList(),
      );

  String toRawJson() =>
      json.encode(bookingRules.map((x) => x.toJson()).toList());
}
