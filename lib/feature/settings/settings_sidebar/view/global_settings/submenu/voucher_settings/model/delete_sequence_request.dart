import 'dart:convert';

class DeleteSequenceRequest {
  String? sequenceId;
  int? voucherSeriesType;

  DeleteSequenceRequest({
    this.sequenceId,
    this.voucherSeriesType,
  });

  factory DeleteSequenceRequest.fromRawJson(String str) =>
      DeleteSequenceRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteSequenceRequest.fromJson(Map<String, dynamic> json) =>
      DeleteSequenceRequest(
        sequenceId: json["sequence_id"],
        voucherSeriesType: json["voucher_series_type"],
      );

  Map<String, dynamic> toJson() => {
        "sequence_id": sequenceId,
        "voucher_series_type": voucherSeriesType,
      };
}
