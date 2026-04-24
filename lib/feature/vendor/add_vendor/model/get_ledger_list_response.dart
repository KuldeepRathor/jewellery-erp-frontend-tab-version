import 'dart:convert';

class LedgerItem {
  String? id;
  String? ledgerItems;

  LedgerItem({
    this.id,
    this.ledgerItems,
  });

  factory LedgerItem.fromJson(Map<String, dynamic> json) => LedgerItem(
        id: json["id"],
        ledgerItems: json["ledger_items"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ledger_items": ledgerItems,
      };
}

class LedgerItemsResponse {
  List<LedgerItem> ledgerItems;

  LedgerItemsResponse({
    required this.ledgerItems,
  });

  factory LedgerItemsResponse.fromRawJson(String str) =>
      LedgerItemsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LedgerItemsResponse.fromJson(Map<String, dynamic> json) =>
      LedgerItemsResponse(
        ledgerItems: List<LedgerItem>.from(
            json["ledger_items"].map((x) => LedgerItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ledger_items": List<dynamic>.from(ledgerItems.map((x) => x.toJson())),
      };
}
