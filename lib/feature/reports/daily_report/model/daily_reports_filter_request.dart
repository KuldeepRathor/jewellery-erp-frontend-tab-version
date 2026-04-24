import 'dart:convert';

class DailyReportsFilterRequest {
  List<String>? branch;
  List<String>? metalType;

  DailyReportsFilterRequest({
    this.branch,
    this.metalType,
  });

  factory DailyReportsFilterRequest.fromRawJson(String str) =>
      DailyReportsFilterRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyReportsFilterRequest.fromJson(Map<String, dynamic> json) =>
      DailyReportsFilterRequest(
        branch: json["branch"] == null
            ? []
            : List<String>.from(json["branch"]!.map((x) => x)),
        metalType: json["metal_type"] == null
            ? []
            : List<String>.from(json["metal_type"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "branch":
            branch == null ? [] : List<dynamic>.from(branch!.map((x) => x)),
        "metal_type": metalType == null
            ? []
            : List<dynamic>.from(metalType!.map((x) => x)),
      };
}
