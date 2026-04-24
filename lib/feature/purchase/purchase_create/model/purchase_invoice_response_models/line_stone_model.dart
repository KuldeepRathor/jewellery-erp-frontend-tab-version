import 'dart:convert';

class LineStone {
  String? id;
  String? organizationId;
  String? name;
  int? pieces;
  String? carat;
  String? weight;
  String? rate;
  String? total;
  String? purchaseLineItemId;

  LineStone({
    this.id,
    this.organizationId,
    this.name,
    this.pieces,
    this.carat,
    this.weight,
    this.rate,
    this.total,
    this.purchaseLineItemId,
  });

  factory LineStone.fromRawJson(String str) =>
      LineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineStone.fromJson(Map<String, dynamic> json) => LineStone(
        id: json["id"],
        organizationId: json["organization_id"],
        name: json["name"],
        pieces: json["pieces"],
        carat: json["carat"],
        weight: json["weight"],
        rate: json["rate"],
        total: json["total"],
        purchaseLineItemId: json["purchase_line_item_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "name": name,
        "pieces": pieces,
        "carat": carat,
        "weight": weight,
        "rate": rate,
        "total": total,
        "purchase_line_item_id": purchaseLineItemId,
      };
  Map<String, dynamic> toRequestJson() => {
        // "id": id,
        // "organization_id": organizationId,
        "name": name,
        "pieces": pieces,
        "carat": carat,
        "weight": weight,
        "rate": rate,
        "total": total,
        // "purchase_line_item_id": purchaseLineItemId,
      };
}
