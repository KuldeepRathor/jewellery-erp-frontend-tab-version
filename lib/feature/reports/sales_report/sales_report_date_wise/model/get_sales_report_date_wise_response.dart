import 'dart:convert';

class GetSalesReportDateWiseReponse {
  List<GetSalesReportDateWiseValue>? values;

  GetSalesReportDateWiseReponse({
    this.values,
  });

  factory GetSalesReportDateWiseReponse.fromRawJson(String str) =>
      GetSalesReportDateWiseReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportDateWiseReponse.fromJson(Map<String, dynamic> json) =>
      GetSalesReportDateWiseReponse(
        values: json["values"] == null
            ? []
            : List<GetSalesReportDateWiseValue>.from(json["values"]!
                .map((x) => GetSalesReportDateWiseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetSalesReportDateWiseValue {
  DateTime? date;
  String? netWeight;
  String? grossWeight;
  String? stoneWeightCarats;
  String? stoneAmount;
  String? gst;
  String? goldAmount;
  String? tdsTcs;
  String? total;
  String? averageRate;

  GetSalesReportDateWiseValue({
    this.date,
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

  factory GetSalesReportDateWiseValue.fromRawJson(String str) =>
      GetSalesReportDateWiseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReportDateWiseValue.fromJson(Map<String, dynamic> json) =>
      GetSalesReportDateWiseValue(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
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
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
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
