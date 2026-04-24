import 'dart:convert';

class GetCancelReportResponse {
  List<GetCancelReportValue>? values;

  GetCancelReportResponse({
    this.values,
  });

  factory GetCancelReportResponse.fromRawJson(String str) =>
      GetCancelReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCancelReportResponse.fromJson(Map<String, dynamic> json) =>
      GetCancelReportResponse(
        values: json["values"] == null
            ? []
            : List<GetCancelReportValue>.from(
                json["values"]!.map((x) => GetCancelReportValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetCancelReportValue {
  DateTime? cancelledAt;
  DateTime? createdAt;
  String? voucherNumber;
  String? recordType;
  String? partyId;
  String? partyType;
  String? partyName;
  String? partyPhone;
  dynamic cancellationNumber;
  dynamic refundAmount;
  dynamic refundMode;
  dynamic refundId;
  dynamic refundAccount;
  dynamic refundAt;

  GetCancelReportValue({
    this.cancelledAt,
    this.createdAt,
    this.voucherNumber,
    this.recordType,
    this.partyId,
    this.partyType,
    this.partyName,
    this.partyPhone,
    this.cancellationNumber,
    this.refundAmount,
    this.refundMode,
    this.refundId,
    this.refundAccount,
    this.refundAt,
  });

  factory GetCancelReportValue.fromRawJson(String str) =>
      GetCancelReportValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCancelReportValue.fromJson(Map<String, dynamic> json) =>
      GetCancelReportValue(
        cancelledAt: json["cancelled_at"] == null
            ? null
            : DateTime.parse(json["cancelled_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        voucherNumber: json["voucher_number"],
        recordType: json["record_type"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        partyPhone: json["party_phone"],
        cancellationNumber: json["cancellation_number"],
        refundAmount: json["refund_amount"],
        refundMode: json["refund_mode"],
        refundId: json["refund_id"],
        refundAccount: json["refund_account"],
        refundAt: json["refund_at"],
      );

  Map<String, dynamic> toJson() => {
        "cancelled_at": cancelledAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "voucher_number": voucherNumber,
        "record_type": recordType,
        "party_id": partyId,
        "party_type": partyType,
        "party_name": partyName,
        "party_phone": partyPhone,
        "cancellation_number": cancellationNumber,
        "refund_amount": refundAmount,
        "refund_mode": refundMode,
        "refund_id": refundId,
        "refund_account": refundAccount,
        "refund_at": refundAt,
      };
}
