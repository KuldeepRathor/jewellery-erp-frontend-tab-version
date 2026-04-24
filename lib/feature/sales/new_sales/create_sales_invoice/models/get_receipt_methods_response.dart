import 'dart:convert';

class GetReceiptMethodsResponse {
  String? id;
  String? method;

  GetReceiptMethodsResponse({
    this.id,
    this.method,
  });

  factory GetReceiptMethodsResponse.fromRawJson(String str) =>
      GetReceiptMethodsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReceiptMethodsResponse.fromJson(Map<String, dynamic> json) =>
      GetReceiptMethodsResponse(
        id: json["id"],
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method": method,
      };
}
