import 'dart:convert';

class EditSequenceResponse {
  String? id;
  String? type;
  String? prefix;
  String? suffix;
  String? startFrom;
  bool? restartFromNewFinancialYear;
  dynamic ornamentTypeValidations;
  String? voucherSeriesType;
  String? voucherSeriesCommodity;
  bool? isDefault;

  EditSequenceResponse({
    this.id,
    this.type,
    this.prefix,
    this.suffix,
    this.startFrom,
    this.restartFromNewFinancialYear,
    this.ornamentTypeValidations,
    this.voucherSeriesType,
    this.voucherSeriesCommodity,
    this.isDefault,
  });

  factory EditSequenceResponse.fromRawJson(String str) =>
      EditSequenceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditSequenceResponse.fromJson(Map<String, dynamic> json) =>
      EditSequenceResponse(
        id: json["id"],
        type: json["type"],
        prefix: json["prefix"],
        suffix: json["suffix"],
        startFrom: json["start_from"],
        restartFromNewFinancialYear: json["restart_from_new_financial_year"],
        ornamentTypeValidations: json["ornament_type_validations"],
        voucherSeriesType: json["voucher_series_type"],
        voucherSeriesCommodity: json["voucher_series_commodity"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "prefix": prefix,
        "suffix": suffix,
        "start_from": startFrom,
        "restart_from_new_financial_year": restartFromNewFinancialYear,
        "ornament_type_validations": ornamentTypeValidations,
        "voucher_series_type": voucherSeriesType,
        "voucher_series_commodity": voucherSeriesCommodity,
        "is_default": isDefault,
      };
}
