import 'dart:convert';

class GetPurchaseReportMonthWiseReponse {
  String? financialYear;
  List<GetPurchaseReportMonthWiseReponseValue>? values;

  GetPurchaseReportMonthWiseReponse({
    this.financialYear,
    this.values,
  });

  factory GetPurchaseReportMonthWiseReponse.fromRawJson(String str) =>
      GetPurchaseReportMonthWiseReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReportMonthWiseReponse.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReportMonthWiseReponse(
        financialYear: json["financial_year"],
        values: json["values"] == null
            ? []
            : List<GetPurchaseReportMonthWiseReponseValue>.from(json["values"]!
                .map(
                    (x) => GetPurchaseReportMonthWiseReponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "financial_year": financialYear,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetPurchaseReportMonthWiseReponseValue {
  int? month;
  String? monthName;
  int? year;
  List<Ornament>? ornaments;

  GetPurchaseReportMonthWiseReponseValue({
    this.month,
    this.monthName,
    this.year,
    this.ornaments,
  });

  factory GetPurchaseReportMonthWiseReponseValue.fromRawJson(String str) =>
      GetPurchaseReportMonthWiseReponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReportMonthWiseReponseValue.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReportMonthWiseReponseValue(
        month: json["month"],
        monthName: json["month_name"],
        year: json["year"],
        ornaments: json["ornaments"] == null
            ? []
            : List<Ornament>.from(
                json["ornaments"]!.map((x) => Ornament.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "month_name": monthName,
        "year": year,
        "ornaments": ornaments == null
            ? []
            : List<dynamic>.from(ornaments!.map((x) => x.toJson())),
      };
}

class Ornament {
  String? ornamentId;
  String? ornamentName;
  List<OrnamentValue>? values;

  Ornament({
    this.ornamentId,
    this.ornamentName,
    this.values,
  });

  factory Ornament.fromRawJson(String str) =>
      Ornament.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ornament.fromJson(Map<String, dynamic> json) => Ornament(
        ornamentId: json["ornament_id"],
        ornamentName: json["ornament_name"],
        values: json["values"] == null
            ? []
            : List<OrnamentValue>.from(
                json["values"]!.map((x) => OrnamentValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ornament_id": ornamentId,
        "ornament_name": ornamentName,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class OrnamentValue {
  int? month;
  int? year;
  String? monthName;
  String? netWeight;
  String? grossWeight;
  String? gst;
  String? goldAmount;
  String? tdsTcs;
  String? total;
  String? roundOff;
  String? averageRate;

  OrnamentValue({
    this.month,
    this.year,
    this.monthName,
    this.netWeight,
    this.grossWeight,
    this.gst,
    this.goldAmount,
    this.tdsTcs,
    this.total,
    this.roundOff,
    this.averageRate,
  });

  factory OrnamentValue.fromRawJson(String str) =>
      OrnamentValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrnamentValue.fromJson(Map<String, dynamic> json) => OrnamentValue(
        month: json["month"],
        year: json["year"],
        monthName: json["month_name"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        gst: json["gst"],
        goldAmount: json["gold_amount"],
        tdsTcs: json["tds_tcs"],
        total: json["total"],
        roundOff: json["round_off"],
        averageRate: json["average_rate"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "year": year,
        "month_name": monthName,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "gst": gst,
        "gold_amount": goldAmount,
        "tds_tcs": tdsTcs,
        "total": total,
        "round_off": roundOff,
        "average_rate": averageRate,
      };
}
