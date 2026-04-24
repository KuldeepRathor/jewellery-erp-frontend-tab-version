import 'dart:convert';

class GetSequencesListingGroupedRequest {
  final String voucherSeriesType;
  final String voucherSeriesCommodity;

  GetSequencesListingGroupedRequest({
    required this.voucherSeriesType,
    required this.voucherSeriesCommodity,
  });

  Map<String, dynamic> toJson() => {
        "voucher_series_type": voucherSeriesType,
        "voucher_series_commodity": voucherSeriesCommodity,
      };

  String toRawJson() => json.encode(toJson());
}
