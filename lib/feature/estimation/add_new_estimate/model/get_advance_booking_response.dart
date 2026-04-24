import 'dart:convert';

class GetAdvanceBookingResponse {
  int? count;
  dynamic next;
  dynamic previous;
  List<AdvanceBookingResult>? results;

  GetAdvanceBookingResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory GetAdvanceBookingResponse.fromRawJson(String str) =>
      GetAdvanceBookingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAdvanceBookingResponse.fromJson(Map<String, dynamic> json) =>
      GetAdvanceBookingResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<AdvanceBookingResult>.from(
                json["results"]!.map((x) => AdvanceBookingResult.fromJson(x))),
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

class AdvanceBookingResult {
  int? id;
  String? bookingId;
  DateTime? createdOn;
  String? phone;
  String? customerName;
  double? rateValue;
  double? quantity;
  double? cost;
  bool? isOnlineMode;
  String? status;
  dynamic completedDate;
  dynamic invoiceNo;
  dynamic cancelledDate;
  String? invoiceUrl;

  //Note: Used only for frontend Purpose
  String? otp;

  AdvanceBookingResult({
    this.id,
    this.bookingId,
    this.createdOn,
    this.phone,
    this.customerName,
    this.rateValue,
    this.quantity,
    this.cost,
    this.isOnlineMode,
    this.status,
    this.completedDate,
    this.invoiceNo,
    this.cancelledDate,
    this.invoiceUrl,
    this.otp,
  });

  factory AdvanceBookingResult.fromRawJson(String str) =>
      AdvanceBookingResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdvanceBookingResult.fromJson(Map<String, dynamic> json) =>
      AdvanceBookingResult(
        id: json["id"],
        bookingId: json["booking_id"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        phone: json["phone"],
        customerName: json["customer_name"],
        rateValue: json["rate_value"]?.toDouble(), // Parse as double
        quantity: json["quantity"]?.toDouble(), // Parse as double
        cost: json["cost"]?.toDouble(), // Parse as double
        isOnlineMode: json["is_online_mode"],
        status: json["status"],
        completedDate: json["completed_date"],
        invoiceNo: json["invoice_no"],
        cancelledDate: json["cancelled_date"],
        invoiceUrl: json["invoice_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "created_on": createdOn?.toIso8601String(),
        "phone": phone,
        "customer_name": customerName,
        "rate_value": rateValue,
        "quantity": quantity,
        "cost": cost,
        "is_online_mode": isOnlineMode,
        "status": status,
        "completed_date": completedDate,
        "invoice_no": invoiceNo,
        "cancelled_date": cancelledDate,
        "invoice_url": invoiceUrl,
      };
}
