import 'dart:convert';

class EditSequenceRequest {
  String? voucherSeriesType;
  String? voucherSeriesCommodity;

  EditSequenceRequest({
    this.voucherSeriesType,
    this.voucherSeriesCommodity,
  });

  factory EditSequenceRequest.fromRawJson(String str) =>
      EditSequenceRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditSequenceRequest.fromJson(Map<String, dynamic> json) =>
      EditSequenceRequest(
        voucherSeriesType: json["voucher_series_type"],
        voucherSeriesCommodity: json["voucher_series_commodity"],
      );

  Map<String, dynamic> toJson() => {
        "voucher_series_type": voucherSeriesType,
        "voucher_series_commodity": voucherSeriesCommodity,
      };
}
