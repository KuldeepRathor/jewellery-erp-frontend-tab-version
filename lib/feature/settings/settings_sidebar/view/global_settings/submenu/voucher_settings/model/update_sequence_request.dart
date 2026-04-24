import 'dart:convert';

class UpdateSequenceRequest {
  List<SequenceLine>? sequenceLines;
  String? voucherSeriesType;
  String? voucherSeriesCommodity;

  UpdateSequenceRequest({
    this.sequenceLines,
    this.voucherSeriesType,
    this.voucherSeriesCommodity,
  });

  factory UpdateSequenceRequest.fromRawJson(String str) =>
      UpdateSequenceRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateSequenceRequest.fromJson(Map<String, dynamic> json) =>
      UpdateSequenceRequest(
        sequenceLines: json["sequence_lines"] == null
            ? []
            : List<SequenceLine>.from(
                json["sequence_lines"]!.map((x) => SequenceLine.fromJson(x))),
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
  String? sequenceId;
  String? prefix;
  String? suffix;
  String? startFrom;
  bool? restartFromNewFinancialYear;
  bool? isDefault;
  bool? isEnabled;

  SequenceLine({
    this.sequenceId,
    this.prefix,
    this.suffix,
    this.startFrom,
    this.restartFromNewFinancialYear,
    this.isDefault,
    this.isEnabled,
  });

  factory SequenceLine.fromRawJson(String str) =>
      SequenceLine.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SequenceLine.fromJson(Map<String, dynamic> json) => SequenceLine(
        sequenceId: json["sequence_id"],
        prefix: json["prefix"],
        suffix: json["suffix"],
        startFrom: json["start_from"],
        restartFromNewFinancialYear: json["restart_from_new_financial_year"],
        isDefault: json["is_default"],
        isEnabled: json["is_enabled"],
      );

  Map<String, dynamic> toJson() => {
        "sequence_id": sequenceId,
        "prefix": prefix,
        "suffix": suffix,
        "start_from": startFrom,
        "restart_from_new_financial_year": restartFromNewFinancialYear,
        "is_default": isDefault,
        "is_enabled": isEnabled,
      };
}
