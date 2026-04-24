import 'dart:convert';

class CreateCounterTransferRequest {
  String? counterToId;
  List<String>? itemIds;
  String? employeeId;
  String? shopId;

  CreateCounterTransferRequest({
    this.counterToId,
    this.itemIds,
    this.employeeId,
    this.shopId,
  });

  factory CreateCounterTransferRequest.fromRawJson(String str) =>
      CreateCounterTransferRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateCounterTransferRequest.fromJson(Map<String, dynamic> json) =>
      CreateCounterTransferRequest(
        counterToId: json["counter_to_id"],
        itemIds: json["item_ids"] == null
            ? []
            : List<String>.from(json["item_ids"]!.map((x) => x)),
        employeeId: json["employee_id"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "counter_to_id": counterToId,
        "item_ids":
            itemIds == null ? [] : List<dynamic>.from(itemIds!.map((x) => x)),
        "employee_id": employeeId,
        "shop_id": shopId,
      };
}
