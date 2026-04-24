import 'dart:convert';

class PurchaseInvoiceErrorResponse {
  List<Detail>? detail;

  PurchaseInvoiceErrorResponse({
    this.detail,
  });

  factory PurchaseInvoiceErrorResponse.fromRawJson(String str) =>
      PurchaseInvoiceErrorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseInvoiceErrorResponse.fromJson(Map<String, dynamic> json) =>
      PurchaseInvoiceErrorResponse(
        detail: json["detail"] == null
            ? []
            : List<Detail>.from(json["detail"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detail": detail == null
            ? []
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class Detail {
  String? type;
  List<dynamic>? loc;
  String? msg;
  dynamic input;

  Detail({
    this.type,
    this.loc,
    this.msg,
    this.input,
  });

  factory Detail.fromRawJson(String str) => Detail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        type: json["type"],
        loc: json["loc"] == null
            ? []
            : List<dynamic>.from(json["loc"]!.map((x) => x)),
        msg: json["msg"],
        input: json["input"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "loc": loc == null ? [] : List<dynamic>.from(loc!.map((x) => x)),
        "msg": msg,
        "input": input,
      };
}
