import 'dart:convert';

class UpdateWebstoreViewSettingsRequest {
  String? type;
  List<String>? ids;

  UpdateWebstoreViewSettingsRequest({
    this.type,
    this.ids,
  });

  factory UpdateWebstoreViewSettingsRequest.fromRawJson(String str) =>
      UpdateWebstoreViewSettingsRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateWebstoreViewSettingsRequest.fromJson(
          Map<String, dynamic> json) =>
      UpdateWebstoreViewSettingsRequest(
        type: json["type"],
        ids: json["ids"] == null
            ? []
            : List<String>.from(json["ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
      };
}
