import 'dart:convert';

class GetAdvanceBookingSetupResponse {
  List<Setup>? setup;

  GetAdvanceBookingSetupResponse({
    this.setup,
  });

  factory GetAdvanceBookingSetupResponse.fromRawJson(String str) =>
      GetAdvanceBookingSetupResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAdvanceBookingSetupResponse.fromJson(Map<String, dynamic> json) =>
      GetAdvanceBookingSetupResponse(
        setup: json["setup"] == null
            ? []
            : List<Setup>.from(json["setup"]!.map((x) => Setup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "setup": setup == null
            ? []
            : List<dynamic>.from(setup!.map((x) => x.toJson())),
      };
}

class Setup {
  int? id;
  String? weightFrom;
  String? weightTo;
  int? advancePercentage;
  int? redeemDuration;

  Setup({
    this.id,
    this.weightFrom,
    this.weightTo,
    this.advancePercentage,
    this.redeemDuration,
  });

  factory Setup.fromRawJson(String str) => Setup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Setup.fromJson(Map<String, dynamic> json) => Setup(
        id: json["id"],
        weightFrom: json["weight_from"],
        weightTo: json["weight_to"],
        advancePercentage: json["advance_percentage"],
        redeemDuration: json["redeem_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weight_from": weightFrom,
        "weight_to": weightTo,
        "advance_percentage": advancePercentage,
        "redeem_duration": redeemDuration,
      };
}
