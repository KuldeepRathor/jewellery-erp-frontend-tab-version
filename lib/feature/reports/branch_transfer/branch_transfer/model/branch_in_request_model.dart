import 'dart:convert';

class BranchInRequestModel {
  String? transferFromBranch;
  String? employeeId;
  List<LineItem>? lineItems;
  String? branchTransferNumber;

  BranchInRequestModel({
    this.transferFromBranch,
    this.employeeId,
    this.lineItems,
    this.branchTransferNumber,
  });

  BranchInRequestModel copyWith({
    String? transferFromBranch,
    String? employeeId,
    List<LineItem>? lineItems,
    String? branchTransferNumber,
  }) =>
      BranchInRequestModel(
        transferFromBranch: transferFromBranch ?? this.transferFromBranch,
        employeeId: employeeId ?? this.employeeId,
        lineItems: lineItems ?? this.lineItems,
        branchTransferNumber: branchTransferNumber ?? this.branchTransferNumber,
      );

  factory BranchInRequestModel.fromRawJson(String str) =>
      BranchInRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchInRequestModel.fromJson(Map<String, dynamic> json) =>
      BranchInRequestModel(
        transferFromBranch: json["transfer_from_branch"],
        employeeId: json["employee_id"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        branchTransferNumber: json["branch_transfer_number"],
      );

  Map<String, dynamic> toJson() => {
        "transfer_from_branch": transferFromBranch,
        "employee_id": employeeId,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "branch_transfer_number": branchTransferNumber,
      };
}

class LineItem {
  String? taggingId;
  Counter? counter;
  String? description;
  String? grossWeight;
  String? netWeight;
  String? stoneCost;
  String? totalCost;

  LineItem({
    this.taggingId,
    this.counter,
    this.description,
    this.grossWeight,
    this.netWeight,
    this.stoneCost,
    this.totalCost,
  });

  LineItem copyWith({
    String? taggingId,
    Counter? counter,
    String? description,
    String? grossWeight,
    String? netWeight,
    String? stoneCost,
    String? totalCost,
  }) =>
      LineItem(
        taggingId: taggingId ?? this.taggingId,
        counter: counter ?? this.counter,
        description: description ?? this.description,
        grossWeight: grossWeight ?? this.grossWeight,
        netWeight: netWeight ?? this.netWeight,
        stoneCost: stoneCost ?? this.stoneCost,
        totalCost: totalCost ?? this.totalCost,
      );

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        taggingId: json["tagging_id"],
        counter: json["counter_to"] == null
            ? null
            : Counter.fromJson(json["counter_to"]),
        description: json["description"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneCost: json["stone_cost"],
        totalCost: json["total_cost"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_id": taggingId,
        "counter_to": counter?.toJson(),
        "description": description,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "stone_cost": stoneCost,
        "total_cost": totalCost,
      };
}

class Counter {
  String? id;

  Counter({
    this.id,
  });

  Counter copyWith({
    String? id,
  }) =>
      Counter(
        id: id ?? this.id,
      );

  factory Counter.fromRawJson(String str) => Counter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
