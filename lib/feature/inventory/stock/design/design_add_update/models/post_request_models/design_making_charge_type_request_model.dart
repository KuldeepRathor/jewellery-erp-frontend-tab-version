import 'dart:convert';

class DesignMakingChargeTypeRequestModel {
  String? id;

  DesignMakingChargeTypeRequestModel({
    this.id,
  });

  factory DesignMakingChargeTypeRequestModel.fromRawJson(String str) =>
      DesignMakingChargeTypeRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DesignMakingChargeTypeRequestModel.fromJson(
          Map<String, dynamic> json) =>
      DesignMakingChargeTypeRequestModel(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
