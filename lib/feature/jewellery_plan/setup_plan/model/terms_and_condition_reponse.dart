import 'dart:convert';

class TermsAndConditionResponse {
  List<TermsAndConditionValue>? values;

  TermsAndConditionResponse({
    this.values,
  });

  factory TermsAndConditionResponse.fromRawJson(String str) =>
      TermsAndConditionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsAndConditionResponse.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionResponse(
        values: json["values"] == null
            ? []
            : List<TermsAndConditionValue>.from(
                json["values"]!.map((x) => TermsAndConditionValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class TermsAndConditionValue {
  String? id;
  String? organizationId;
  String? text;

  TermsAndConditionValue({
    this.id,
    this.organizationId,
    this.text,
  });

  factory TermsAndConditionValue.fromRawJson(String str) =>
      TermsAndConditionValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsAndConditionValue.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionValue(
        id: json["id"],
        organizationId: json["organization_id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "text": text,
      };
}
