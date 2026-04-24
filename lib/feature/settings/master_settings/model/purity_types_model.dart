import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PurityData {
  List<PurityValue>? values;

  PurityData({
    this.values,
  });

  factory PurityData.fromRawJson(String str) =>
      PurityData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurityData.fromJson(Map<String, dynamic> json) => PurityData(
        values: json["values"] == null
            ? []
            : List<PurityValue>.from(
                json["values"]!.map((x) => PurityValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class PurityValue {
  String? id;
  String? purityType;
  String? purityName;
  String? secondaryName;
  bool? status;
  // This field is used to track if the value is being edited
  bool isEditing = false;
  TextEditingController textController;

  PurityValue({
    this.id,
    this.purityType,
    this.purityName,
    this.secondaryName,
    this.status,
    required this.textController,
  });

  factory PurityValue.fromRawJson(String str) =>
      PurityValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurityValue.fromJson(Map<String, dynamic> json) => PurityValue(
        id: json["id"],
        purityType: json["purity_type"],
        purityName: json["purity_name"],
        secondaryName: json["secondary_name"],
        status: json["status"],
        textController: TextEditingController(text: json["secondary_name"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purity_type": purityType,
        "purity_name": purityName,
        "secondary_name": secondaryName,
        "status": status,
      };
}
