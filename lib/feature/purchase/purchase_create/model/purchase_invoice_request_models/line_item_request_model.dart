import 'dart:convert';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/line_stone_request_model.dart';

class LineItemRequestModel {
  String? amount;
  String? code;
  String? ornamentCode;
  String? ornamentId;
  String? ornamentMetalType;
  String? ornamentName;
  String? grossWeight;
  String? hsnSac;
  String? hsnSacType;
  String? itemDescription;
  String? less;
  List<LineStoneRequestModel>? lineStones;
  String? mc;
  String? netWeight;
  int? pieces;
  String? rate;
  String? stone;
  String? tch;
  String? va;

  LineItemRequestModel({
    this.amount,
    this.code,
    this.ornamentCode,
    this.ornamentId,
    this.ornamentMetalType,
    this.ornamentName,
    this.hsnSac,
    this.hsnSacType,
    this.grossWeight,
    this.itemDescription,
    this.less,
    this.lineStones,
    this.mc,
    this.netWeight,
    this.pieces,
    this.rate,
    this.stone,
    this.tch,
    this.va,
  });

  factory LineItemRequestModel.fromRawJson(String str) =>
      LineItemRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItemRequestModel.fromJson(Map<String, dynamic> json) =>
      LineItemRequestModel(
        amount: json["amount"],
        code: json["code"],
        ornamentCode: json["ornament_code"],
        ornamentId: json["ornament_id"],
        ornamentMetalType: json["ornament_metal_type"],
        ornamentName: json["ornament_name"],
        hsnSac: json["hsn_sac"],
        hsnSacType: json["hsn_sac_type"],
        grossWeight: json["gross_weight"],
        itemDescription: json["item_description"],
        less: json["less"],
        lineStones:
            json["line_stones"] == null
                ? []
                : List<LineStoneRequestModel>.from(
                  json["line_stones"]!.map(
                    (x) => LineStoneRequestModel.fromJson(x),
                  ),
                ),
        mc: json["mc"],
        netWeight: json["net_weight"],
        pieces: json["pieces"],
        rate: json["rate"],
        stone: json["stone"],
        tch: json["tch"],
        va: json["va"],
      );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "code": code,
    "ornament_code": ornamentCode,
    "ornament_id": ornamentId,
    "ornament_metal_type": ornamentMetalType,
    "ornament_name": ornamentName,
    "hsn_sac": hsnSac,
    "hsn_sac_type": hsnSacType,
    "gross_weight": grossWeight,
    "item_description": itemDescription,
    "less": less,
    "line_stones":
        lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
    "mc": mc,
    "net_weight": netWeight,
    "pieces": pieces,
    "rate": rate,
    "stone": stone,
    "tch": tch,
    "va": va,
  };
}
