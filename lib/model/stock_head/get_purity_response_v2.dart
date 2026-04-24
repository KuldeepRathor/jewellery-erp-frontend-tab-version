import 'dart:convert';

class GetPurityResponseV2 {
  String? id;
  String? organizationId;
  List<GetPurityValue>? values;
  List<GetPurityValue>? gold;
  List<GetPurityValue>? silver;
  List<GetPurityValue>? platinum;

  GetPurityResponseV2({
    this.id,
    this.organizationId,
    this.values,
    this.gold,
    this.silver,
    this.platinum,
  });

  factory GetPurityResponseV2.fromRawJson(String str) =>
      GetPurityResponseV2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurityResponseV2.fromJson(Map<String, dynamic> json) =>
      GetPurityResponseV2(
        id: json["id"],
        organizationId: json["organization_id"],
        values: json["values"] == null
            ? []
            : List<GetPurityValue>.from(
                json["values"]!.map((x) => GetPurityValue.fromJson(x))),
        gold: json["gold"] == null
            ? []
            : List<GetPurityValue>.from(
                json["gold"]!.map((x) => GetPurityValue.fromJson(x))),
        silver: json["silver"] == null
            ? []
            : List<GetPurityValue>.from(
                json["silver"]!.map((x) => GetPurityValue.fromJson(x))),
        platinum: json["platinum"] == null
            ? []
            : List<GetPurityValue>.from(
                json["platinum"]!.map((x) => GetPurityValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "gold": gold == null
            ? []
            : List<dynamic>.from(gold!.map((x) => x.toJson())),
        "silver": silver == null
            ? []
            : List<dynamic>.from(silver!.map((x) => x.toJson())),
        "platinum": platinum == null
            ? []
            : List<dynamic>.from(platinum!.map((x) => x.toJson())),
      };
}

class GetPurityValue {
  String? purityType;
  String? purityName;

  GetPurityValue({
    this.purityType,
    this.purityName,
  });

  factory GetPurityValue.fromRawJson(String str) =>
      GetPurityValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurityValue.fromJson(Map<String, dynamic> json) => GetPurityValue(
        purityType: json["purity_type"],
        purityName: json["purity_name"],
      );

  Map<String, dynamic> toJson() => {
        "purity_type": purityType,
        "purity_name": purityName,
      };
}
