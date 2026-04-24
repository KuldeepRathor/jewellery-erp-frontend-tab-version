import 'dart:convert';

class CreateSequenceRequest {
  List<SequenceLine>? sequenceLines;
  int? voucherSeriesType;
  int? voucherSeriesCommodity;

  CreateSequenceRequest({
    this.sequenceLines,
    this.voucherSeriesType,
    this.voucherSeriesCommodity,
  });

  factory CreateSequenceRequest.fromRawJson(String str) =>
      CreateSequenceRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateSequenceRequest.fromJson(Map<String, dynamic> json) =>
      CreateSequenceRequest(
        sequenceLines: json["sequence_lines"] == null
            ? []
            : List<SequenceLine>.from(
                json["sequence_lines"].map((x) => SequenceLine.fromJson(x)),
              ),
        voucherSeriesType: json["voucher_series_type"],
        voucherSeriesCommodity: json["voucher_series_commodity"],
      );

  Map<String, dynamic> toJson() => {
        "sequence_lines": sequenceLines == null
            ? []
            : List<dynamic>.from(sequenceLines!.map((x) => x.toJson())),
        "voucher_series_type": voucherSeriesType,
        "voucher_series_commodity": voucherSeriesCommodity,
      };
}

class SequenceLine {
  String? prefix;
  String? suffix;
  String? startFrom;
  bool? restartFromNewFinancialYear;
  bool? isDefault;
  bool? isEnabled;

  SequenceLine({
    this.prefix,
    this.suffix,
    this.startFrom,
    this.restartFromNewFinancialYear,
    this.isDefault,
    this.isEnabled,
  });

  factory SequenceLine.fromJson(Map<String, dynamic> json) => SequenceLine(
        prefix: json["prefix"],
        suffix: json["suffix"],
        startFrom: json["start_from"],
        restartFromNewFinancialYear: json["restart_from_new_financial_year"],
        isDefault: json["is_default"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "prefix": prefix,
        "suffix": suffix,
        "start_from": startFrom,
        "restart_from_new_financial_year": restartFromNewFinancialYear,
        "is_default": isDefault,
        "is_enabled": isEnabled,
      };
}
