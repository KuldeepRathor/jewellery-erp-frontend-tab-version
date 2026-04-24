import 'dart:convert';

class BranchOutByNoResponseModel {
  List<Value>? values;

  BranchOutByNoResponseModel({
    this.values,
  });

  factory BranchOutByNoResponseModel.fromRawJson(String str) =>
      BranchOutByNoResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchOutByNoResponseModel.fromJson(Map<String, dynamic> json) =>
      BranchOutByNoResponseModel(
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  String? employeeId;
  String? transferToBranch;
  String? itemId;
  String? description;
  String? grossWeight;
  String? netWeight;
  String? stoneCost;
  String? totalCost;
  String? branchTransferNumber;
  String? shopId;
  DateTime? date;

  Value({
    this.employeeId,
    this.transferToBranch,
    this.itemId,
    this.description,
    this.grossWeight,
    this.netWeight,
    this.stoneCost,
    this.totalCost,
    this.branchTransferNumber,
    this.shopId,
    this.date,
  });

  factory Value.fromRawJson(String str) => Value.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        employeeId: json["employee_id"],
        transferToBranch: json["transfer_to_branch"],
        itemId: json["item_id"],
        description: json["description"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneCost: json["stone_cost"],
        totalCost: json["total_cost"],
        branchTransferNumber: json["branch_transfer_number"],
        shopId: json["shop_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "transfer_to_branch": transferToBranch,
        "item_id": itemId,
        "description": description,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stone_cost": stoneCost,
        "total_cost": totalCost,
        "branch_transfer_number": branchTransferNumber,
        "shop_id": shopId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}
