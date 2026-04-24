import 'dart:convert';

class PaymentMethodResponse {
  String? id;
  String? method;

  PaymentMethodResponse({
    this.id,
    this.method,
  });

  factory PaymentMethodResponse.fromRawJson(String str) =>
      PaymentMethodResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodResponse(
        id: json["id"],
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method": method,
      };
}
