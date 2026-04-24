import 'dart:convert';

class PostDailyRatesRequest {
  String? price24K;
  String? price22K;
  String? pricePlain;
  String? price18K;
  String? price23K;
  String? price20K;
  String? price14K;
  String? price9K;
  String? priceSilver999;
  String? priceSilver925;
  String? priceSilver;
  String? pricePlatinum;

  PostDailyRatesRequest({
    this.price24K,
    this.price22K,
    this.pricePlain,
    this.price18K,
    this.price23K,
    this.price20K,
    this.price14K,
    this.price9K,
    this.priceSilver999,
    this.priceSilver925,
    this.priceSilver,
    this.pricePlatinum,
  });

  factory PostDailyRatesRequest.fromRawJson(String str) =>
      PostDailyRatesRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostDailyRatesRequest.fromJson(Map<String, dynamic> json) =>
      PostDailyRatesRequest(
        price24K: json["price_24k"],
        price22K: json["price_22k"],
        pricePlain: json["price_plain"],
        price18K: json["price_18k"],
        price23K: json["price_23k"],
        price20K: json["price_20k"],
        price14K: json["price_14k"],
        price9K: json["price_9k"],
        priceSilver999: json["price_silver_999"],
        priceSilver925: json["price_silver_925"],
        priceSilver: json["price_silver"],
        pricePlatinum: json["price_platinum"],
      );

  Map<String, dynamic> toJson() => {
        "price_24k": price24K,
        "price_22k": price22K,
        "price_plain": pricePlain,
        "price_18k": price18K,
        "price_23k": price23K,
        "price_20k": price20K,
        "price_14k": price14K,
        "price_9k": price9K,
        "price_silver_999": priceSilver999,
        "price_silver_925": priceSilver925,
        "price_silver": priceSilver,
        "price_platinum": pricePlatinum,
      };
}
