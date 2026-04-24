import 'dart:convert';

class GetSetupResponse {
  List<SetupOption>? setupOptions;

  GetSetupResponse({
    this.setupOptions,
  });

  factory GetSetupResponse.fromRawJson(String str) =>
      GetSetupResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSetupResponse.fromJson(Map<String, dynamic> json) =>
      GetSetupResponse(
        setupOptions: json["setup_options"] == null
            ? []
            : List<SetupOption>.from(
                json["setup_options"]!.map((x) => SetupOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "setup_options": setupOptions == null
            ? []
            : List<dynamic>.from(setupOptions!.map((x) => x.toJson())),
      };
}

class SetupOption {
  int? id;
  dynamic weightFrom;
  String? weightTo;
  dynamic advancePercentage;
  dynamic redeemDuration;
  bool? blocked;

  SetupOption({
    this.id,
    this.weightFrom,
    this.weightTo,
    this.advancePercentage,
    this.redeemDuration,
    this.blocked,
  });

  factory SetupOption.fromRawJson(String str) =>
      SetupOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SetupOption.fromJson(Map<String, dynamic> json) => SetupOption(
        id: json["id"],
        weightFrom: json["weight_from"],
        weightTo: json["weight_to"],
        advancePercentage: json["advance_percentage"],
        redeemDuration: json["redeem_duration"],
        blocked: json["blocked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weight_from": weightFrom,
        "weight_to": weightTo,
        "advance_percentage": advancePercentage,
        "redeem_duration": redeemDuration,
        "blocked": blocked,
      };
}
