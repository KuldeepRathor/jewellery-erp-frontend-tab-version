import 'dart:convert';

class GetSequencesDropdownResponse {
  List<GetSequencesDropdownValue>? values;

  GetSequencesDropdownResponse({
    this.values,
  });

  factory GetSequencesDropdownResponse.fromRawJson(String str) =>
      GetSequencesDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSequencesDropdownResponse.fromJson(Map<String, dynamic> json) =>
      GetSequencesDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetSequencesDropdownValue>.from(json["values"]!
                .map((x) => GetSequencesDropdownValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetSequencesDropdownValue {
  String? id;
  String? type;
  String? value;
  bool? isDefault;

  GetSequencesDropdownValue({
    this.id,
    this.type,
    this.value,
    this.isDefault,
  });

  factory GetSequencesDropdownValue.fromRawJson(String str) =>
      GetSequencesDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSequencesDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetSequencesDropdownValue(
        id: json["id"],
        type: json["type"],
        value: json["value"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
        "isDefault": isDefault,
      };
}
