import 'dart:convert';

class CompleteBookingRequest {
  int? bookingId;
  DateTime? completionDate;
  String? invoice;

  CompleteBookingRequest({
    this.bookingId,
    this.completionDate,
    this.invoice,
  });

  factory CompleteBookingRequest.fromRawJson(String str) =>
      CompleteBookingRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompleteBookingRequest.fromJson(Map<String, dynamic> json) =>
      CompleteBookingRequest(
        bookingId: json["booking_id"],
        completionDate: json["completion_date"] == null
            ? null
            : DateTime.parse(json["completion_date"]),
        invoice: json["invoice"],
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "completion_date":
            "${completionDate!.year.toString().padLeft(4, '0')}-${completionDate!.month.toString().padLeft(2, '0')}-${completionDate!.day.toString().padLeft(2, '0')}",
        "invoice": invoice,
      };
}
