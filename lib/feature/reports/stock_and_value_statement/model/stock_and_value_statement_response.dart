import 'dart:convert';

class StockAndStatmentValueReportResponseModel {
  List<CombinedValue>? combinedValues;

  StockAndStatmentValueReportResponseModel({
    this.combinedValues,
  });

  StockAndStatmentValueReportResponseModel copyWith({
    List<CombinedValue>? combinedValues,
  }) =>
      StockAndStatmentValueReportResponseModel(
        combinedValues: combinedValues ?? this.combinedValues,
      );

  factory StockAndStatmentValueReportResponseModel.fromRawJson(String str) =>
      StockAndStatmentValueReportResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockAndStatmentValueReportResponseModel.fromJson(
          Map<String, dynamic> json) =>
      StockAndStatmentValueReportResponseModel(
        combinedValues: json["combined_values"] == null
            ? []
            : List<CombinedValue>.from(
                json["combined_values"]!.map((x) => CombinedValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "combined_values": combinedValues == null
            ? []
            : List<dynamic>.from(combinedValues!.map((x) => x.toJson())),
      };
}

class CombinedValue {
  String? ornamentId;
  String? code;
  String? description;
  String? openingQt;
  String? closingQt;
  String? inwardQt;
  String? outwardQt;
  String? openingNetWeight;
  String? closingNetWeight;
  String? inwardNetWeight;
  String? outwardNetWeight;
  String? openingGrossWeight;
  String? closingGrossWeight;
  String? inwardGrossWeight;
  String? outwardGrossWeight;
  String? openingAmount;
  String? closingAmount;
  String? inwardAmount;
  String? outwardAmount;
  dynamic differenceValue;

  CombinedValue({
    this.ornamentId,
    this.code,
    this.description,
    this.openingQt,
    this.closingQt,
    this.inwardQt,
    this.outwardQt,
    this.openingNetWeight,
    this.closingNetWeight,
    this.inwardNetWeight,
    this.outwardNetWeight,
    this.openingGrossWeight,
    this.closingGrossWeight,
    this.inwardGrossWeight,
    this.outwardGrossWeight,
    this.openingAmount,
    this.closingAmount,
    this.inwardAmount,
    this.outwardAmount,
    this.differenceValue,
  });

  CombinedValue copyWith({
    String? ornamentId,
    String? code,
    String? description,
    String? openingQt,
    String? closingQt,
    String? inwardQt,
    String? outwardQt,
    String? openingNetWeight,
    String? closingNetWeight,
    String? inwardNetWeight,
    String? outwardNetWeight,
    String? openingGrossWeight,
    String? closingGrossWeight,
    String? inwardGrossWeight,
    String? outwardGrossWeight,
    String? openingAmount,
    String? closingAmount,
    String? inwardAmount,
    String? outwardAmount,
    dynamic differenceValue,
  }) =>
      CombinedValue(
        ornamentId: ornamentId ?? this.ornamentId,
        code: code ?? this.code,
        description: description ?? this.description,
        openingQt: openingQt ?? this.openingQt,
        closingQt: closingQt ?? this.closingQt,
        inwardQt: inwardQt ?? this.inwardQt,
        outwardQt: outwardQt ?? this.outwardQt,
        openingNetWeight: openingNetWeight ?? this.openingNetWeight,
        closingNetWeight: closingNetWeight ?? this.closingNetWeight,
        inwardNetWeight: inwardNetWeight ?? this.inwardNetWeight,
        outwardNetWeight: outwardNetWeight ?? this.outwardNetWeight,
        openingGrossWeight: openingGrossWeight ?? this.openingGrossWeight,
        closingGrossWeight: closingGrossWeight ?? this.closingGrossWeight,
        inwardGrossWeight: inwardGrossWeight ?? this.inwardGrossWeight,
        outwardGrossWeight: outwardGrossWeight ?? this.outwardGrossWeight,
        openingAmount: openingAmount ?? this.openingAmount,
        closingAmount: closingAmount ?? this.closingAmount,
        inwardAmount: inwardAmount ?? this.inwardAmount,
        outwardAmount: outwardAmount ?? this.outwardAmount,
        differenceValue: differenceValue ?? this.differenceValue,
      );

  factory CombinedValue.fromRawJson(String str) =>
      CombinedValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CombinedValue.fromJson(Map<String, dynamic> json) => CombinedValue(
        ornamentId: json["ornament_id"],
        code: json["code"],
        description: json["description"],
        openingQt: json["opening_qt"],
        closingQt: json["closing_qt"],
        inwardQt: json["inward_qt"],
        outwardQt: json["outward_qt"],
        openingNetWeight: json["opening_net_weight"],
        closingNetWeight: json["closing_net_weight"],
        inwardNetWeight: json["inward_net_weight"],
        outwardNetWeight: json["outward_net_weight"],
        openingGrossWeight: json["opening_gross_weight"],
        closingGrossWeight: json["closing_gross_weight"],
        inwardGrossWeight: json["inward_gross_weight"],
        outwardGrossWeight: json["outward_gross_weight"],
        openingAmount: json["opening_amount"],
        closingAmount: json["closing_amount"],
        inwardAmount: json["inward_amount"],
        outwardAmount: json["outward_amount"],
        differenceValue: json["difference_value"],
      );

  Map<String, dynamic> toJson() => {
        "ornament_id": ornamentId,
        "code": code,
        "description": description,
        "opening_qt": openingQt,
        "closing_qt": closingQt,
        "inward_qt": inwardQt,
        "outward_qt": outwardQt,
        "opening_net_weight": openingNetWeight,
        "closing_net_weight": closingNetWeight,
        "inward_net_weight": inwardNetWeight,
        "outward_net_weight": outwardNetWeight,
        "opening_gross_weight": openingGrossWeight,
        "closing_gross_weight": closingGrossWeight,
        "inward_gross_weight": inwardGrossWeight,
        "outward_gross_weight": outwardGrossWeight,
        "opening_amount": openingAmount,
        "closing_amount": closingAmount,
        "inward_amount": inwardAmount,
        "outward_amount": outwardAmount,
        "difference_value": differenceValue,
      };
}
