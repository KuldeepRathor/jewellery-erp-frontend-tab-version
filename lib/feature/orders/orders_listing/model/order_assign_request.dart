import 'dart:convert';

class OrderAssignRequest {
  String? orderLineItemId;
  List<String>? assignedUserId;
  String? orderNumber;
  String? ornamentName;
  double? grossWeight;
  double? netWeight;
  double? pieces;

  OrderAssignRequest({
    this.orderLineItemId,
    this.assignedUserId,
    this.orderNumber,
    this.ornamentName,
    this.grossWeight,
    this.netWeight,
    this.pieces,
  });

  factory OrderAssignRequest.fromRawJson(String str) =>
      OrderAssignRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderAssignRequest.fromJson(Map<String, dynamic> json) =>
      OrderAssignRequest(
        orderLineItemId: json["order_line_item_id"],
        assignedUserId: json["assigned_user_id"] == null
            ? []
            : List<String>.from(json["assigned_user_id"]!.map((x) => x)),
        orderNumber: json["order_number"],
        ornamentName: json["ornament_name"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        pieces: json["pieces"],
      );

  Map<String, dynamic> toJson() => {
        "order_line_item_id": orderLineItemId,
        "assigned_user_id": assignedUserId == null
            ? []
            : List<dynamic>.from(assignedUserId!.map((x) => x)),
        "order_number": orderNumber,
        "ornament_name": ornamentName,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "pieces": pieces,
      };
}
