import 'dart:convert';

class GetPurchaseReportDateWiseReponse {
  List<GetPurchaseReportDateWiseReponseValue>? values;

  GetPurchaseReportDateWiseReponse({
    this.values,
  });

  factory GetPurchaseReportDateWiseReponse.fromRawJson(String str) =>
      GetPurchaseReportDateWiseReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReportDateWiseReponse.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReportDateWiseReponse(
        values: json["values"] == null
            ? []
            : List<GetPurchaseReportDateWiseReponseValue>.from(json["values"]!
                .map((x) => GetPurchaseReportDateWiseReponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetPurchaseReportDateWiseReponseValue {
  DateTime? date;
  List<Ornament>? ornaments;

  GetPurchaseReportDateWiseReponseValue({
    this.date,
    this.ornaments,
  });

  factory GetPurchaseReportDateWiseReponseValue.fromRawJson(String str) =>
      GetPurchaseReportDateWiseReponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReportDateWiseReponseValue.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReportDateWiseReponseValue(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        ornaments: json["ornaments"] == null
            ? []
            : List<Ornament>.from(
                json["ornaments"]!.map((x) => Ornament.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
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
  DateTime? date;
  String? netWeight;
  String? grossWeight;
  String? gst;
  String? goldAmount;
  String? tdsTcs;
  String? total;
  String? roundOff;
  String? averageRate;

  OrnamentValue({
    this.date,
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
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
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
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
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
