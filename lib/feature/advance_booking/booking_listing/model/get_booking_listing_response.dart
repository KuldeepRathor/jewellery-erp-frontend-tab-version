import 'dart:convert';

class GetBookingListingResponse {
  int? count;
  String? next;
  dynamic previous;
  List<GetBookingListingValue>? results;

  GetBookingListingResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory GetBookingListingResponse.fromRawJson(String str) =>
      GetBookingListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBookingListingResponse.fromJson(Map<String, dynamic> json) =>
      GetBookingListingResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<GetBookingListingValue>.from(json["results"]!
                .map((x) => GetBookingListingValue.fromJson(x))),
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

class GetBookingListingValue {
  int? id;
  String? bookingId;
  DateTime? createdOn;
  String? phone;
  String? customerName;
  double? rateValue; // Changed from int to double
  double? quantity; // Changed from int to double
  double? cost; // Changed from int to double
  bool? isOnlineMode;
  String? status;
  DateTime? completedDate;
  String? invoiceNo;
  dynamic cancelledDate;
  String? invoiceUrl;

  GetBookingListingValue({
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
  });

  factory GetBookingListingValue.fromRawJson(String str) =>
      GetBookingListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBookingListingValue.fromJson(Map<String, dynamic> json) =>
      GetBookingListingValue(
        id: json["id"],
        bookingId: json["booking_id"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        phone: json["phone"],
        customerName: json["customer_name"],
        rateValue: json["rate_value"]?.toDouble(), // Convert to double
        quantity: json["quantity"]?.toDouble(), // Convert to double
        cost: json["cost"]?.toDouble(), // Convert to double
        isOnlineMode: json["is_online_mode"],
        status: json["status"],
        completedDate: json["completed_date"] == null
            ? null
            : DateTime.parse(json["completed_date"]),
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
        "completed_date": completedDate?.toIso8601String(),
        "invoice_no": invoiceNo,
        "cancelled_date": cancelledDate,
        "invoice_url": invoiceUrl,
      };
}
