import 'dart:convert';

class BranchOutRequestModel {
  String? transferToBranch;
  String? employeeId;
  List<LineItem>? lineItems;

  BranchOutRequestModel({
    this.transferToBranch,
    this.employeeId,
    this.lineItems,
  });

  BranchOutRequestModel copyWith({
    String? transferToBranch,
    String? employeeId,
    List<LineItem>? lineItems,
  }) =>
      BranchOutRequestModel(
        transferToBranch: transferToBranch ?? this.transferToBranch,
        employeeId: employeeId ?? this.employeeId,
        lineItems: lineItems ?? this.lineItems,
      );

  factory BranchOutRequestModel.fromRawJson(String str) =>
      BranchOutRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchOutRequestModel.fromJson(Map<String, dynamic> json) =>
      BranchOutRequestModel(
        transferToBranch: json["transfer_to_branch"],
        employeeId: json["employee_id"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transfer_to_branch": transferToBranch,
        "employee_id": employeeId,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? taggingId;
  Counter? counter;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? stoneCost;
  String? totalCost;

  LineItem({
    this.taggingId,
    this.counter,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.stoneCost,
    this.totalCost,
  });

  LineItem copyWith({
    String? taggingId,
    Counter? counter,
    String? description,
    int? pieces,
    String? grossWeight,
    String? netWeight,
    String? stoneCost,
    String? totalCost,
  }) =>
      LineItem(
        taggingId: taggingId ?? this.taggingId,
        counter: counter ?? this.counter,
        description: description ?? this.description,
        pieces: pieces ?? this.pieces,
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
        counter: json["counter_from"] == null
            ? null
            : Counter.fromJson(json["counter_from"]),
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        stoneCost: json["stone_cost"],
        totalCost: json["total_cost"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_id": taggingId,
        "counter_from": counter?.toJson(),
        "description": description,
        "pieces": pieces,
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
