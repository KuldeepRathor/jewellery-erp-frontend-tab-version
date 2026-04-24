import 'dart:convert';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/line_stone_model.dart';

class LineItem {
  String? id;
  String? organizationId;
  String? code;
  String? itemDescription;
  int? pieces;
  String? grossWeight;
  String? less;
  String? netWeight;
  String? va;
  String? tch;
  String? mc;
  String? stone;
  String? rate;
  String? amount;
  String? purchaseInvoiceId;
  List<LineStone>? lineStones;

  LineItem({
    this.id,
    this.organizationId,
    this.code,
    this.itemDescription,
    this.pieces,
    this.grossWeight,
    this.less,
    this.netWeight,
    this.va,
    this.tch,
    this.mc,
    this.stone,
    this.rate,
    this.amount,
    this.purchaseInvoiceId,
    this.lineStones,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
    id: json["id"],
    organizationId: json["organization_id"],
    code: json["code"],
    itemDescription: json["item_description"],
    pieces: json["pieces"],
    grossWeight: json["gross_weight"],
    less: json["less"],
    netWeight: json["net_weight"],
    va: json["va"],
    tch: json["tch"],
    mc: json["mc"],
    stone: json["stone"],
    rate: json["rate"],
    amount: json["amount"],
    purchaseInvoiceId: json["purchase_invoice_id"],
    lineStones:
        json["line_stones"] == null
            ? []
            : List<LineStone>.from(
              json["line_stones"]!.map((x) => LineStone.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization_id": organizationId,
    "code": code,
    "item_description": itemDescription,
    "pieces": pieces,
    "gross_weight": grossWeight,
    "less": less,
    "net_weight": netWeight,
    "va": va,
    "tch": tch,
    "mc": mc,
    "stone": stone,
    "rate": rate,
    "amount": amount,
    "purchase_invoice_id": purchaseInvoiceId,
    "line_stones":
        lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
  };
  Map<String, dynamic> toRequestJson() => {
    // "id": id,
    // "organization_id": organizationId,
    "code": code,
    "item_description": itemDescription,
    "pieces": pieces,
    "gross_weight": grossWeight,
    "less": less,
    "net_weight": netWeight,
    "va": va,
    "tch": tch,
    "mc": mc,
    "stone": stone,
    "rate": rate,
    "amount": amount,
    // "purchase_invoice_id": purchaseInvoiceId,
    "line_stones":
        lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toRequestJson())),
  };
}
