import 'dart:convert';

class GetSequencesListingGroupedResponse {
  int? voucherSeriesType;
  int? voucherSeriesCommodity;
  String? voucherSeriesTypeName;
  String? voucherSeriesCommodityName;
  List<SequenceLineItem>? sequenceLineItems;

  GetSequencesListingGroupedResponse({
    this.voucherSeriesType,
    this.voucherSeriesCommodity,
    this.voucherSeriesTypeName,
    this.voucherSeriesCommodityName,
    this.sequenceLineItems,
  });

  factory GetSequencesListingGroupedResponse.fromRawJson(String str) =>
      GetSequencesListingGroupedResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSequencesListingGroupedResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSequencesListingGroupedResponse(
        voucherSeriesType: json["voucher_series_type"],
        voucherSeriesCommodity: json["voucher_series_commodity"],
        voucherSeriesTypeName: json["voucher_series_type_name"],
        voucherSeriesCommodityName: json["voucher_series_commodity_name"],
        sequenceLineItems: json["sequence_line_items"] == null
            ? []
            : List<SequenceLineItem>.from(json["sequence_line_items"]!
                .map((x) => SequenceLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "voucher_series_type": voucherSeriesType,
        "voucher_series_commodity": voucherSeriesCommodity,
        "voucher_series_type_name": voucherSeriesTypeName,
        "voucher_series_commodity_name": voucherSeriesCommodityName,
        "sequence_line_items": sequenceLineItems == null
            ? []
            : List<dynamic>.from(sequenceLineItems!.map((x) => x.toJson())),
      };
}

class SequenceLineItem {
  String? id;
  String? suffix;
  String? prefix;
  String? startFrom;
  bool? restartEveryYr;
  bool? isDefault;

  SequenceLineItem({
    this.id,
    this.suffix,
    this.prefix,
    this.startFrom,
    this.restartEveryYr,
    this.isDefault,
  });

  factory SequenceLineItem.fromRawJson(String str) =>
      SequenceLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SequenceLineItem.fromJson(Map<String, dynamic> json) =>
      SequenceLineItem(
        id: json["id"],
        suffix: json["suffix"],
        prefix: json["prefix"],
        startFrom: json["start_from"],
        restartEveryYr: json["restart_every_yr"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "suffix": suffix,
        "prefix": prefix,
        "start_from": startFrom,
        "restart_every_yr": restartEveryYr,
        "is_default": isDefault,
      };
}
