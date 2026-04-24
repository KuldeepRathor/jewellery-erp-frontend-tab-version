import 'dart:convert';

class GetSalesReportMonthWiseReponse {
  String? financialYear;
  List<GetSalesReportMonthWiseValue>? values;

  GetSalesReportMonthWiseReponse({
    this.financialYear,
    this.values,
  });

  factory GetSalesReportMonthWiseReponse.fromRawJson(String str) =>
      GetSalesReportMonthWiseReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportMonthWiseReponse.fromJson(Map<String, dynamic> json) =>
      GetSalesReportMonthWiseReponse(
        financialYear: json["financial_year"],
        values: json["values"] == null
            ? []
            : List<GetSalesReportMonthWiseValue>.from(json["values"]!
                .map((x) => GetSalesReportMonthWiseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "financial_year": financialYear,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetSalesReportMonthWiseValue {
  int? month;
  int? year;
  String? monthName;
  String? netWeight;
  String? grossWeight;
  String? stoneWeightCarats;
  String? stoneAmount;
  String? gst;
  String? goldAmount;
  String? tdsTcs;
  String? total;
  String? averageRate;

  GetSalesReportMonthWiseValue({
    this.month,
    this.year,
    this.monthName,
    this.netWeight,
    this.grossWeight,
    this.stoneWeightCarats,
    this.stoneAmount,
    this.gst,
    this.goldAmount,
    this.tdsTcs,
    this.total,
    this.averageRate,
  });

  factory GetSalesReportMonthWiseValue.fromRawJson(String str) =>
      GetSalesReportMonthWiseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportMonthWiseValue.fromJson(Map<String, dynamic> json) =>
      GetSalesReportMonthWiseValue(
        month: json["month"],
        year: json["year"],
        monthName: json["month_name"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        stoneWeightCarats: json["stone_weight_carats"],
        stoneAmount: json["stone_amount"],
        gst: json["gst"],
        goldAmount: json["gold_amount"],
        tdsTcs: json["tds_tcs"],
        total: json["total"],
        averageRate: json["average_rate"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "year": year,
        "month_name": monthName,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "stone_weight_carats": stoneWeightCarats,
        "stone_amount": stoneAmount,
        "gst": gst,
        "gold_amount": goldAmount,
        "tds_tcs": tdsTcs,
        "total": total,
        "average_rate": averageRate,
      };
}
