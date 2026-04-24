import 'dart:convert';

class GetSelectedPuritySegregatedResponse {
  String? id;
  String? organizationId;
  List<String>? gold;
  List<String>? silver;
  List<String>? platinum;

  GetSelectedPuritySegregatedResponse({
    this.id,
    this.organizationId,
    this.gold,
    this.silver,
    this.platinum,
  });

  factory GetSelectedPuritySegregatedResponse.fromRawJson(String str) =>
      GetSelectedPuritySegregatedResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSelectedPuritySegregatedResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSelectedPuritySegregatedResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        gold: json["gold"] == null
            ? []
            : List<String>.from(json["gold"]!.map((x) => x)),
        silver: json["silver"] == null
            ? []
            : List<String>.from(json["silver"]!.map((x) => x)),
        platinum: json["platinum"] == null
            ? []
            : List<String>.from(json["platinum"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "gold": gold == null ? [] : List<dynamic>.from(gold!.map((x) => x)),
        "silver":
            silver == null ? [] : List<dynamic>.from(silver!.map((x) => x)),
        "platinum":
            platinum == null ? [] : List<dynamic>.from(platinum!.map((x) => x)),
      };
}
