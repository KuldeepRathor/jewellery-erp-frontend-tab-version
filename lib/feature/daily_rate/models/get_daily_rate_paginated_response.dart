import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';

class GetPaginatedDailyRatesResponse {
  List<DailyRateResponse>? values;
  Pagination? pagination;

  GetPaginatedDailyRatesResponse({this.values, this.pagination});

  factory GetPaginatedDailyRatesResponse.fromRawJson(String str) =>
      GetPaginatedDailyRatesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaginatedDailyRatesResponse.fromJson(Map<String, dynamic> json) =>
      GetPaginatedDailyRatesResponse(
        values:
            json["values"] == null
                ? []
                : List<DailyRateResponse>.from(
                  json["values"]!.map((x) => DailyRateResponse.fromJson(x)),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class DailyRateResponse {
  String? id;
  String? organizationId;
  String? price24k;
  String? price22k;
  String? pricePlain;
  String? price18k;
  String? price23k;
  String? price20k;
  String? price14k;
  String? price9k;
  String? priceSilver999;
  String? priceSilver;
  String? priceSilver925;
  String? pricePlatinum;
  DateTime? date;
  DateTime? time;

  DailyRateResponse({
    this.id,
    this.organizationId,
    this.price24k,
    this.price22k,
    this.pricePlain,
    this.price18k,
    this.price23k,
    this.price20k,
    this.price14k,
    this.price9k,
    this.priceSilver999,
    this.priceSilver,
    this.priceSilver925,
    this.pricePlatinum,
    this.date,
    this.time,
  });

  factory DailyRateResponse.fromRawJson(String str) =>
      DailyRateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyRateResponse.fromJson(Map<String, dynamic> json) =>
      DailyRateResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        price24k: json["price_24k"],
        price22k: json["price_22k"],
        pricePlain: json["price_plain"],
        price18k: json["price_18k"],
        price23k: json["price_23k"],
        price20k: json["price_20k"],
        price14k: json["price_14k"],
        price9k: json["price_9k"],
        priceSilver999: json["price_silver_999"],
        priceSilver: json["price_silver"],
        priceSilver925: json["price_silver_925"],
        pricePlatinum: json["price_platinum"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"] == null ? null : _parseTime(json["time"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "price_24k": price24k,
    "price_22k": price22k,
    "price_plain": pricePlain,
    "price_18k": price18k,
    "price_23k": price23k,
    "price_20k": price20k,
    "price_14k": price14k,
    "price_9k": price9k,
    "price_silver_999": priceSilver999,
    "price_silver": priceSilver,
    "price_silver_925": priceSilver925,
    "price_platinum": pricePlatinum,
    "date": date?.toIso8601String(),
    "time": time?.toIso8601String(),
  };

  static DateTime _parseTime(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double seconds = double.parse(parts[2]);
    int wholeSeconds = seconds.floor();
    int milliseconds = ((seconds - wholeSeconds) * 1000).round();

    return DateTime(
      1970,
      1,
      1,
      hours + 5,
      minutes + 30,
      wholeSeconds,
      milliseconds,
    );
  }
}
