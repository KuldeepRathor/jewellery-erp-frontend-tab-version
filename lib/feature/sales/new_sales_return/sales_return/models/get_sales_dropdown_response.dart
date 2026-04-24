import 'dart:convert';

class GetSalesDropdownResponse {
  List<GetSalesDropdownValue>? values;

  GetSalesDropdownResponse({
    this.values,
  });

  factory GetSalesDropdownResponse.fromRawJson(String str) =>
      GetSalesDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetSalesDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetSalesDropdownValue>.from(
                json["values"]!.map((x) => GetSalesDropdownValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetSalesDropdownValue {
  String? id;
  String? saleNumber;

  GetSalesDropdownValue({
    this.id,
    this.saleNumber,
  });

  factory GetSalesDropdownValue.fromRawJson(String str) =>
      GetSalesDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetSalesDropdownValue(
        id: json["id"],
        saleNumber: json["sale_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sale_number": saleNumber,
      };
}
