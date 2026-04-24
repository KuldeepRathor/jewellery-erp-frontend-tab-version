import 'dart:convert';

class GetSavingsPlanResponseModel {
  List<GetSavingsPlanValue>? plans;

  GetSavingsPlanResponseModel({
    this.plans,
  });

  factory GetSavingsPlanResponseModel.fromRawJson(String str) =>
      GetSavingsPlanResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSavingsPlanResponseModel.fromJson(Map<String, dynamic> json) =>
      GetSavingsPlanResponseModel(
        plans: json["plans"] == null
            ? []
            : List<GetSavingsPlanValue>.from(
                json["plans"]!.map((x) => GetSavingsPlanValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plans": plans == null
            ? []
            : List<dynamic>.from(plans!.map((x) => x.toJson())),
      };
}

class GetSavingsPlanValue {
  int? id;
  String? name;
  String? minimum;
  String? maximum;
  String? prefix;
  bool? isPrefix;

  GetSavingsPlanValue({
    this.id,
    this.name,
    this.minimum,
    this.maximum,
    this.prefix,
    this.isPrefix,
  });

  factory GetSavingsPlanValue.fromRawJson(String str) =>
      GetSavingsPlanValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSavingsPlanValue.fromJson(Map<String, dynamic> json) =>
      GetSavingsPlanValue(
        id: json["id"],
        name: json["name"],
        minimum: json["minimum"],
        maximum: json["maximum"],
        prefix: json["prefix"],
        isPrefix: json["is_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "minimum": minimum,
        "maximum": maximum,
        "prefix": prefix,
        "is_prefix": isPrefix,
      };
}
