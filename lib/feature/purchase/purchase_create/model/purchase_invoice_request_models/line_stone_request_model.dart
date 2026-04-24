import 'dart:convert';

class LineStoneRequestModel {
  String? carat;
  String? name;
  int? pieces;
  String? rate;
  String? total;
  String? weight;

  LineStoneRequestModel({
    this.carat,
    this.name,
    this.pieces,
    this.rate,
    this.total,
    this.weight,
  });

  factory LineStoneRequestModel.fromRawJson(String str) =>
      LineStoneRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineStoneRequestModel.fromJson(Map<String, dynamic> json) =>
      LineStoneRequestModel(
        carat: json["carat"],
        name: json["name"],
        pieces: json["pieces"],
        rate: json["rate"],
        total: json["total"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "carat": carat,
        "name": name,
        "pieces": pieces,
        "rate": rate,
        "total": total,
        "weight": weight,
      };
}
