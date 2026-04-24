import 'dart:convert';

class RepairAssignRequest {
  String? repairLineItemId;
  List<String>? assignedUserId;
  String? repairNumber;
  String? ornamentName;
  double? grossWeight;
  double? netWeight;
  double? pieces;

  RepairAssignRequest({
    this.repairLineItemId,
    this.assignedUserId,
    this.repairNumber,
    this.ornamentName,
    this.grossWeight,
    this.netWeight,
    this.pieces,
  });

  factory RepairAssignRequest.fromRawJson(String str) =>
      RepairAssignRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RepairAssignRequest.fromJson(Map<String, dynamic> json) =>
      RepairAssignRequest(
        repairLineItemId: json["repair_line_item_id"],
        assignedUserId: json["assigned_user_id"] == null
            ? []
            : List<String>.from(json["assigned_user_id"]!.map((x) => x)),
        repairNumber: json["repair_number"],
        ornamentName: json["ornament_name"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        pieces: json["pieces"],
      );

  Map<String, dynamic> toJson() => {
        "repair_line_item_id": repairLineItemId,
        "assigned_user_id": assignedUserId == null
            ? []
            : List<dynamic>.from(assignedUserId!.map((x) => x)),
        "repair_number": repairNumber,
        "ornament_name": ornamentName,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "pieces": pieces,
      };
}
