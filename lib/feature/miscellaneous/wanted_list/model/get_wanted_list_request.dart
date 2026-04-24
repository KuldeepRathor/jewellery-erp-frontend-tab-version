import 'dart:convert';

class GetWantedListRequest {
  List<String>? design;
  List<String>? size;

  GetWantedListRequest({
    this.design,
    this.size,
  });

  factory GetWantedListRequest.fromRawJson(String str) =>
      GetWantedListRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWantedListRequest.fromJson(Map<String, dynamic> json) =>
      GetWantedListRequest(
        design: json["design"] == null
            ? []
            : List<String>.from(json["design"]!.map((x) => x)),
        size: json["size"] == null
            ? []
            : List<String>.from(json["size"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "design":
            design == null ? [] : List<dynamic>.from(design!.map((x) => x)),
        "size": size == null ? [] : List<dynamic>.from(size!.map((x) => x)),
      };
}
